# -*- coding: utf-8 -*-
# @author: rebort
import os
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.corelibs.logger import logger
from config import config


def init_mount(app: FastAPI):
    """ 挂载静态文件 -- https://fastapi.tiangolo.com/zh/tutorial/static-files/ """

    # 优先使用 backend/static（上传文件实际落盘目录），避免 BASEDIR 指向项目根导致 404
    backend_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    backend_static = os.path.join(backend_root, config.STATIC_DIR)
    project_static = os.path.join(config.BASEDIR, config.STATIC_DIR)
    static_abs = backend_static if os.path.isdir(backend_static) else project_static
    os.makedirs(static_abs, exist_ok=True)
    app.mount(f"/{config.STATIC_DIR}", StaticFiles(directory=static_abs), name=config.STATIC_DIR)

    # 单独挂载 /media，对齐后端存储路径 /media/playwright/...
    media_abs = os.path.join(static_abs, "media")
    os.makedirs(media_abs, exist_ok=True)
    app.mount("/media", StaticFiles(directory=media_abs), name="media")

    # 挂载 uploads（用于 Skill runtime 截图/产物直链访问）
    uploads_abs = os.path.join(backend_root, "uploads")
    os.makedirs(uploads_abs, exist_ok=True)
    app.mount("/uploads", StaticFiles(directory=uploads_abs), name="uploads")

    # 便携目录：托管 Vite 构建的前端（config.yaml 中 frontend.dist_path）
    dist_path = (getattr(config, "FRONTEND_DIST_PATH", None) or "").strip()
    if dist_path and os.path.isdir(dist_path):
        assets_dir = os.path.join(dist_path, "assets")
        if os.path.isdir(assets_dir):
            app.mount("/assets", StaticFiles(directory=assets_dir), name="spa_assets")
        app.mount("/", StaticFiles(directory=dist_path, html=True), name="spa")
    elif dist_path:
        logger.warning("FRONTEND_DIST_PATH 已配置但目录不存在，跳过前端托管: %s", dist_path)