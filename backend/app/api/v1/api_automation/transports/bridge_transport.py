#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import json
from typing import Any, Dict

import requests


async def invoke_external_bridge(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = dict(api_req.get("protocol_config") or api_req.get("bridge") or {})
    b_url = str(pc.get("url") or "").strip()
    if not b_url and url and str(url).lower().startswith("http"):
        b_url = str(url).strip()
    if not b_url:
        return {
            "code": 400,
            "body": {"msg": "external_bridge 缺少 protocol_config.url"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    method = str(pc.get("method") or "POST").upper()
    headers = {str(k): str(v) for k, v in (pc.get("headers") or {}).items()}
    body = pc.get("body")
    timeout = float(pc.get("timeout") or 60)

    try:
        if method == "GET":
            r = requests.get(b_url, headers=headers, timeout=timeout)
        else:
            if isinstance(body, (dict, list)):
                r = requests.post(b_url, headers=headers, json=body, timeout=timeout)
            elif body is None:
                r = requests.post(b_url, headers=headers, timeout=timeout)
            else:
                r = requests.post(b_url, headers=headers, data=str(body), timeout=timeout)

        try:
            parsed = r.json()
        except Exception:
            parsed = {"raw": r.text}

        # 桥约定：可直接返回业务 JSON，或包一层 { status_code, headers, body }
        if isinstance(parsed, dict) and "status_code" in parsed:
            code = int(parsed.get("status_code") or r.status_code)
            hdr = dict(parsed.get("headers") or {})
            inner = parsed.get("body", parsed)
        else:
            code = r.status_code
            hdr = dict(r.headers)
            inner = parsed

        elapsed_ms = round(r.elapsed.total_seconds() * 1000, 2)
        return {
            "code": code,
            "body": inner if isinstance(inner, (dict, list)) else {"value": inner},
            "header": hdr,
            "headers": hdr,
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": method, "url": b_url, "headers": headers, "body": body},
        }
    except Exception as e:
        return {
            "code": 500,
            "body": {"msg": "external_bridge 调用失败", "exception": str(e)},
            "header": {},
            "headers": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": {"method": method, "url": b_url},
        }
