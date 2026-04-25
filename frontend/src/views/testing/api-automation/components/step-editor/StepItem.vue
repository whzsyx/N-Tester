<template>
  <div class="step-item" :class="{ disabled: !step.enable }">
    <!-- 步骤头部 -->
    <div class="step-header" @click="toggle">
      <span class="step-index">{{ index + 1 }}</span>
      <span class="step-type-tag" :style="{ background: typeInfo.color }">{{ typeInfo.label }}</span>
      <el-input
        v-model="step.name"
        size="small"
        class="step-name-input"
        placeholder="步骤名称"
        @click.stop
      />
      <div class="step-actions" @click.stop>
        <el-switch v-model="step.enable" size="small" />
        <el-button type="danger" link size="small" @click="$emit('delete')">
          <el-icon><ele-Delete /></el-icon>
        </el-button>
        <el-icon class="expand-icon" :class="{ expanded }">
          <ele-ArrowRight />
        </el-icon>
      </div>
    </div>

    <!-- 步骤内容（展开时显示） -->
    <div v-show="expanded" class="step-body">
      <ApiStepForm v-if="step.step_type === 'api'" :step="step" :service-id="serviceId" />
      <SqlStepForm v-else-if="step.step_type === 'sql'" :step="step" />
      <ScriptStepForm v-else-if="step.step_type === 'script'" :step="step" :service-id="serviceId" />
      <IfStepForm v-else-if="step.step_type === 'if'" :step="step" />
      <LoopStepForm v-else-if="step.step_type === 'loop'" :step="step" />
      <WaitStepForm v-else-if="step.step_type === 'wait'" :step="step" />

      <!-- if/loop 子步骤编辑器 -->
      <div v-if="step.step_type === 'if' || step.step_type === 'loop'" class="children-editor">
        <div class="children-label">子步骤</div>
        <StepEditor
          v-model="step.children_steps"
          :service-id="serviceId"
          :depth="depth + 1"
        />
      </div>

      <!-- 提取 + 断言（api/sql 步骤显示） -->
      <div v-if="['api', 'sql'].includes(step.step_type)" class="evp-section">
        <ExtractValidatorPanel
          :extracts="step.extracts || (step.extracts = [])"
          :validators="step.validators || (step.validators = [])"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, defineAsyncComponent } from 'vue'
import ApiStepForm from './ApiStepForm.vue'
import SqlStepForm from './SqlStepForm.vue'
import ScriptStepForm from './ScriptStepForm.vue'
import IfStepForm from './IfStepForm.vue'
import LoopStepForm from './LoopStepForm.vue'
import WaitStepForm from './WaitStepForm.vue'
import ExtractValidatorPanel from './ExtractValidatorPanel.vue'

// 懒加载避免循环引用
const StepEditor = defineAsyncComponent(() => import('./StepEditor.vue'))

const props = defineProps<{
  step: any
  index: number
  serviceId?: number
  depth?: number
}>()

defineEmits<{ (e: 'delete'): void }>()

const expanded = ref(false)
const toggle = () => { expanded.value = !expanded.value }

const TYPE_META: Record<string, { label: string; color: string }> = {
  api:    { label: 'HTTP',   color: '#6366f1' },
  sql:    { label: 'SQL',    color: '#783887' },
  script: { label: '脚本',   color: '#7b4d12' },
  if:     { label: '条件',   color: '#ee46bc' },
  loop:   { label: '循环',   color: '#ef6820' },
  wait:   { label: '等待',   color: '#10b981' },
}

const typeInfo = computed(() => TYPE_META[props.step.step_type] || { label: props.step.step_type, color: '#94a3b8' })
</script>

<style scoped>
.step-item {
  border: 1px solid var(--el-border-color-light);
  border-radius: 8px;
  overflow: hidden;
  transition: opacity .2s;
}
.step-item.disabled { opacity: .55; }

.step-header {
  display: flex; align-items: center; gap: 8px;
  padding: 8px 10px; cursor: pointer;
  background: var(--el-fill-color-lighter);
  user-select: none;
}
.step-header:hover { background: var(--el-fill-color-light); }

.step-index {
  width: 20px; height: 20px; border-radius: 50%;
  background: var(--el-color-primary-light-7);
  color: var(--el-color-primary); font-size: 11px; font-weight: 600;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}

.step-type-tag {
  padding: 2px 8px; border-radius: 4px; font-size: 11px;
  color: #fff; font-weight: 600; white-space: nowrap; flex-shrink: 0;
}

.step-name-input { flex: 1; }
.step-name-input :deep(.el-input__wrapper) { box-shadow: none; background: transparent; }

.step-actions { display: flex; align-items: center; gap: 6px; flex-shrink: 0; }

.expand-icon {
  transition: transform .2s; color: var(--el-text-color-placeholder);
}
.expand-icon.expanded { transform: rotate(90deg); }

.step-body { padding: 12px; border-top: 1px solid var(--el-border-color-lighter); }

.children-editor {
  margin-top: 12px; padding: 10px;
  border: 1px dashed var(--el-border-color);
  border-radius: 6px; background: var(--el-fill-color-lighter);
}
.children-label {
  font-size: 11px; font-weight: 600; color: var(--el-text-color-secondary);
  margin-bottom: 8px;
}

.evp-section { margin-top: 12px; }
</style>
