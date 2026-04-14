<template>
	<div class="performance-page">
		<el-card shadow="hover">
			<template #header>
				<div class="card-header">
					<el-icon><DataAnalysis /></el-icon>
					<span>造数管理</span>
				</div>
			</template>
			<el-empty description="造数管理功能开发中，敬请期待..." :image-size="120">
				<template #image>
					<el-icon :size="120" color="#c0c4cc"><DataAnalysis /></el-icon>
				</template>
			</el-empty>
		</el-card>
	</div>
</template>

<script setup lang="ts" name="PerformanceData">
import { DataAnalysis } from '@element-plus/icons-vue';
</script>

<style scoped lang="scss">
.performance-page {
	padding: 10px 10px 20px 10px;

	:deep(.el-card__body) {
		padding: 10px 10px 20px 10px;
	}

	.card-header {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 16px;
		font-weight: 600;
	}
}
</style>