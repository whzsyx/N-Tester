/**
 * API测试模块接口
 */
import request from '/@/utils/request'

// ==================== API项目管理 ====================
export const apiProjectApi = {
  // 创建API项目
  create: (data: any) => request.post('/v1/api_testing/projects', data),
  
  // 获取API项目列表
  list: (params: any) => request.get('/v1/api_testing/projects', { params }),
  
  // 获取API项目详情
  get: (id: number) => request.get(`/v1/api_testing/projects/${id}`),
  
  // 更新API项目
  update: (id: number, data: any) => request.put(`/v1/api_testing/projects/${id}`, data),
  
  // 删除API项目
  delete: (id: number) => request.delete(`/v1/api_testing/projects/${id}`),
  
  // 导出API项目
  export: (id: number) => request.get(`/v1/api_testing/projects/${id}/export`),
  
  // 导入API项目
  import: (projectId: number, data: any) => request.post(`/v1/api_testing/projects/import?project_id=${projectId}`, { data })
}

// ==================== API集合管理 ====================
export const apiCollectionApi = {
  // 创建API集合
  create: (data: any) => request.post('/v1/api_testing/collections', data),
  
  // 获取API集合树
  tree: (apiProjectId: number) => request.get('/v1/api_testing/collections/tree', { params: { api_project_id: apiProjectId } }),
  
  // 获取API集合详情
  get: (id: number) => request.get(`/v1/api_testing/collections/${id}`),
  
  // 更新API集合
  update: (id: number, data: any) => request.put(`/v1/api_testing/collections/${id}`, data),
  
  // 删除API集合
  delete: (id: number) => request.delete(`/v1/api_testing/collections/${id}`),
  
  // 导出API集合
  export: (id: number) => request.get(`/v1/api_testing/collections/${id}/export`),
  
  // 导入API集合
  import: (apiProjectId: number, data: any, parentId?: number) => 
    request.post(`/v1/api_testing/collections/import?api_project_id=${apiProjectId}${parentId ? `&parent_id=${parentId}` : ''}`, { data })
}

// ==================== API请求管理 ====================
export const apiRequestApi = {
  // 创建API请求
  create: (data: any) => request.post('/v1/api_testing/requests', data),
  
  // 获取API请求列表
  list: (params: any) => request.get('/v1/api_testing/requests', { params }),
  
  // 获取API请求详情
  get: (id: number) => request.get(`/v1/api_testing/requests/${id}`),
  
  // 更新API请求
  update: (id: number, data: any) => request.put(`/v1/api_testing/requests/${id}`, data),
  
  // 删除API请求
  delete: (id: number) => request.delete(`/v1/api_testing/requests/${id}`),
  
  // 执行API请求
  execute: (id: number, data: any) => request.post(`/v1/api_testing/requests/${id}/execute`, data),
  
  // 获取请求历史
  history: (id: number, params: any) => request.get(`/v1/api_testing/requests/${id}/history`, { params })
}

// ==================== 环境变量管理 ====================
export const apiEnvironmentApi = {
  // 创建环境变量
  create: (data: any) => request.post('/v1/api_testing/environments', data),
  
  // 获取环境变量列表
  list: (projectId: number) => request.get('/v1/api_testing/environments', { params: { project_id: projectId } }),
  
  // 获取环境变量详情
  get: (id: number) => request.get(`/v1/api_testing/environments/${id}`),
  
  // 更新环境变量
  update: (id: number, data: any) => request.put(`/v1/api_testing/environments/${id}`, data),
  
  // 删除环境变量
  delete: (id: number) => request.delete(`/v1/api_testing/environments/${id}`),
  
  // 激活环境变量
  activate: (id: number) => request.post(`/v1/api_testing/environments/${id}/activate`),
  
  // 导出环境变量
  export: (projectId: number) => request.get('/v1/api_testing/environments/export', { params: { project_id: projectId } }),
  
  // 导入环境变量
  import: (projectId: number, data: any) => request.post(`/v1/api_testing/environments/import?project_id=${projectId}`, { data })
}

// ==================== 测试套件管理 ====================
export const apiTestSuiteApi = {
  // 创建测试套件
  create: (data: any) => request.post('/v1/api_testing/test_suites', data),
  
  // 获取测试套件列表
  list: (params: any) => request.get('/v1/api_testing/test_suites', { params }),
  
  // 获取测试套件详情
  get: (id: number) => request.get(`/v1/api_testing/test_suites/${id}`),
  
  // 更新测试套件
  update: (id: number, data: any) => request.put(`/v1/api_testing/test_suites/${id}`, data),
  
  // 删除测试套件
  delete: (id: number) => request.delete(`/v1/api_testing/test_suites/${id}`),
  
  // 执行测试套件
  execute: (id: number) => request.post(`/v1/api_testing/test_suites/${id}/execute`),
  
  // 获取执行历史
  executions: (id: number, params: any) => request.get(`/v1/api_testing/test_suites/${id}/executions`, { params })
}
