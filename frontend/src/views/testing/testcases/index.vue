<template>
	<div class="testcase-container">
		<el-card shadow="hover" class="search-card">
			<!-- 搜索区域 -->
			<el-form :inline="true" :model="queryForm" class="search-form">
				<el-form-item label="项目">
					<el-select v-model="queryForm.project_id" placeholder="请选择项目" clearable @change="handleQuery" style="width: 200px">
						<el-option v-for="project in projectList" :key="project.id" :label="project.name" :value="project.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="标题">
					<el-input v-model="queryForm.title" placeholder="请输入用例标题" clearable @keyup.enter="handleQuery" style="width: 200px" />
				</el-form-item>
				<el-form-item label="状态">
					<el-select v-model="queryForm.status" placeholder="请选择状态" clearable style="width: 120px">
						<el-option label="草稿" value="draft" />
						<el-option label="激活" value="active" />
						<el-option label="已废弃" value="deprecated" />
					</el-select>
				</el-form-item>
				<el-form-item label="优先级">
					<el-select v-model="queryForm.priority" placeholder="请选择优先级" clearable style="width: 120px">
						<el-option label="低" value="low" />
						<el-option label="中" value="medium" />
						<el-option label="高" value="high" />
						<el-option label="紧急" value="critical" />
					</el-select>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleQuery">
						<el-icon><ele-Search /></el-icon>
						查询
					</el-button>
					<el-button @click="handleReset">
						<el-icon><ele-Refresh /></el-icon>
						重置
					</el-button>
				</el-form-item>
			</el-form>
		</el-card>

		<el-card shadow="hover" class="table-card">
			<!-- 操作按钮 -->
			<div class="table-header">
				<el-button type="primary" @click="handleAdd" :disabled="!queryForm.project_id">
					<el-icon><ele-Plus /></el-icon>
					新增用例
				</el-button>
			</div>

			<!-- 数据表格 -->
			<el-table :data="tableData" style="width: 100%" v-loading="loading">
				<el-table-column prop="id" label="ID" width="80" />
				<el-table-column prop="title" label="用例标题" min-width="200" show-overflow-tooltip />
				<el-table-column prop="priority" label="优先级" width="100">
					<template #default="{ row }">
						<el-tag v-if="row.priority === 'critical'" type="danger">紧急</el-tag>
						<el-tag v-else-if="row.priority === 'high'" type="warning">高</el-tag>
						<el-tag v-else-if="row.priority === 'medium'" type="info">中</el-tag>
						<el-tag v-else type="success">低</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="status" label="状态" width="100">
					<template #default="{ row }">
						<el-tag v-if="row.status === 'active'" type="success">激活</el-tag>
						<el-tag v-else-if="row.status === 'draft'" type="info">草稿</el-tag>
						<el-tag v-else type="danger">已废弃</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="test_type" label="类型" width="120">
					<template #default="{ row }">
						{{ getTestTypeLabel(row.test_type) }}
					</template>
				</el-table-column>
				<el-table-column prop="author_name" label="作者" width="120" />
				<el-table-column prop="assignee_name" label="指派人" width="120" />
				<el-table-column prop="creation_date" label="创建时间" width="180">
					<template #default="{ row }">
						{{ formatDateTime(row.creation_date) }}
					</template>
				</el-table-column>
				<el-table-column label="操作" width="240" fixed="right">
					<template #default="{ row }">
						<el-button type="primary" size="small" @click="handleView(row)">查看</el-button>
						<el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
						<el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
					</template>
				</el-table-column>
			</el-table>

			<!-- 分页 -->
			<el-pagination
				v-model:current-page="queryForm.page"
				v-model:page-size="queryForm.page_size"
				:page-sizes="[10, 20, 50, 100]"
				:total="total"
				layout="total, sizes, prev, pager, next, jumper"
				@size-change="handleQuery"
				@current-change="handleQuery"
				class="pagination"
			/>
		</el-card>

		<!-- 新增/编辑对话框 -->
		<TestCaseForm
			v-model="dialogVisible"
			:project-id="queryForm.project_id || 0"
			:project-name="currentProjectName"
			:testcase-id="currentTestCaseId"
			@success="handleQuery"
		/>

		<!-- 详情对话框 -->
		<TestCaseDetail v-model="detailVisible" :testcase-id="currentTestCaseId || 0" />
	</div>
</template>

<script setup lang="ts" name="TestCaseList">
import { ref, reactive, onMounted, computed } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getTestCaseList, deleteTestCase } from '/@/api/v1/testcases';
import { getProjectList } from '/@/api/v1/project';
import TestCaseForm from './components/TestCaseForm.vue';
import TestCaseDetail from './components/TestCaseDetail.vue';

// 查询表单
const queryForm = reactive({
	project_id: null as number | null,
	title: '',
	status: '',
	priority: '',
	page: 1,
	page_size: 20,
});

// 数据
const tableData = ref<any[]>([]);
const total = ref(0);
const loading = ref(false);
const projectList = ref<any[]>([]);

// 对话框
const dialogVisible = ref(false);
const detailVisible = ref(false);
const currentTestCaseId = ref<number | null>(null);
const currentProjectName = computed(() => {
	const project = projectList.value.find((p) => p.id === queryForm.project_id);
	return project ? project.name : '';
});

// 获取项目列表
const getProjects = async () => {
	try {
		const res = await getProjectList({ page: 1, page_size: 100 });
		if (res.code === 200) {
			projectList.value = res.data.items || [];
			// 如果有项目，自动选中第一个
			if (projectList.value.length > 0 && !queryForm.project_id) {
				queryForm.project_id = projectList.value[0].id;
				handleQuery();
			}
		}
	} catch (error) {
		console.error('获取项目列表失败:', error);
	}
};

// 查询
const handleQuery = async () => {
	if (!queryForm.project_id) {
		ElMessage.warning('请先选择项目');
		return;
	}

	loading.value = true;
	try {
		const res = await getTestCaseList(queryForm);
		if (res.code === 200) {
			const items = res.data.items || res.data.rows || [];
			const totalCount = res.data.total || res.data.rowTotal || 0;
			
			tableData.value = items;
			total.value = totalCount;
		}
	} catch (error) {
		console.error('查询失败:', error);
		ElMessage.error('查询失败');
	} finally {
		loading.value = false;
	}
};

// 重置
const handleReset = () => {
	queryForm.title = '';
	queryForm.status = '';
	queryForm.priority = '';
	queryForm.page = 1;
	if (queryForm.project_id) {
		handleQuery();
	}
};

// 新增
const handleAdd = () => {
	currentTestCaseId.value = null;
	dialogVisible.value = true;
};

// 编辑
const handleEdit = (row: any) => {
	currentTestCaseId.value = row.id;
	dialogVisible.value = true;
};

// 查看
const handleView = (row: any) => {
	currentTestCaseId.value = row.id;
	detailVisible.value = true;
};

// 删除
const handleDelete = (row: any) => {
	ElMessageBox.confirm(`确定要删除测试用例"${row.title}"吗？`, '提示', {
		confirmButtonText: '确定',
		cancelButtonText: '取消',
		type: 'warning',
	})
		.then(async () => {
			try {
				const res = await deleteTestCase(row.id);
				if (res.code === 200) {
					ElMessage.success('删除成功');
					handleQuery();
				}
			} catch (error) {
				console.error('删除失败:', error);
				ElMessage.error('删除失败');
			}
		})
		.catch(() => {});
};

// 获取测试类型标签
const getTestTypeLabel = (type: string) => {
	const typeMap: Record<string, string> = {
		functional: '功能测试',
		integration: '集成测试',
		api: 'API测试',
		ui: 'UI测试',
		performance: '性能测试',
		security: '安全测试',
	};
	return typeMap[type] || type;
};

// 格式化日期时间
const formatDateTime = (dateTime: string) => {
	if (!dateTime) return '-';
	const date = new Date(dateTime);
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, '0');
	const day = String(date.getDate()).padStart(2, '0');
	const hours = String(date.getHours()).padStart(2, '0');
	const minutes = String(date.getMinutes()).padStart(2, '0');
	const seconds = String(date.getSeconds()).padStart(2, '0');
	return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 初始化
onMounted(() => {
	getProjects();
});
</script>

<style scoped lang="scss">
.testcase-container {
	padding: 20px;

	.search-card {
		margin-bottom: 20px;
	}

	.table-card {
		.table-header {
			margin-bottom: 20px;
		}

		.pagination {
			margin-top: 20px;
			display: flex;
			justify-content: flex-end;
		}
	}
}
</style>
