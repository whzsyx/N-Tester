#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""启动入口：先加载 config.yaml，再按其中 server 段启动 uvicorn。"""
import os
import sys

# 确保可导入同目录下的 main、portable_env
_BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
if _BACKEND_DIR not in sys.path:
    sys.path.insert(0, _BACKEND_DIR)

if __name__ == "__main__":
    from portable_env import load_portable_yaml_into_environ

    load_portable_yaml_into_environ()
    host = os.environ.get("UVICORN_HOST", "0.0.0.0")
    port = int(os.environ.get("UVICORN_PORT", "8100"))
    import uvicorn

    uvicorn.run("main:app", host=host, port=port, reload=False, workers=1)
