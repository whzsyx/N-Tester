#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import asyncio
import base64
import json
import threading
import time
import uuid
from typing import Any, Dict
from urllib.parse import urlparse

try:
    from paho.mqtt.client import CallbackAPIVersion, Client
except ImportError:  # pragma: no cover
    Client = None  # type: ignore
    CallbackAPIVersion = None  # type: ignore


def _pc(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = dict(api_req.get("protocol_config") or api_req.get("mqtt") or {})
    if not pc.get("host") and url:
        u = str(url).strip().lower()
        if u.startswith("mqtt://") or u.startswith("mqtts://"):
            p = urlparse(u)
            pc["host"] = p.hostname or ""
            if p.port:
                pc["port"] = p.port
            if u.startswith("mqtts://"):
                pc["use_tls"] = True
    return pc


def _payload_bytes(pc: Dict[str, Any]) -> bytes:
    if pc.get("payload_bytes_b64"):
        return base64.b64decode(str(pc["payload_bytes_b64"]))
    p = pc.get("payload")
    if p is None:
        return b""
    if isinstance(p, (dict, list)):
        enc = str(pc.get("payload_json_encoding") or "utf-8")
        return json.dumps(p, ensure_ascii=False).encode(enc)
    return str(p).encode(str(pc.get("payload_encoding") or "utf-8"))


def _invoke_mqtt_sync(pc: Dict[str, Any]) -> Dict[str, Any]:
    assert Client is not None and CallbackAPIVersion is not None
    host = str(pc.get("host") or pc.get("broker_host") or "").strip()
    port = int(pc.get("port") or pc.get("broker_port") or 1883)
    if not host:
        return {
            "code": 400,
            "body": {"msg": "MQTT 缺少 protocol_config.host（或 url 为 mqtt(s)://host:port）"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    topic_pub = str(pc.get("topic") or pc.get("publish_topic") or "").strip()
    topic_sub = str(pc.get("subscribe_topic") or "").strip()
    qos_pub = int(pc.get("qos") if pc.get("qos") is not None else pc.get("publish_qos") or 0)
    qos_sub = int(pc.get("subscribe_qos") if pc.get("subscribe_qos") is not None else qos_pub)
    retain = bool(pc.get("retain", False))
    wait_sec = float(pc.get("wait_for_message_timeout") or 0)
    connect_timeout = float(pc.get("connect_timeout") or 15)
    t0 = time.perf_counter()

    if not topic_pub:
        return {
            "code": 400,
            "body": {"msg": "MQTT 缺少 protocol_config.topic（或 publish_topic）"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    user = pc.get("username")
    password = pc.get("password")
    client_id = str(pc.get("client_id") or "").strip() or f"api_auto_{uuid.uuid4().hex[:12]}"
    recv_enc = str(pc.get("recv_encoding") or "utf-8")

    userdata: Dict[str, Any] = {
        "conn_ok": threading.Event(),
        "conn_err": None,
        "msg_ok": threading.Event(),
        "last_msg": None,
    }

    def on_connect(_client: Any, ud: Dict[str, Any], _flags: Any, reason_code: Any, _properties: Any) -> None:
        try:
            if hasattr(reason_code, "is_failure") and reason_code.is_failure:
                ud["conn_err"] = str(reason_code)
            elif isinstance(reason_code, int) and reason_code != 0:
                ud["conn_err"] = f"CONNACK {reason_code}"
        except Exception as e:
            ud["conn_err"] = str(e)
        ud["conn_ok"].set()

    def on_message(_client: Any, ud: Dict[str, Any], msg: Any) -> None:
        try:
            text = msg.payload.decode(recv_enc, errors="replace")
        except Exception:
            text = ""
        ud["last_msg"] = {
            "topic": getattr(msg, "topic", "") or "",
            "qos": int(getattr(msg, "qos", 0) or 0),
            "payload_text": text,
            "payload_len": len(msg.payload or b""),
        }
        ud["msg_ok"].set()

    client = Client(CallbackAPIVersion.VERSION2, client_id=client_id, userdata=userdata)
    client.on_connect = on_connect
    client.on_message = on_message

    if user is not None:
        client.username_pw_set(str(user), str(password) if password is not None else None)

    if bool(pc.get("use_tls") or pc.get("tls")):
        tls = pc.get("tls") if isinstance(pc.get("tls"), dict) else {}
        ca = tls.get("ca_pem") or tls.get("cafile")
        cert = tls.get("cert_pem") or tls.get("certfile")
        key = tls.get("key_pem") or tls.get("keyfile")
        if isinstance(ca, str) and "BEGIN" in ca:
            import tempfile
            import os

            fd, ca_path = tempfile.mkstemp(suffix=".pem", text=True)
            os.write(fd, ca.encode("utf-8"))
            os.close(fd)
            try:
                client.tls_set(
                    ca_certs=ca_path,
                    certfile=str(cert) if cert else None,
                    keyfile=str(key) if key else None,
                )
            finally:
                try:
                    os.unlink(ca_path)
                except OSError:
                    pass
        elif ca:
            client.tls_set(ca_certs=str(ca), certfile=str(cert) if cert else None, keyfile=str(key) if key else None)
        else:
            client.tls_set()

    keepalive = int(pc.get("keepalive") or 60)
    try:
        client.connect(host, port, keepalive=keepalive)
        client.loop_start()
        if not userdata["conn_ok"].wait(connect_timeout):
            return {
                "code": 504,
                "body": {"msg": "MQTT 连接超时", "protocol": "mqtt"},
                "header": {},
                "res_time": str(round((time.perf_counter() - t0) * 1000, 2)),
                "cookies": [],
                "raw_request": {"url": f"mqtt://{host}:{port}"},
            }
        if userdata["conn_err"]:
            return {
                "code": 502,
                "body": {"msg": f"MQTT 连接失败: {userdata['conn_err']}", "protocol": "mqtt"},
                "header": {},
                "res_time": str(round((time.perf_counter() - t0) * 1000, 2)),
                "cookies": [],
                "raw_request": {"url": f"mqtt://{host}:{port}"},
            }

        if topic_sub:
            client.subscribe(topic_sub, qos=qos_sub)
            time.sleep(float(pc.get("subscribe_settle_ms", 80)) / 1000.0)

        userdata["msg_ok"].clear()
        inf = client.publish(topic_pub, _payload_bytes(pc), qos=qos_pub, retain=retain)
        try:
            inf.wait_for_publish(timeout=float(pc.get("publish_timeout") or 15))
        except Exception as e:
            return {
                "code": 500,
                "body": {"msg": f"MQTT 发布失败: {e}", "protocol": "mqtt"},
                "header": {},
                "res_time": str(round((time.perf_counter() - t0) * 1000, 2)),
                "cookies": [],
                "raw_request": {"url": f"mqtt://{host}:{port}", "topic": topic_pub},
            }

        received = None
        if topic_sub and wait_sec > 0:
            if userdata["msg_ok"].wait(wait_sec):
                received = userdata["last_msg"]
            else:
                elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
                return {
                    "code": 504,
                    "body": {
                        "msg": "等待订阅消息超时",
                        "published": True,
                        "subscribe_topic": topic_sub,
                        "protocol": "mqtt",
                    },
                    "header": {},
                    "res_time": str(elapsed_ms),
                    "cookies": [],
                    "raw_request": {"url": f"mqtt://{host}:{port}", "topic": topic_pub},
                }

        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        body: Dict[str, Any] = {"published": True, "topic": topic_pub, "protocol": "mqtt"}
        if received is not None:
            body["received"] = received
        return {
            "code": 200,
            "body": body,
            "header": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": "MQTT", "url": f"mqtt://{host}:{port}", "body": topic_pub},
        }
    except Exception as e:
        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        return {
            "code": 500,
            "body": {"msg": "MQTT 执行失败", "exception": str(e), "protocol": "mqtt"},
            "header": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"url": f"mqtt://{host}:{port}"},
        }
    finally:
        try:
            client.loop_stop()
            client.disconnect()
        except Exception:
            pass


async def invoke_mqtt(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    if Client is None:
        return {
            "code": 500,
            "body": {"msg": "未安装 paho-mqtt，请执行: pip install paho-mqtt"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }
    pc = _pc(api_req, url)
    return await asyncio.to_thread(_invoke_mqtt_sync, pc)
