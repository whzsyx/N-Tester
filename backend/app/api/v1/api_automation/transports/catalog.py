#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

from __future__ import annotations

from typing import Any, Dict, List


def list_transport_catalog() -> List[Dict[str, Any]]:
    return [
        {
            "id": "http",
            "title": "HTTP / HTTPS",
            "description": "REST、SOAP（XML Body）、GraphQL（HTTP POST）、Webhook 等，走标准请求配置",
            "req_fields": ["method", "url", "header", "params", "body_type", "body", "form_data", "form_urlencoded", "file_path", "config"],
        },
        {
            "id": "websocket",
            "title": "WebSocket",
            "description": "长连接、推送、游戏/金融行情等。",
            "req_fields": ["protocol", "protocol_config"],
            "protocol_config_schema": {
                "ws_url": "ws(s)://host:port/path",
                "headers": "可选，对象",
                "subprotocols": "可选，字符串数组",
                "messages": "发送列表，每项 {text: str} 或 {binary_b64: str}",
                "receive_count": "接收帧次数，默认 1",
                "timeout": "单次收发超时秒，默认 30",
                "close_after": "完成后是否 close，默认 true",
            },
        },
        {
            "id": "tcp",
            "title": "TCP 原始套接字",
            "description": "自定义二进制协议、硬件网关、遗留 Socket 服务。",
            "req_fields": ["protocol", "protocol_config"],
            "protocol_config_schema": {
                "host": "IP 或域名",
                "port": "端口整数",
                "send_text": "以 UTF-8 发送的文本（与 send_hex 二选一）",
                "send_hex": "十六进制字符串，如 48656c6c6f",
                "read_max_bytes": "读回最大字节，默认 65536",
                "timeout": "连接与读写超时秒，默认 10",
            },
        },
        {
            "id": "external_bridge",
            "title": "外部协议桥（HTTP）",
            "description": "企业内 gRPC、JAR 签名、IBM MQ、SAP RFC 等：由你们自建微服务接收本请求 JSON，返回统一结构 {status_code, headers, body}。",
            "req_fields": ["protocol", "protocol_config"],
            "protocol_config_schema": {
                "url": "桥服务 HTTP(S) 地址",
                "method": "POST 或 GET，默认 POST",
                "headers": "可选",
                "body": "任意 JSON，由桥服务解释",
                "timeout": "秒，默认 60",
            },
        },
        {
            "id": "grpc",
            "title": "gRPC",
            "description": "Unary：服务端需开启 reflection 时用 request(JSON)；无 reflection 可用 request_bytes_b64 发已序列化 protobuf。",
            "req_fields": ["protocol", "protocol_config"],
            "protocol_config_schema": {
                "target": "host:port，或接口 url 填 grpc://host:port / grpcs://",
                "method": "完整路径，如 /helloworld.Greeter/SayHello",
                "request": "JSON 对象，与 proto 字段对应（reflection 模式）",
                "request_bytes_b64": "与 request 二选一：原始请求 protobuf 的 base64",
                "metadata": "可选，对象或 [[key,value],...] gRPC metadata",
                "timeout": "秒，默认 60",
                "use_tls": "是否 TLS（grpcs:// 或 true）",
                "tls": "可选 { ca_pem: PEM 字符串 } 校验服务端证书",
                "ignore_unknown_json_fields": "Parse JSON 时是否忽略未知字段，默认 true",
            },
        },
        {
            "id": "mqtt",
            "title": "MQTT",
            "description": "发布消息；可选 subscribe_topic + wait_for_message_timeout 等待一条回包。",
            "req_fields": ["protocol", "protocol_config"],
            "protocol_config_schema": {
                "host": "Broker 主机，或 url 填 mqtt(s)://host:port",
                "port": "端口，默认 1883；mqtts 常 8883",
                "topic": "发布主题（或 publish_topic）",
                "payload": "字符串，或对象（自动 JSON）",
                "payload_bytes_b64": "与 payload 二选一",
                "qos": "0|1|2，默认 0",
                "retain": "是否 retain，默认 false",
                "username": "可选",
                "password": "可选",
                "client_id": "可选，默认随机",
                "subscribe_topic": "可选，先订阅再发",
                "subscribe_qos": "订阅 QoS，默认同 qos",
                "wait_for_message_timeout": "订阅模式下等待首条消息秒数，0 表示不等待",
                "use_tls": "是否 TLS",
                "tls": "可选 { ca_pem, cert_pem, key_pem } PEM 字符串",
                "connect_timeout": "连接等待秒，默认 15",
            },
        },
    ]
