<template>
	<div class="app-test-task layout-container autotest-module-shell">
		<el-empty description="任务管理">
			<template #default>
				<p class="hint">
					老板，此页面还没开发好，欲知后事如何，请见下次分解。
				</p>
			</template>
		</el-empty>
	</div>
</template>

<script setup lang="ts">

</script>

<style scoped lang="scss">
.app-test-task {
	padding: 48px 24px;
	min-height: 360px;
}

.hint {
	margin: 0;
	max-width: 420px;
	font-size: 13px;
	color: var(--el-text-color-secondary);
	line-height: 1.6;
	text-align: center;
}
</style>
