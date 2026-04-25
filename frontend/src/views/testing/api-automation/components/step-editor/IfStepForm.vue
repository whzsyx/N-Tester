<template>
  <div class="if-step-form">
    <div class="if-row">
      <span class="if-label">如果</span>
      <el-input v-model="req.check" placeholder="${变量名} 或 表达式" size="small" style="flex:1" />
      <el-select v-model="req.comparator" size="small" style="width:110px">
        <el-option v-for="c in comparators" :key="c.value" :label="c.label" :value="c.value" />
      </el-select>
      <el-input v-model="req.expect" placeholder="期望值" size="small" style="flex:1" />
    </div>
    <div class="if-hint">条件满足时执行下方子步骤，不满足则跳过</div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ step: any }>()

const req = computed(() => {
  if (!props.step.request) props.step.request = { check: '', comparator: 'eq', expect: '', remarks: '' }
  return props.step.request
})

const comparators = [
  { label: '等于', value: 'eq' }, { label: '不等于', value: 'ne' },
  { label: '大于', value: 'gt' }, { label: '大于等于', value: 'gte' },
  { label: '小于', value: 'lt' }, { label: '小于等于', value: 'lte' },
  { label: '包含', value: 'contains' }, { label: '不包含', value: 'not_contains' },
  { label: '为空', value: 'is_null' }, { label: '非空', value: 'not_null' },
]
</script>

<style scoped>
.if-step-form { padding: 4px 0; }
.if-row { display: flex; align-items: center; gap: 8px; }
.if-label { font-size: 12px; font-weight: 600; color: #ee46bc; white-space: nowrap; }
.if-hint { font-size: 11px; color: var(--el-text-color-placeholder); margin-top: 6px; }
</style>
