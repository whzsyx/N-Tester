<template>
  <div
    class="wf-node"
    :class="[`wf-node--${node.step.step_type}`, { selected, disabled: !node.step.enable, 'connect-target': isConnectTarget }]"
    @mousedown.left.stop="onBodyMousedown"
    @click.stop="$emit('click')"
    @mouseenter="$emit('node-enter', node.id)"
    @mouseleave="$emit('node-leave', node.id)"
  >
    <!-- Left port "+" -->
    <div class="wf-port wf-port--left">
      <div
        class="wf-port__btn"
        title="向前添加节点"
        @mousedown.stop="$emit('connect-start', node.id, 'left', $event)"
        @click.stop="$emit('add-before', node.id)"
      >+</div>
    </div>

    <!-- Node header -->
    <div class="wf-node__header">
      <div class="wf-node__icon" :style="{ background: meta.color }">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" v-html="svgPath" />
      </div>
      <div class="wf-node__body">
        <div class="wf-node__title">{{ node.step.name }}</div>
        <div class="wf-node__sub">{{ subtitle }}</div>
      </div>
      <div class="wf-node__actions">
        <button class="wf-node__action-btn" title="复制" @click.stop="$emit('copy')">
          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
          </svg>
        </button>
        <button class="wf-node__action-btn wf-node__action-btn--danger" title="删除" @click.stop="$emit('delete')">
          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- IF node: branch rows -->
    <div v-if="node.step.step_type === 'if'" class="wf-node__branches">
      <div class="wf-branch-row">
        <span class="wf-branch-label wf-branch-label--if">IF</span>
        <div
          class="wf-port__btn wf-port__btn--branch"
          title="添加IF分支节点"
          @mousedown.stop="$emit('connect-start', node.id, 'if', $event)"
          @click.stop="$emit('add-branch', node.id, 'if')"
        >+</div>
      </div>
      <div class="wf-branch-row">
        <span class="wf-branch-label wf-branch-label--else">ELSE</span>
        <div
          class="wf-port__btn wf-port__btn--branch"
          title="添加ELSE分支节点"
          @mousedown.stop="$emit('connect-start', node.id, 'else', $event)"
          @click.stop="$emit('add-branch', node.id, 'else')"
        >+</div>
      </div>
    </div>

    <!-- LOOP node: just shows an "add loop step" button; children are full canvas cards -->
    <div v-if="node.step.step_type === 'loop'" class="wf-node__loop-body">
      <div
        class="wf-loop-add"
        @mousedown.stop="$emit('connect-start', node.id, 'loop', $event)"
        @click.stop="$emit('add-branch', node.id, 'loop')"
      >
        <span class="wf-loop-add__icon">+</span>
        <span>添加循环步骤</span>
      </div>
    </div>

    <!-- Right port "+" -->
    <div class="wf-port wf-port--right">
      <div
        class="wf-port__btn"
        title="向后添加节点"
        @mousedown.stop="$emit('connect-start', node.id, 'right', $event)"
        @click.stop="$emit('add-after', node.id)"
      >+</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { STEP_TYPE_META, STEP_TYPE_SVG } from './types'
import type { WorkflowNode } from './types'

const props = defineProps<{
  node: WorkflowNode
  selected: boolean
  isConnectTarget?: boolean
}>()

const emit = defineEmits<{
  (e: 'click'): void
  (e: 'delete'): void
  (e: 'copy'): void
  (e: 'add-after', nodeId: string): void
  (e: 'add-before', nodeId: string): void
  (e: 'add-branch', nodeId: string, branch: string): void
  (e: 'connect-start', nodeId: string, port: string, event: MouseEvent): void
  (e: 'node-enter', nodeId: string): void
  (e: 'node-leave', nodeId: string): void
  (e: 'dragstart', event: MouseEvent): void
}>()

const meta = computed(() => STEP_TYPE_META[props.node.step.step_type])
const svgPath = computed(() => STEP_TYPE_SVG[props.node.step.step_type])

const subtitle = computed(() => {
  const req = props.node.step.request
  const type = props.node.step.step_type
  if (type === 'api') return req?.api_id ? props.node.step.name : '未设置接口'
  if (type === 'sql') return req?.sql ? req.sql.slice(0, 20) + '…' : '未设置SQL'
  if (type === 'script') return req?.script_content ? '已设置脚本' : '未设置脚本'
  if (type === 'if') return req?.check || '未设置条件'
  if (type === 'loop') return `循环 ${req?.count_number ?? 3} 次`
  if (type === 'wait') return `等待 ${req?.wait_time ?? 1}s`
  return ''
})

function onBodyMousedown(e: MouseEvent) {
  const t = e.target as HTMLElement
  if (t.closest('.wf-port') || t.closest('.wf-node__actions') || t.closest('.wf-loop-add')) return
  emit('dragstart', e)
}
</script>

<style scoped>
/* ── Base node ── */
.wf-node {
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 180px;
  background: var(--el-bg-color, #fff);
  border: 1.5px solid var(--el-border-color-light, #e2e8f0);
  border-radius: 10px;
  cursor: grab;
  user-select: none;
  box-sizing: border-box;
  transition: border-color 0.15s, box-shadow 0.15s;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.wf-node:hover {
  border-color: var(--el-border-color, #cbd5e1);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.wf-node.selected {
  border-color: var(--el-color-primary, #409eff);
  box-shadow: 0 0 0 3px rgba(64,158,255,0.15);
}
.wf-node.disabled { opacity: 0.5; }
.wf-node.connect-target {
  border-color: #10b981;
  box-shadow: 0 0 0 3px rgba(16,185,129,0.2);
}

/* ── Header ── */
.wf-node__header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 12px;
}
.wf-node__icon {
  flex-shrink: 0;
  width: 30px;
  height: 30px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}
.wf-node__body { flex: 1; min-width: 0; }
.wf-node__title {
  font-size: 13px;
  font-weight: 600;
  color: var(--el-text-color-primary, #1e293b);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: normal;
  word-break: break-all;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.wf-node__sub {
  font-size: 11px;
  color: var(--el-text-color-placeholder, #94a3b8);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: normal;
  word-break: break-all;
  margin-top: 2px;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

/* ── Hover actions ── */
.wf-node__actions {
  display: flex;
  gap: 3px;
  opacity: 0;
  transition: opacity 0.15s;
  flex-shrink: 0;
}
.wf-node:hover .wf-node__actions { opacity: 1; }
.wf-node__action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 4px;
  border: 1px solid var(--el-border-color-light, #e2e8f0);
  background: var(--el-bg-color, #fff);
  color: var(--el-text-color-secondary, #64748b);
  cursor: pointer;
  padding: 0;
  transition: color 0.12s, border-color 0.12s;
}
.wf-node__action-btn:hover { color: var(--el-color-primary); border-color: var(--el-color-primary); }
.wf-node__action-btn--danger:hover { color: var(--el-color-danger); border-color: var(--el-color-danger); }

/* ── Ports (left / right "+" buttons) ── */
.wf-port {
  position: absolute;
  top: 22px; /* vertically centered on the 64px header row (10px padding + 30px icon / 2 ≈ 22px) */
  opacity: 0;
  transition: opacity 0.15s;
  z-index: 10;
}
.wf-node:hover .wf-port { opacity: 1; }
.wf-port--left { left: -14px; }
.wf-port--right { right: -14px; }

.wf-port__btn {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: var(--el-color-primary, #409eff);
  color: #fff;
  font-size: 16px;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(64,158,255,0.4);
  transition: transform 0.12s, box-shadow 0.12s;
  user-select: none;
}
.wf-port__btn:hover {
  transform: scale(1.15);
  box-shadow: 0 3px 8px rgba(64,158,255,0.5);
}

/* ── IF branches ── */
.wf-node__branches {
  border-top: 1px solid var(--el-border-color-lighter, #f0f0f0);
  padding: 6px 12px 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.wf-branch-row {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
}
.wf-branch-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.5px;
}
.wf-branch-label--if { color: #6366f1; }
.wf-branch-label--else { color: #94a3b8; }

.wf-port__btn--branch {
  width: 20px;
  height: 20px;
  font-size: 14px;
  box-shadow: 0 1px 4px rgba(64,158,255,0.3);
}

/* ── LOOP inner body ── */
.wf-node__loop-body {
  border-top: 1px solid var(--el-border-color-lighter, #f0f0f0);
  margin: 0 8px 8px;
  border-radius: 6px;
  background: var(--el-fill-color-lighter, #f8fafc);
  padding: 6px;
  min-height: 40px;
}
.wf-loop-children {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-bottom: 6px;
}
.wf-loop-child {
  display: flex;
  align-items: center;
  gap: 4px;
  background: var(--el-bg-color, #fff);
  border: 1px solid var(--el-border-color-light, #e2e8f0);
  border-radius: 6px;
  padding: 3px 7px;
  font-size: 11px;
}
.wf-loop-child__icon {
  width: 16px;
  height: 16px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}
.wf-loop-child__name {
  color: var(--el-text-color-regular, #475569);
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.wf-loop-add {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 4px;
  border: 1.5px dashed var(--el-border-color, #cbd5e1);
  border-radius: 6px;
  cursor: pointer;
  font-size: 11px;
  color: var(--el-text-color-placeholder, #94a3b8);
  transition: border-color 0.15s, color 0.15s;
}
.wf-loop-add:hover {
  border-color: var(--el-color-primary, #409eff);
  color: var(--el-color-primary, #409eff);
}
.wf-loop-add__icon {
  font-size: 14px;
  line-height: 1;
  font-weight: 600;
}
</style>
