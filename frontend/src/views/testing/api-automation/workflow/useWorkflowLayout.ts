import type { ApiStep, WorkflowNode } from './types'
import { NODE_WIDTH, NODE_HEIGHT, genId } from './types'

export type BranchType = 'main' | 'if' | 'else' | 'loop' | null

export interface EdgeDef {
  id: string
  path: string
  label?: string
  dashed?: boolean
  isLoop?: boolean
  color?: string
}

export interface LayoutOptions {
  startX: number   // left margin
  startY: number   // top margin / vertical center for top-level row
  gapX: number     // horizontal gap between nodes
  gapY: number     // vertical gap between branches
}

const NODE_W = NODE_WIDTH   // 180
const NODE_H = NODE_HEIGHT  // 64

const DEFAULTS: LayoutOptions = {
  startX: 60,
  startY: 200,
  gapX: 80,   // horizontal gap between nodes
  gapY: 60,   // vertical gap between if/else rows
}

// ─── Flatten / Rebuild ────────────────────────────────────────────────────────

export function flattenSteps(
  steps: ApiStep[],
  parentId: string | null = null,
  branchType: BranchType = 'main',
  depth = 0,
): WorkflowNode[] {
  const nodes: WorkflowNode[] = []
  // Use an explicit stack instead of recursion to avoid stack overflow with many steps
  const stack: Array<{ step: ApiStep; parentId: string | null; branchType: BranchType; depth: number }> = []
  for (let i = steps.length - 1; i >= 0; i--) {
    stack.push({ step: steps[i], parentId, branchType: parentId === null ? 'main' : branchType, depth })
  }

  const seen = new Set<ApiStep>() // guard against circular references

  while (stack.length > 0) {
    const { step, parentId: pid, branchType: bt, depth: d } = stack.pop()!
    if (seen.has(step)) continue
    seen.add(step)

    const id = step._uid != null ? `wf_uid_${step._uid}` : genId()
    const node: WorkflowNode = { id, step, x: 0, y: 0, parentId: pid, branchType: pid === null ? 'main' : bt, depth: d }
    nodes.push(node)

    if ((step.step_type === 'if' || step.step_type === 'loop') && step.children_steps?.length) {
      const childBranch = step.step_type === 'if' ? 'if' : 'loop'
      // Push in reverse so they come out in order
      for (let i = step.children_steps.length - 1; i >= 0; i--) {
        stack.push({ step: step.children_steps[i], parentId: id, branchType: childBranch, depth: d + 1 })
      }
    }
  }

  return nodes
}

export function rebuildScript(nodes: WorkflowNode[]): ApiStep[] {
  // Only return top-level steps; children are already referenced via step.children_steps
  // Guard: deduplicate to avoid circular reference issues
  const seen = new Set<ApiStep>()
  return nodes
    .filter(n => n.parentId === null)
    .map(n => n.step)
    .filter(s => { if (seen.has(s)) return false; seen.add(s); return true })
}

/**
 * Deep-clone an ApiStep tree iteratively, breaking any circular references.
 * Safe to pass to JSON.stringify.
 */
export function safeCloneScript(steps: ApiStep[]): any[] {
  // Iterative deep clone using an explicit stack
  function cloneOne(s: ApiStep, visited: Set<ApiStep>): any {
    if (visited.has(s)) return { ...s, children_steps: [] }
    visited.add(s)
    const children = Array.isArray(s.children_steps)
      ? s.children_steps.map(c => cloneOne(c, visited))
      : []
    visited.delete(s)
    return { ...s, children_steps: children }
  }
  return steps.map(s => cloneOne(s, new Set<ApiStep>()))
}

// ─── Layout ───────────────────────────────────────────────────────────────────

/**
 * Horizontal left-to-right layout.
 * Top-level nodes are laid out in a single horizontal row.
 * if/loop children are laid out in sub-rows below their parent.
 */
export function computeLayout(nodes: WorkflowNode[], opts?: Partial<LayoutOptions>): WorkflowNode[] {
  const o = { ...DEFAULTS, ...opts }
  layoutRow(nodes.filter(n => n.parentId === null), nodes, o.startX, o.startY, o)
  return nodes
}

/**
 * Lay out a row of sibling nodes horizontally starting at (startX, centerY).
 * Returns the total width consumed by this row.
 */
function layoutRow(
  row: WorkflowNode[],
  all: WorkflowNode[],
  startX: number,
  centerY: number,
  o: LayoutOptions,
): number {
  let x = startX
  for (const node of row) {
    node.x = x
    node.y = centerY - NODE_H / 2

    if (node.step.step_type === 'if') {
      const ifChildren = all.filter(n => n.parentId === node.id && n.branchType === 'if')
      const elseChildren = all.filter(n => n.parentId === node.id && n.branchType === 'else')
      const childStartX = x + NODE_W + o.gapX

      // IF branch: above center, ELSE branch: below center
      const ifY = centerY - NODE_H / 2 - o.gapY / 2 - NODE_H / 2
      const elseY = centerY + NODE_H / 2 + o.gapY / 2 + NODE_H / 2

      const ifWidth = ifChildren.length ? layoutRow(ifChildren, all, childStartX, ifY + NODE_H / 2, o) : 0
      const elseWidth = elseChildren.length ? layoutRow(elseChildren, all, childStartX, elseY + NODE_H / 2, o) : 0

      x += NODE_W + o.gapX + Math.max(ifWidth, elseWidth, 0)
    } else if (node.step.step_type === 'loop') {
      const loopChildren = all.filter(n => n.parentId === node.id && n.branchType === 'loop')
      const childStartX = x + NODE_W + o.gapX
      const childWidth = loopChildren.length ? layoutRow(loopChildren, all, childStartX, centerY, o) : 0
      x += NODE_W + o.gapX + childWidth
    } else {
      x += NODE_W + o.gapX
    }
  }
  return x - startX
}

// ─── Edges ────────────────────────────────────────────────────────────────────

/** Horizontal bezier: right-center of from → left-center of to */
function hBezier(from: WorkflowNode, to: WorkflowNode): string {
  const x1 = from.x + NODE_W
  const y1 = from.y + NODE_H / 2
  const x2 = to.x
  const y2 = to.y + NODE_H / 2
  const cx = (x1 + x2) / 2
  return `M ${x1},${y1} C ${cx},${y1} ${cx},${y2} ${x2},${y2}`
}

/** From right-center of node down/up to left-center of target (for if branches) */
function branchBezier(from: WorkflowNode, to: WorkflowNode, port: 'top-right' | 'bottom-right'): string {
  const x1 = from.x + NODE_W / 2
  const y1 = port === 'top-right' ? from.y : from.y + NODE_H
  const x2 = to.x
  const y2 = to.y + NODE_H / 2
  const cx1 = x1 + (x2 - x1) * 0.5
  const cy1 = y1
  const cx2 = x1 + (x2 - x1) * 0.5
  const cy2 = y2
  return `M ${x1},${y1} C ${cx1},${cy1} ${cx2},${cy2} ${x2},${y2}`
}

export function buildEdges(nodes: WorkflowNode[]): EdgeDef[] {
  const edges: EdgeDef[] = []

  // Helper: bezier from right-center of `from` to left-center of `to`
  const right2left = (from: WorkflowNode, to: WorkflowNode): string => {
    const x1 = from.x + NODE_W, y1 = from.y + NODE_H / 2
    const x2 = to.x,            y2 = to.y + NODE_H / 2
    const cx = (x1 + x2) / 2
    return `M ${x1},${y1} C ${cx},${y1} ${cx},${y2} ${x2},${y2}`
  }

  // Helper: bezier from a specific (px,py) to left-center of `to`
  const port2left = (px: number, py: number, to: WorkflowNode): string => {
    const x2 = to.x, y2 = to.y + NODE_H / 2
    const cx = (px + x2) / 2
    return `M ${px},${py} C ${cx},${py} ${cx},${y2} ${x2},${y2}`
  }

  for (const node of nodes) {
    // ── Sequential siblings (same parentId + branchType, ordered by array position) ──
    const sibs = nodes.filter(n => n.parentId === node.parentId && n.branchType === node.branchType)
    const idx = sibs.indexOf(node)
    if (idx > 0) {
      const prev = sibs[idx - 1]
      edges.push({ id: `seq_${prev.id}_${node.id}`, path: right2left(prev, node) })
    }

    // ── IF node: draw edges from IF port and ELSE port to ALL their children ──
    if (node.step.step_type === 'if') {
      const ifChildren  = nodes.filter(n => n.parentId === node.id && n.branchType === 'if')
      const elseChildren = nodes.filter(n => n.parentId === node.id && n.branchType === 'else')

      // IF port: right side of the IF row (approx y = node.y + NODE_H + 10)
      const ifPortX  = node.x + NODE_W
      const ifPortY  = node.y + NODE_H + 12   // inside the branches section, IF row
      const elsePortX = node.x + NODE_W
      const elsePortY = node.y + NODE_H + 36  // ELSE row

      // Only draw parent→first-child edge; sequential edges handle the rest
      if (ifChildren.length > 0) {
        edges.push({
          id: `if_${node.id}_if_0`,
          path: port2left(ifPortX, ifPortY, ifChildren[0]),
          label: 'IF',
          color: '#6366f1',
        })
      }
      if (elseChildren.length > 0) {
        edges.push({
          id: `if_${node.id}_else_0`,
          path: port2left(elsePortX, elsePortY, elseChildren[0]),
          label: 'ELSE',
          color: '#94a3b8',
          dashed: true,
        })
      }
    }

    // ── LOOP node: edge to first loop child + loop-back arc ──
    if (node.step.step_type === 'loop') {
      const loopChildren = nodes.filter(n => n.parentId === node.id && n.branchType === 'loop')
      if (loopChildren.length > 0) {
        edges.push({ id: `loop_${node.id}_0`, path: right2left(node, loopChildren[0]), color: '#ef6820' })
        const last = loopChildren[loopChildren.length - 1]
        const x1 = last.x + NODE_W / 2, y1 = last.y + NODE_H
        const x2 = node.x + NODE_W / 2, y2 = node.y + NODE_H
        const cy = Math.max(y1, y2) + 40
        edges.push({
          id: `loop_back_${node.id}`,
          path: `M ${x1},${y1} C ${x1},${cy} ${x2},${cy} ${x2},${y2}`,
          isLoop: true, dashed: true, color: '#ef6820',
        })
      }
    }
  }

  return edges
}

export function getEdgePath(from: WorkflowNode, to: WorkflowNode): string {
  return hBezier(from, to)
}
