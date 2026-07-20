/**
 * 压测场景 — 纯函数共享层
 * 供 index.vue（子列表操作）与 addUpdate.vue（表单提交）共同使用
 */

export const THREAD_TYPE_LABELS: Record<string, string> = {
	'0': 'SetUp',
	'1': 'Standard',
	'2': 'Stepping',
	'3': 'Ultimate',
};

/** ultimate_rows 防御式解析：兼容 array / JSON string / null */
export function normalizeUltimateRows(raw: any): any[] {
	if (!raw) return [];
	if (Array.isArray(raw)) return raw;
	if (typeof raw === 'string') {
		try {
			const parsed = JSON.parse(raw);
			return Array.isArray(parsed) ? parsed : [];
		} catch {
			return [];
		}
	}
	return [];
}

/** 后端子配置字段 → 前端字段，同时计算 known_times / has_unknown_times */
export function normalizeConfig(raw: any): any {
	const tt: string = raw.thread_type ?? '1';
	const forever = raw.loop_forever === 1;
	const dur = raw.duration ?? 0;
	const ramp = raw.ramp_up_time ?? 0;
	const delay = raw.startup_delay ?? 0;

	let known_times = 0;
	let has_unknown_times = false;
	if (raw.estimated_duration != null) {
		known_times = raw.estimated_duration;
	} else if (['0', '1'].includes(tt)) {
		known_times = ramp + delay;
		if (forever && dur > 0) { known_times += dur; }
		else { has_unknown_times = true; }
	} else if (tt === '2') {
		const maxT  = raw.thread_count || 0;
		const burst = raw.step_start_users_burst || 0;
		const count = raw.step_start_users_count || 0;
		const period = raw.step_start_users_period || 0;
		const rampUp = raw.step_ramp_up || 0;
		const sCnt  = raw.step_stop_users_count || 0;
		const sPer  = raw.step_stop_users_period || 0;
		const stepsUp   = count > 0 && maxT > burst ? Math.ceil((maxT - burst) / count) : 0;
		const stepsDown = sCnt > 0 && maxT > 0 ? Math.ceil(maxT / sCnt) : 0;
		// period 是每批爬坡完成后的等待间隔，每批（含初始burst）各自占用 rampUp 秒
		known_times = (raw.step_initial_delay || 0) + (stepsUp + 1) * rampUp + stepsUp * period + (raw.step_flight_time || 0) + stepsDown * sPer;
	} else if (tt === '3') {
		const rows = Array.isArray(raw.ultimate_rows) ? raw.ultimate_rows : [];
		if (rows.length > 0) {
			const times = rows.map((r: any) => (r.initial_delay || 0) + (r.startup_time || 0) + (r.hold_load_for || 0) + (r.shutdown_time || 0));
			known_times = Math.max(...times);
		}
	}

	return {
		id: raw.id,
		tg_name: raw.tg_name ?? '',
		thread_type: tt,
		thread_type_label: THREAD_TYPE_LABELS[tt] ?? tt,
		active: tt === '3' ? true : raw.status === 1,
		threads: raw.thread_count,
		ramp_up: raw.ramp_up_time,
		loop_count: raw.loop_count,
		forever,
		duration: raw.duration,
		start_delay: raw.startup_delay,
		step_initial_delay:      raw.step_initial_delay,
		step_start_users_count:  raw.step_start_users_count,
		step_start_users_burst:  raw.step_start_users_burst,
		step_start_users_period: raw.step_start_users_period,
		step_stop_users_count:   raw.step_stop_users_count,
		step_stop_users_period:  raw.step_stop_users_period,
		step_flight_time:        raw.step_flight_time,
		step_ramp_up:            raw.step_ramp_up,
		ultimate_rows: normalizeUltimateRows(raw.ultimate_rows),
		estimated_duration: raw.estimated_duration ?? null,
		known_times,
		has_unknown_times,
	};
}

export interface PreviewPoint {
	time: number;   // 相对压测开始的秒数
	value: number;  // 该时刻的并发线程数
}

/**
 * 复刻 SteppingThreadGroup（jmeter-plugins）真实调度算法，生成线程数-时间折线关键点。
 * 时间轴分为：初始 burst（第0组）→ 逐步加压（每组 step_start_users_count 个，
 * 组内爬坡 step_ramp_up 秒，组间间隔 step_start_users_period 秒）→ 满载保持
 * step_flight_time 秒 → 每 step_stop_users_period 秒瞬时减少 step_stop_users_count
 * 个线程，直至归零。爬坡段用两点线性插值精确还原，瞬时增减用同一时刻两个不同数值
 * 的点表示垂直阶跃，因此只需关键拐点、无需按固定频率采样。
 */
export function buildSteppingPreviewPoints(tab: any): PreviewPoint[] {
	const N      = Number(tab?.threads) || 0;
	const init   = Math.max(0, Number(tab?.step_initial_delay) || 0);
	const burst  = Math.max(0, Math.min(Number(tab?.step_start_users_burst) || 0, N));
	const count  = Number(tab?.step_start_users_count) || 0;
	const period = Math.max(0, Number(tab?.step_start_users_period) || 0);
	const rampUp = Math.max(0, Number(tab?.step_ramp_up) || 0);
	const flight = Math.max(0, Number(tab?.step_flight_time) || 0);
	const sCnt   = Math.max(0, Number(tab?.step_stop_users_count) || 0);
	const sPer   = Math.max(0, Number(tab?.step_stop_users_period) || 0);

	if (N <= 0) return [{ time: 0, value: 0 }];

	// 第0组固定为初始 burst（即便为0，仍占用一个 rampUp 窗口，与 known_times 计算口径一致），
	// 之后每组 count 个线程，最后一组为余数；count 未配置时不臆造后续分组
	const stepsUp = (count > 0 && N > burst) ? Math.ceil((N - burst) / count) : 0;
	const groupSizes: number[] = [burst];
	let remaining = N - burst;
	for (let i = 0; i < stepsUp; i++) {
		const size = Math.min(count, remaining);
		groupSizes.push(size);
		remaining -= size;
	}

	const points: PreviewPoint[] = [];
	const push = (time: number, value: number) => points.push({ time, value });

	let t = 0;
	let value = 0;
	push(t, value);
	if (init > 0) { t = init; push(t, value); }

	groupSizes.forEach((size, i) => {
		if (i > 0 && period > 0) { t += period; push(t, value); }
		if (rampUp > 0) {
			push(t, value);
			value += size;
			t += rampUp;
			push(t, value);
		} else {
			value += size;
			push(t, value);
		}
	});

	if (flight > 0) {
		push(t, value);
		t += flight;
	}
	push(t, value);

	if (sCnt > 0 && value > 0) {
		// 每一步都是先等待 sPer 秒再瞬时停止 sCnt 个线程（含最后一步），
		// 与 known_times 的 stepsDown×sPer 口径保持一致
		while (value > 0) {
			t += sPer;
			const size = Math.min(sCnt, value);
			push(t, value);
			value -= size;
			push(t, value);
		}
	}

	return points;
}

/**
 * 复刻 UltimateThreadGroup（jmeter-plugins）真实调度算法，生成线程数-时间折线关键点。
 * 每个自定义阶段各自独立按 initial_delay → startup_time（线性爬坡）→ hold_load_for
 * （满载保持）→ shutdown_time（线性下降）运行，多阶段的并发线程数为各阶段贡献值
 * 的叠加（非取最大值，取最大值仅用于估算总耗时）。用极小的时间偏移在每个阶段的
 * 关键拐点前后各采样一次，精确还原 startup_time/shutdown_time 为0时的瞬时跳变。
 */
export function buildUltimatePreviewPoints(tab: any): PreviewPoint[] {
	const rows = Array.isArray(tab?.ultimate_rows) ? tab.ultimate_rows : [];
	if (!rows.length) return [{ time: 0, value: 0 }];

	type Stage = { t1: number; t2: number; t3: number; t4: number; startup: number; shutdown: number; peak: number };

	const stages: Stage[] = rows.map((r: any) => {
		const delay    = Math.max(0, Number(r?.initial_delay) || 0);
		const startup  = Math.max(0, Number(r?.startup_time) || 0);
		const hold     = Math.max(0, Number(r?.hold_load_for) || 0);
		const shutdown = Math.max(0, Number(r?.shutdown_time) || 0);
		const peak     = Math.max(0, Number(r?.start_threads) || 0);
		const t1 = delay;
		const t2 = delay + startup;
		const t3 = delay + startup + hold;
		const t4 = delay + startup + hold + shutdown;
		return { t1, t2, t3, t4, startup, shutdown, peak };
	});

	const maxEnd = Math.max(0, ...stages.map((s: Stage) => s.t4));
	// 相对总时长的极小偏移，用于捕捉瞬时跳变的前后取值，对图表显示无感知影响
	const eps = Math.max(maxEnd, 1) * 1e-5;

	const contributionAt = (s: Stage, time: number): number => {
		if (time <= s.t1) return 0;
		if (time < s.t2) return s.startup > 0 ? s.peak * (time - s.t1) / s.startup : s.peak;
		if (time < s.t3) return s.peak;
		if (time < s.t4) return s.shutdown > 0 ? s.peak * (1 - (time - s.t3) / s.shutdown) : 0;
		return 0;
	};

	const timeSet = new Set<number>([0]);
	stages.forEach((s: Stage) => {
		[s.t1, s.t2, s.t3, s.t4].forEach(tm => {
			timeSet.add(tm);
			timeSet.add(Math.max(0, tm - eps));
			timeSet.add(tm + eps);
		});
	});

	const sortedTimes = Array.from(timeSet).sort((a, b) => a - b);
	return sortedTimes.map(tm => ({
		time: Number(tm.toFixed(4)),
		value: stages.reduce((sum: number, s: Stage) => sum + contributionAt(s, tm), 0),
	}));
}

/** 按线程组类型分发生成预览折线关键点；非 Stepping/Ultimate 类型返回空数组 */
export function buildGroupPreviewPoints(tab: any): PreviewPoint[] {
	const tt = String(tab?.thread_type ?? '1');
	if (tt === '2') return buildSteppingPreviewPoints(tab);
	if (tt === '3') return buildUltimatePreviewPoints(tab);
	return [];
}

/** 前端表单子配置 → 后端请求体（兼容 standard / stepping / ultimate 三种类型） */
export function buildConfigPayload(cfg: any, withStatus?: number): any {
	const tt: string = cfg.thread_type ?? '1';
	const payload: any = {
		thread_type: tt,
	};
	if (cfg.tg_name)              payload.tg_name    = cfg.tg_name;
	if (withStatus !== undefined) payload.status     = withStatus;

	if (tt === '0' || tt === '1') {
		payload.thread_count  = cfg.threads;
		payload.ramp_up_time  = cfg.ramp_up;
		payload.loop_forever  = cfg.forever ? 1 : 0;
		payload.startup_delay = cfg.start_delay ?? 0;
		if (!cfg.forever && cfg.loop_count !== undefined) payload.loop_count = cfg.loop_count;
		if (cfg.forever  && cfg.duration  !== undefined) payload.duration   = cfg.duration;
	} else if (tt === '2') {
		payload.thread_count              = cfg.threads;
		payload.step_initial_delay        = cfg.step_initial_delay      ?? 0;
		payload.step_start_users_count    = cfg.step_start_users_count;
		payload.step_start_users_burst    = cfg.step_start_users_burst  ?? 0;
		payload.step_start_users_period   = cfg.step_start_users_period;
		payload.step_stop_users_count     = cfg.step_stop_users_count   ?? 0;
		payload.step_stop_users_period    = cfg.step_stop_users_period  ?? 0;
		payload.step_flight_time          = cfg.step_flight_time        ?? 0;
		payload.step_ramp_up              = cfg.step_ramp_up            ?? 0;
	} else if (tt === '3') {
		payload.ultimate_rows = (cfg.ultimate_rows ?? []).map((r: any) => ({
			start_threads: r.start_threads ?? 0,
			initial_delay: r.initial_delay ?? 0,
			startup_time:  r.startup_time  ?? 0,
			hold_load_for: r.hold_load_for ?? 0,
			shutdown_time: r.shutdown_time ?? 0,
		}));
	}
	if (cfg.estimated_duration != null) payload.estimated_duration = cfg.estimated_duration;
	return payload;
}