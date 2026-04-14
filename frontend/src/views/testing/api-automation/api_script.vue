<template>
	<div>
		<el-card class="box-card">
			<div class="script-topbar">
				<div class="script-topbar-left">
					<span class="script-title">接口自动化 - 场景管理</span>
				</div>
				<div class="script-topbar-right">
					<el-input 
						v-model="searchParams.search.name__icontains" 
						placeholder="模糊搜索" 
						clearable 
						style="width: 300px; margin-right: 10px;"
						@keyup.enter="get_script_list"
					>
						<template #append>
							<el-button @click="get_script_list">搜索</el-button>
						</template>
					</el-input>
					<el-button type="danger" @click="reset_search">重置</el-button>
					<el-button type="primary" @click="Add">新增场景</el-button>
				</div>
			</div>
		</el-card>

		<el-card class="box-card mt-10px">
			<el-table :data="table_data" stripe>
				<el-table-column prop="id" label="ID" width="90" />
				<el-table-column prop="name" label="名称" />
				<el-table-column prop="description" label="描述" />
				<el-table-column label="操作" width="260">
					<template #default="{ row }">
						<el-button type="primary" size="small" @click="run_script(row)">立即测试</el-button>
						<el-button type="warning" size="small" @click="Edit(row)">编辑</el-button>
						<el-button type="danger" size="small" @click="Delete(row)">删除</el-button>
					</template>
				</el-table-column>
			</el-table>

			<div class="pagination-wrapper">
				<el-pagination
					v-model:current-page="searchParams.currentPage"
					v-model:page-size="searchParams.pageSize"
					:page-sizes="[10, 25, 50, 100]"
					:background="true"
					layout="total, sizes, prev, pager, next, jumper"
					:total="total"
					@size-change="get_script_list"
					@current-change="get_script_list"
				/>
			</div>
		</el-card>

		<!-- 新增场景对话框 -->
		<el-dialog v-model="addDialogRef" :title="dialogTitle" width="900px" destroy-on-close>
			<el-form :model="add_form" label-width="90px">
				<el-form-item label="名称" required><el-input v-model="add_form.name" /></el-form-item>
				<el-form-item label="描述"><el-input v-model="add_form.description" type="textarea" /></el-form-item>
				<el-form-item label="CI执行">
					<el-select v-model="add_form.config.api_service_id" placeholder="选择服务" style="width: 260px" clearable @change="get_api_tree_list">
						<el-option v-for="s in service_list" :key="s.id" :label="s.name" :value="s.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="环境" required>
					<el-select v-model="add_form.config.env_id" placeholder="选择环境" style="width: 260px">
						<el-option v-for="e in env_list" :key="e.id" :label="e.name" :value="e.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="参数集">
					<el-select v-model="add_form.config.params_id" placeholder="选择参数集" style="width: 260px" clearable>
						<el-option v-for="p in params_list" :key="p.id" :label="p.name" :value="p.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="用例选择">
					<el-button @click="open_case_picker">从接口树添加</el-button>
				</el-form-item>
				<el-form-item label="已选步骤">
					<el-table :data="add_form.script" size="small" height="220">
						<el-table-column prop="name" label="步骤名" />
						<el-table-column prop="step" label="顺序" width="90" />
					</el-table>
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button @click="addDialogRef = false">取消</el-button>
				<el-button type="primary" @click="add_confirm">确定</el-button>
			</template>
		</el-dialog>

		<!-- 用例选择（从接口树勾选） -->
		<el-dialog v-model="casePickerVisible" title="从接口树添加用例" width="900px" destroy-on-close>
			<div style="display:flex; gap:10px; margin-bottom: 10px;">
				<el-input v-model="caseTreeFilter" placeholder="搜索接口/用例" clearable />
				<el-button type="primary" @click="confirm_add_cases">确认添加</el-button>
			</div>
			<el-tree
				ref="caseTreeRef"
				:data="tree_list"
				:props="{ children: 'children', label: 'name' }"
				node-key="id"
				show-checkbox
				:default-expand-all="true"
				:filter-node-method="filterCaseNode"
			/>
			<template #footer>
				<el-button @click="casePickerVisible = false">关闭</el-button>
			</template>
		</el-dialog>

		<!-- 编辑场景对话框 -->
		<el-dialog v-model="editDialogRef" :title="dialogTitle" width="900px" destroy-on-close>
			<el-form :model="add_form" label-width="90px">
				<el-form-item label="名称" required><el-input v-model="add_form.name" /></el-form-item>
				<el-form-item label="描述"><el-input v-model="add_form.description" type="textarea" /></el-form-item>
				<el-form-item label="CI执行">
					<el-select v-model="add_form.config.api_service_id" placeholder="选择服务" style="width: 260px" clearable @change="get_api_tree_list">
						<el-option v-for="s in service_list" :key="s.id" :label="s.name" :value="s.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="环境" required>
					<el-select v-model="add_form.config.env_id" placeholder="选择环境" style="width: 260px">
						<el-option v-for="e in env_list" :key="e.id" :label="e.name" :value="e.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="参数集">
					<el-select v-model="add_form.config.params_id" placeholder="选择参数集" style="width: 260px" clearable>
						<el-option v-for="p in params_list" :key="p.id" :label="p.name" :value="p.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="已选步骤">
					<el-table :data="add_form.script" size="small" height="260">
						<el-table-column prop="name" label="步骤名" />
						<el-table-column prop="step" label="顺序" width="90" />
					</el-table>
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button @click="editDialogRef = false">取消</el-button>
				<el-button type="primary" @click="edit_confirm">确定</el-button>
			</template>
		</el-dialog>

		<!-- 运行配置对话框 -->
		<el-dialog v-model="runDialogRef" :title="dialogTitle" width="600px" destroy-on-close>
			<el-form :model="run_form" label-width="90px">
				<el-form-item label="任务名称" required><el-input v-model="run_form.name" /></el-form-item>
				<el-form-item label="环境" required>
					<el-select v-model="run_form.config.env_id" placeholder="选择环境" style="width: 260px">
						<el-option v-for="e in env_list" :key="e.id" :label="e.name" :value="e.id" />
					</el-select>
				</el-form-item>
				<el-form-item label="参数集">
					<el-select v-model="run_form.config.params_id" placeholder="选择参数集" style="width: 260px" clearable>
						<el-option v-for="p in params_list" :key="p.id" :label="p.name" :value="p.id" />
					</el-select>
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button @click="runDialogRef = false">取消</el-button>
				<el-button type="primary" @click="run_confirm">确定</el-button>
			</template>
		</el-dialog>


		<!-- 执行监控：右侧抽屉-->
		<el-drawer
			v-model="resultDialogRef"
			direction="rtl"
			size="min(92vw, 1680px)"
			append-to-body
			destroy-on-close
			class="wa-run-monitor-drawer wa-run-monitor-theme"
			:show-close="true"
			:close-on-click-modal="false"
			@closed="stopPolling"
		>
			<template #header>
				<div class="wa-run-monitor-drawer-header">
					<div class="wa-run-monitor-drawer-titleline">
						<span class="wa-run-monitor-drawer-title">{{ run_form.name }} - {{ run_type }}</span>
						<el-tag type="info" effect="plain" size="small" class="wa-run-monitor-drawer-badge">执行监控</el-tag>
					</div>
					<p class="wa-run-monitor-drawer-sub">接口场景步骤与日志，执行结束后可继续查看或关闭抽屉</p>
				</div>
			</template>
			<div class="wa-run-monitor-shell">
				<div class="wa-run-monitor-body api-run-monitor-body--solo">
					<div class="wa-run-monitor-pane api-run-monitor-pane--solo">
						<div class="wa-run-monitor-desc">
							<el-card shadow="never" class="wa-run-monitor-surface wa-run-monitor-summary">
								<el-descriptions :column="4" class="wa-run-monitor-desc-table" size="small">
									<el-descriptions-item label="任务名称">{{ run_form.name }}</el-descriptions-item>
									<el-descriptions-item label="执行人">{{ run_form.username || '—' }}</el-descriptions-item>
									<el-descriptions-item label="开始时间">{{ start_time ? String(start_time).replace('T', ' ') : '—' }}</el-descriptions-item>
									<el-descriptions-item label="结束时间">{{ end_time ? String(end_time).replace('T', ' ') : '—' }}</el-descriptions-item>
									<el-descriptions-item label="执行环境">{{ run_env || '—' }}</el-descriptions-item>
									<el-descriptions-item label="执行总数">{{ run_count }}</el-descriptions-item>
									<el-descriptions-item label="通过数">{{ Math.max(0, run_count - run_fail) }}</el-descriptions-item>
									<el-descriptions-item label="失败数">{{ run_fail }}</el-descriptions-item>
								</el-descriptions>
							</el-card>
						</div>
						<div class="wa-run-monitor-split">
							<el-card shadow="never" class="wa-run-monitor-surface wa-run-monitor-card wa-run-monitor-card--timeline">
								<template #header>
									<span class="wa-run-monitor-card-title">执行步骤</span>
								</template>
								<el-timeline class="wa-run-monitor-timeline">
									<el-timeline-item
										v-for="(res, index) in run_result_list"
										:key="index"
										:timestamp="res.create_time ? '执行时间：' + String(res.create_time).replace('T', ' ') : ''"
										:type="res.status === 1 ? 'success' : 'danger'"
									>
										<div class="api-run-monitor-step">
											<div>
												<div class="api-run-monitor-step-title">
													<span v-if="res.name !== '执行结束'">接口：{{ res.name }}</span>
													<span v-else>{{ res.name }}</span>
												</div>
												<div v-if="res.name !== '执行结束'" class="api-run-monitor-step-meta">
													<span>code：{{ res?.res?.code ?? '-' }}</span>
													<span>size：{{ res?.res?.size ?? 0 }}B</span>
													<span>time：{{ res?.res?.res_time ?? 0 }}ms</span>
												</div>
											</div>
											<div v-if="res.name !== '执行结束'">
												<el-button type="primary" link @click="view_result(res)">查看详情</el-button>
											</div>
										</div>
									</el-timeline-item>
								</el-timeline>
							</el-card>
							<el-card shadow="never" class="wa-run-monitor-surface wa-run-monitor-card wa-run-monitor-card--log">
								<template #header>
									<div class="wa-run-monitor-log-toolbar">
										<span class="wa-run-monitor-log-toolbar-title">
											<el-icon class="wa-run-monitor-log-toolbar-icon"><Monitor /></el-icon>
											场景执行日志
										</span>
										<el-button size="small" class="wa-run-monitor-btn-ghost" @click="copyApiRunLog">
											<el-icon class="el-icon--left"><DocumentCopy /></el-icon>
											复制
										</el-button>
									</div>
								</template>
								<ul class="wa-run-monitor-log-list">
									<li v-if="run_type !== '执行结束'" class="wa-run-monitor-log-pending">
										<span class="wa-run-monitor-log-dot" aria-hidden="true" />
										执行日志获取中…
									</li>
									<li
										v-for="(log, idx) in run_result_log"
										:key="idx"
										class="wa-run-monitor-log-line"
										:class="logLineClass(log)"
									>
										<template v-for="(seg, si) in parseLogLineForDisplay(log)" :key="`${idx}-${si}`">
											<span :class="seg.cls">{{ seg.text }}</span>
										</template>
									</li>
								</ul>
							</el-card>
						</div>
					</div>
				</div>
				<div class="wa-run-monitor-footer">
					<el-button class="wa-run-monitor-btn-ghost" @click="resultDialogRef = false">关闭</el-button>
				</div>
			</div>
		</el-drawer>

		<!-- 结果详情抽屉 -->
		<el-drawer v-model="detail_drawer" title="请求详情" size="1100px" destroy-on-close>
			<ApiDetail
				v-if="(detail?.res ?? detail?.response ?? detail?.res_info) && (detail?.req ?? detail?.request ?? detail?.req_info)"
				:api-data="buildDetailApiData(detail)"
				:env_list="env_list"
				:tree_list="tree_list"
				:params_list="params_list"
				:local_db_list="[]"
			/>
		</el-drawer>
	</div>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue';
import { ElMessage, ElMessageBox, ElTree } from 'element-plus';
import { DocumentCopy, Monitor } from '@element-plus/icons-vue';
import { Session } from '/@/utils/storage';
import { logLineClass, parseLogLineForDisplay } from '@/utils/runMonitorLog';
import ApiDetail from './api_detail.vue';
import {
	api_tree_list,
	api_script_list,
	add_api_script,
	edit_api_script,
	del_api_script,
	api_env,
	params_select,
	run_api_script,
	get_api_script_log,
	get_api_script_result,
	api_db_list,
	api_service,
	api_tree,
} from '/@/api/v1/api_automation';

const searchParams = ref({
	search: { name__icontains: '', type__icontains: '' },
	currentPage: 1,
	pageSize: 10,
});
const table_data = ref<any[]>([]);
const total = ref(0);

const get_script_list = async () => {
	const res: any = await api_script_list(searchParams.value as any);
	const raw = res?.data;
	const list = Array.isArray(raw?.content) ? raw.content : (Array.isArray(raw) ? raw : []);
	table_data.value = list;
	total.value = typeof raw?.total === 'number' ? raw.total : list.length;
};

const reset_search = () => {
	searchParams.value = { search: { name__icontains: '', type__icontains: '' }, currentPage: 1, pageSize: 10 };
	get_script_list();
};

const addDialogRef = ref(false);
const editDialogRef = ref(false);
const runDialogRef = ref(false);
const resultDialogRef = ref(false);
const dialogTitle = ref('');

const add_form = ref<any>({
	name: '',
	description: '',
	type: 1,
	config: { params_id: null, env_id: null, api_service_id: null },
	script: [],
});

const env_list = ref<any[]>([]);
const params_list = ref<any[]>([]);
const tree_list = ref<any[]>([]);
const service_list = ref<any[]>([]);

const load_service_list = async () => {
	try {
		const res: any = await api_service({ page: 1, pageSize: 200, search: {} });
		const raw = res?.data;
		service_list.value = Array.isArray(raw?.content) ? raw.content : (Array.isArray(raw) ? raw : []);
	} catch (e) {
		console.error('加载服务列表失败:', e);
		service_list.value = [];
	}
};

const get_env_list = async () => {
	const res: any = await api_env({});
	env_list.value = res.data || [];
};
const get_params = async () => {
	const res: any = await params_select({});
	params_list.value = res.data || [];
};
const get_api_tree_list = async () => {

	const serviceId = add_form.value?.config?.api_service_id;
	if (serviceId) {
		const res: any = await api_tree({ search: { api_service_id: Number(serviceId) } });
		tree_list.value = res.data || [];
	} else {
		const res: any = await api_tree_list({});
		tree_list.value = res.data || [];
	}
};
const get_db_list = async () => {
	await api_db_list({});
};

const Add = async () => {
	add_form.value = { name: '', description: '', type: 1, config: { params_id: null, env_id: null, api_service_id: null }, script: [] };
	await Promise.all([load_service_list(), get_api_tree_list(), get_env_list(), get_params(), get_db_list()]);
	dialogTitle.value = '新增测试场景';
	addDialogRef.value = true;
};

const add_confirm = async () => {
	const res: any = await add_api_script(add_form.value);
	ElMessage.success(res.message || '已创建');
	addDialogRef.value = false;
	await get_script_list();
};

const edit_confirm = async () => {
	const res: any = await edit_api_script(add_form.value);
	ElMessage.success(res.message || '已保存');
	editDialogRef.value = false;
	await get_script_list();
};

const Edit = async (row: any) => {
	await Promise.all([load_service_list(), get_api_tree_list(), get_env_list(), get_params(), get_db_list()]);
	dialogTitle.value = `编辑脚本：${row.name}`;
	add_form.value = { ...row };
	editDialogRef.value = true;
};

const Delete = async (row: any) => {
	await ElMessageBox.confirm(`您确认需要删除：${row.name} 么？`, '提示', { type: 'warning' });
	const res: any = await del_api_script({ id: row.id });
	ElMessage.success(res.message || '已删除');
	await get_script_list();
};

// run
const run_form = ref<any>({ name: '', config: { env_id: null, params_id: null }, run_list: [] });
const result_id = ref<number | null>(null);
const run_type = ref('准备执行');
const run_env = ref('');
const run_result_log = ref<any[]>([]);
const run_result_list = ref<any[]>([]);
const run_count = ref(0);
const run_fail = ref(0);
const start_time = ref('');
const end_time = ref('');


const detail_drawer = ref(false);
const detail = ref<any>({});

const view_result = async (row: any) => {

	detail.value = row;
	detail_drawer.value = true;
};

const buildDetailApiData = (d: any) => {

	const stableId = d?.api_id ?? d?.id ?? d?.uuid ?? d?.menu_id ?? `${d?.result_id ?? ''}-${d?.name ?? ''}`;
	return {
		api_id: stableId,
		api_info: {
			id: stableId,
			name: d?.name,
			req: d?.req ?? d?.request ?? d?.req_info,
			res: d?.res ?? d?.response ?? d?.res_info,
		},
	};
};
const interval = ref<any>(null);

const run_script = async (row: any) => {

	await Promise.all([get_env_list(), get_params()]);
	run_form.value = { name: row.name, config: { env_id: null, params_id: null }, run_list: [row] };
	dialogTitle.value = '请配置调试信息';
	runDialogRef.value = true;
};


const casePickerVisible = ref(false);
const caseTreeRef = ref<InstanceType<typeof ElTree>>();
const caseTreeFilter = ref('');

const open_case_picker = async () => {
	await get_api_tree_list();
	casePickerVisible.value = true;
};

const isLeafApiNode = (node: any) => {
	return node && (node.type === 2 || node.type === 3) && node.api_id != null;
};

const collectCheckedLeafNodes = () => {
	const nodes = caseTreeRef.value?.getCheckedNodes?.(false, true) ?? [];
	return (nodes as any[]).filter(isLeafApiNode);
};

const confirm_add_cases = async () => {
	const picked = collectCheckedLeafNodes();
	if (!picked.length) {
		ElMessage.warning('请先在接口树中勾选需要添加的接口/用例');
		return;
	}
	const existingApiIds = new Set((add_form.value.script || []).map((s: any) => Number(s?.api_id)).filter((x: any) => !Number.isNaN(x)));
	const start = (add_form.value.script || []).length;
	const nextSteps = picked
		.filter((n: any) => !existingApiIds.has(Number(n.api_id)))
		.map((n: any, idx: number) => ({
			name: n.name,
			api_id: Number(n.api_id),
			step: start + idx + 1,
		}));
	add_form.value.script = [...(add_form.value.script || []), ...nextSteps];
	ElMessage.success(`已添加 ${nextSteps.length} 个步骤`);
	casePickerVisible.value = false;
};

const filterCaseNode = (value: string, data: any) => {
	if (!value) return true;
	return String(data?.name || '').includes(value);
};

watch(caseTreeFilter, (v) => {
	caseTreeRef.value?.filter?.(v);
});

const startPolling = async () => {
	if (interval.value) return;
	interval.value = setInterval(async () => {
		await get_result();
	}, 1500);
};
const stopPolling = () => {
	if (interval.value) clearInterval(interval.value);
	interval.value = null;
};

const copyApiRunLog = async () => {
	const lines = run_result_log.value;
	const text = Array.isArray(lines) ? lines.join('\n') : '';
	if (!text.trim()) {
		ElMessage.info('暂无日志可复制');
		return;
	}
	try {
		await navigator.clipboard.writeText(text);
		ElMessage.success('已复制到剪贴板');
	} catch {
		ElMessage.warning('复制失败，请手动选择日志文本');
	}
};

const get_result = async () => {
	await Promise.all([get_script_log(), get_script_result()]);
};

const get_script_log = async () => {
	if (!result_id.value) return;
	const res: any = await get_api_script_log({ result_id: result_id.value });
	run_result_log.value = res.data || [];
};
const get_script_result = async () => {
	if (!result_id.value) return;
	const res: any = await get_api_script_result({ result_id: result_id.value });
	run_result_list.value = res.data || [];


	const list = run_result_list.value || [];
	run_count.value = list.length;
	run_fail.value = 0;
	if (list.length > 0) {
		start_time.value = String(list[list.length - 1]?.create_time ?? '');
	}
	end_time.value = '';
	for (const item of list) {
		if (item?.status === 0) run_fail.value += 1;
		if (item?.name === '执行结束') {
			run_type.value = '执行结束';
			run_count.value = Math.max(0, run_count.value - 1);
			end_time.value = String(item?.create_time ?? '');
			stopPolling();
			break;
		}
	}
};

const run_confirm = async () => {
	run_result_log.value = [];
	run_result_list.value = [];
	run_count.value = 0;
	run_fail.value = 0;
	start_time.value = '';
	end_time.value = '';
	run_type.value = '正在执行';
	if (!run_form.value.config.env_id || !run_form.value.name) {
		ElMessage.error('请选择环境并填写任务名称');
		return;
	}
	env_list.value.forEach((item: any) => {
		if (run_form.value.config.env_id === item.id) run_env.value = item.name;
	});
	result_id.value = Date.now();
	run_form.value.result_id = result_id.value;


	try {
		const userInfo = Session.get('userInfo');
		if (userInfo?.username) run_form.value.username = userInfo.username;
	} catch (_) {}

	runDialogRef.value = false;
	resultDialogRef.value = true;
	await startPolling();
	const res: any = await run_api_script(run_form.value);
	ElMessage.success(res.message || '已触发执行');
};

onMounted(async () => {
	await get_script_list();
});
</script>



<style scoped>
/* 通用样式 */
.box-card {
	margin-bottom: 10px;
}

.mt-10px {
	margin-top: 10px;
}

/* 脚本页面样式 */
.script-topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.script-topbar-left {
	display: flex;
	align-items: center;
	gap: 10px;
}

.script-topbar-right {
	display: flex;
	align-items: center;
	gap: 10px;
}

.script-title {
	font-size: 16px;
	font-weight: bold;
	color: var(--el-text-color-primary);
}

.pagination-wrapper {
	margin-top: 20px;
	display: flex;
	justify-content: center;
}

/* 对话框内容样式 */
.text-sm {
	font-size: 14px;
}

.text-gray-500 {
	color: #6b7280;
}

.mb-10px {
	margin-bottom: 10px;
}

.mb-6px {
	margin-bottom: 6px;
}

.font-bold {
	font-weight: bold;
}

/* 无浏览器 Tab 时，单列铺满抽屉主区域 */
.api-run-monitor-body--solo {
	display: flex;
	flex-direction: column;
	min-height: 0;
}

.api-run-monitor-pane--solo {
	flex: 1;
	min-height: 0;
	overflow: hidden;
}

.api-run-monitor-step {
	display: flex;
	justify-content: space-between;
	gap: 10px;
	align-items: flex-start;
}

.api-run-monitor-step-title {
	font-weight: 600;
	color: var(--wa-tm-text);
}

.api-run-monitor-step-meta {
	margin-top: 6px;
	color: var(--wa-tm-muted);
	font-size: 12px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px 10px;
}
</style>

<style lang="scss">
@import '@/theme/modules/web-run-monitor.scss';
</style>