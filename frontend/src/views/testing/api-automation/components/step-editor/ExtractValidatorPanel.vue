<template>
  <div class="evp-wrap">
    <!-- 提取规则 -->
    <div class="evp-section">
      <div class="evp-header">
        <span class="evp-title">变量提取</span>
        <el-button type="primary" link size="small" @click="addExtract">+ 添加</el-button>
      </div>
      <div v-for="(e, i) in extracts" :key="i" class="evp-row">
        <el-input v-model="e.name" placeholder="变量名" size="small" style="width:120px" />
        <el-select v-model="e.extract_type" size="small" style="width:100px">
          <el-option label="jmespath" value="jmespath" />
          <el-option label="jsonpath" value="jsonpath" />
          <el-option label="响应头" value="header" />
        </el-select>
        <el-input v-model="e.path" :placeholder="extractPlaceholder(e.extract_type)" size="small" style="flex:1" />
        <el-button type="danger" link size="small" @click="extracts.splice(i,1)">删除</el-button>
      </div>
      <div v-if="!extracts.length" class="evp-empty">暂无提取规则</div>
    </div>

    <!-- 断言规则 -->
    <div class="evp-section">
      <div class="evp-header">
        <span class="evp-title">断言</span>
        <el-button type="primary" link size="small" @click="addValidator">+ 添加</el-button>
      </div>
      <div v-for="(v, i) in validators" :key="i" class="evp-row">
        <el-select v-model="v.mode" size="small" style="width:90px">
          <el-option label="jmespath" value="jmespath" />
          <el-option label="jsonpath" value="jsonpath" />
          <el-option label="变量" value="variable" />
        </el-select>
        <el-input v-model="v.check" placeholder="取值表达式" size="small" style="flex:1" />
        <el-select v-model="v.comparator" size="small" style="width:100px">
          <el-option v-for="c in comparators" :key="c.value" :label="c.label" :value="c.value" />
        </el-select>
        <el-input v-model="v.expect" placeholder="期望值" size="small" style="flex:1" />
        <el-button type="danger" link size="small" @click="validators.splice(i,1)">删除</el-button>
      </div>
      <div v-if="!validators.length" class="evp-empty">暂无断言规则</div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{ extracts: any[]; validators: any[] }>()

const comparators = [
  { label: '等于', value: 'eq' }, { label: '不等于', value: 'ne' },
  { label: '大于', value: 'gt' }, { label: '大于等于', value: 'gte' },
  { label: '小于', value: 'lt' }, { label: '小于等于', value: 'lte' },
  { label: '包含', value: 'contains' }, { label: '不包含', value: 'not_contains' },
  { label: '开头', value: 'startswith' }, { label: '结尾', value: 'endswith' },
  { label: '正则', value: 'regex' }, { label: '为空', value: 'is_null' },
  { label: '非空', value: 'not_null' },
]

const extractPlaceholder = (t: string) => {
  if (t === 'jmespath') return 'body.data.token'
  if (t === 'jsonpath') return '$.data.rows[0].id'
  return 'Content-Type'
}

const addExtract = () => props.extracts.push({ name: '', extract_type: 'jmespath', path: '' })
const addValidator = () => props.validators.push({ mode: 'jmespath', check: '', comparator: 'eq', expect: '' })
</script>

<style scoped>
.evp-wrap { display: flex; flex-direction: column; gap: 12px; }
.evp-section { border: 1px solid var(--el-border-color-light); border-radius: 6px; padding: 8px 10px; }
.evp-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.evp-title { font-size: 12px; font-weight: 600; color: var(--el-text-color-regular); }
.evp-row { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
.evp-empty { font-size: 12px; color: var(--el-text-color-placeholder); text-align: center; padding: 4px 0; }
</style>
