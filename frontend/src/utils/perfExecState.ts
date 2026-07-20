// 压测场景 execState（阶段勾选 + 进度条）状态机
// 手动触发（index.vue 直连 /execute 原始流）与定时任务触发（monitor.vue 经 /monitor 补发的
// 结构化 stage_start/stage_done 事件）共用同一套阶段推进逻辑，避免两处各写一份、长期跑偏。

export interface ExecStage {
	label: string;
	done: boolean;
	active: boolean;
}

export interface ExecState {
	stages: ExecStage[];
	progress: number;
}

export interface StageEvent {
	type: 'stage_start' | 'stage_done';
	stage?: number;
	stage_name?: string;
	message?: string;
}

/**
 * 根据 stage_start/stage_done 事件推进 execState（阶段勾选状态 + 进度百分比）。
 * isExecuteAction: 是否为 execute/recover 动作 —— 该场景下最后一个阶段完成即代表
 * JMeter 已转入后台运行，此时保持该阶段 active（而非 done），真实进度改由 Monitor SSE 驱动。
 * 返回 true 表示"最后一个阶段刚刚启动完成"，调用方应据此把场景状态置为运行中。
 */
export function applyStageEvent(execState: ExecState, evt: StageEvent, isExecuteAction: boolean): boolean {
	const stages = execState.stages;
	// 后端 stage 字段为 1-indexed，转换为 0-indexed 数组下标
	const stageIdx = (evt.stage ?? 1) - 1;
	let lastStageStarted = false;

	if (evt.type === 'stage_start') {
		stages.forEach((s, i) => {
			s.done = i < stageIdx;
			s.active = i === stageIdx;
		});
		// 前置阶段（非最后）各占 3%；最后阶段由 Monitor SSE 填充，此处保持在 preWeight
		const preWeight = Math.max(0, (stages.length - 1) * 3);
		execState.progress = Math.min(stageIdx * 3, preWeight);
	} else if (evt.type === 'stage_done') {
		const isLastStage = stageIdx === stages.length - 1;
		if (isLastStage && isExecuteAction) {
			stages.forEach((s, i) => { s.done = i < stageIdx; s.active = i === stageIdx; });
			lastStageStarted = true;
		} else {
			stages.forEach((s, i) => {
				s.done = i <= stageIdx;
				s.active = i === stageIdx + 1 && stageIdx + 1 < stages.length;
			});
			// 非最后阶段：3% 递增；inspect 最后阶段：100%
			execState.progress = isLastStage ? 100 : (stageIdx + 1) * 3;
		}
	}
	return lastStageStarted;
}