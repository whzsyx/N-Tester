"""
项目管理模块测试用例
"""
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

# 测试数据
TEST_PROJECT = {
    "name": "测试项目",
    "description": "这是一个测试项目",
    "status": "active"
}

TEST_MEMBER = {
    "user_id": 2,
    "role": "developer"
}

TEST_ENVIRONMENT = {
    "name": "开发环境",
    "base_url": "https://dev.example.com",
    "description": "开发环境配置",
    "variables": {
        "API_KEY": "dev_key_123",
        "TIMEOUT": "30"
    },
    "is_default": True
}


class TestProjectManagement:
    """项目管理测试类"""
    
    @pytest.mark.asyncio
    async def test_create_project(self, client: AsyncClient, auth_headers: dict):
        """测试创建项目"""
        response = await client.post(
            "/api/v1/projects",
            json=TEST_PROJECT,
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["message"] == "项目创建成功"
        assert data["data"]["name"] == TEST_PROJECT["name"]
        assert data["data"]["member_count"] == 1  # 创建者自动成为成员
    
    @pytest.mark.asyncio
    async def test_get_project_list(self, client: AsyncClient, auth_headers: dict):
        """测试获取项目列表"""
        response = await client.get(
            "/api/v1/projects?page=1&page_size=20",
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert "items" in data["data"]
        assert "total" in data["data"]
    
    @pytest.mark.asyncio
    async def test_get_project_detail(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试获取项目详情"""
        response = await client.get(
            f"/api/v1/projects/{test_project_id}",
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["data"]["id"] == test_project_id
    
    @pytest.mark.asyncio
    async def test_update_project(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试更新项目"""
        update_data = {
            "name": "更新后的项目名称",
            "description": "更新后的描述"
        }
        response = await client.put(
            f"/api/v1/projects/{test_project_id}",
            json=update_data,
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["data"]["name"] == update_data["name"]
    
    @pytest.mark.asyncio
    async def test_add_project_member(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试添加项目成员"""
        response = await client.post(
            f"/api/v1/projects/{test_project_id}/members",
            json=TEST_MEMBER,
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["data"]["role"] == TEST_MEMBER["role"]
    
    @pytest.mark.asyncio
    async def test_get_project_members(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试获取项目成员列表"""
        response = await client.get(
            f"/api/v1/projects/{test_project_id}/members",
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert isinstance(data["data"], list)
        assert len(data["data"]) >= 1  # 至少有创建者
    
    @pytest.mark.asyncio
    async def test_create_project_environment(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试创建项目环境"""
        response = await client.post(
            f"/api/v1/projects/{test_project_id}/environments",
            json=TEST_ENVIRONMENT,
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["data"]["name"] == TEST_ENVIRONMENT["name"]
        assert data["data"]["is_default"] == True
    
    @pytest.mark.asyncio
    async def test_get_project_environments(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试获取项目环境列表"""
        response = await client.get(
            f"/api/v1/projects/{test_project_id}/environments",
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert isinstance(data["data"], list)
    
    @pytest.mark.asyncio
    async def test_permission_check(self, client: AsyncClient, non_member_headers: dict, test_project_id: int):
        """测试权限检查 - 非成员无法访问"""
        response = await client.get(
            f"/api/v1/projects/{test_project_id}",
            headers=non_member_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 400
        assert "无权访问" in data["message"]
    
    @pytest.mark.asyncio
    async def test_delete_project(self, client: AsyncClient, auth_headers: dict, test_project_id: int):
        """测试删除项目"""
        response = await client.delete(
            f"/api/v1/projects/{test_project_id}",
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 200
        assert data["message"] == "项目删除成功"


class TestProjectValidation:
    """项目数据验证测试类"""
    
    @pytest.mark.asyncio
    async def test_create_project_with_duplicate_name(self, client: AsyncClient, auth_headers: dict):
        """测试创建重名项目"""
        # 先创建一个项目
        await client.post("/api/v1/projects", json=TEST_PROJECT, headers=auth_headers)
        
        # 尝试创建同名项目
        response = await client.post(
            "/api/v1/projects",
            json=TEST_PROJECT,
            headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["code"] == 400
        assert "已存在" in data["message"]
    
    @pytest.mark.asyncio
    async def test_create_project_with_invalid_data(self, client: AsyncClient, auth_headers: dict):
        """测试创建项目时数据验证"""
        invalid_data = {
            "name": "",  # 空名称
            "status": "invalid_status"
        }
        response = await client.post(
            "/api/v1/projects",
            json=invalid_data,
            headers=auth_headers
        )
        assert response.status_code == 422  # Validation error


# Pytest fixtures
@pytest.fixture
async def test_project_id(client: AsyncClient, auth_headers: dict):
    """创建测试项目并返回ID"""
    response = await client.post(
        "/api/v1/projects",
        json=TEST_PROJECT,
        headers=auth_headers
    )
    data = response.json()
    project_id = data["data"]["id"]
    
    yield project_id
    
    # 清理：删除测试项目
    await client.delete(
        f"/api/v1/projects/{project_id}",
        headers=auth_headers
    )


@pytest.fixture
def auth_headers(test_token: str):
    """认证请求头"""
    return {"Authorization": f"Bearer {test_token}"}


@pytest.fixture
def non_member_headers(non_member_token: str):
    """非成员认证请求头"""
    return {"Authorization": f"Bearer {non_member_token}"}
