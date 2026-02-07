/**
 * SSL证书管理API
 */
import request from '/@/utils/request'

export interface SSLCertificate {
  id?: number
  project_id: number
  name: string
  cert_type: 'CA' | 'CLIENT'
  domain?: string
  ca_cert?: string
  client_cert?: string
  client_key?: string
  passphrase?: string
  is_active: boolean
  description?: string
  creation_date?: string
  updation_date?: string
}

export interface SSLCertificateCreate {
  project_id: number
  name: string
  cert_type: 'CA' | 'CLIENT'
  domain?: string
  ca_cert?: string
  client_cert?: string
  client_key?: string
  passphrase?: string
  is_active?: boolean
  description?: string
}

export interface SSLCertificateUpdate {
  name?: string
  domain?: string
  ca_cert?: string
  client_cert?: string
  client_key?: string
  passphrase?: string
  is_active?: boolean
  description?: string
}

export const sslCertificateApi = {
  /**
   * 创建SSL证书
   */
  create(data: SSLCertificateCreate) {
    return request({
      url: '/v1/api_testing/ssl-certificates',
      method: 'post',
      data
    })
  },

  /**
   * 获取证书列表
   */
  list(params: { project_id: number; page?: number; page_size?: number }) {
    return request({
      url: '/v1/api_testing/ssl-certificates',
      method: 'get',
      params
    })
  },

  /**
   * 获取证书详情
   */
  get(id: number) {
    return request({
      url: `/v1/api_testing/ssl-certificates/${id}`,
      method: 'get'
    })
  },

  /**
   * 更新证书
   */
  update(id: number, data: SSLCertificateUpdate) {
    return request({
      url: `/v1/api_testing/ssl-certificates/${id}`,
      method: 'put',
      data
    })
  },

  /**
   * 删除证书
   */
  delete(id: number) {
    return request({
      url: `/v1/api_testing/ssl-certificates/${id}`,
      method: 'delete'
    })
  },

  /**
   * 切换证书启用状态
   */
  toggle(id: number) {
    return request({
      url: `/v1/api_testing/ssl-certificates/${id}/toggle`,
      method: 'put'
    })
  }
}
