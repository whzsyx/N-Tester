"""
测试用例管理业务逻辑层
"""

from typing import List
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.v1.testcases.crud import (
    TestCaseCRUD, TestCaseStepCRUD, VersionCRUD,
    ProjectVersionCRUD, TestCaseVersionCRUD
)
from app.api.v1.testcases.schema import (
    TestCaseCreateSchema, TestCaseUpdateSchema, TestCaseOutSchema, TestCaseQuerySchema,
    TestCaseStepOutSchema, VersionCreateSchema, VersionUpdateSchema, VersionOutSchema,
    VersionQuerySchema, VersionAssociationSchema
)
from app.api.v1.testcases.model import TestCaseModel, VersionModel
from app.api.v1.projects.crud import ProjectMemberCRUD
from app.common.response import page_response


class TestCaseService:
    """测试用例服务"""
    
    @classmethod
    async def create_testcase_service(
        cls,
        project_id: int,
        data: TestCaseCreateSchema,
        current_user_id: int,
        db: AsyncSession
    ) -> TestCaseOutSchema:
        """创建测试用例"""
        # 检查项目权限
        await cls._check_project_member(project_id, current_user_id, db)
        
        crud = TestCaseCRUD(db)
        
        # 创建测试用例
        testcase_data = data.model_dump(exclude={"steps"})
        testcase_data["project_id"] = project_id
        testcase_data["author_id"] = current_user_id
        testcase_data["created_by"] = current_user_id
        testcase = await crud.create_crud(testcase_data)
        
        # 创建测试步骤
        if data.steps:
            print(f"[DEBUG] 创建步骤，数量: {len(data.steps)}")
            step_crud = TestCaseStepCRUD(db)
            for i, step_data in enumerate(data.steps):
                step_dict = step_data.model_dump()
                print(f"[DEBUG] 步骤{i+1}: {step_dict}")
                step_dict["test_case_id"] = testcase.id
                step_dict["created_by"] = current_user_id
                created_step = await step_crud.create_crud(step_dict)
                print(f"[DEBUG] 创建成功，步骤ID: {created_step.id}")
        else:
            print("[DEBUG] 没有步骤数据")
        
        # 重新获取测试用例（包含关联数据）
        testcase = await crud.get_with_relations_crud(testcase.id)
        
        return cls._build_testcase_out(testcase)
    
    @classmethod
    async def get_testcase_list_service(
        cls,
        query: TestCaseQuerySchema,
        current_user_id: int,
        db: AsyncSession
    ) -> dict:
        """获取测试用例列表"""
        # 检查项目权限
        await cls._check_project_member(query.project_id, current_user_id, db)
        
        crud = TestCaseCRUD(db)
        
        # 构建查询条件
        conditions = []
        if query.title:
            conditions.append(TestCaseModel.title.like(f"%{query.title}%"))
        if query.status:
            conditions.append(TestCaseModel.status == query.status)
        if query.priority:
            conditions.append(TestCaseModel.priority == query.priority)
        if query.test_type:
            conditions.append(TestCaseModel.test_type == query.test_type)
        if query.author_id:
            conditions.append(TestCaseModel.author_id == query.author_id)
        
        # 如果指定了版本，需要关联查询
        if query.version_id:
            # TODO: 实现版本过滤
            pass
        
        # 查询测试用例
        skip = (query.page - 1) * query.page_size
        testcases, total = await crud.get_project_testcases_crud(
            query.project_id,
            conditions,
            skip,
            query.page_size
        )
        
        # 构建输出
        items = [cls._build_testcase_out(tc).model_dump() for tc in testcases]
        
        # 直接返回数据字典，不使用page_response
        return {
            "items": items,
            "total": total,
            "page": query.page,
            "page_size": query.page_size,
            "total_pages": (total + query.page_size - 1) // query.page_size
        }
    
    @classmethod
    async def get_testcase_detail_service(
        cls,
        testcase_id: int,
        current_user_id: int,
        db: AsyncSession
    ) -> TestCaseOutSchema:
        """获取测试用例详情"""
        crud = TestCaseCRUD(db)
        testcase = await crud.get_with_relations_crud(testcase_id)
        
        if not testcase:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="测试用例不存在"
            )
        
        # 检查项目权限
        await cls._check_project_member(testcase.project_id, current_user_id, db)
        
        return cls._build_testcase_out(testcase)
    
    @classmethod
    async def update_testcase_service(
        cls,
        testcase_id: int,
        data: TestCaseUpdateSchema,
        current_user_id: int,
        db: AsyncSession
    ) -> TestCaseOutSchema:
        """更新测试用例"""
        crud = TestCaseCRUD(db)
        testcase = await crud.get_by_id_crud(testcase_id)
        
        if not testcase:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="测试用例不存在"
            )
        
        # 检查项目权限
        await cls._check_project_member(testcase.project_id, current_user_id, db)
        
        # 更新测试用例
        update_data = data.model_dump(exclude_unset=True, exclude={"steps"})
        update_data["updated_by"] = current_user_id
        testcase = await crud.update_crud(testcase_id, update_data)
        
        # 更新测试步骤
        if data.steps is not None:
            step_crud = TestCaseStepCRUD(db)
            # 删除旧步骤
            await step_crud.delete_testcase_steps_crud(testcase_id)
            # 创建新步骤
            for step_data in data.steps:
                step_dict = step_data.model_dump()
                step_dict["test_case_id"] = testcase_id
                step_dict["created_by"] = current_user_id
                await step_crud.create_crud(step_dict)
        
        # 重新获取测试用例（包含关联数据）
        testcase = await crud.get_with_relations_crud(testcase.id)
        
        return cls._build_testcase_out(testcase)
    
    @classmethod
    async def delete_testcase_service(
        cls,
        testcase_id: int,
        current_user_id: int,
        db: AsyncSession
    ) -> None:
        """删除测试用例"""
        crud = TestCaseCRUD(db)
        testcase = await crud.get_by_id_crud(testcase_id)
        
        if not testcase:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="测试用例不存在"
            )
        
        # 检查项目权限
        await cls._check_project_member(testcase.project_id, current_user_id, db)
        
        await crud.delete_crud([testcase_id])
    
    @classmethod
    def _build_testcase_out(cls, testcase: TestCaseModel) -> TestCaseOutSchema:
        """构建测试用例输出"""
        print(f"[DEBUG] _build_testcase_out - testcase.id: {testcase.id}")
        print(f"[DEBUG] testcase.steps 类型: {type(testcase.steps)}")
        print(f"[DEBUG] testcase.steps 长度: {len(testcase.steps) if testcase.steps else 0}")
        if testcase.steps:
            print(f"[DEBUG] testcase.steps 内容: {testcase.steps}")
        
        testcase_out = TestCaseOutSchema.model_validate(testcase)
        
        print(f"[DEBUG] testcase_out.steps 长度: {len(testcase_out.steps) if testcase_out.steps else 0}")
        
        # 设置作者和指派人姓名
        if testcase.author:
            testcase_out.author_name = testcase.author.nickname or testcase.author.username
        if testcase.assignee:
            testcase_out.assignee_name = testcase.assignee.nickname or testcase.assignee.username
        
        # 设置步骤
        if testcase.steps:
            print(f"[DEBUG] 手动设置 steps，数量: {len(testcase.steps)}")
            testcase_out.steps = [TestCaseStepOutSchema.model_validate(step) for step in testcase.steps]
            print(f"[DEBUG] 设置后 testcase_out.steps 长度: {len(testcase_out.steps)}")
        
        # 设置版本ID列表
        if testcase.versions:
            testcase_out.version_ids = [v.version_id for v in testcase.versions]
        
        print(f"[DEBUG] 最终返回的 testcase_out.steps: {testcase_out.steps}")
        return testcase_out
    
    @classmethod
    async def _check_project_member(
        cls,
        project_id: int,
        user_id: int,
        db: AsyncSession
    ) -> None:
        """检查用户是否是项目成员"""
        member_crud = ProjectMemberCRUD(db)
        is_member = await member_crud.check_user_in_project_crud(project_id, user_id)
        if not is_member:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="您不是该项目成员，无权访问"
            )


class VersionService:
    """版本服务"""
    
    @classmethod
    async def create_version_service(
        cls,
        data: VersionCreateSchema,
        current_user_id: int,
        db: AsyncSession
    ) -> VersionOutSchema:
        """创建版本"""
        crud = VersionCRUD(db)
        
        # 检查版本名称是否已存在
        existing = await crud.get_by_name_crud(data.name)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="版本名称已存在"
            )
        
        # 创建版本
        version_data = data.model_dump(exclude={"project_ids"})
        version_data["created_by"] = current_user_id
        version = await crud.create_crud(version_data)
        
        # 关联项目
        if data.project_ids:
            pv_crud = ProjectVersionCRUD(db)
            for project_id in data.project_ids:
                await pv_crud.create_crud({
                    "project_id": project_id,
                    "version_id": version.id,
                    "created_by": current_user_id
                })
        
        # 重新获取版本（包含关联数据）
        version = await crud.get_with_relations_crud(version.id)
        
        return cls._build_version_out(version)
    
    @classmethod
    async def get_version_list_service(
        cls,
        query: VersionQuerySchema,
        current_user_id: int,
        db: AsyncSession
    ) -> dict:
        """获取版本列表"""
        crud = VersionCRUD(db)
        
        # 构建查询条件
        conditions = []
        if query.name:
            conditions.append(VersionModel.name.like(f"%{query.name}%"))
        if query.is_baseline is not None:
            conditions.append(VersionModel.is_baseline == query.is_baseline)
        
        # TODO: 如果指定了项目，需要关联查询
        
        # 查询版本
        skip = (query.page - 1) * query.page_size
        versions, total = await crud.get_versions_crud(
            conditions,
            skip,
            query.page_size
        )
        
        # 构建输出
        items = [cls._build_version_out(v).model_dump() for v in versions]
        
        # 直接返回数据字典，不使用page_response
        return {
            "items": items,
            "total": total,
            "page": query.page,
            "page_size": query.page_size,
            "total_pages": (total + query.page_size - 1) // query.page_size
        }
    
    @classmethod
    async def get_version_detail_service(
        cls,
        version_id: int,
        current_user_id: int,
        db: AsyncSession
    ) -> VersionOutSchema:
        """获取版本详情"""
        crud = VersionCRUD(db)
        version = await crud.get_with_relations_crud(version_id)
        
        if not version:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="版本不存在"
            )
        
        return cls._build_version_out(version)
    
    @classmethod
    async def update_version_service(
        cls,
        version_id: int,
        data: VersionUpdateSchema,
        current_user_id: int,
        db: AsyncSession
    ) -> VersionOutSchema:
        """更新版本"""
        crud = VersionCRUD(db)
        version = await crud.get_by_id_crud(version_id)
        
        if not version:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="版本不存在"
            )
        
        # 更新版本
        update_data = data.model_dump(exclude_unset=True)
        update_data["updated_by"] = current_user_id
        version = await crud.update_crud(version_id, update_data)
        
        # 重新获取版本（包含关联数据）
        version = await crud.get_with_relations_crud(version.id)
        
        return cls._build_version_out(version)
    
    @classmethod
    async def delete_version_service(
        cls,
        version_id: int,
        current_user_id: int,
        db: AsyncSession
    ) -> None:
        """删除版本"""
        crud = VersionCRUD(db)
        await crud.delete_crud([version_id])
    
    @classmethod
    async def associate_testcases_service(
        cls,
        data: VersionAssociationSchema,
        current_user_id: int,
        db: AsyncSession
    ) -> None:
        """关联测试用例到版本"""
        # 检查版本是否存在
        version_crud = VersionCRUD(db)
        version = await version_crud.get_by_id_crud(data.version_id)
        if not version:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="版本不存在"
            )
        
        # 删除旧关联
        tcv_crud = TestCaseVersionCRUD(db)
        await tcv_crud.delete_version_testcases_crud(data.version_id)
        
        # 创建新关联
        for testcase_id in data.testcase_ids:
            await tcv_crud.create_crud({
                "test_case_id": testcase_id,
                "version_id": data.version_id,
                "created_by": current_user_id
            })
    
    @classmethod
    def _build_version_out(cls, version: VersionModel) -> VersionOutSchema:
        """构建版本输出"""
        version_out = VersionOutSchema.model_validate(version)
        
        # 设置项目数量和用例数量
        if version.projects:
            version_out.project_count = len(version.projects)
        if version.test_cases:
            version_out.testcase_count = len(version.test_cases)
        
        return version_out
