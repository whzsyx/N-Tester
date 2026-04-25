<template>
	<div v-if="!validServiceId">
		<el-empty description="请先选择服务" />
	</div>
	<el-tabs v-else v-model="activeTab" type="border-card">
		<el-tab-pane label="仓库管理" name="repository">
			<RepositoryManager :serviceId="serviceId" />
		</el-tab-pane>
		<el-tab-pane label="覆盖率报告" name="coverage">
			<CoverageReportList :serviceId="serviceId" />
		</el-tab-pane>
	</el-tabs>
</template>

<script setup lang="ts">
import { computed, defineAsyncComponent, ref } from 'vue';

const props = defineProps<{ serviceId: number }>();

const activeTab = ref<'repository' | 'coverage'>('repository');

const validServiceId = computed(() => props.serviceId && props.serviceId > 0);

const RepositoryManager = defineAsyncComponent({
	loader: () => import('./RepositoryManager.vue'),
	errorComponent: {
		template: '<div style="padding: 20px; color: #909399;">仓库管理加载中...</div>',
	},
	delay: 200,
	timeout: 5000,
});

const CoverageReportList = defineAsyncComponent({
	loader: () => import('./CoverageReportList.vue'),
	errorComponent: {
		template: '<div style="padding: 20px; color: #909399;">覆盖率报告加载中...</div>',
	},
	delay: 200,
	timeout: 5000,
});
</script>
