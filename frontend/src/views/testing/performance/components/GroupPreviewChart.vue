<template>
	<div class="group-preview-chart">
		<div ref="chartRef" class="group-preview-chart__canvas" :style="{ height: height + 'px' }" />
	</div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, watch } from 'vue';
import * as echarts from 'echarts';
import { storeToRefs } from 'pinia';
import { useThemeConfig } from '/@/stores/themeConfig';

export interface PreviewPoint {
	time: number;
	value: number;
}

const props = withDefaults(defineProps<{
	points: PreviewPoint[];
	legendName?: string;
	height?: number;
}>(), {
	legendName: '活跃线程数',
	height: 320,
});

const chartRef = ref<HTMLElement | null>(null);
let chartInstance: echarts.ECharts | null = null;

const { themeConfig } = storeToRefs(useThemeConfig());

/**
 * 读取 Element Plus 已计算好的 light-5 变体（主题色与白色 50% 混合），
 * 避免对较深的主题色直接使用原色导致折线过于刺眼。
 * light-5 在任何主题色下都是适合图表折线的中亮色系。
 */
const getLineColor = (): string =>
	getComputedStyle(document.documentElement)
		.getPropertyValue('--el-color-primary-light-3').trim() || '#7B9FFF';

/** 秒数 -> 00:00:00，与 JMeter 原生预览图的 Elapsed time 轴格式保持一致 */
const formatElapsed = (totalSeconds: number): string => {
	const s = Math.max(0, Math.round(totalSeconds));
	const hh = Math.floor(s / 3600);
	const mm = Math.floor((s % 3600) / 60);
	const ss = s % 60;
	const pad = (n: number) => String(n).padStart(2, '0');
	return `${pad(hh)}:${pad(mm)}:${pad(ss)}`;
};

/** 图例 hover 提示仅保留中文/主文案，去掉括号里的英文翻译 */
const stripBrackets = (name: string): string => name.replace(/[（(][^）)]*[）)]/g, '').trim();

// 浅蓝色 hover 提示公共样式，主提示与图例提示保持一致
const TOOLTIP_STYLE = {
	backgroundColor: '#ecf5ff',
	borderColor: '#d9ecff',
	borderWidth: 1,
	textStyle: { color: '#303133', fontSize: 12 },
};

const buildOption = (): echarts.EChartsOption => {
	const hasData = props.points.length > 1 && props.points.some(p => p.value > 0);
	const data = props.points.map(p => [Number(p.time.toFixed(2)), p.value]);

	return {
		grid: { left: 20, right: 20, top: 44, bottom: 22, containLabel: true },
		legend: {
			data: [props.legendName],
			top: 6,
			left: 'center',
			icon: 'rect',
			itemWidth: 16,
			itemHeight: 3,
			textStyle: { fontSize: 12, color: '#606266' },
			tooltip: {
				show: true,
				...TOOLTIP_STYLE,
				formatter: (params: any) => stripBrackets(params.name),
			},
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: { type: 'line' },
			...TOOLTIP_STYLE,
			formatter: (params: any) => {
				const p = Array.isArray(params) ? params[0] : params;
				if (!p) return '';
				const [t, v] = p.value as [number, number];
				return `运行时间：${formatElapsed(t)}<br/>${stripBrackets(props.legendName)}：${v}`;
			},
		},
		xAxis: {
			type: 'value',
			axisLabel: { fontSize: 11, color: '#909399', formatter: (v: number) => formatElapsed(v) },
			axisLine: { lineStyle: { color: '#e0e0e0' } },
			splitLine: { show: true, lineStyle: { color: '#e4e7ed', type: 'dashed' } },
			min: 0,
		},
		yAxis: {
			type: 'value',
			// 纵轴刻度值位数会随线程数变化，若标题贴靠刻度值（旋转显示）会被挤压重叠，
			// 因此固定放在 Y 轴顶部、水平显示，与刻度值宽度解耦
			name: '活跃线程数',
			nameLocation: 'end',
			nameGap: 16,
			nameTextStyle: { fontSize: 12, color: '#606266', fontWeight: 500 },
			axisLabel: { fontSize: 11, color: '#909399' },
			axisLine: { show: false },
			splitLine: { show: true, lineStyle: { color: '#e4e7ed', type: 'dashed' } },
			min: 0,
		},
		// 固定 id + invisible 切换显隐，避免空数组无法覆盖上一次已渲染图形的 merge 问题
		graphic: [
			{
				id: 'group-preview-chart-no-data',
				type: 'text',
				left: 'center',
				top: 'middle',
				silent: true,
				invisible: hasData,
				style: { text: '配置不完整，暂无预览数据', fill: '#c0c4cc', fontSize: 12 },
			},
			{
				// X 轴标题：置于容器右下角，containLabel 保证刻度值在 grid 内（grid 以上），
				// 此 graphic 在 grid.bottom 区域之外，自然落在刻度值下方一行，不撑开右侧空白
				id: 'x-axis-name',
				type: 'text',
				right: 4,
				bottom: 4,
				silent: true,
				style: { text: '运行时间', fill: '#606266', fontSize: 12, fontWeight: 500 },
			},
		],
		series: [{
			name: props.legendName,
			type: 'line',
			data,
			showSymbol: false,
			smooth: false,
			lineStyle: { width: 2.5, color: getLineColor() },
			itemStyle: { color: getLineColor() },
			areaStyle: { color: getLineColor(), opacity: 0.15 },
		}],
	};
};

const initChart = () => {
	if (!chartRef.value) return;
	chartInstance?.dispose();
	chartInstance = echarts.init(chartRef.value);
	chartInstance.setOption(buildOption());
};

watch(() => [props.points, props.legendName], () => {
	chartInstance?.setOption(buildOption());
}, { deep: true });

// 主题色变化时同步更新折线和填充颜色
watch(() => themeConfig.value.primary, () => {
	chartInstance?.setOption(buildOption());
});

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
</script>

<style scoped lang="scss">
.group-preview-chart {
	margin-top: 8px;
	border: 1px dashed var(--el-border-color);
	border-radius: 6px;
	padding: 4px 4px 0;

	&__canvas {
		width: 100%;
	}
}
</style>