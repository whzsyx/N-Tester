"""
Skill 管理模块
"""

from fastapi import APIRouter
from .controller import router as skill_router

router = APIRouter()
router.include_router(skill_router)

__all__ = ["router"]

