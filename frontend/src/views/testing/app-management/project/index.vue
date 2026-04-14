<template>
	<div class="app-test-project layout-container autotest-module-shell">
		<div class="page-toolbar">
			<span class="page-toolbar__title">APP管理</span>
			<span class="page-toolbar__hint">包与图像资源</span>
		</div>
		<el-tabs v-model="subTab" class="project-inner-tabs">
			<el-tab-pane label="包管理" name="package">
				<AppPackage />
			</el-tab-pane>
			<el-tab-pane label="图像库" name="images">
				<AppImages />
			</el-tab-pane>
		</el-tabs>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import AppPackage from '../app_package.vue';
import AppImages from '../app_images.vue';

const subTab = ref<'package' | 'images'>('package');
</script>

<style scoped lang="scss">
.layout-container.autotest-module-shell {
	min-height: 400px;
}

.page-toolbar {
	display: flex;
	align-items: baseline;
	gap: 12px;
	margin-bottom: 12px;
	padding-bottom: 12px;
	border-bottom: 1px solid var(--el-border-color-lighter);
}

.page-toolbar__title {
	font-size: 16px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.page-toolbar__hint {
	font-size: 13px;
	color: var(--el-text-color-secondary);
}

.project-inner-tabs {
	:deep(.el-tabs__content) {
		padding-top: 8px;
	}
}
</style>
