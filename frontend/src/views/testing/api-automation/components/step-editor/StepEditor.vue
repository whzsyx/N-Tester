<template>
  <div class="step-editor">
    <!-- 步骤列表 -->
    <div v-if="steps.length" class="step-list">
      <StepItem
        v-for="(step, i) in steps"
        :key="step._uid || i"
        :step="step"
        :index="i"
        :service-id="serviceId"
        :depth="depth"
        @delete="removeStep(i)"
      />
    </div>
    <div v-else class="step-empty">暂无步骤，点击下方按钮添加</div>

    <!-- 添加步骤菜单 -->
    <div v-if="!maxDepthReached" class="step-add-bar">
      <el-dropdown trigger="click" @command="addStep">
        <el-button type="primary" size="small" plain>
          <el-icon><ele-Plus /></el-icon> 添加步骤
        </el-button>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item v-for="t in stepTypes" :key="t.value" :command="t.value">
              <span class="step-type-dot" :style="{ background: t.color }"></span>
              {{ t.label }}
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
    <div v-else class="step-max-depth">已达最大嵌套深度（5层）</div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import StepItem from './StepItem.vue'

const props = defineProps<{
  modelValue: any[]
  serviceId?: number
  depth?: number
}>()

const emit = defineEmits<{ (e: 'update:modelValue', v: any[]): void }>()

const steps = computed({
  get: () => props.modelValue || [],
  set: (v) => emit('update:modelValue', v),
})

const MAX_DEPTH = 5
const maxDepthReached = computed(() => (props.depth || 0) >= MAX_DEPTH)

const stepTypes = [
  { label: 'HTTP 请求', value: 'api',    color: '#6366f1' },
  { label: 'SQL 查询',  value: 'sql',    color: '#783887' },
  { label: '自定义脚本', value: 'script', color: '#7b4d12' },
  { label: '条件控制器', value: 'if',     color: '#ee46bc' },
  { label: '循环控制器', value: 'loop',   color: '#ef6820' },
  { label: '等待控制器', value: 'wait',   color: '#10b981' },
]

const DEFAULT_REQUEST: Record<string, any> = {
  api:    { api_id: null },
  sql:    { db_id: null, sql: '', variable_name: '' },
  script: { script_content: '' },
  if:     { check: '', comparator: 'eq', expect: '', remarks: '' },
  loop:   { loop_type: 'count', count_number: 3, count_sleep_time: 0,
            for_variable_name: 'item', for_variable: '', for_sleep_time: 0,
            while_variable: '', while_comparator: 'eq', while_value: '',
            while_timeout: 60, while_sleep_time: 1 },
  wait:   { wait_time: 1 },
}

let _uid = 0
const addStep = (type: string) => {
  const newStep: any = {
    _uid: ++_uid,
    step_type: type,
    name: stepTypes.find(t => t.value === type)?.label || type,
    enable: true,
    request: JSON.parse(JSON.stringify(DEFAULT_REQUEST[type] || {})),
    extracts: [],
    validators: [],
    children_steps: [],
  }
  emit('update:modelValue', [...steps.value, newStep])
}

const removeStep = (i: number) => {
  const arr = [...steps.value]
  arr.splice(i, 1)
  emit('update:modelValue', arr)
}
</script>

<style scoped>
.step-editor { display: flex; flex-direction: column; gap: 0; }
.step-list { display: flex; flex-direction: column; gap: 6px; margin-bottom: 8px; }
.step-empty {
  text-align: center; font-size: 12px; color: var(--el-text-color-placeholder);
  padding: 16px 0; border: 1px dashed var(--el-border-color-light); border-radius: 6px;
  margin-bottom: 8px;
}
.step-add-bar { display: flex; }
.step-max-depth { font-size: 11px; color: var(--el-text-color-placeholder); }
.step-type-dot {
  display: inline-block; width: 8px; height: 8px; border-radius: 50%;
  margin-right: 6px; vertical-align: middle;
}
</style>
