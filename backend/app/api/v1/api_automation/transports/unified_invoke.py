#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

from typing import Any, Dict


def normalize_transport_response(res: Dict[str, Any]) -> Dict[str, Any]:
    """统一 headers/header 键，便于断言与 JMESPath meta.headers。"""
    if not isinstance(res, dict):
        return {
            "code": 500,
            "body": {"msg": "非法响应", "raw": str(res)},
            "header": {},
            "headers": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }
    h = res.get("header") if res.get("header") is not None else res.get("headers")
    if not isinstance(h, dict):
        h = {}
    res["header"] = dict(h)
    res["headers"] = dict(h)
    return res


async def unified_transport_invoke(
    *,
    protocol: str,
    url: str,
    api_req: Dict[str, Any],
    method: int,
    headers: Dict[str, Any],
    params: Dict[str, Any],
    body_type: int,
    body: Any,
    form_data: Dict[str, Any],
    form_urlencoded: Dict[str, Any],
    file_paths: Any,
    config: Dict[str, Any],
) -> Dict[str, Any]:
    proto = (protocol or "http").lower().strip()
    if proto in ("", "http", "https"):
        from app.api.v1.api_automation.service import ApiAutomationService

        res = await ApiAutomationService._send_request(
            method=method,
            url=str(url),
            headers=headers,
            params=params,
            body_type=body_type,
            body=body,
            form_data=form_data,
            form_urlencoded=form_urlencoded,
            file_paths=file_paths or [],
            config=config,
        )
        return normalize_transport_response(res)

    if proto == "websocket":
        from .websocket_transport import invoke_websocket

        return normalize_transport_response(await invoke_websocket(api_req, url))

    if proto == "tcp":
        from .tcp_transport import invoke_tcp

        return normalize_transport_response(await invoke_tcp(api_req, url))

    if proto in ("external_bridge", "bridge", "adapter"):
        from .bridge_transport import invoke_external_bridge

        return normalize_transport_response(await invoke_external_bridge(api_req, url))

    if proto == "grpc":
        from .grpc_transport import invoke_grpc

        return normalize_transport_response(await invoke_grpc(api_req, url))

    if proto == "mqtt":
        from .mqtt_transport import invoke_mqtt

        return normalize_transport_response(await invoke_mqtt(api_req, url))

    return normalize_transport_response(
        {
            "code": 400,
            "body": {
                "msg": f"不支持的协议: {proto}",
                "hint": "支持: http, websocket, tcp, external_bridge, grpc, mqtt。",
            },
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }
    )
