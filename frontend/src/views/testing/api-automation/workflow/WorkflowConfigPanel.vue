<template>
  <div class="wcp-overlay" :class="{ visible }" @click.self="$emit('close')">
    <div class="wcp-panel" :class="{ open: visible }">
      <!-- Header -->
      <div class="wcp-header">
        <div class="wcp-title-row">
          <span
            class="wcp-type-badge"
            :style="node ? { background: STEP_TYPE_META[node.step.step_type].color } : {}"
          >
            {{ node ? STEP_TYPE_META[node.step.step_type].label : '' }}
          </span>
          <el-input
            v-if="node"
            v-model="node.step.name"
            size="small"
            class="wcp-name-input"
            placeholder="步骤名称"
          />
        </div>
        <el-button class="wcp-close-btn" text @click="$emit('close')">
          <el-icon><Close /></el-icon>
        </el-button>
      </div>

      <!-- Form body -->
      <div class="wcp-body" v-if="node">
        <ApiStepForm
          v-if="node.step.step_type === 'api'"
          :step="node.step"
          :service-id="serviceId"
        />
        <SqlStepForm
          v-else-if="node.step.step_type === 'sql'"
          :step="node.step"
        />
        <ScriptStepForm
          v-else-if="node.step.step_type === 'script'"
          :step="node.step"
          :service-id="serviceId"
        />
        <IfStepForm
          v-else-if="node.step.step_type === 'if'"
          :step="node.step"
        />
        <LoopStepForm
          v-else-if="node.step.step_type === 'loop'"
          :step="node.step"
        />
        <WaitStepForm
          v-else-if="node.step.step_type === 'wait'"
          :step="node.step"
        />

        <!-- Extract + Validator panel for api and sql -->
        <template v-if="node.step.step_type === 'api' || node.step.step_type === 'sql'">
          <el-divider />
          <ExtractValidatorPanel
            :extracts="node.step.extracts"
            :validators="node.step.validators"
          />
        </template>
      </div>

      <!-- Footer -->
      <div class="wcp-footer">
        <el-button type="primary" style="width: 100%" @click="$emit('save')">保存</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Close } from '@element-plus/icons-vue'
import { STEP_TYPE_META, type WorkflowNode } from './types'
import ApiStepForm from '../components/step-editor/ApiStepForm.vue'
import SqlStepForm from '../components/step-editor/SqlStepForm.vue'
import ScriptStepForm from '../components/step-editor/ScriptStepForm.vue'
import IfStepForm from '../components/step-editor/IfStepForm.vue'
import LoopStepForm from '../components/step-editor/LoopStepForm.vue'
import WaitStepForm from '../components/step-editor/WaitStepForm.vue'
import ExtractValidatorPanel from '../components/step-editor/ExtractValidatorPanel.vue'

defineProps<{
  visible: boolean
  node: WorkflowNode | null
  serviceId: number
}>()

defineEmits<{
  (e: 'close'): void
  (e: 'save'): void
}>()
</script>

<style scoped>
.wcp-overlay {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 100;
}
.wcp-overlay.visible {
  pointer-events: auto;
}

.wcp-panel {
  position: absolute;
  top: 0;
  right: 0;
  width: 420px;
  height: 100%;
  background: var(--el-bg-color);
  border-left: 1px solid var(--el-border-color-light);
  box-shadow: -4px 0 16px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  transform: translateX(100%);
  transition: transform 0.25s ease;
}
.wcp-panel.open {
  transform: translateX(0);
}

.wcp-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid var(--el-border-color-light);
  flex-shrink: 0;
  gap: 8px;
}
.wcp-title-row {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
  min-width: 0;
}
.wcp-type-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 11px;
  color: #fff;
  white-space: nowrap;
  flex-shrink: 0;
}
.wcp-name-input {
  flex: 1;
  min-width: 0;
}
.wcp-close-btn {
  flex-shrink: 0;
  padding: 4px;
}

.wcp-body {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
}

.wcp-footer {
  padding: 12px 16px;
  border-top: 1px solid var(--el-border-color-light);
  flex-shrink: 0;
}
</style>
