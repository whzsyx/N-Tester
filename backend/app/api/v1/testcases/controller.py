"""
测试用例管理控制器
"""

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.sqlalchemy import get_db
from app.core.dependencies import get_current_user_id
from app.api.v1.testcases.service import TestCaseService, VersionService
from app.api.v1.testcases.schema import (
    TestCaseCreateSchema, TestCaseUpdateSchema, TestCaseOutSchema, TestCaseQuerySchema,
    VersionCreateSchema, VersionUpdateSchema, VersionOutSchema, VersionQuerySchema,
    VersionAssociationSchema
)
from app.common.response import success_response

router = APIRouter(prefix="/testcases", tags=["测试用例管理"])


# ========== 测试用例 ==========

@router.post("", summary="创建测试用例")
async def create_testcase(
    project_id: int = Query(..., description="项目ID"),
    data: TestCaseCreateSchema = None,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """创建测试用例"""
    result = await TestCaseService.create_testcase_service(
        project_id, data, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.get("", summary="获取测试用例列表")
async def get_testcase_list(
    query: TestCaseQuerySchema = Depends(),
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """获取测试用例列表"""
    result = await TestCaseService.get_testcase_list_service(
        query, current_user_id, db
    )
    return success_response(data=result)


# ========== 版本管理 ==========
# 注意：版本路由必须在 /{testcase_id} 之前，否则会被错误匹配

@router.post("/versions", summary="创建版本")
async def create_version(
    data: VersionCreateSchema,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """创建版本"""
    result = await VersionService.create_version_service(
        data, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.get("/versions", summary="获取版本列表")
async def get_version_list(
    query: VersionQuerySchema = Depends(),
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """获取版本列表"""
    result = await VersionService.get_version_list_service(
        query, current_user_id, db
    )
    return success_response(data=result)


@router.get("/versions/{version_id}", summary="获取版本详情")
async def get_version_detail(
    version_id: int,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """获取版本详情"""
    result = await VersionService.get_version_detail_service(
        version_id, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.put("/versions/{version_id}", summary="更新版本")
async def update_version(
    version_id: int,
    data: VersionUpdateSchema,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """更新版本"""
    result = await VersionService.update_version_service(
        version_id, data, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.delete("/versions/{version_id}", summary="删除版本")
async def delete_version(
    version_id: int,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """删除版本"""
    await VersionService.delete_version_service(
        version_id, current_user_id, db
    )
    return success_response(message="删除成功")


@router.post("/versions/associate", summary="关联测试用例到版本")
async def associate_testcases(
    data: VersionAssociationSchema,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """关联测试用例到版本"""
    await VersionService.associate_testcases_service(
        data, current_user_id, db
    )
    return success_response(message="关联成功")


# ========== 测试用例详情/更新/删除 ==========
# 注意：这些路由必须在版本路由之后，避免路径冲突

@router.get("/{testcase_id}", summary="获取测试用例详情")
async def get_testcase_detail(
    testcase_id: int,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """获取测试用例详情"""
    result = await TestCaseService.get_testcase_detail_service(
        testcase_id, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.put("/{testcase_id}", summary="更新测试用例")
async def update_testcase(
    testcase_id: int,
    data: TestCaseUpdateSchema,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """更新测试用例"""
    result = await TestCaseService.update_testcase_service(
        testcase_id, data, current_user_id, db
    )
    return success_response(data=result.model_dump())


@router.delete("/{testcase_id}", summary="删除测试用例")
async def delete_testcase(
    testcase_id: int,
    current_user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """删除测试用例"""
    await TestCaseService.delete_testcase_service(
        testcase_id, current_user_id, db
    )
    return success_response(message="删除成功")
