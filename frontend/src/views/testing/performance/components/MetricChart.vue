<template>
	<div class="metric-chart-panel" :class="{ 'is-dark': darkMode }">
		<div class="panel-title-handle" />
		<el-tooltip v-if="expandable" content="放大" placement="top" :show-after="400">
			<el-button class="panel-expand-btn" size="small" text circle @click="handleExpand">
				<el-icon><ele-FullScreen /></el-icon>
			</el-button>
		</el-tooltip>
		<div ref="chartRef" class="panel-chart" :style="{ height: chartHeight + 'px' }" />
	</div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, watch } from 'vue';
import * as echarts from 'echarts';

export interface SeriesItem {
	name: string;
	data: number[];
}

const props = withDefaults(defineProps<{
	title: string;
	unit: string;
	series: SeriesItem[];
	timeLabels: string[];
	darkMode?: boolean;
	expandable?: boolean;
	chartHeight?: number;
}>(), {
	darkMode: false,
	expandable: true,
	chartHeight: 180,
});

const emit = defineEmits<{
	(e: 'expand', cfg: { title: string; unit: string; series: SeriesItem[]; timeLabels: string[] }): void;
}>();

const chartRef = ref<HTMLElement | null>(null);
let chartInstance: echarts.ECharts | null = null;

// Grafana 配色方案
const DARK_COLORS  = ['#7EB26D', '#EAB839', '#6ED0E0', '#EF843C', '#E24D42', '#1F78C1', '#BA43A9'];
const LIGHT_COLORS = ['#5470C6', '#91CC75', '#FAC858', '#EE6666', '#73C0DE', '#3BA272', '#FC8452'];

// hex → rgba，用于悬停外环半透明色
const hexToRgba = (hex: string, alpha: number) => {
	const r = parseInt(hex.slice(1, 3), 16);
	const g = parseInt(hex.slice(3, 5), 16);
	const b = parseInt(hex.slice(5, 7), 16);
	return `rgba(${r},${g},${b},${alpha})`;
};

const buildOption = (dark: boolean): echarts.EChartsOption => {
	const colors = dark ? DARK_COLORS : LIGHT_COLORS;
	const gridColor  = dark ? 'rgba(255,255,255,0.08)' : '#f0f0f0';
	const axisColor  = dark ? '#32333a' : '#e0e0e0';
	const labelColor = dark ? '#9fa7b3' : '#909399';
	const titleColor = dark ? '#d8d9da' : '#303133';
	const tooltipBg  = dark ? '#1c2128' : '#fff';
	const tooltipBorder = dark ? '#454c53' : '#ddd';
	// Grafana 使用 Inter 字体族，与 ECharts 默认 sans-serif 有明显视觉差异
	const fontFamily = 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';

	return {
		backgroundColor: dark ? '#181b1f' : 'transparent',
		color: colors,
		title: {
			text: props.title,
			textStyle: { color: titleColor, fontSize: 13, fontWeight: 'bold', fontFamily },
			top: 6,
			left: 'center',
		},
		tooltip: {
			trigger: 'axis',
			backgroundColor: tooltipBg,
			borderColor: tooltipBorder,
			textStyle: { color: dark ? '#d8d9da' : '#303133', fontSize: 12, fontFamily },
			axisPointer: {
				type: 'cross',
				// crossStyle → X 轴纵向指示线；lineStyle → Y 轴横向指示线
				crossStyle: {
					color: dark ? 'rgba(255,255,255,0.18)' : 'rgba(0,0,0,0.12)',
					width: 1,
					type: 'dashed',
				},
				lineStyle: {
					color: dark ? 'rgba(255,255,255,0.18)' : 'rgba(0,0,0,0.12)',
					width: 1,
					type: 'dashed',
				},
				// 轴上标注：字号小、背景浅、垂直居中
				label: {
					fontSize: 10,
					height: 16,
					lineHeight: 16,
					padding: [0, 5],
					backgroundColor: dark ? 'rgba(44,50,53,0.85)' : 'rgba(220,222,226,0.8)',
					color: dark ? '#c2cad6' : '#666',
					fontFamily,
					borderWidth: 0,
				},
			},
			formatter: (params: any) => {
				if (!Array.isArray(params) || !params.length) return '';
				const now = new Date();
				const yyyy = now.getFullYear();
				const mm   = String(now.getMonth() + 1).padStart(2, '0');
				const dd   = String(now.getDate()).padStart(2, '0');
				const time = `${params[0].axisValue}:00`;
				const dateTime = `${yyyy}-${mm}-${dd} ${time}`;
				let html = `<div style="margin-bottom:4px;font-weight:600;">${dateTime}</div>`;
				params.forEach((p: any) => {
					html += `<div style="display:flex;align-items:center;gap:8px;line-height:1.8;">
						<span style="display:inline-block;width:12px;height:2px;background:${p.color};border-radius:1px;"></span>
						<span style="flex:1">${p.seriesName}</span>
						<span style="font-weight:600;">${p.value}</span>
					</div>`;
				});
				return html;
			},
		},
		legend: {
			data: props.series.map(s => s.name),
			bottom: 2,
			left: 'center',
			textStyle: { color: labelColor, fontSize: 12, fontWeight: 500, fontFamily },
			itemWidth: 16,
			itemHeight: 2,
			icon: 'rect',
		},
		grid: {
			left: 8,
			right: 18,
			top: 44,
			bottom: 34,
			containLabel: true,
		},
		xAxis: {
			type: 'category',
			data: props.timeLabels,
			boundaryGap: false,
			axisLine: { lineStyle: { color: axisColor } },
			axisTick: { show: false },
			axisLabel: { color: labelColor, fontSize: 12, fontWeight: 400, fontFamily },
			// 纵向网格线
			splitLine: { show: true, lineStyle: { color: gridColor, type: 'dashed' } },
		},
		yAxis: {
			type: 'value',
			name: props.unit,
			nameLocation: 'end',
			nameTextStyle: { color: labelColor, fontSize: 12, fontWeight: 400, align: 'right', verticalAlign: 'bottom', padding: [0, 0, 2, 0], fontFamily },
			axisLine: { show: false },
			axisTick: { show: false },
			axisLabel: { color: labelColor, fontSize: 12, fontWeight: 400, fontFamily },
			// 横向网格线
			splitLine: { show: true, lineStyle: { color: gridColor } },
		},
		series: props.series.map((s, i) => ({
			name: s.name,
			type: 'line',
			data: s.data,
			smooth: false,
			symbol: 'circle',
			symbolSize: 5,
			showSymbol: true,
			lineStyle: { width: 1.5, color: colors[i % colors.length] },
			itemStyle: { color: colors[i % colors.length] },
			// 悬停：中心点不变，外框淡化放大
			emphasis: {
				scale: false,
				itemStyle: {
					color: colors[i % colors.length],
					borderColor: hexToRgba(colors[i % colors.length], 0.35),
					borderWidth: 6,
				},
			},
		})),
	};
};

const initChart = () => {
	if (!chartRef.value) return;
	chartInstance?.dispose();
	chartInstance = echarts.init(chartRef.value);
	chartInstance.setOption(buildOption(!!props.darkMode));
};

watch(() => props.darkMode, () => {
	if (!chartRef.value) return;
	chartInstance?.dispose();
	chartInstance = echarts.init(chartRef.value);
	chartInstance.setOption(buildOption(!!props.darkMode));
});

watch(() => [props.series, props.timeLabels], () => {
	chartInstance?.setOption(buildOption(!!props.darkMode));
}, { deep: true });

const ro = typeof ResizeObserver !== 'undefined'
	? new ResizeObserver(() => chartInstance?.resize())
	: null;

onMounted(() => {
	initChart();
	if (chartRef.value && ro) ro.observe(chartRef.value);
});

onBeforeUnmount(() => {
	ro?.disconnect();
	chartInstance?.dispose();
	chartInstance = null;
});

const handleExpand = () => {
	emit('expand', { title: props.title, unit: props.unit, series: props.series, timeLabels: props.timeLabels });
};
</script>

<style scoped lang="scss">
.metric-chart-panel {
	position: relative;
	border: 1px solid var(--el-border-color);
	border-radius: 6px;
	overflow: hidden;
	background: var(--el-fill-color-blank);

	&.is-dark {
		border-color: #32333a;
		background: #181b1f;


		.panel-expand-btn {
			color: #9e9e9e !important;

			&:hover {
				color: #d9d9d9 !important;
				background: rgba(255, 255, 255, 0.1) !important;
			}
		}
	}

	.panel-title-handle {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		height: 40px;
		z-index: 5;
		cursor: move;
	}

	.panel-expand-btn {
		position: absolute;
		top: 4px;
		right: 4px;
		z-index: 10;
		color: var(--el-text-color-secondary);
		opacity: 0;
		transition: opacity 0.15s;
	}

	&:hover .panel-expand-btn {
		opacity: 1;
	}

	.panel-chart {
		width: 100%;
	}
}
</style>
