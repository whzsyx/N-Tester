/**
 * 前置/后置操作相关API
 */
import request from '/@/utils/request'

// ==================== 公共脚本管理 ====================

/**
 * 获取公共脚本列表
 */
export function getPublicScripts(params: {
  project_id: number
  page?: number
  page_size?: number
}) {
  return request({
    url: '/v1/api_testing/public-scripts',
    method: 'get',
    params
  })
}

/**
 * 创建公共脚本
 */
export function createPublicScript(data: {
  project_id: number
  name: string
  description?: string
  script_type?: string
  script_content: string
  category?: string
  is_active?: boolean
}) {
  return request({
    url: '/v1/api_testing/public-scripts',
    method: 'post',
    data
  })
}

/**
 * 更新公共脚本
 */
export function updatePublicScript(id: number, data: any) {
  return request({
    url: `/v1/api_testing/public-scripts/${id}`,
    method: 'put',
    data
  })
}

/**
 * 删除公共脚本
 */
export function deletePublicScript(id: number) {
  return request({
    url: `/v1/api_testing/public-scripts/${id}`,
    method: 'delete'
  })
}

/**
 * 获取公共脚本详情
 */
export function getPublicScriptDetail(id: number) {
  return request({
    url: `/v1/api_testing/public-scripts/${id}`,
    method: 'get'
  })
}

// ==================== 数据库配置管理 ====================

/**
 * 获取数据库配置列表
 */
export function getDatabaseConfigs(params: {
  project_id: number
  page?: number
  page_size?: number
}) {
  return request({
    url: '/v1/api_testing/database-configs',
    method: 'get',
    params
  })
}

/**
 * 创建数据库配置
 */
export function createDatabaseConfig(data: {
  project_id: number
  name: string
  description?: string
  db_type: string
  host: string
  port: number
  database_name?: string
  username?: string
  password?: string
  connection_params?: any
  is_active?: boolean
}) {
  return request({
    url: '/v1/api_testing/database-configs',
    method: 'post',
    data
  })
}

/**
 * 更新数据库配置
 */
export function updateDatabaseConfig(id: number, data: any) {
  return request({
    url: `/v1/api_testing/database-configs/${id}`,
    method: 'put',
    data
  })
}

/**
 * 删除数据库配置
 */
export function deleteDatabaseConfig(id: number) {
  return request({
    url: `/v1/api_testing/database-configs/${id}`,
    method: 'delete'
  })
}

/**
 * 获取数据库配置详情
 */
export function getDatabaseConfigDetail(id: number) {
  return request({
    url: `/v1/api_testing/database-configs/${id}`,
    method: 'get'
  })
}

/**
 * 测试数据库连接
 */
export function testDatabaseConnection(id: number) {
  return request({
    url: `/v1/api_testing/database-configs/${id}/test`,
    method: 'post'
  })
}
