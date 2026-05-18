#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
from __future__ import annotations

import asyncio
import base64
import time
from typing import Any, Dict, List, Tuple
from urllib.parse import urlparse

try:
    import grpc
    from google.protobuf.descriptor_pool import DescriptorPool
    from google.protobuf.json_format import MessageToDict, ParseDict
    from google.protobuf.message_factory import GetMessageClass
    from grpc_reflection.v1alpha.proto_reflection_descriptor_database import ProtoReflectionDescriptorDatabase
except ImportError:  # pragma: no cover
    grpc = None  # type: ignore


def _pc(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    pc = dict(api_req.get("protocol_config") or api_req.get("grpc") or {})
    if not pc.get("target") and url:
        u = str(url).strip()
        low = u.lower()
        if low.startswith("grpc://"):
            p = urlparse(u)
            h = p.hostname or ""
            po = p.port if p.port is not None else 50051
            pc["target"] = f"{h}:{po}" if h else ""
        elif low.startswith("grpcs://"):
            p = urlparse(u)
            h = p.hostname or ""
            po = p.port if p.port is not None else 443
            pc["target"] = f"{h}:{po}" if h else ""
            pc["use_tls"] = True
        elif u and "://" not in u and ":" in u:
            pc["target"] = u
    return pc


def _metadata_tuples(meta: Any) -> List[Tuple[str, str]]:
    if not meta:
        return []
    if isinstance(meta, dict):
        return [(str(k).lower(), str(v)) for k, v in meta.items()]
    out: List[Tuple[str, str]] = []
    if isinstance(meta, list):
        for item in meta:
            if isinstance(item, (list, tuple)) and len(item) >= 2:
                out.append((str(item[0]).lower(), str(item[1])))
    return out


def _build_channel(target: str, pc: Dict[str, Any]) -> Any:
    opts = []
    if pc.get("grpc_max_receive_message_length") is not None:
        opts.append(("grpc.max_receive_message_length", int(pc["grpc_max_receive_message_length"])))
    if pc.get("grpc_max_send_message_length") is not None:
        opts.append(("grpc.max_send_message_length", int(pc["grpc_max_send_message_length"])))

    use_tls = bool(pc.get("use_tls") or pc.get("tls"))
    if use_tls:
        tls = pc.get("tls") if isinstance(pc.get("tls"), dict) else {}
        ca_pem = tls.get("ca_pem") or tls.get("root_cert_pem") or tls.get("ca_cert_pem")
        root = None
        if isinstance(ca_pem, str) and "BEGIN" in ca_pem:
            root = ca_pem.encode("utf-8")
        creds = grpc.ssl_channel_credentials(root_certificates=root)
        return grpc.secure_channel(target, creds, options=opts or None)

    return grpc.insecure_channel(target, options=opts or None)


def _grpc_status_to_http(code: Any) -> int:
    if grpc is None:
        return 500
    m = {
        grpc.StatusCode.OK: 200,
        grpc.StatusCode.INVALID_ARGUMENT: 400,
        grpc.StatusCode.NOT_FOUND: 404,
        grpc.StatusCode.ALREADY_EXISTS: 409,
        grpc.StatusCode.PERMISSION_DENIED: 403,
        grpc.StatusCode.UNAUTHENTICATED: 401,
        grpc.StatusCode.RESOURCE_EXHAUSTED: 429,
        grpc.StatusCode.UNAVAILABLE: 503,
        grpc.StatusCode.DEADLINE_EXCEEDED: 504,
        grpc.StatusCode.ABORTED: 409,
        grpc.StatusCode.FAILED_PRECONDITION: 400,
    }
    return int(m.get(code, 500))


def _invoke_grpc_sync(pc: Dict[str, Any]) -> Dict[str, Any]:
    assert grpc is not None
    target = str(pc.get("target") or "").strip()
    method_path = str(pc.get("method") or "").strip()
    if not method_path.startswith("/"):
        method_path = "/" + method_path
    timeout = float(pc.get("timeout") or 60)
    metadata = _metadata_tuples(pc.get("metadata") or pc.get("headers"))

    if not target:
        return {
            "code": 400,
            "body": {"msg": "gRPC 缺少 protocol_config.target（或 url 为 grpc(s)://host:port）"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }
    if method_path == "/":
        return {
            "code": 400,
            "body": {"msg": "gRPC 缺少 protocol_config.method，格式 /package.Service/Method"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }

    t0 = time.perf_counter()
    channel = _build_channel(target, pc)
    try:
        raw_b64 = (pc.get("request_bytes_b64") or "").strip()
        if raw_b64:
            try:
                req_bytes = base64.b64decode(raw_b64)
            except Exception as e:
                return {
                    "code": 400,
                    "body": {"msg": f"request_bytes_b64 非法: {e}"},
                    "header": {},
                    "res_time": "0",
                    "cookies": [],
                    "raw_request": None,
                }
            multi = channel.unary_unary(
                method_path,
                request_serializer=lambda x: x,
                response_deserializer=lambda x: x,
            )
            try:
                out_b = multi(
                    req_bytes,
                    timeout=timeout,
                    metadata=metadata,
                )
            except grpc.RpcError as e:  # type: ignore[misc]
                elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
                return {
                    "code": _grpc_status_to_http(e.code()),
                    "body": {
                        "msg": str(e.details() or e.code()),
                        "grpc_code": e.code().name,
                        "protocol": "grpc",
                        "mode": "raw",
                    },
                    "header": {},
                    "res_time": str(elapsed_ms),
                    "cookies": [],
                    "raw_request": {"method": method_path, "url": f"grpc://{target}"},
                }
            elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
            return {
                "code": 200,
                "body": {
                    "raw_response_b64": base64.b64encode(out_b).decode("ascii") if out_b else "",
                    "protocol": "grpc",
                    "mode": "raw",
                },
                "header": {},
                "res_time": str(elapsed_ms),
                "cookies": [],
                "raw_request": {"method": method_path, "url": f"grpc://{target}"},
            }

        reflection_db = ProtoReflectionDescriptorDatabase(channel)
        pool = DescriptorPool(reflection_db)
        inner = method_path.strip("/")
        if "/" not in inner:
            return {
                "code": 400,
                "body": {"msg": "method 须为 /package.Service/Method 形式"},
                "header": {},
                "res_time": "0",
                "cookies": [],
                "raw_request": None,
            }
        service_full, rpc_name = inner.rsplit("/", 1)
        try:
            svc_desc = pool.FindServiceByName(service_full)
        except KeyError:
            return {
                "code": 400,
                "body": {
                    "msg": f"找不到服务 {service_full}（请确认服务端已开启 gRPC reflection）",
                    "protocol": "grpc",
                },
                "header": {},
                "res_time": str(round((time.perf_counter() - t0) * 1000, 2)),
                "cookies": [],
                "raw_request": {"method": method_path, "url": f"grpc://{target}"},
            }
        if rpc_name not in svc_desc.methods_by_name:
            return {
                "code": 400,
                "body": {"msg": f"找不到 RPC {rpc_name}", "protocol": "grpc"},
                "header": {},
                "res_time": str(round((time.perf_counter() - t0) * 1000, 2)),
                "cookies": [],
                "raw_request": None,
            }
        md = svc_desc.methods_by_name[rpc_name]
        req_msg = GetMessageClass(md.input_type)()
        ParseDict(
            pc.get("request") if isinstance(pc.get("request"), dict) else {},
            req_msg,
            ignore_unknown_fields=bool(pc.get("ignore_unknown_json_fields", True)),
        )
        resp_cls = GetMessageClass(md.output_type)

        multi = channel.unary_unary(
            method_path,
            request_serializer=req_msg.SerializeToString,
            response_deserializer=resp_cls.FromString,
        )
        try:
            resp_msg = multi(req_msg, timeout=timeout, metadata=metadata)
        except grpc.RpcError as e:  # type: ignore[misc]
            elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
            return {
                "code": _grpc_status_to_http(e.code()),
                "body": {
                    "msg": str(e.details() or e.code()),
                    "grpc_code": e.code().name,
                    "protocol": "grpc",
                    "mode": "reflection",
                },
                "header": {},
                "res_time": str(elapsed_ms),
                "cookies": [],
                "raw_request": {"method": method_path, "url": f"grpc://{target}"},
            }

        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        body_dict = MessageToDict(resp_msg, preserving_proto_field_name=True)
        return {
            "code": 200,
            "body": {"response": body_dict, "protocol": "grpc", "mode": "reflection"},
            "header": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": method_path, "url": f"grpc://{target}"},
        }
    except Exception as e:
        elapsed_ms = round((time.perf_counter() - t0) * 1000, 2)
        return {
            "code": 500,
            "body": {"msg": "gRPC 执行失败", "exception": str(e), "protocol": "grpc"},
            "header": {},
            "res_time": str(elapsed_ms),
            "cookies": [],
            "raw_request": {"method": method_path, "url": f"grpc://{target}"},
        }
    finally:
        try:
            channel.close()
        except Exception:
            pass


async def invoke_grpc(api_req: Dict[str, Any], url: str) -> Dict[str, Any]:
    if grpc is None:
        return {
            "code": 500,
            "body": {"msg": "未安装 grpcio / grpcio-reflection，请执行: pip install grpcio grpcio-reflection"},
            "header": {},
            "res_time": "0",
            "cookies": [],
            "raw_request": None,
        }
    pc = _pc(api_req, url)
    return await asyncio.to_thread(_invoke_grpc_sync, pc)
