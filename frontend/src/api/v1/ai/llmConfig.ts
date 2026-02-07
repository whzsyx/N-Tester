import request from '/@/utils/request'

/**
 * LLM 配置 API
 */
export function useLLMConfigApi() {
  return {
    /**
     * 获取配置列表
     */
    getList: (params?: {
      provider?: string
      is_active?: boolean
    }) => {
      return request({
        url: '/v1/ai/llm-config',
        method: 'GET',
        params
      })
    },

    /**
     * 获取默认配置
     */
    getDefault: () => {
      return request({
        url: '/v1/ai/llm-config/default',
        method: 'GET'
      })
    },

    /**
     * 获取配置详情
     */
    getDetail: (id: number) => {
      return request({
        url: `/v1/ai/llm-config/${id}`,
        method: 'GET'
      })
    },

    /**
     * 创建配置
     */
    create: (data: LLMConfigCreateData) => {
      return request({
        url: '/v1/ai/llm-config',
        method: 'POST',
        data
      })
    },

    /**
     * 更新配置
     */
    update: (id: number, data: LLMConfigUpdateData) => {
      return request({
        url: `/v1/ai/llm-config/${id}`,
        method: 'PUT',
        data
      })
    },

    /**
     * 删除配置
     */
    delete: (id: number) => {
      return request({
        url: `/v1/ai/llm-config/${id}`,
        method: 'DELETE'
      })
    },

    /**
     * 设置为默认配置
     */
    setDefault: (id: number) => {
      return request({
        url: `/v1/ai/llm-config/${id}/set-default`,
        method: 'POST'
      })
    },

    /**
     * 测试配置
     */
    test: (data: LLMConfigTestData) => {
      return request({
        url: '/v1/ai/llm-config/test',
        method: 'POST',
        data
      })
    }
  }
}

/**
 * LLM 提供商类型
 */
export type LLMProvider = 'openai' | 'azure_openai' | 'anthropic' | 'ollama' | 'custom'

/**
 * LLM 配置数据
 */
export interface LLMConfigData {
  id: number
  config_name: string
  name: string
  provider: LLMProvider
  model_name: string
  api_key: string
  base_url?: string
  system_prompt?: string
  temperature: number
  max_tokens: number
  supports_vision: boolean
  context_limit: number
  is_default: boolean
  is_active: boolean
  creation_date?: string
  created_by?: number
  updation_date?: string
  updated_by?: number
}

/**
 * 创建配置数据
 */
export interface LLMConfigCreateData {
  config_name: string
  name: string
  provider: LLMProvider
  model_name: string
  api_key: string
  base_url?: string
  system_prompt?: string
  temperature?: number
  max_tokens?: number
  supports_vision?: boolean
  context_limit?: number
  is_default?: boolean
  is_active?: boolean
}

/**
 * 更新配置数据
 */
export interface LLMConfigUpdateData {
  config_name?: string
  name?: string
  provider?: LLMProvider
  model_name?: string
  api_key?: string
  base_url?: string
  system_prompt?: string
  temperature?: number
  max_tokens?: number
  supports_vision?: boolean
  context_limit?: number
  is_default?: boolean
  is_active?: boolean
}

/**
 * 测试配置数据
 */
export interface LLMConfigTestData {
  config_id?: number
  config_name?: string
  name?: string
  provider?: LLMProvider
  api_key?: string
  base_url?: string
  test_message?: string
}

/**
 * 测试响应数据
 */
export interface LLMConfigTestResponse {
  success: boolean
  message: string
  response?: string
  error?: string
  latency?: number
}
