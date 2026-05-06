<template>
  <div class="evp-wrap">
    <!-- 变量提取 -->
    <div class="evp-section">
      <div class="evp-header">
        <span class="evp-title">变量提取</span>
        <el-button type="primary" link size="small" @click="addExtract">+ 添加</el-button>
      </div>
      <div v-for="(e, i) in extracts" :key="i" class="evp-row">
        <el-input v-model="e.name" placeholder="变量名" size="small" style="width:110px" />
        <el-select v-model="e.extract_type" size="small" style="width:110px" @change="() => { e.path = '' }">
          <el-option label="jmespath" value="jmespath" />
          <el-option label="jsonpath" value="jsonpath" />
          <el-option label="响应头" value="header" />
          <el-option label="状态码" value="status_code" />
          <el-option label="响应时间" value="response_time" />
          <el-option label="正则" value="regex" />
        </el-select>
        <el-input
          v-if="e.extract_type !== 'status_code' && e.extract_type !== 'response_time'"
          v-model="e.path"
          :placeholder="extractPlaceholder(e.extract_type)"
          size="small"
          style="flex:1"
        />
        <span v-else style="flex:1;font-size:12px;color:#909399;padding-left:6px">
          {{ e.extract_type === 'status_code' ? '自动提取响应状态码' : '自动提取响应时间(ms)' }}
        </span>
        <el-button type="danger" link size="small" @click="extracts.splice(i, 1)">删除</el-button>
      </div>
      <div v-if="!extracts.length" class="evp-empty">暂无提取规则</div>
    </div>

    <!-- 断言 -->
    <div class="evp-section">
      <div class="evp-header">
        <span class="evp-title">断言</span>
        <el-button type="primary" link size="small" @click="addValidator">+ 添加</el-button>
      </div>
      <div v-for="(v, i) in validators" :key="i" class="evp-row evp-row--validator">
        <!-- 断言类型 -->
        <el-select v-model="v.mode" size="small" style="width:110px" @change="() => { v.check = ''; v.expect = '' }">
          <el-option label="jmespath" value="jmespath" />
          <el-option label="jsonpath" value="jsonpath" />
          <el-option label="变量" value="variable" />
          <el-option label="响应头" value="header" />
          <el-option label="状态码" value="status_code" />
          <el-option label="响应时间" value="response_time" />
          <el-option label="响应体包含" value="body_contains" />
          <el-option label="正则匹配" value="regex" />
        </el-select>

        <!-- 取值表达式（状态码/响应时间/响应体包含 不需要路径） -->
        <el-input
          v-if="!['status_code', 'response_time', 'body_contains'].includes(v.mode)"
          v-model="v.check"
          :placeholder="validatorCheckPlaceholder(v.mode)"
          size="small"
          style="flex:1"
        />
        <span
          v-else
          style="flex:1;font-size:12px;color:#909399;padding:0 6px;white-space:nowrap"
        >
          {{ validatorCheckLabel(v.mode) }}
        </span>

        <!-- 比较符 -->
        <el-select v-model="v.comparator" size="small" :style="comparatorWidth(v.mode)">
          <el-option v-for="c in getComparators(v.mode)" :key="c.value" :label="c.label" :value="c.value" />
        </el-select>

        <!-- 期望值 -->
        <el-input v-model="v.expect" placeholder="期望值" size="small" style="flex:1" />
        <el-button type="danger" link size="small" @click="validators.splice(i, 1)">删除</el-button>
      </div>
      <div v-if="!validators.length" class="evp-empty">暂无断言规则</div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{ extracts: any[]; validators: any[] }>()

// ---- 提取类型占位符 ----
const extractPlaceholder = (t: string) => {
  if (t === 'jmespath') return 'body.data.token'
  if (t === 'jsonpath') return '$.data.rows[0].id'
  if (t === 'header') return 'Content-Type'
  if (t === 'regex') return '正则表达式，如 (\\d+)'
  return ''
}

// ---- 断言取值表达式占位符 ----
const validatorCheckPlaceholder = (mode: string) => {
  if (mode === 'jmespath') return 'body.code'
  if (mode === 'jsonpath') return '$.code'
  if (mode === 'variable') return '变量名，如 token'
  if (mode === 'header') return 'Header 名，如 Content-Type'
  if (mode === 'regex') return '正则表达式'
  return '取值表达式'
}

const validatorCheckLabel = (mode: string) => {
  if (mode === 'status_code') return '响应状态码'
  if (mode === 'response_time') return '响应时间(ms)'
  if (mode === 'body_contains') return '响应体文本'
  return ''
}

const comparatorWidth = (mode: string) => {
  return { width: '110px' }
}

// ---- 比较符列表（根据断言类型过滤） ----
const allComparators = [
  { label: '等于', value: 'eq' },
  { label: '不等于', value: 'ne' },
  { label: '大于', value: 'gt' },
  { label: '大于等于', value: 'gte' },
  { label: '小于', value: 'lt' },
  { label: '小于等于', value: 'lte' },
  { label: '包含', value: 'contains' },
  { label: '不包含', value: 'not_contains' },
  { label: '开头', value: 'startswith' },
  { label: '结尾', value: 'endswith' },
  { label: '正则', value: 'regex' },
  { label: '为空', value: 'is_null' },
  { label: '非空', value: 'not_null' },
  { label: '匹配', value: 'match' },
]

const numericComparators = ['eq', 'ne', 'gt', 'gte', 'lt', 'lte']
const textComparators = ['eq', 'ne', 'contains', 'not_contains', 'startswith', 'endswith', 'regex', 'is_null', 'not_null']

const getComparators = (mode: string) => {
  if (mode === 'status_code' || mode === 'response_time') {
    return allComparators.filter(c => numericComparators.includes(c.value))
  }
  if (mode === 'body_contains') {
    return allComparators.filter(c => ['contains', 'not_contains', 'regex', 'match'].includes(c.value))
  }
  return allComparators
}

// ---- 添加 ----
const addExtract = () => props.extracts.push({ name: '', extract_type: 'jmespath', path: '' })
const addValidator = () => props.validators.push({ mode: 'jmespath', check: '', comparator: 'eq', expect: '' })
</script>

<style scoped>
.evp-wrap { display: flex; flex-direction: column; gap: 12px; }
.evp-section { border: 1px solid var(--el-border-color-light); border-radius: 6px; padding: 8px 10px; }
.evp-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.evp-title { font-size: 12px; font-weight: 600; color: var(--el-text-color-regular); }
.evp-row { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; flex-wrap: nowrap; }
.evp-row--validator { flex-wrap: wrap; }
.evp-empty { font-size: 12px; color: var(--el-text-color-placeholder); text-align: center; padding: 4px 0; }
</style>
