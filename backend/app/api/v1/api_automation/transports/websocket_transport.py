#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import asyncio
import base64
import json
import time
from typing import Any, Dict, List

try:
    import websockets
except ImportError:  # pragma: no cover
    websockets = None  # type: ignore


def _merge_pc(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = dict(api_req.get("protocol_config") or api_req.get("ws") or {})
    if not pc.get("ws_url") and url and str(url).strip().lower().startswith("ws"):
        pc["ws_url"] = str(url).strip()
    return pc


async def invoke_websocket(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    if websockets is None:
        return {
            "code": 500,
            "body": {"msg": "未安装 websockets 库，请执行: pip install websockets"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    pc = _merge_pc(api_req, url)
    ws_url = str(pc.get("ws_url") or "").strip()
    if not ws_url:
        return {
            "code": 400,
            "body": {"msg": "WebSocket 缺少 protocol_config.ws_url（或接口 url 为 ws:// 开头）"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    headers = {str(k): str(v) for k, v in (pc.get("headers") or {}).items() if k}
    subs: List[str] = [str(s) for s in (pc.get("subprotocols") or []) if s]
    messages: List[Dict[str, Any]] = list(pc.get("messages") or [])
    if not messages and pc.get("send_text") is not None:
        messages = [{"text": str(pc.get("send_text"))}]
    if not messages and pc.get("body") is not None:
        b = pc.get("body")
        messages = [{"text": json.dumps(b, ensure_ascii=False) if not isinstance(b, str) else b}]

    receive_count = max(1, int(pc.get("receive_count") or 1))
    timeout = float(pc.get("timeout") or 30)
    close_after = bool(pc.get("close_after", True))

    t0 = time.perf_counter()
    frames: List[Dict[str, Any]] = []

    try:
        connect_kw: Dict[str, Any] = {"extra_headers": headers} if headers else {}
        if subs:
            connect_kw["subprotocols"] = subs

        async with websockets.connect(ws_url, **connect_kw) as ws:  # type: ignore[misc]
            for m in messages:
                if "text" in m:
                    await ws.send(str(m["text"]))
                elif "binary_b64" in m:
                    await ws.send(base64.b64decode(str(m["binary_b64"])))
                else:
                    await ws.send(json.dumps(m, ensure_ascii=False))

            for _ in range(receive_count):
                raw = await asyncio.wait_for(ws.recv(), timeout=timeout)
                if isinstance(raw, bytes):
                    frames.append({"type": "binary", "binary_b64": base64.b64encode(raw).decode("ascii")})
                else:
                    frames.append({"type": "text", "text": raw})

            if close_after:
                await ws.close()

        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        return {
            "code": 200,
            "body": {"frames": frames, "protocol": "websocket"},
            "header": {},
            "headers": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": "WEBSOCKET", "url": ws_url, "headers": headers, "body": messages},
        }
    except Exception as e:
        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        return {
            "code": 500,
            "body": {"msg": "WebSocket 执行失败", "exception": str(e), "protocol": "websocket"},
            "header": {},
            "headers": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": "WEBSOCKET", "url": ws_url},
        }
