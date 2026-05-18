#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import asyncio
import base64
import binascii
import time
from typing import Any, Dict
from urllib.parse import urlparse


def _pc(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = dict(api_req.get("protocol_config") or api_req.get("tcp") or {})
    if not pc.get("host") and url and str(url).lower().startswith("tcp://"):
        u = urlparse(str(url).strip())
        pc["host"] = u.hostname or ""
        pc["port"] = u.port or 0
    return pc


async def invoke_tcp(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = _pc(api_req, url)
    host = str(pc.get("host") or "").strip()
    port = int(pc.get("port") or 0)
    if not host or not port:
        return {
            "code": 400,
            "body": {"msg": "TCP 缺少 protocol_config.host/port（或 url 使用 tcp://host:port）"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    send_hex = (pc.get("send_hex") or "").strip()
    send_text = pc.get("send_text")
    if send_hex:
        try:
            payload = binascii.unhexlify(send_hex.replace(" ", ""))
        except binascii.Error as e:
            return {
                "code": 400,
                "body": {"msg": f"send_hex 非法: {e}"},
                "header": {},
                "res_time": "0",
                "cookies": [],
                "raw_request": None,
            }
    elif send_text is not None:
        enc = str(pc.get("send_encoding") or "utf-8")
        payload = str(send_text).encode(enc)
    else:
        payload = b""

    read_max = int(pc.get("read_max_bytes") or 65536)
    timeout = float(pc.get("timeout") or 10)
    t0 = time.perf_counter()

    try:
        conn = asyncio.open_connection(host, port)
        reader, writer = await asyncio.wait_for(conn, timeout=timeout)
        try:
            if payload:
                writer.write(payload)
                await writer.drain()
            data = await asyncio.wait_for(reader.read(read_max), timeout=timeout)
        finally:
            writer.close()
            try:
                await writer.wait_closed()
            except Exception:
                pass

        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        text_preview = ""
        try:
            text_preview = data.decode(str(pc.get("recv_encoding") or "utf-8"), errors="replace")[:4000]
        except Exception:
            text_preview = ""

        return {
            "code": 200,
            "body": {
                "raw_b64": base64.b64encode(data).decode("ascii") if data else "",
                "raw_len": len(data or b""),
                "text_preview": text_preview,
                "protocol": "tcp",
            },
            "header": {},
            "headers": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {
                "method": "TCP",
                "url": f"tcp://{host}:{port}",
                "headers": {},
                "body": send_hex or (send_text if send_text is not None else ""),
            },
        }
    except Exception as e:
        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        return {
            "code": 500,
            "body": {"msg": "TCP 执行失败", "exception": str(e), "protocol": "tcp"},
            "header": {},
            "headers": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": "TCP", "url": f"tcp://{host}:{port}"},
        }
