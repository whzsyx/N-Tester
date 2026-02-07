<template>
	<div class="step-manager">
		<el-button type="primary" size="small" @click="handleAdd" style="margin-bottom: 10px">
			<el-icon><ele-Plus /></el-icon>
			添加步骤
		</el-button>

		<div class="step-table-container">
			<el-table :data="steps" border style="width: 100%">
				<el-table-column label="步骤" width="80" align="center">
					<template #default="{ $index }">
						{{ $index + 1 }}
					</template>
				</el-table-column>
				<el-table-column label="操作" min-width="200">
					<template #default="{ row }">
						<el-input 
							v-model="row.action" 
							type="textarea" 
							:rows="3" 
							placeholder="请输入操作步骤" 
							@change="emitUpdate"
						/>
					</template>
				</el-table-column>
				<el-table-column label="预期结果" min-width="200">
					<template #default="{ row }">
						<el-input 
							v-model="row.expected" 
							type="textarea" 
							:rows="3" 
							placeholder="请输入预期结果" 
							@change="emitUpdate"
						/>
					</template>
				</el-table-column>
				<el-table-column label="操作" width="150" align="center">
					<template #default="{ $index }">
						<el-button link type="primary" size="small" @click="handleMoveUp($index)" :disabled="$index === 0">
							<el-icon><ele-Top /></el-icon>
							上移
						</el-button>
						<el-button link type="primary" size="small" @click="handleMoveDown($index)" :disabled="$index === steps.length - 1">
							<el-icon><ele-Bottom /></el-icon>
							下移
						</el-button>
						<el-button link type="danger" size="small" @click="handleDelete($index)">
							<el-icon><ele-Delete /></el-icon>
							删除
						</el-button>
					</template>
				</el-table-column>
			</el-table>
		</div>

		<el-empty v-if="steps.length === 0" description="暂无测试步骤，请点击上方按钮添加" :image-size="100" />
	</div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';

const props = defineProps({
	modelValue: {
		type: Array as () => any[],
		default: () => [],
	},
});

const emit = defineEmits(['update:modelValue']);

const steps = ref<any[]>([]);

// 添加步骤
const handleAdd = () => {
	steps.value.push({
		step_number: steps.value.length + 1,
		action: '',
		expected: '',
	});
	updateStepNumbers();
	emitUpdate();
};

// 删除步骤
const handleDelete = (index: number) => {
	steps.value.splice(index, 1);
	updateStepNumbers();
	emitUpdate();
};

// 上移
const handleMoveUp = (index: number) => {
	if (index === 0) return;
	const temp = steps.value[index];
	steps.value[index] = steps.value[index - 1];
	steps.value[index - 1] = temp;
	updateStepNumbers();
	emitUpdate();
};

// 下移
const handleMoveDown = (index: number) => {
	if (index === steps.value.length - 1) return;
	const temp = steps.value[index];
	steps.value[index] = steps.value[index + 1];
	steps.value[index + 1] = temp;
	updateStepNumbers();
	emitUpdate();
};

// 更新步骤序号
const updateStepNumbers = () => {
	steps.value.forEach((step, index) => {
		step.step_number = index + 1;
	});
};

// 发送更新事件
const emitUpdate = () => {
	emit('update:modelValue', steps.value);
};

// 监听外部值变化
watch(
	() => props.modelValue,
	(val) => {
		if (val && val.length > 0) {
			steps.value = JSON.parse(JSON.stringify(val));
		} else {
			steps.value = [];
		}
	},
	{ immediate: true, deep: true }
);
</script>

<style scoped lang="scss">
.step-manager {
	width: 100%;
	
	.step-table-container {
		max-height: 400px;
		overflow-y: auto;
		border: 1px solid #ebeef5;
		border-radius: 4px;
		margin-top: 10px;
	}

	:deep(.el-table) {
		.el-input {
			width: 100%;
		}
		
		.el-textarea__inner {
			resize: vertical;
			min-height: 60px;
		}
		
		.el-table__cell {
			padding: 12px 0;
		}
	}
	
	.el-empty {
		padding: 40px 0;
	}
}
</style>
