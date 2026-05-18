#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import asyncio
import time
from typing import Any, Dict, List, Tuple

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.v1.api_automation.model import ApiModel, ApiPerfReportModel
from app.api.v1.api_automation.transports.unified_invoke import unified_transport_invoke


def _clamp_int(v: Any, lo: int, hi: int, default: int) -> int:
    try:
        x = int(v)
    except (TypeError, ValueError):
        x = default
    return max(lo, min(hi, x))


def _percentile(sorted_vals: List[float], p: float) -> float:
    if not sorted_vals:
        return 0.0
    xs = sorted_vals
    if len(xs) == 1:
        return float(xs[0])
    k = (len(xs) - 1) * (p / 100.0)
    f = int(k)
    c = min(f + 1, len(xs) - 1)
    d0 = xs[f] * (c - k)
    d1 = xs[c] * (k - f)
    return float(d0 + d1)


def _latency_ms(res: Dict[str, Any], wall_ms: float) -> float:
    try:
        v = float(str(res.get("res_time") or 0))
        if v > 0:
            return v
    except (TypeError, ValueError):
        pass
    return wall_ms


async def _invoke_once(prepared: Dict[str, Any]) -> Tuple[int, float]:
    t0 = time.perf_counter()
    res = await unified_transport_invoke(
        protocol=prepared["protocol"],
        url=prepared["url"],
        api_req=prepared["api_req"],
        method=prepared["method"],
        headers=prepared["headers"],
        params=prepared["params"],
        body_type=prepared["body_type"],
        body=prepared["body"],
        form_data=prepared["form_data"],
        form_urlencoded=prepared["form_urlencoded"],
        file_paths=prepared["file_paths"],
        config=prepared["config"],
    )
    wall_ms = (time.perf_counter() - t0) * 1000.0
    code = int(res.get("code") or 0)
    return code, _latency_ms(res, wall_ms)


class ApiPerfService:
    @staticmethod
    async def build_invoke_plan(db: AsyncSession, body: Dict[str, Any], user_id: int) -> Dict[str, Any]:
        """与单次调试相同的变量解析与参数合并；不执行前置/后置/断言。"""
        from app.api.v1.api_automation.service import ApiAutomationService
        from app.api.v1.api_automation.model import ApiParamsModel

        env_id = int(body.get("env_id") or 0)
        req = body.get("req") or {}
        raw_url = body.get("url") or req.get("url") or ""
        url = await ApiAutomationService.handle_var(db, env_id, raw_url)

        params_id = req.get("params_id")
        if params_id is not None:
            p = (
                await db.execute(
                    select(ApiParamsModel).where(ApiParamsModel.id == int(params_id), ApiParamsModel.enabled_flag == 1)
                )
            ).scalar_one_or_none()
            if p and isinstance(req.get("body"), dict) and isinstance(p.value, dict):
                req["body"].update(p.value)

        body_payload = await ApiAutomationService.handle_var(db, env_id, req.get("body") or {})
        method = int(req.get("method") or 2)
        body_type = int(req.get("body_type") or 2)
        headers = await ApiAutomationService.handle_var(db, env_id, ApiAutomationService.params_header(req.get("header")))
        params = await ApiAutomationService.handle_var(db, env_id, ApiAutomationService.params_header(req.get("params")))
        form_data = await ApiAutomationService.handle_var(db, env_id, ApiAutomationService.params_header(req.get("form_data")))
        form_urlencoded = await ApiAutomationService.handle_var(db, env_id, ApiAutomationService.params_header(req.get("form_urlencoded")))
        file_paths = req.get("file_path") or []
        config = req.get("config") or {"retry": 0, "req_timeout": 5, "res_timeout": 5}

        protocol = str(req.get("protocol") or "http").strip().lower()
        if protocol not in ("", "http", "https"):
            raise ValueError("接口压测当前仅支持 HTTP/HTTPS；其它协议请使用性能测试 / JMeter 链路")

        return {
            "protocol": protocol or "http",
            "url": str(url),
            "api_req": req,
            "method": method,
            "headers": headers,
            "params": params,
            "body_type": body_type,
            "body": body_payload,
            "form_data": form_data,
            "form_urlencoded": form_urlencoded,
            "file_paths": file_paths,
            "config": config,
        }

    @staticmethod
    async def run_and_save_report(db: AsyncSession, body: Dict[str, Any], user_id: int) -> Dict[str, Any]:
        api_id = int(body.get("id") or 0)
        if not api_id:
            raise ValueError("缺少接口 id")

        row = (
            await db.execute(
                select(ApiModel).where(ApiModel.id == api_id, ApiModel.enabled_flag == 1, ApiModel.created_by == user_id)
            )
        ).scalar_one_or_none()
        if not row:
            raise ValueError("接口不存在或无权访问")

        perf = body.get("perf") or {}
        concurrent = _clamp_int(perf.get("concurrent"), 1, 100, 10)
        duration_sec = float(_clamp_int(perf.get("duration_sec"), 5, 600, 30))
        max_requests = _clamp_int(perf.get("max_requests"), 10, 200_000, 5000)

        plan = await ApiPerfService.build_invoke_plan(db, body, user_id)

        deadline = time.perf_counter() + duration_sec
        codes: List[int] = []
        lats: List[float] = []
        errors_sample: List[str] = []
        lock = asyncio.Lock()
        total = 0

        async def worker() -> None:
            nonlocal total
            while True:
                async with lock:
                    if total >= max_requests or time.perf_counter() >= deadline:
                        return
                    total += 1
                try:
                    code, lat = await _invoke_once(plan)
                    async with lock:
                        codes.append(code)
                        lats.append(lat)
                        if code >= 400 and len(errors_sample) < 8:
                            errors_sample.append(f"HTTP {code}")
                except Exception as e:
                    async with lock:
                        codes.append(599)
                        lats.append(0.0)
                        if len(errors_sample) < 8:
                            errors_sample.append(str(e)[:200])

        wall0 = time.perf_counter()
        await asyncio.gather(*[worker() for _ in range(concurrent)])
        wall_elapsed = max(time.perf_counter() - wall0, 1e-6)

        ok = sum(1 for c in codes if c < 400)
        fail = len(codes) - ok
        lat_sorted = sorted(lats)
        summary = {
            "total_requests": len(codes),
            "concurrent": concurrent,
            "duration_wall_sec": round(wall_elapsed, 3),
            "duration_config_sec": duration_sec,
            "max_requests": max_requests,
            "success": ok,
            "fail": fail,
            "rps": round(len(codes) / wall_elapsed, 2),
            "latency_ms": {
                "min": round(min(lats), 2) if lats else 0,
                "max": round(max(lats), 2) if lats else 0,
                "avg": round(sum(lats) / len(lats), 2) if lats else 0,
                "p50": round(_percentile(lat_sorted, 50), 2),
                "p90": round(_percentile(lat_sorted, 90), 2),
                "p95": round(_percentile(lat_sorted, 95), 2),
                "p99": round(_percentile(lat_sorted, 99), 2),
            },
            "status_histogram": _histogram(codes),
            "errors_sample": errors_sample,
            "url": plan.get("url"),
            "protocol": plan.get("protocol"),
        }

        title = str(perf.get("title") or "").strip() or f"压测-{api_id}"
        report = ApiPerfReportModel(
            api_id=api_id,
            api_service_id=int(row.api_service_id),
            env_id=int(body.get("env_id") or 0),
            title=title,
            perf_config={
                "concurrent": concurrent,
                "duration_sec": duration_sec,
                "max_requests": max_requests,
            },
            summary=summary,
            detail={"note": "轻量压测报告；完整企业级压测请对接 JMeter / 性能测试模块"},
            created_by=user_id,
            updated_by=user_id,
        )
        db.add(report)
        await db.commit()
        await db.refresh(report)
        return {"report_id": int(report.id), "summary": summary}

    @staticmethod
    async def list_reports(
        db: AsyncSession,
        user_id: int,
        body: Dict[str, Any],
    ) -> Dict[str, Any]:
        api_id = body.get("api_id")
        page = max(1, int(body.get("page") or 1))
        page_size = _clamp_int(body.get("pageSize") or body.get("page_size"), 1, 100, 20)

        q = [ApiPerfReportModel.enabled_flag == 1, ApiPerfReportModel.created_by == user_id]
        if api_id is not None:
            q.append(ApiPerfReportModel.api_id == int(api_id))

        cnt_stmt = select(func.count()).select_from(ApiPerfReportModel).where(*q)
        total = int((await db.execute(cnt_stmt)).scalar_one() or 0)
        offset = (page - 1) * page_size
        rows = (
            await db.execute(
                select(ApiPerfReportModel)
                .where(*q)
                .order_by(ApiPerfReportModel.id.desc())
                .offset(offset)
                .limit(page_size)
            )
        ).scalars().all()

        items = []
        for r in rows:
            items.append(
                {
                    "id": r.id,
                    "api_id": r.api_id,
                    "api_service_id": r.api_service_id,
                    "env_id": r.env_id,
                    "title": r.title,
                    "perf_config": r.perf_config,
                    "summary": r.summary,
                    "creation_date": r.creation_date.isoformat() if r.creation_date else None,
                }
            )
        return {"content": items, "total": total, "page": page, "pageSize": page_size}

    @staticmethod
    async def get_report(db: AsyncSession, report_id: int, user_id: int) -> Dict[str, Any] | None:
        r = (
            await db.execute(
                select(ApiPerfReportModel).where(
                    ApiPerfReportModel.id == int(report_id),
                    ApiPerfReportModel.enabled_flag == 1,
                    ApiPerfReportModel.created_by == user_id,
                )
            )
        ).scalar_one_or_none()
        if not r:
            return None
        return {
            "id": r.id,
            "api_id": r.api_id,
            "api_service_id": r.api_service_id,
            "env_id": r.env_id,
            "title": r.title,
            "perf_config": r.perf_config,
            "summary": r.summary,
            "detail": r.detail,
            "creation_date": r.creation_date.isoformat() if r.creation_date else None,
        }


def _histogram(codes: List[int]) -> Dict[str, int]:
    h: Dict[str, int] = {}
    for c in codes:
        k = str(c)
        h[k] = h.get(k, 0) + 1
    return h
