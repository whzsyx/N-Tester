<template>
  <div
    class="canvas-wrapper"
    :class="{ panning: isPanning, connecting: !!connectState }"
    @mousedown.middle="startPan"
    @mousedown.left="onCanvasMousedown"
    @wheel.prevent="onWheel"
    @mousemove="onCanvasMousemove"
    @mouseup="onCanvasMouseup"
  >
    <!-- Zoom controls -->
    <div class="canvas-zoom-bar">
      <button class="canvas-zoom-btn" @click="scale = Math.min(MAX_SCALE, +(scale + 0.1).toFixed(2))">+</button>
      <span class="canvas-zoom-label">{{ Math.round(scale * 100) }}%</span>
      <button class="canvas-zoom-btn" @click="scale = Math.max(MIN_SCALE, +(scale - 0.1).toFixed(2))">−</button>
      <button class="canvas-zoom-btn" @click="resetView" title="重置">⊙</button>
    </div>

    <div
      class="canvas-inner"
      :style="{
        width: canvasWidth + 'px',
        height: canvasHeight + 'px',
        transform: `translate(${panX}px, ${panY}px) scale(${scale})`,
        transformOrigin: '0 0',
      }"
    >
      <svg class="canvas-svg" :width="canvasWidth" :height="canvasHeight">
        <defs>
          <marker id="arr" markerWidth="7" markerHeight="7" refX="5" refY="3" orient="auto">
            <path d="M0,0 L0,6 L7,3 z" fill="#94a3b8" />
          </marker>
          <marker id="arr-blue" markerWidth="7" markerHeight="7" refX="5" refY="3" orient="auto">
            <path d="M0,0 L0,6 L7,3 z" fill="#6366f1" />
          </marker>
          <marker id="arr-orange" markerWidth="7" markerHeight="7" refX="5" refY="3" orient="auto">
            <path d="M0,0 L0,6 L7,3 z" fill="#ef6820" />
          </marker>
        </defs>

        <g v-for="edge in edges" :key="edge.id">
          <path
            :d="edge.path"
            :stroke="edge.color || '#94a3b8'"
            stroke-width="1.5"
            fill="none"
            :stroke-dasharray="edge.dashed ? '5,4' : undefined"
            :marker-end="markerFor(edge)"
          />
          <text
            v-if="edge.label"
            :x="midpoint(edge.path).x"
            :y="midpoint(edge.path).y - 5"
            text-anchor="middle"
            font-size="10"
            font-weight="700"
            :fill="edge.color || '#64748b'"
          >{{ edge.label }}</text>
        </g>

        <!-- Live connection line while dragging -->
        <path
          v-if="connectState"
          :d="connectLinePath"
          stroke="#409eff"
          stroke-width="2"
          fill="none"
          stroke-dasharray="6,3"
          marker-end="url(#arr-blue)"
        />
      </svg>

      <!-- Node cards -->
      <NodeCard
        v-for="node in topLevelNodes"
        :key="node.id"
        :node="node"
        :selected="selectedId === node.id"
        :is-connect-target="connectState !== null && hoverNodeId === node.id && hoverNodeId !== connectState.fromId"
        :style="{ position: 'absolute', left: node.x + 'px', top: node.y + 'px' }"
        @click="$emit('select', node.id)"
        @delete="$emit('delete', node.id)"
        @copy="$emit('copy', node.id)"
        @add-after="onAddAfter"
        @add-before="onAddBefore"
        @add-branch="onAddBranch"
        @connect-start="onConnectStart"
        @node-enter="hoverNodeId = $event"
        @node-leave="hoverNodeId = null"
        @dragstart="onDragStart(node, $event)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onUnmounted } from 'vue'
import { buildEdges } from './useWorkflowLayout'
import type { EdgeDef } from './useWorkflowLayout'
import { NODE_WIDTH, NODE_HEIGHT } from './types'
import type { WorkflowNode } from './types'
import NodeCard from './WorkflowNode.vue'

const props = defineProps<{
  nodes: WorkflowNode[]
  selectedId: string | null
}>()

const emit = defineEmits<{
  (e: 'select', nodeId: string): void
  (e: 'move', nodeId: string, x: number, y: number): void
  (e: 'delete', nodeId: string): void
  (e: 'copy', nodeId: string): void
  (e: 'add-after', nodeId: string): void
  (e: 'add-before', nodeId: string): void
  (e: 'add-branch', nodeId: string, branch: string): void
  (e: 'connect', fromId: string, port: string, toId: string): void
}>()

// All nodes render as positioned cards — loop children too (they're full cards now)
const topLevelNodes = computed(() => props.nodes)

function getLoopChildren(parentId: string): WorkflowNode[] {
  return props.nodes.filter(n => n.parentId === parentId && n.branchType === 'loop')
}

const edges = computed(() => buildEdges(props.nodes))

const canvasWidth = computed(() =>
  props.nodes.length ? Math.max(...props.nodes.map(n => n.x + NODE_WIDTH + 200)) : 1200
)
const canvasHeight = computed(() =>
  props.nodes.length ? Math.max(...props.nodes.map(n => n.y + NODE_HEIGHT + 200)) : 600
)

function markerFor(edge: EdgeDef): string {
  if (edge.color === '#6366f1') return 'url(#arr-blue)'
  if (edge.color === '#ef6820') return 'url(#arr-orange)'
  return 'url(#arr)'
}

function midpoint(d: string): { x: number; y: number } {
  const nums = d.match(/[-\d.]+/g)?.map(Number)
  if (!nums || nums.length < 8) return { x: 0, y: 0 }
  const [x1, y1, cx1, cy1, cx2, cy2, x2, y2] = nums
  const t = 0.5, mt = 1 - t
  return {
    x: mt**3*x1 + 3*mt**2*t*cx1 + 3*mt*t**2*cx2 + t**3*x2,
    y: mt**3*y1 + 3*mt**2*t*cy1 + 3*mt*t**2*cy2 + t**3*y2,
  }
}

// ─── Node drag ────────────────────────────────────────────────────────────────
interface DragState { nodeId: string; mx: number; my: number; nx: number; ny: number }
let drag: DragState | null = null

function onDragStart(node: WorkflowNode, e: MouseEvent) {
  e.preventDefault()
  e.stopPropagation()
  drag = { nodeId: node.id, mx: e.clientX, my: e.clientY, nx: node.x, ny: node.y }
  document.addEventListener('mousemove', onNodeMove)
  document.addEventListener('mouseup', onNodeUp)
}

function onNodeMove(e: MouseEvent) {
  if (!drag) return
  const nx = Math.max(0, drag.nx + (e.clientX - drag.mx) / scale.value)
  const ny = Math.max(0, drag.ny + (e.clientY - drag.my) / scale.value)
  emit('move', drag.nodeId, nx, ny)
}

function onNodeUp() {
  drag = null
  document.removeEventListener('mousemove', onNodeMove)
  document.removeEventListener('mouseup', onNodeUp)
}

// ─── Connection drag ──────────────────────────────────────────────────────────
interface ConnectState { fromId: string; port: string; x1: number; y1: number; mx: number; my: number }
const connectState = ref<ConnectState | null>(null)
const hoverNodeId = ref<string | null>(null)

const connectLinePath = computed(() => {
  if (!connectState.value) return ''
  const { x1, y1, mx, my } = connectState.value
  const cx = (x1 + mx) / 2
  return `M ${x1},${y1} C ${cx},${y1} ${cx},${my} ${mx},${my}`
})

function onConnectStart(nodeId: string, port: string, e: MouseEvent) {
  e.preventDefault()
  e.stopPropagation()
  const node = props.nodes.find(n => n.id === nodeId)
  if (!node) return
  // Compute start point in canvas coords
  const wrapperRect = (e.currentTarget as HTMLElement)?.closest?.('.canvas-wrapper')?.getBoundingClientRect()
  const canvasEl = (e.currentTarget as HTMLElement)?.closest?.('.canvas-inner')
  // Use node position + port offset
  let x1 = node.x + NODE_WIDTH
  let y1 = node.y + NODE_HEIGHT / 2
  if (port === 'left') { x1 = node.x; }
  if (port === 'if') { x1 = node.x + NODE_WIDTH; y1 = node.y + NODE_HEIGHT + 10; }
  if (port === 'else') { x1 = node.x + NODE_WIDTH; y1 = node.y + NODE_HEIGHT + 30; }
  if (port === 'loop') { x1 = node.x + NODE_WIDTH / 2; y1 = node.y + NODE_HEIGHT + 20; }

  connectState.value = { fromId: nodeId, port, x1, y1, mx: x1, my: y1 }
}

function onCanvasMousemove(e: MouseEvent) {
  if (connectState.value) {
    // Convert mouse to canvas coords
    const wrapper = (e.currentTarget as HTMLElement)
    const rect = wrapper.getBoundingClientRect()
    connectState.value.mx = (e.clientX - rect.left - panX.value) / scale.value
    connectState.value.my = (e.clientY - rect.top - panY.value) / scale.value
  }
}

function onCanvasMouseup(e: MouseEvent) {
  if (connectState.value && hoverNodeId.value && hoverNodeId.value !== connectState.value.fromId) {
    emit('connect', connectState.value.fromId, connectState.value.port, hoverNodeId.value)
  }
  connectState.value = null
}

// ─── Quick-add handlers (bubble up to editor) ─────────────────────────────────
function onAddAfter(nodeId: string) { emit('add-after', nodeId) }
function onAddBefore(nodeId: string) { emit('add-before', nodeId) }
function onAddBranch(nodeId: string, branch: string) { emit('add-branch', nodeId, branch) }

// ─── Canvas pan ───────────────────────────────────────────────────────────────
const panX = ref(0)
const panY = ref(0)
const scale = ref(1)
const isPanning = ref(false)
let panStart = { mx: 0, my: 0, px: 0, py: 0 }

function startPan(e: MouseEvent) {
  if (connectState.value) return
  isPanning.value = true
  panStart = { mx: e.clientX, my: e.clientY, px: panX.value, py: panY.value }
  document.addEventListener('mousemove', onPanMove)
  document.addEventListener('mouseup', onPanUp)
}

function onCanvasMousedown(e: MouseEvent) {
  const target = e.target as HTMLElement
  if (target.closest('.wf-node')) return
  startPan(e)
}

function onPanMove(e: MouseEvent) {
  if (!isPanning.value) return
  panX.value = panStart.px + e.clientX - panStart.mx
  panY.value = panStart.py + e.clientY - panStart.my
}

function onPanUp() {
  isPanning.value = false
  document.removeEventListener('mousemove', onPanMove)
  document.removeEventListener('mouseup', onPanUp)
}

const MIN_SCALE = 0.2
const MAX_SCALE = 2.5

function onWheel(e: WheelEvent) {
  const delta = e.deltaY > 0 ? -0.08 : 0.08
  scale.value = Math.min(MAX_SCALE, Math.max(MIN_SCALE, +(scale.value + delta).toFixed(2)))
}

function resetView() {
  scale.value = 1
  panX.value = 0
  panY.value = 0
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onNodeMove)
  document.removeEventListener('mouseup', onNodeUp)
  document.removeEventListener('mousemove', onPanMove)
  document.removeEventListener('mouseup', onPanUp)
})
</script>

<style scoped>
.canvas-wrapper {
  width: 100%;
  height: 100%;
  overflow: hidden;
  background-color: #eef2f7;
  background-image: radial-gradient(circle, #c8d3e0 1px, transparent 1px);
  background-size: 24px 24px;
  cursor: default;
  position: relative;
}
html.dark .canvas-wrapper {
  background-color: var(--el-bg-color-page, #1a1a2e);
  background-image: radial-gradient(circle, var(--el-border-color-lighter, #3a3a4a) 1px, transparent 1px);
}
.canvas-wrapper.panning { cursor: grabbing !important; }
.canvas-wrapper:not(.panning):not(.connecting) { cursor: grab; }
.canvas-wrapper.connecting { cursor: crosshair; }
.canvas-wrapper :deep(.wf-node) { cursor: grab; }
.canvas-wrapper :deep(.wf-node):active { cursor: grabbing; }

.canvas-inner {
  position: absolute;
  top: 0;
  left: 0;
  min-width: 1200px;
  min-height: 600px;
  will-change: transform;
}
.canvas-svg {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: visible;
}

.canvas-zoom-bar {
  position: absolute;
  bottom: 16px;
  right: 16px;
  z-index: 20;
  display: flex;
  align-items: center;
  gap: 2px;
  background: var(--el-bg-color, #fff);
  border: 1px solid var(--el-border-color-light, #e2e8f0);
  border-radius: 8px;
  padding: 3px 6px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.canvas-zoom-btn {
  width: 24px;
  height: 24px;
  border: none;
  background: transparent;
  color: var(--el-text-color-regular, #64748b);
  cursor: pointer;
  border-radius: 4px;
  font-size: 16px;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.12s, color 0.12s;
}
.canvas-zoom-btn:hover {
  background: var(--el-fill-color-light, #f1f5f9);
  color: var(--el-color-primary, #409eff);
}
.canvas-zoom-label {
  font-size: 12px;
  color: var(--el-text-color-secondary, #64748b);
  min-width: 36px;
  text-align: center;
  user-select: none;
}
</style>
