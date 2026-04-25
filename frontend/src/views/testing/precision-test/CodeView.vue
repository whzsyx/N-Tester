<template>
	<div ref="containerRef" class="code-view">
		<table class="code-table">
			<tbody>
				<tr
					v-for="(line, idx) in lines"
					:key="idx"
					:ref="(el) => setLineRef(el, idx + 1)"
					:class="getLineClass(idx + 1)"
				>
					<td class="line-number">{{ idx + 1 }}</td>
					<td class="line-content"><pre>{{ line }}</pre></td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';

const props = defineProps<{
	content: string;
	linesCoveredStatus: Record<number, 0 | 1 | 2>;
}>();

const containerRef = ref<HTMLElement | null>(null);
const lineRefs: Record<number, HTMLElement> = {};

const lines = computed(() => props.content.split('\n'));

const setLineRef = (el: any, lineNo: number) => {
	if (el) lineRefs[lineNo] = el as HTMLElement;
};

const getLineClass = (lineNo: number): string => {
	const status = props.linesCoveredStatus[lineNo];
	if (status === 2) return 'line-covered';
	if (status === 1) return 'line-partial';
	if (status === 0) return 'line-missed';
	return '';
};

/** Scroll the container to the given line offset */
const locationEl = (offset: number) => {
	const el = lineRefs[offset];
	if (el) {
		el.scrollIntoView({ behavior: 'smooth', block: 'center' });
	}
};

defineExpose({ locationEl });
</script>

<style scoped lang="scss">
.code-view {
	overflow: auto;
	max-height: 70vh;
	border: 1px solid #e4e7ed;
	border-radius: 4px;
	background: #fafafa;
	font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
	font-size: 13px;
}

.code-table {
	width: 100%;
	border-collapse: collapse;
}

.line-number {
	width: 48px;
	min-width: 48px;
	text-align: right;
	padding: 0 8px;
	color: #909399;
	background: #f0f0f0;
	border-right: 1px solid #e4e7ed;
	user-select: none;
	vertical-align: top;
}

.line-content {
	padding: 0 8px;
	white-space: pre;
	vertical-align: top;

	pre {
		margin: 0;
		padding: 0;
		font-family: inherit;
		font-size: inherit;
	}
}

.line-covered {
	background-color: #f0fff0;
}

.line-partial {
	background-color: #fffbe6;
}

.line-missed {
	background-color: #fff0f0;
}
</style>
