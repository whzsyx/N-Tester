<template>
	<div class="app-management-tabs">
		<el-tabs v-model="active" type="border-card">
			<el-tab-pane label="APP自动化" name="automation">
				<AppAutomation />
			</el-tab-pane>
			<el-tab-pane label="包管理" name="package">
				<AppPackage />
			</el-tab-pane>
			<el-tab-pane label="图像识别" name="images">
				<AppImages />
			</el-tab-pane>
			<el-tab-pane label="测试结果" name="results">
				<AppResults />
			</el-tab-pane>
		</el-tabs>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import AppAutomation from './app_automation.vue';
import AppPackage from './app_package.vue';
import AppImages from './app_images.vue';
import AppResults from './app_results.vue';

const active = ref<'automation' | 'package' | 'images' | 'results'>('automation');
</script>

<style scoped>
.app-management-tabs {
	padding: 10px;
}
</style>
