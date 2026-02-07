import request from '/@/utils/request'

/**
 * 编码生成器API
 */
export function useCodeGeneratorApi() {
  return {
    /**
     * 生成编码
     */
    generate: (data: {
      prefix?: string
      separator?: string
      generate_mode?: string
      date_format?: string
      seq_length?: number
      seq_reset_rule?: string
      random_length?: number
      custom_template?: string
      business_type?: string
    }) => {
      return request({
        url: '/v1/system/code-generator/generate',
        method: 'post',
        data
      })
    },

    /**
     * 获取生成方式列表
     */
    getModes: () => {
      return request({
        url: '/v1/system/code-generator/modes',
        method: 'get'
      })
    }
  }
}

/**
 * 生成方式类型
 */
export type GenerateMode =
  | 'datetime'   // 日期时间
  | 'date_seq'   // 日期+序号
  | 'uuid'       // UUID片段
  | 'snowflake'  // 雪花ID
  | 'random'     // 随机字符
  | 'custom'     // 自定义模板

/**
 * 序号重置规则类型
 */
export type SeqResetRule = 'daily' | 'monthly' | 'yearly' | 'never'

/**
 * 编码生成器配置接口
 */
export interface CodeGeneratorConfig {
  prefix?: string
  separator?: string
  generateMode?: GenerateMode
  dateFormat?: string
  seqLength?: number
  seqResetRule?: SeqResetRule
  randomLength?: number
  customTemplate?: string
  businessType?: string
}
