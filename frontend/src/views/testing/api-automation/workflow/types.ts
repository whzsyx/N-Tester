// 步骤类型
export type StepType = 'api' | 'sql' | 'script' | 'if' | 'loop' | 'wait'

// 原始步骤数据（与 StepEditor 共用）
export interface ApiStep {
  _uid?: number
  step_type: StepType
  name: string
  enable: boolean
  request: Record<string, any>
  extracts: any[]
  validators: any[]
  children_steps: ApiStep[]
}

// 工作流节点（视图模型）
export interface WorkflowNode {
  id: string
  step: ApiStep           // 直接引用原始步骤对象，双向绑定
  x: number
  y: number
  parentId: string | null
  branchType: 'main' | 'if' | 'else' | 'loop' | null
  depth: number
}

// 显式连线（用于自由连接模式）
export interface WorkflowEdge {
  id: string
  fromId: string
  toId: string
  fromPort: 'right' | 'if' | 'else' | 'loop'  // source port
  label?: string
}

// 节点尺寸常量
export const NODE_WIDTH = 180
export const NODE_HEIGHT = 64
export const GAP_Y = 60       // 分支垂直间距
export const GAP_X = 80       // 节点水平间距

// SVG icon paths for each step type (used in node cards)
export const STEP_TYPE_SVG: Record<StepType, string> = {
  api:    `<rect x="3" y="5" width="18" height="14" rx="2" stroke="currentColor" stroke-width="1.5" fill="none"/><text x="12" y="15" text-anchor="middle" font-size="6" font-weight="700" fill="currentColor">API</text>`,
  sql:    `<ellipse cx="12" cy="7" rx="7" ry="3" stroke="currentColor" stroke-width="1.5" fill="none"/><path d="M5 7v5c0 1.66 3.13 3 7 3s7-1.34 7-3V7" stroke="currentColor" stroke-width="1.5" fill="none"/><path d="M5 12v5c0 1.66 3.13 3 7 3s7-1.34 7-3v-5" stroke="currentColor" stroke-width="1.5" fill="none"/>`,
  script: `<polyline points="16 18 22 12 16 6" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/><polyline points="8 6 2 12 8 18" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/>`,
  if:     `<circle cx="12" cy="12" r="3" fill="currentColor"/><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>`,
  loop:   `<path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/><polyline points="3 3 3 8 8 8" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/>`,
  wait:   `<circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.5" fill="none"/><polyline points="12 7 12 12 15 15" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/>`,
}

// 步骤类型元数据
export const STEP_TYPE_META: Record<StepType, { label: string; color: string; icon: string }> = {
  api:    { label: 'HTTP 请求',  color: '#6366f1', icon: 'Connection' },
  sql:    { label: '数据库操作', color: '#783887', icon: 'DataLine' },
  script: { label: '代码执行',  color: '#7b4d12', icon: 'Document' },
  if:     { label: '条件分支',  color: '#ee46bc', icon: 'Switch' },
  loop:   { label: '循环控制',  color: '#ef6820', icon: 'RefreshRight' },
  wait:   { label: '等待控制',  color: '#10b981', icon: 'Timer' },
}

// 添加节点菜单项
export const ADD_NODE_MENU = [
  { type: 'loop'   as StepType, label: '循环控制',   group: '逻辑' },
  { type: 'if'     as StepType, label: '条件分支',   group: '逻辑' },
  { type: 'api'    as StepType, label: 'HTTP 请求',  group: '步骤' },
  { type: 'script' as StepType, label: '代码执行',   group: '步骤' },
  { type: 'sql'    as StepType, label: '数据库操作', group: '步骤' },
  { type: 'wait'   as StepType, label: '等待控制',   group: '步骤' },
]

// 各步骤类型的默认 request 数据（与 StepEditor 保持一致）
const DEFAULT_REQUEST: Record<StepType, Record<string, any>> = {
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

// 工厂函数：创建指定类型的默认步骤
export function DEFAULT_STEP(type: StepType): ApiStep {
  return {
    step_type: type,
    name: STEP_TYPE_META[type].label,
    enable: true,
    request: JSON.parse(JSON.stringify(DEFAULT_REQUEST[type])),
    extracts: [],
    validators: [],
    children_steps: [],
  }
}

let _uid = 0
export function genId(): string {
  return `wf_${++_uid}_${Date.now()}`
}
