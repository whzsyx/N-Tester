"""
API v1版本
"""

from fastapi import APIRouter
from app.api.v1.system import router as system_router
from app.api.v1.monitor import router as monitor_router
from app.api.v1.common.health.controller import router as health_router
from app.api.v1.oauth.controller import router as oauth_router
from app.api.v1.ai import router as ai_router
from app.api.v1.projects import router as projects_router
from app.api.v1.testcases.controller import router as testcases_router
from app.api.v1.api_testing.controller import router as api_testing_router

# 创建v1路由
router = APIRouter(prefix="/v1")

# 注册子路由
router.include_router(system_router, prefix="/system", tags=["系统管理"])
router.include_router(monitor_router, prefix="/monitor", tags=["系统监控"])
router.include_router(health_router, prefix="/common/health", tags=["健康检查"])
router.include_router(oauth_router)  # OAuth router 已经在 controller 中定义了 prefix="/oauth"
router.include_router(ai_router, prefix="/ai", tags=["AI 模块"])
router.include_router(projects_router, prefix="/projects", tags=["项目管理"])
router.include_router(testcases_router, tags=["测试用例管理"])
router.include_router(api_testing_router, tags=["API测试"])

__all__ = ["router"]
