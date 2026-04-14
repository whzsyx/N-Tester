<template>
	<div class="perf-scheduler-container">
		<el-card shadow="hover">
			<!-- 工具栏 -->
			<div class="toolbar">
				<div class="toolbar-left">
					<el-input
						v-model="query.name"
						placeholder="搜索任务名称"
						clearable
						style="width: 300px"
						@keyup.enter="handleQuery"
						@clear="handleQuery"
					>
						<template #prefix><el-icon><ele-Search /></el-icon></template>
					</el-input>
					<el-select v-model="query.task_status" placeholder="任务状态" clearable style="width: 130px" @change="handleQuery">
						<el-option label="待触发" value="pending" />
						<el-option label="进行中" value="running" />
						<el-option label="已结束" value="finished" />
						<el-option label="已取消" value="cancelled" />
					</el-select>
					<el-select v-model="query.enabled" placeholder="启用状态" clearable style="width: 120px" @change="handleQuery">
						<el-option label="启用" :value="1" />
						<el-option label="禁用" :value="0" />
					</el-select>
					<el-button type="primary" @click="handleQuery">
						<el-icon><ele-Search /></el-icon>查询
					</el-button>
					<el-button @click="resetQuery">
						<el-icon><ele-RefreshRight /></el-icon>重置
					</el-button>
				</div>
				<div class="toolbar-right">
					<el-button type="primary" @click="openCreateDialog">
						<el-icon><ele-Plus /></el-icon>新建定时任务
					</el-button>
					<el-button :loading="statusRefreshing" @click="handleRefreshStatus">
						<el-icon><ele-Refresh /></el-icon>刷新任务状态
					</el-button>
				</div>
			</div>

			<!-- 列表 -->
			<el-table v-loading="loading" :data="taskList" border stripe style="width: 100%">
				<el-table-column prop="id" label="任务ID" width="80" align="center" />
				<el-table-column prop="name" label="任务名称" min-width="150" show-overflow-tooltip />
				<el-table-column label="任务编号" width="150" align="center">
					<template #default="{ row }">
						<el-tooltip
							:content="row.task_status === 'running' ? '点击跳转任务列表查看进度' : '点击跳转压测场景列表'"
							placement="top"
							:show-after="300"
						>
							<span class="scene-no-link" @click="handleGotoScene(row)">{{ row.scene_no }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="script_name" label="任务脚本" min-width="140" show-overflow-tooltip />
				<el-table-column label="启用状态" width="130" align="center">
					<template #default="{ row }">
						<el-switch
							v-model="row.enabled"
							:active-value="1"
							:inactive-value="0"
							:disabled="row.task_status === 'running'"
							@change="handleEnabledChange(row)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="任务状态" width="130" align="center">
					<template #default="{ row }">
						<el-tag
							:type="taskStatusType(row.task_status)"
							size="small"
							:effect="row.task_status === 'running' ? 'dark' : 'light'"
						>
							{{ taskStatusLabel(row.task_status) }}
						</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="创建时间" width="200" align="center">
					<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.created_at) }}</span></template>
				</el-table-column>
				<el-table-column label="计划执行时间" width="200" align="center">
					<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.plan_time) }}</span></template>
				</el-table-column>
				<el-table-column prop="created_by" label="创建人" width="130" align="center" show-overflow-tooltip />
				<el-table-column label="操作" width="260" fixed="right" align="center" class-name="operation-col">
					<template #default="{ row }">
						<div class="action-btns">
							<!-- 进行中：仅取消（查看进度通过点击任务编号跳转） -->
							<template v-if="row.task_status === 'running'">
								<el-button type="warning" size="small" text style="font-weight:600" @click="handleCancel(row)">
									<el-icon><ele-CircleClose /></el-icon>取消
								</el-button>
							</template>
							<!-- 待触发 / 已取消：编辑 + 删除 -->
							<template v-else-if="row.task_status === 'pending' || row.task_status === 'cancelled'">
								<el-button type="primary" size="small" text style="font-weight:600" @click="openEditDialog(row)">
									<el-icon><ele-Edit /></el-icon>编辑
								</el-button>
								<el-button type="danger" size="small" text style="font-weight:600" @click="handleDelete(row)">
									<el-icon><ele-Delete /></el-icon>删除
								</el-button>
							</template>
							<!-- 已结束：结果报告（只读） -->
							<template v-else-if="row.task_status === 'finished'">
								<el-button type="success" size="small" text style="font-weight:600" @click="handleViewReport(row)">
									<el-icon><ele-DataLine /></el-icon>结果报告
								</el-button>
							</template>
						</div>
					</template>
				</el-table-column>
			</el-table>

			<!-- 分页 -->
			<div class="pagination">
				<el-pagination
					v-model:current-page="query.page"
					v-model:page-size="query.page_size"
					:page-sizes="[10, 20, 50]"
					:total="total"
					layout="total, sizes, prev, pager, next, jumper"
					@size-change="handleQuery"
					@current-change="handleQuery"
				/>
			</div>
		</el-card>

		<!-- 新建 / 编辑 弹窗 -->
		<el-dialog
			v-model="dialogVisible"
			:title="dialogMode === 'create' ? '新建定时任务' : '编辑定时任务'"
			width="660px"
			top="8vh"
			class="perf-scheduler-dialog"
			destroy-on-close
			@close="resetForm"
		>
			<el-form ref="formRef" :model="form" :rules="rules" label-width="110px" size="default">
				<el-form-item label="任务名称" prop="name">
					<el-input v-model="form.name" placeholder="请输入任务名称，最多100个字符" maxlength="100" show-word-limit clearable />
				</el-form-item>
				<el-form-item label="关联压测场景" prop="scene_id">
					<el-select
						v-model="form.scene_id"
						placeholder="请选择压测场景（排除进行中）"
						clearable
						style="width: 100%"
						filterable
						@change="handleSceneChange"
					>
						<el-option
							v-for="s in availableScenes"
							:key="s.id"
							:label="`${s.scene_no}：${s.script_name}`"
							:value="s.id"
						/>
					</el-select>
				</el-form-item>
				<el-form-item label="启用状态">
					<el-switch
						v-model="form.enabled"
						:active-value="1"
						:inactive-value="0"
						inline-prompt
						active-text="启用"
						inactive-text="禁用"
					/>
					<span class="form-hint">禁用后即使到达计划时间也不会触发执行</span>
				</el-form-item>
				<el-form-item label="计划执行时间" prop="plan_time">
					<el-date-picker
						v-model="form.plan_time"
						type="datetime"
						placeholder="请选择计划执行时间（年/月/日 时:分:秒）"
						format="YYYY-MM-DD HH:mm:ss"
						value-format="YYYY-MM-DDTHH:mm:ss"
						style="width: 100%"
					/>
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<script setup lang="ts" name="PerformanceScheduler">
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus';

const router = useRouter();

// ======================== 工具函数 ========================
const formatDateTime = (val: string) => {
	if (!val) return '-';
	return val.replace('T', ' ').substring(0, 19);
};

// ======================== 状态映射 ========================
const taskStatusLabel = (s: string) => {
	const map: Record<string, string> = {
		pending: '待触发', running: '进行中', finished: '已结束', cancelled: '已取消',
	};
	return map[s] ?? s;
};

const taskStatusType = (s: string): '' | 'success' | 'warning' | 'danger' | 'info' => {
	const map: Record<string, '' | 'success' | 'warning' | 'danger' | 'info'> = {
		pending: 'warning', running: '', finished: 'success', cancelled: 'info',
	};
	return map[s] ?? '';
};

// ======================== 压测场景数据（来自场景列表） ========================
const allScenes = [
	{ id: 1, scene_no: 'JMX00000001', name: '登录接口压测-v1', script_name: 'login_stress.jmx', status: 'running' },
	{ id: 2, scene_no: 'JMX00000002', name: '订单查询压测', script_name: 'order_stress.jmx', status: 'completed' },
	{ id: 3, scene_no: 'JMX00000003', name: '全链路压测场景', script_name: 'search_perf.jmx', status: 'failed' },
	{ id: 4, scene_no: 'JMX00000004', name: '搜索接口基准测试', script_name: 'search_perf.jmx', status: 'cancelled' },
];

// 可关联的场景：排除进行中的
const availableScenes = allScenes.filter(s => s.status !== 'running');

// ======================== 列表 ========================
const loading = ref(false);
const taskList = ref<any[]>([]);
const total = ref(0);
const statusRefreshing = ref(false);

const query = reactive({
	name: '',
	task_status: undefined as string | undefined,
	enabled: undefined as number | undefined,
	page: 1,
	page_size: 10,
});

let nextId = 5;
const mockData: any[] = [
	{
		id: 1,
		name: '登录接口夜间压测',
		scene_id: 2,
		scene_no: 'JMX00000002',
		script_name: 'order_stress.jmx',
		enabled: 1,
		task_status: 'pending',
		plan_time: '2026-04-11T02:00:00',
		created_at: '2026-04-10T09:00:00',
		created_by: 'admin',
	},
	{
		id: 2,
		name: '订单全链路每日压测',
		scene_id: 2,
		scene_no: 'JMX00000002',
		script_name: 'order_stress.jmx',
		enabled: 1,
		task_status: 'running',
		plan_time: '2026-04-10T10:00:00',
		created_at: '2026-04-09T16:30:00',
		created_by: 'admin',
	},
	{
		id: 3,
		name: '搜索接口基准-周报',
		scene_id: 4,
		scene_no: 'JMX00000004',
		script_name: 'search_perf.jmx',
		enabled: 0,
		task_status: 'cancelled',
		plan_time: '2026-04-09T23:00:00',
		created_at: '2026-04-08T14:00:00',
		created_by: 'tester',
	},
	{
		id: 4,
		name: '全链路压测-周五执行',
		scene_id: 3,
		scene_no: 'JMX00000003',
		script_name: 'search_perf.jmx',
		enabled: 1,
		task_status: 'finished',
		plan_time: '2026-04-07T20:00:00',
		created_at: '2026-04-07T09:00:00',
		created_by: 'admin',
	},
];

const handleQuery = () => {
	loading.value = true;
	setTimeout(() => {
		let data = [...mockData];
		if (query.name) data = data.filter(r => r.name.includes(query.name));
		if (query.task_status) data = data.filter(r => r.task_status === query.task_status);
		if (query.enabled !== undefined) data = data.filter(r => r.enabled === query.enabled);
		total.value = data.length;
		const start = (query.page - 1) * query.page_size;
		taskList.value = data.slice(start, start + query.page_size);
		loading.value = false;
	}, 200);
};

const resetQuery = () => {
	query.name = '';
	query.task_status = undefined;
	query.enabled = undefined;
	query.page = 1;
	handleQuery();
};

// ======================== 刷新状态 ========================
const handleRefreshStatus = () => {
	statusRefreshing.value = true;
	setTimeout(() => {
		statusRefreshing.value = false;
		handleQuery();
		ElMessage.success('任务状态已刷新');
	}, 800);
};

// ======================== 启用状态切换 ========================
const handleEnabledChange = (row: any) => {
	const item = mockData.find(r => r.id === row.id);
	if (item) item.enabled = row.enabled;
	ElMessage.success(row.enabled ? `「${row.name}」已启用` : `「${row.name}」已禁用`);
};

// ======================== 取消任务 ========================
const handleCancel = (row: any) => {
	ElMessageBox.confirm(
		`确认取消定时任务「${row.name}」？取消后任务状态将变为已取消。`,
		'取消定时任务',
		{ type: 'warning', confirmButtonText: '确认取消', cancelButtonText: '返回', confirmButtonClass: 'el-button--danger' }
	).then(() => {
		const item = mockData.find(r => r.id === row.id);
		if (item) item.task_status = 'cancelled';
		handleQuery();
		ElMessage.success('定时任务已取消');
	}).catch(() => {});
};


// ======================== 结果报告（跳转测试报告） ========================
const handleViewReport = (row: any) => {
	router.push({ path: '/performance/report', query: { scene_no: row.scene_no } });
};

// ======================== 跳转压测场景列表 ========================
const handleGotoScene = (row: any) => {
	router.push({ path: '/performance/scenario', query: { scene_no: row.scene_no } });
};

// ======================== 删除 ========================
const handleDelete = (row: any) => {
	ElMessageBox.confirm(
		`确认删除定时任务「${row.name}」？`,
		'删除确认',
		{ type: 'warning', confirmButtonText: '确认删除', cancelButtonText: '取消', confirmButtonClass: 'el-button--danger' }
	).then(() => {
		const idx = mockData.findIndex(r => r.id === row.id);
		if (idx > -1) mockData.splice(idx, 1);
		handleQuery();
		ElMessage.success('删除成功');
	}).catch(() => {});
};

// ======================== 新建 / 编辑 弹窗 ========================
const dialogVisible = ref(false);
const dialogMode = ref<'create' | 'edit'>('create');
const submitLoading = ref(false);
const formRef = ref<FormInstance>();
const editId = ref<number | null>(null);

const defaultForm = () => ({
	name: '',
	scene_id: undefined as number | undefined,
	enabled: 1,
	plan_time: '',
});

const form = reactive(defaultForm());

const rules = {
	name: [
		{ required: true, message: '请输入任务名称', trigger: 'blur' },
		{ max: 100, message: '任务名称不能超过 100 个字符', trigger: 'blur' },
	],
	scene_id: [
		{ required: true, message: '请选择关联压测场景', trigger: 'change' },
	],
	plan_time: [
		{ required: true, message: '请选择计划执行时间', trigger: 'change' },
	],
};

const handleSceneChange = (sceneId: number) => {
	const scene = availableScenes.find(s => s.id === sceneId);
	if (scene && !form.name) {
		form.name = scene.name;
	}
};

const openCreateDialog = () => {
	dialogMode.value = 'create';
	editId.value = null;
	Object.assign(form, defaultForm());
	dialogVisible.value = true;
};

const openEditDialog = (row: any) => {
	dialogMode.value = 'edit';
	editId.value = row.id;
	form.name = row.name;
	form.scene_id = row.scene_id;
	form.enabled = row.enabled;
	form.plan_time = row.plan_time;
	dialogVisible.value = true;
};

const resetForm = () => {
	formRef.value?.resetFields();
	Object.assign(form, defaultForm());
	editId.value = null;
};

const handleSubmit = () => {
	formRef.value?.validate((valid: boolean) => {
		if (!valid) return;
		submitLoading.value = true;
		setTimeout(() => {
			const scene = availableScenes.find(s => s.id === form.scene_id);
			if (dialogMode.value === 'create') {
				mockData.unshift({
					id: nextId++,
					name: form.name,
					scene_id: form.scene_id,
					scene_no: scene?.scene_no ?? '',
					script_name: scene?.script_name ?? '',
					enabled: form.enabled,
					task_status: 'pending',
					plan_time: form.plan_time,
					created_at: new Date().toISOString(),
					created_by: 'admin',
				});
				ElMessage.success('定时任务创建成功');
			} else {
				const item = mockData.find(r => r.id === editId.value);
				if (item) {
					item.name = form.name;
					item.scene_id = form.scene_id;
					item.scene_no = scene?.scene_no ?? item.scene_no;
					item.script_name = scene?.script_name ?? item.script_name;
					item.enabled = form.enabled;
					item.plan_time = form.plan_time;
				}
				ElMessage.success('定时任务更新成功');
			}
			submitLoading.value = false;
			dialogVisible.value = false;
			handleQuery();
		}, 400);
	});
};

// ======================== 初始化 ========================
onMounted(() => {
	handleQuery();
});
</script>

<style scoped lang="scss">
.perf-scheduler-container {
	padding: 10px 10px 20px 10px;

	:deep(.el-card__body) {
		padding: 10px 10px 20px 10px;
	}

	:deep(.el-button > span) {
		display: inline-flex !important;
		align-items: center !important;
		line-height: 1 !important;
	}

	.toolbar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 16px;

		.toolbar-left {
			display: flex;
			align-items: center;
			gap: 10px;
			flex-wrap: wrap;
		}

		.toolbar-right {
			display: flex;
			align-items: center;
			gap: 10px;
		}
	}

	.scene-no-link {
		color: var(--el-color-primary);
		cursor: pointer;
		font-size: 13.5px;

		&:hover {
			text-decoration: underline;
		}
	}

	:deep(.el-tag) {
		font-size: 13px;
		padding: 0 8px;
	}

	:deep(.el-table) {
		font-size: 13.5px;

		.el-table__header th {
			font-size: 13.5px;
			background-color: #eef3fb;

			.cell {
				display: inline-flex;
				align-items: center;
				justify-content: center;
				white-space: nowrap;
			}
		}

		.el-table__cell {
			padding: 11px 0;
		}

		td.operation-col {
			background-color: #f0f2f5 !important;
		}
	}

	.action-btns {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-wrap: nowrap;

		:deep(.el-button) {
			padding: 0 6px;
			font-weight: 600;

			.el-icon {
				margin-right: 2px;
			}
		}
	}

	.pagination {
		margin-top: 16px;
		display: flex;
		justify-content: flex-end;
	}

	.form-hint {
		margin-left: 10px;
		font-size: 13px;
		color: #909399;
		line-height: 1;
	}

	// 弹窗内 placeholder 统一 13px
	:deep(.el-dialog) {
		.el-input__inner,
		.el-input__placeholder,
		.el-textarea__inner,
		.el-select__placeholder {
			font-size: 13px;
		}

		.el-input .el-input__inner::placeholder,
		.el-textarea__inner::placeholder {
			font-size: 13px;
		}
	}
}
</style>

<style lang="scss">
/* 按钮内 slot wrapper span 设为 flex，使图标与文字垂直居中 */
.perf-scheduler-container .el-button > span {
	display: inline-flex !important;
	align-items: center !important;
	line-height: 1 !important;
}

/* 定时任务弹窗（teleport 到 body，需非 scoped 覆盖） */
.perf-scheduler-dialog {
	.el-dialog__body {
		padding: 32px 36px 16px;
	}

	.el-dialog__footer {
		padding-top: 80px;
	}
}
</style>