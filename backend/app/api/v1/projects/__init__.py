"""
项目管理模块
"""

from fastapi import APIRouter
from .controller import router as project_router

router = APIRouter()
router.include_router(project_router)

__all__ = ["router"]
