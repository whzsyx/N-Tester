"""
测试用例管理数据访问层
"""

from typing import Optional, List
from sqlalchemy import select, and_, func, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from app.core.base_crud import BaseCRUD
from app.api.v1.testcases.model import (
    TestCaseModel, TestCaseStepModel, VersionModel,
    ProjectVersionModel, TestCaseVersionModel
)


class TestCaseCRUD(BaseCRUD[TestCaseModel]):
    """测试用例CRUD"""
    
    def __init__(self, db: AsyncSession):
        super().__init__(TestCaseModel, db)
    
    async def get_with_relations_crud(self, testcase_id: int) -> Optional[TestCaseModel]:
        """获取测试用例（包含关联数据）"""
        stmt = (
            select(self.model)
            .where(self.model.id == testcase_id)
            .options(
                selectinload(self.model.steps),
                selectinload(self.model.author),
                selectinload(self.model.assignee),
                selectinload(self.model.versions)
            )
        )
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
    
    async def get_project_testcases_crud(
        self,
        project_id: int,
        conditions: list = None,
        skip: int = 0,
        limit: int = 20
    ) -> tuple[List[TestCaseModel], int]:
        """获取项目的测试用例列表"""
        # 构建查询条件
        query_conditions = [self.model.project_id == project_id]
        if conditions:
            query_conditions.extend(conditions)
        
        # 查询总数
        count_stmt = select(func.count(self.model.id)).where(and_(*query_conditions))
        count_result = await self.db.execute(count_stmt)
        total = count_result.scalar()
        
        # 查询列表
        stmt = (
            select(self.model)
            .where(and_(*query_conditions))
            .options(
                selectinload(self.model.steps),
                selectinload(self.model.author),
                selectinload(self.model.assignee),
                selectinload(self.model.versions)
            )
            .order_by(self.model.creation_date.desc())
            .offset(skip)
            .limit(limit)
        )
        result = await self.db.execute(stmt)
        items = result.scalars().all()
        
        return list(items), total


class TestCaseStepCRUD(BaseCRUD[TestCaseStepModel]):
    """测试用例步骤CRUD"""
    
    def __init__(self, db: AsyncSession):
        super().__init__(TestCaseStepModel, db)
    
    async def get_testcase_steps_crud(self, testcase_id: int) -> List[TestCaseStepModel]:
        """获取测试用例的所有步骤"""
        stmt = (
            select(self.model)
            .where(self.model.test_case_id == testcase_id)
            .order_by(self.model.step_number.asc())
        )
        result = await self.db.execute(stmt)
        return list(result.scalars().all())
    
    async def delete_testcase_steps_crud(self, testcase_id: int) -> None:
        """删除测试用例的所有步骤"""
        stmt = select(self.model).where(self.model.test_case_id == testcase_id)
        result = await self.db.execute(stmt)
        steps = result.scalars().all()
        for step in steps:
            await self.db.delete(step)
        await self.db.commit()


class VersionCRUD(BaseCRUD[VersionModel]):
    """版本CRUD"""
    
    def __init__(self, db: AsyncSession):
        super().__init__(VersionModel, db)
    
    async def get_by_name_crud(self, name: str) -> Optional[VersionModel]:
        """根据版本名称获取版本"""
        stmt = select(self.model).where(self.model.name == name)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
    
    async def get_with_relations_crud(self, version_id: int) -> Optional[VersionModel]:
        """获取版本（包含关联数据）"""
        stmt = (
            select(self.model)
            .where(self.model.id == version_id)
            .options(
                selectinload(self.model.projects),
                selectinload(self.model.test_cases)
            )
        )
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
    
    async def get_versions_crud(
        self,
        conditions: list = None,
        skip: int = 0,
        limit: int = 20
    ) -> tuple[List[VersionModel], int]:
        """获取版本列表"""
        # 构建查询条件
        query_conditions = []
        if conditions:
            query_conditions.extend(conditions)
        
        # 查询总数
        if query_conditions:
            count_stmt = select(func.count(self.model.id)).where(and_(*query_conditions))
        else:
            count_stmt = select(func.count(self.model.id))
        count_result = await self.db.execute(count_stmt)
        total = count_result.scalar()
        
        # 查询列表
        if query_conditions:
            stmt = (
                select(self.model)
                .where(and_(*query_conditions))
                .options(
                    selectinload(self.model.projects),
                    selectinload(self.model.test_cases)
                )
                .order_by(self.model.creation_date.desc())
                .offset(skip)
                .limit(limit)
            )
        else:
            stmt = (
                select(self.model)
                .options(
                    selectinload(self.model.projects),
                    selectinload(self.model.test_cases)
                )
                .order_by(self.model.creation_date.desc())
                .offset(skip)
                .limit(limit)
            )
        result = await self.db.execute(stmt)
        items = result.scalars().all()
        
        return list(items), total


class ProjectVersionCRUD(BaseCRUD[ProjectVersionModel]):
    """项目版本关联CRUD"""
    
    def __init__(self, db: AsyncSession):
        super().__init__(ProjectVersionModel, db)
    
    async def get_by_project_version_crud(
        self,
        project_id: int,
        version_id: int
    ) -> Optional[ProjectVersionModel]:
        """根据项目ID和版本ID获取关联"""
        stmt = select(self.model).where(
            and_(
                self.model.project_id == project_id,
                self.model.version_id == version_id
            )
        )
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
    
    async def get_project_versions_crud(self, project_id: int) -> List[VersionModel]:
        """获取项目的所有版本"""
        stmt = (
            select(VersionModel)
            .join(ProjectVersionModel, ProjectVersionModel.version_id == VersionModel.id)
            .where(ProjectVersionModel.project_id == project_id)
            .order_by(VersionModel.creation_date.desc())
        )
        result = await self.db.execute(stmt)
        return list(result.scalars().all())


class TestCaseVersionCRUD(BaseCRUD[TestCaseVersionModel]):
    """用例版本关联CRUD"""
    
    def __init__(self, db: AsyncSession):
        super().__init__(TestCaseVersionModel, db)
    
    async def get_by_testcase_version_crud(
        self,
        testcase_id: int,
        version_id: int
    ) -> Optional[TestCaseVersionModel]:
        """根据用例ID和版本ID获取关联"""
        stmt = select(self.model).where(
            and_(
                self.model.test_case_id == testcase_id,
                self.model.version_id == version_id
            )
        )
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
    
    async def get_version_testcases_crud(self, version_id: int) -> List[TestCaseModel]:
        """获取版本的所有测试用例"""
        stmt = (
            select(TestCaseModel)
            .join(TestCaseVersionModel, TestCaseVersionModel.test_case_id == TestCaseModel.id)
            .where(TestCaseVersionModel.version_id == version_id)
            .options(
                selectinload(TestCaseModel.steps),
                selectinload(TestCaseModel.author),
                selectinload(TestCaseModel.assignee)
            )
            .order_by(TestCaseModel.creation_date.desc())
        )
        result = await self.db.execute(stmt)
        return list(result.scalars().all())
    
    async def delete_version_testcases_crud(self, version_id: int) -> None:
        """删除版本的所有测试用例关联"""
        stmt = select(self.model).where(self.model.version_id == version_id)
        result = await self.db.execute(stmt)
        associations = result.scalars().all()
        for association in associations:
            await self.db.delete(association)
        await self.db.commit()
