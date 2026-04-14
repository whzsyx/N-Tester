<template>
	<div class="perf-config-container">
		<el-card shadow="hover">
			<el-tabs v-model="activeTab" class="config-tabs">
				<!-- ========== Tab1：压力机配置 ========== -->
				<el-tab-pane label="压力机配置" name="worker">
					<!-- 工具栏 -->
					<div class="toolbar">
						<div class="toolbar-left">
							<el-input
								v-model="workerQuery.name"
								placeholder="搜索名称"
								clearable
								style="width: 300px"
								@keyup.enter="handleWorkerQuery"
							>
								<template #prefix><el-icon><ele-Search /></el-icon></template>
							</el-input>
							<el-select v-model="workerQuery.status" placeholder="状态" clearable style="width: 160px" @change="handleWorkerQuery">
								<el-option :value="1" label="启用" />
								<el-option :value="0" label="禁用" />
							</el-select>
							<el-button type="primary" @click="handleWorkerQuery">
								<el-icon><ele-Search /></el-icon>搜索
							</el-button>
							<el-button @click="resetWorkerQuery">
								<el-icon><ele-Refresh /></el-icon>重置
							</el-button>
						</div>
						<div class="toolbar-right">
							<el-button type="primary" @click="handleWorkerAdd">
								<el-icon><ele-Plus /></el-icon>新增
							</el-button>
						</div>
					</div>

					<!-- 表格 -->
					<el-table v-loading="workerLoading" :data="workerList" border stripe style="width: 100%">
						<el-table-column prop="name" min-width="120" align="center" show-overflow-tooltip>
							<template #header>
								<span>压力机名称</span>
								<el-tooltip content="压力机host名称或pod的服务名称缩写，如分布式 jmeter-worker-1" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="type" min-width="105" align="center">
							<template #header>
								<span>压力机类型</span>
								<el-tooltip content="单机：单机压测；Master：分布式控制机；Slave：分布式执行机" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
							<template #default="{ row }">
								<el-tag
									:type="row.type === 'master' ? 'warning' : row.type === 'slave' ? 'success' : 'primary'"
									size="small"
								>
									{{ row.type === 'master' ? 'Master' : row.type === 'slave' ? 'Slave' : '单机' }}
								</el-tag>
							</template>
						</el-table-column>
						<el-table-column prop="status" min-width="95" align="center">
							<template #header><span>状态</span></template>
							<template #default="{ row }">
								<el-switch
									v-model="row.status"
									:active-value="1"
									:inactive-value="0"
									active-text="启用"
									inactive-text="禁用"
									inline-prompt
									size="default"
									@change="handleWorkerStatusChange(row)"
								/>
							</template>
						</el-table-column>
						<el-table-column prop="ip" min-width="120" align="center">
							<template #header>
								<span>机器IP</span>
								<el-tooltip content="压力机所在服务器的 IP 地址" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="port" min-width="100" align="center">
							<template #header>
								<span>监听端口</span>
								<el-tooltip content="压力机服务监听端口，如 JMeter 默认 1099" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="monitor_port" min-width="100" align="center">
							<template #header>
								<span>Monitor</span>
								<el-tooltip content="Prometheus 监控端口，用于采集压力机性能指标，默认 9270" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="max_concurrency" min-width="110" align="center">
							<template #header>
								<span>最大并发数</span>
								<el-tooltip content="该节点物理支持的最大并发用户数，超出此值可能导致机器过载" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="created_at" label="创建时间" min-width="160" align="center">
							<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.created_at) }}</span></template>
						</el-table-column>
						<el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
						<el-table-column label="操作" width="210" fixed="right" align="center" class-name="operation-col">
							<template #default="{ row }">
								<div class="action-btns">
									<el-button type="primary" size="small" text @click="handleWorkerEdit(row)">
										<el-icon><ele-Edit /></el-icon>修改
									</el-button>
									<el-button type="success" size="small" text @click="handleWorkerCopy(row)">
										<el-icon><ele-CopyDocument /></el-icon>复制
									</el-button>
									<el-button type="danger" size="small" text @click="handleWorkerDelete(row)">
										<el-icon><ele-Delete /></el-icon>删除
									</el-button>
								</div>
							</template>
						</el-table-column>
					</el-table>

					<!-- 分页 -->
					<el-pagination
						v-show="workerTotal > 0"
						v-model:current-page="workerQuery.page"
						v-model:page-size="workerQuery.page_size"
						:page-sizes="[10, 20, 50]"
						:total="workerTotal"
						layout="total, sizes, prev, pager, next, jumper"
						class="pagination"
						@size-change="handleWorkerQuery"
						@current-change="handleWorkerQuery"
					/>
				</el-tab-pane>

				<!-- ========== Tab2：参数配置 ========== -->
				<el-tab-pane label="参数配置" name="param">
					<!-- 工具栏 -->
					<div class="toolbar">
						<div class="toolbar-left">
							<el-input
								v-model="paramQuery.name"
								placeholder="搜索参数名称/参数名"
								clearable
								style="width: 300px"
								@keyup.enter="handleParamQuery"
							>
								<template #prefix><el-icon><ele-Search /></el-icon></template>
							</el-input>
							<el-select v-model="paramQuery.status" placeholder="状态" clearable style="width: 160px" @change="handleParamQuery">
								<el-option :value="1" label="启用" />
								<el-option :value="0" label="禁用" />
							</el-select>
							<el-button type="primary" @click="handleParamQuery">
								<el-icon><ele-Search /></el-icon>搜索
							</el-button>
							<el-button @click="resetParamQuery">
								<el-icon><ele-Refresh /></el-icon>重置
							</el-button>
						</div>
						<div class="toolbar-right">
							<el-button type="primary" @click="handleParamAdd">
								<el-icon><ele-Plus /></el-icon>新增
							</el-button>
						</div>
					</div>

					<!-- 表格 -->
					<el-table v-loading="paramLoading" :data="paramList" border stripe style="width: 100%">
						<el-table-column type="index" label="编号" width="60" align="center" />
						<el-table-column prop="label" min-width="120" show-overflow-tooltip>
							<template #header>
								<span>参数名称</span>
								<el-tooltip content="参数的中文说明，如「远程 Worker 上的目标目录」" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="key" min-width="120" show-overflow-tooltip>
							<template #header>
								<span>参数名</span>
								<el-tooltip content="参数的英文标识，通常为全大写，如 REMOTE_PATH" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
							<template #default="{ row }">
								<span class="key-badge">{{ row.key }}</span>
							</template>
						</el-table-column>
						<el-table-column prop="value" min-width="120" show-overflow-tooltip>
							<template #header>
								<span>参数值</span>
								<el-tooltip content="参数的实际值，如 /data/jmeter/" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column prop="status" label="状态" width="120" align="center">
							<template #default="{ row }">
								<el-switch
									v-model="row.status"
									:active-value="1"
									:inactive-value="0"
									active-text="启用"
									inactive-text="禁用"
									inline-prompt
									size="default"
									@change="handleParamStatusChange(row)"
								/>
							</template>
						</el-table-column>
						<el-table-column prop="created_at" label="创建时间" min-width="160" align="center">
							<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.created_at) }}</span></template>
						</el-table-column>
						<el-table-column prop="remark" label="备注" min-width="130" show-overflow-tooltip />
						<el-table-column label="操作" width="200" fixed="right" align="center" class-name="operation-col">
							<template #default="{ row }">
								<div class="action-btns">
									<el-button type="primary" size="small" text @click="handleParamEdit(row)">
										<el-icon><ele-Edit /></el-icon>修改
									</el-button>
									<el-button type="danger" size="small" text @click="handleParamDelete(row)">
										<el-icon><ele-Delete /></el-icon>删除
									</el-button>
								</div>
							</template>
						</el-table-column>
					</el-table>

					<!-- 分页 -->
					<el-pagination
						v-show="paramTotal > 0"
						v-model:current-page="paramQuery.page"
						v-model:page-size="paramQuery.page_size"
						:page-sizes="[10, 20, 50]"
						:total="paramTotal"
						layout="total, sizes, prev, pager, next, jumper"
						class="pagination"
						@size-change="handleParamQuery"
						@current-change="handleParamQuery"
					/>
				</el-tab-pane>
			</el-tabs>
		</el-card>

		<!-- ========== 压力机 新增/编辑 对话框 ========== -->
		<el-dialog
			v-model="workerDialogVisible"
			:title="workerDialogTitle"
			width="620px"
			top="6vh"
			:close-on-click-modal="false"
			@close="resetWorkerForm"
		>
			<el-form ref="workerFormRef" :model="workerForm" :rules="workerRules" size="default" label-width="115px" hide-required-asterisk class="worker-form">
				<el-form-item prop="name">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>压力机名称</span>
						<el-tooltip content="压力机host名称或pod的服务名称缩写，如分布式 jmeter-worker-1" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input v-model="workerForm.name" placeholder="压力机名称，如分布式：jmeter-worker-1" maxlength="100" show-word-limit />
				</el-form-item>
				<el-form-item prop="type">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>压力机类型</span>
						<el-tooltip content="单机：单节点独立压测；Master：分布式主控节点，负责调度；Slave：分布式执行节点，接受 Master 调度" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-radio-group v-model="workerForm.type" @change="workerFormRef?.validateField('name')">
						<el-radio value="standalone">单机</el-radio>
						<el-radio value="master">Master</el-radio>
						<el-radio value="slave">Slave</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item prop="status">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>状态</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-radio-group v-model="workerForm.status">
						<el-radio :value="1">启用</el-radio>
						<el-radio :value="0">禁用</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item prop="ip">
					<template #label>
						<span class="label-txt">机器IP</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-input v-model="workerForm.ip" placeholder="机器IP地址，如 192.168.1.100" />
				</el-form-item>
				<el-form-item prop="port">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>监听端口</span>
						<el-tooltip content="压力机服务RMI监听端口，JMeter 默认 1099" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input-number v-model="workerForm.port" :min="1" :max="65535" placeholder="输入压力机的RMI监听端口，1~65535" style="width: 100%" controls-position="right" />
				</el-form-item>
				<el-form-item prop="monitor_port">
					<template #label>
						<span class="label-txt">Monitor</span>
						<el-tooltip content="Prometheus 监控端口，默认 9270" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input-number v-model="workerForm.monitor_port" :min="1" :max="65535" placeholder="输入Prometheus的监控端口，1~65535" style="width: 100%" controls-position="right" />
				</el-form-item>
				<el-form-item prop="max_concurrency">
					<template #label>
						<span class="label-txt">最大并发数</span>
						<el-tooltip content="该节点物理支持的最大并发用户数" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input-number v-model="workerForm.max_concurrency" :min="1" placeholder="正整数，如 500" style="width: 100%" controls-position="right" />
				</el-form-item>
				<el-form-item prop="remark">
					<template #label>
						<span class="label-txt">备注</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-input v-model="workerForm.remark" type="textarea" :rows="4" placeholder="选填，描述该压力机用途或所属环境" maxlength="500" show-word-limit />
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button size="default" @click="workerDialogVisible = false">取 消</el-button>
				<el-button size="default" type="primary" :loading="workerSubmitLoading" @click="handleWorkerSubmit">确 定</el-button>
			</template>
		</el-dialog>

		<!-- ========== 参数 新增/编辑 对话框 ========== -->
		<el-dialog
			v-model="paramDialogVisible"
			:title="paramDialogTitle"
			width="520px"
			:close-on-click-modal="false"
			@close="resetParamForm"
		>
			<el-form ref="paramFormRef" :model="paramForm" :rules="paramRules" size="default" label-width="105px" hide-required-asterisk class="param-form">
				<el-form-item prop="label">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>参数名称</span>
						<el-tooltip content="参数的中文说明，如「远程 Worker 上的目标目录」" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input v-model="paramForm.label" placeholder="如远程 Worker 上的目标目录" maxlength="100" show-word-limit />
				</el-form-item>
				<el-form-item prop="key">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>参数名</span>
						<el-tooltip content="参数英文标识，通常全大写，如 REMOTE_PATH" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-input v-model="paramForm.key" placeholder="如REMOTE_PATH" maxlength="100" show-word-limit />
				</el-form-item>
				<el-form-item prop="value">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>参数值</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-input v-model="paramForm.value" placeholder="如/data/jmeter/" maxlength="500" show-word-limit />
				</el-form-item>
				<el-form-item prop="status">
					<template #label>
						<span class="label-txt">状态</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-radio-group v-model="paramForm.status">
						<el-radio :value="1">启用</el-radio>
						<el-radio :value="0">禁用</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item prop="remark">
					<template #label>
						<span class="label-txt">备注</span>
						<span class="label-tip-placeholder" />
					</template>
					<el-input v-model="paramForm.remark" type="textarea" :rows="4" placeholder="请输入备注信息" maxlength="500" show-word-limit />
				</el-form-item>
			</el-form>
			<template #footer>
				<el-button size="default" @click="paramDialogVisible = false">取 消</el-button>
				<el-button size="default" type="primary" :loading="paramSubmitLoading" @click="handleParamSubmit">确 定</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<script setup lang="ts" name="PerformanceConfig">
import { ref, reactive, computed, onMounted } from 'vue';
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus';

// ======================== 公共 ========================
const activeTab = ref('worker');

const formatDateTime = (val: string) => {
	if (!val) return '-';
	return val.replace('T', ' ').substring(0, 19);
};

// ======================== 压力机配置 ========================
const workerLoading = ref(false);
const workerList = ref<any[]>([]);
const workerTotal = ref(0);

const workerQuery = reactive({
	name: '',
	status: undefined as number | undefined,
	page: 1,
	page_size: 10,
});

// 模拟数据（后端接口接入后替换）
const mockWorkerData = [
	{ id: 1, name: 'jmeter-worker-1', type: 'standalone', status: 1, ip: '192.168.1.101', port: 1099, monitor_port: 9270, max_concurrency: 500, remark: '测试环境单机压力机', created_at: '2026-04-08T10:00:00' },
	{ id: 2, name: 'jmeter-master-1', type: 'master', status: 1, ip: '192.168.1.102', port: 1099, monitor_port: 9270, max_concurrency: 1000, remark: '分布式主控节点', created_at: '2026-04-08T10:00:00' },
	{ id: 3, name: 'jmeter-slave-1', type: 'slave', status: 1, ip: '192.168.1.103', port: 1099, monitor_port: 9270, max_concurrency: 1000, remark: '分布式从节点1', created_at: '2026-04-08T10:00:00' },
	{ id: 4, name: 'jmeter-slave-2', type: 'slave', status: 0, ip: '192.168.1.104', port: 1099, monitor_port: 9270, max_concurrency: 1000, remark: '备用从节点', created_at: '2026-04-08T10:00:00' },
];

const handleWorkerQuery = () => {
	workerLoading.value = true;
	setTimeout(() => {
		let data = [...mockWorkerData];
		if (workerQuery.name) data = data.filter((r) => r.name.includes(workerQuery.name));
		if (workerQuery.status !== undefined) data = data.filter((r) => r.status === workerQuery.status);
		workerList.value = data;
		workerTotal.value = data.length;
		workerLoading.value = false;
	}, 200);
};

const resetWorkerQuery = () => {
	workerQuery.name = '';
	workerQuery.status = undefined;
	workerQuery.page = 1;
	handleWorkerQuery();
};

const handleWorkerStatusChange = (row: any) => {
	ElMessage.success(`已${row.status === 1 ? '启用' : '禁用'}：${row.name}`);
};

// 压力机表单
const workerDialogVisible = ref(false);
const workerSubmitLoading = ref(false);
const workerFormRef = ref<FormInstance>();
const currentWorkerId = ref<number | null>(null);
const workerDialogTitle = computed(() => (currentWorkerId.value ? '修改压力机配置' : '新增压力机配置'));

const workerForm = reactive({
	name: '',
	type: 'standalone',
	status: 1,
	ip: '',
	port: undefined as number | undefined,
	monitor_port: undefined as number | undefined,
	max_concurrency: undefined as number | undefined,
	remark: '',
});

const workerRules = {
	name: [
		{ required: true, message: '请输入压力机名称', trigger: 'blur' },
		{
			validator: (_rule: any, value: string, callback: (e?: Error) => void) => {
				const duplicate = mockWorkerData.find(
					(r) => r.name === value && r.type === workerForm.type && r.id !== currentWorkerId.value
				);
				if (duplicate) {
					const typeLabel = workerForm.type === 'master' ? 'Master' : workerForm.type === 'slave' ? 'Slave' : '单机';
					callback(new Error(`${typeLabel} 类型下已存在名称「${value}」，请更换名称`));
				} else {
					callback();
				}
			},
			trigger: 'blur',
		},
	],
	type: [{ required: true, message: '请选择类型', trigger: 'change' }],
	status: [{ required: true, message: '请选择状态', trigger: 'change' }],
	port: [{ required: true, message: '请输入监听端口', trigger: 'blur' }],
	ip: [{ pattern: /^(\d{1,3}\.){3}\d{1,3}$/, message: 'IP 格式不正确', trigger: 'blur' }],
};

const handleWorkerAdd = () => {
	currentWorkerId.value = null;
	workerDialogVisible.value = true;
};

const handleWorkerEdit = (row: any) => {
	currentWorkerId.value = row.id;
	Object.assign(workerForm, { ...row });
	workerDialogVisible.value = true;
};

const handleWorkerCopy = (row: any) => {
	currentWorkerId.value = null;
	Object.assign(workerForm, { ...row, name: `${row.name}-copy`, id: undefined });
	workerDialogVisible.value = true;
	ElMessage.info('已复制配置，请修改名称后保存');
};

const handleWorkerDelete = (row: any) => {
	ElMessageBox.confirm(`确定要删除压力机「${row.name}」吗？`, '提示', {
		confirmButtonText: '确定',
		cancelButtonText: '取消',
		type: 'warning',
	}).then(() => {
		const idx = mockWorkerData.findIndex((r) => r.id === row.id);
		if (idx > -1) mockWorkerData.splice(idx, 1);
		handleWorkerQuery();
		ElMessage.success('删除成功');
	}).catch(() => {});
};

const handleWorkerSubmit = async () => {
	if (!workerFormRef.value) return;
	await workerFormRef.value.validate((valid) => {
		if (!valid) return;
		workerSubmitLoading.value = true;
		setTimeout(() => {
			if (currentWorkerId.value) {
				const item = mockWorkerData.find((r) => r.id === currentWorkerId.value);
				if (item) Object.assign(item, workerForm);
				ElMessage.success('修改成功');
			} else {
				mockWorkerData.push({
					...workerForm,
					port: workerForm.port!,
					monitor_port: workerForm.monitor_port!,
					max_concurrency: workerForm.max_concurrency!,
					id: Date.now(),
					created_at: new Date().toISOString(),
				});
				ElMessage.success('新增成功');
			}
			workerSubmitLoading.value = false;
			workerDialogVisible.value = false;
			handleWorkerQuery();
		}, 300);
	});
};

const resetWorkerForm = () => {
	workerFormRef.value?.resetFields();
	Object.assign(workerForm, { name: '', type: 'standalone', status: 1, ip: '', port: undefined, monitor_port: undefined, max_concurrency: undefined, remark: '' });
	currentWorkerId.value = null;
};

// ================================ 参数配置Tab ====================================
const paramLoading = ref(false);
const paramList = ref<any[]>([]);
const paramTotal = ref(0);

const paramQuery = reactive({
	name: '',
	status: undefined as number | undefined,
	page: 1,
	page_size: 10,
});

const mockParamData = [
	{ id: 1, label: '远程 Worker 上的目标目录', key: 'REMOTE_PATH', value: '/data/jmeter/', status: 1, remark: 'JMeter 分布式场景文件传输目录', created_at: '2026-04-08T10:00:00' },
	{ id: 2, label: 'JMeter 主控节点 IP', key: 'CONTROLLER_HOST', value: '192.168.1.100', status: 1, remark: 'JMeter Master 节点地址', created_at: '2026-04-08T10:00:00' },
	{ id: 3, label: '报告输出路径', key: 'REPORT_OUTPUT_DIR', value: '/data/reports/', status: 1, remark: '测试报告存储目录', created_at: '2026-04-08T10:00:00' },
	{ id: 4, label: '线程组超时时间(ms)', key: 'THREAD_TIMEOUT', value: '30000', status: 0, remark: '已废弃', created_at: '2026-04-08T10:00:00' },
];

const handleParamQuery = () => {
	paramLoading.value = true;
	setTimeout(() => {
		let data = [...mockParamData];
		if (paramQuery.name) data = data.filter((r) => r.label.includes(paramQuery.name) || r.key.includes(paramQuery.name));
		if (paramQuery.status !== undefined) data = data.filter((r) => r.status === paramQuery.status);
		paramList.value = data;
		paramTotal.value = data.length;
		paramLoading.value = false;
	}, 200);
};

const resetParamQuery = () => {
	paramQuery.name = '';
	paramQuery.status = undefined;
	paramQuery.page = 1;
	handleParamQuery();
};

const handleParamStatusChange = (row: any) => {
	ElMessage.success(`已${row.status === 1 ? '启用' : '禁用'}：${row.key}`);
};

// 参数表单
const paramDialogVisible = ref(false);
const paramSubmitLoading = ref(false);
const paramFormRef = ref<FormInstance>();
const currentParamId = ref<number | null>(null);
const paramDialogTitle = computed(() => (currentParamId.value ? '编辑参数' : '新增参数'));

const paramForm = reactive({
	label: '',
	key: '',
	value: '',
	status: 1,
	remark: '',
});

const paramRules = {
	label: [{ required: true, message: '请输入参数名称', trigger: 'blur' }],
	key: [
		{ required: true, message: '请输入参数名', trigger: 'blur' },
		{ pattern: /^[A-Z0-9_]+$/, message: '参数名只能包含大写字母、数字和下划线', trigger: 'blur' },
		{
			validator: (_rule: any, value: string, callback: (e?: Error) => void) => {
				const duplicate = mockParamData.find(
					(r) => r.key === value && r.id !== currentParamId.value
				);
				if (duplicate) {
					callback(new Error(`参数名「${value}」已存在，请更换`));
				} else {
					callback();
				}
			},
			trigger: 'blur',
		},
	],
	value: [{ required: true, message: '请输入参数值', trigger: 'blur' }],
};

const handleParamAdd = () => {
	currentParamId.value = null;
	paramDialogVisible.value = true;
};

const handleParamEdit = (row: any) => {
	currentParamId.value = row.id;
	Object.assign(paramForm, { ...row });
	paramDialogVisible.value = true;
};

const handleParamDelete = (row: any) => {
	ElMessageBox.confirm(`确定要删除参数「${row.key}」吗？`, '提示', {
		confirmButtonText: '确定',
		cancelButtonText: '取消',
		type: 'warning',
	}).then(() => {
		const idx = mockParamData.findIndex((r) => r.id === row.id);
		if (idx > -1) mockParamData.splice(idx, 1);
		handleParamQuery();
		ElMessage.success('删除成功');
	}).catch(() => {});
};

const handleParamSubmit = async () => {
	if (!paramFormRef.value) return;
	await paramFormRef.value.validate((valid) => {
		if (!valid) return;
		paramSubmitLoading.value = true;
		setTimeout(() => {
			if (currentParamId.value) {
				const item = mockParamData.find((r) => r.id === currentParamId.value);
				if (item) Object.assign(item, paramForm);
				ElMessage.success('修改成功');
			} else {
				mockParamData.push({ ...paramForm, id: Date.now(), created_at: new Date().toISOString() });
				ElMessage.success('新增成功');
			}
			paramSubmitLoading.value = false;
			paramDialogVisible.value = false;
			handleParamQuery();
		}, 300);
	});
};

const resetParamForm = () => {
	paramFormRef.value?.resetFields();
	Object.assign(paramForm, { label: '', key: '', value: '', status: 1, remark: '' });
	currentParamId.value = null;
};

// ======================== 初始化 ========================
onMounted(() => {
	handleWorkerQuery();
	handleParamQuery();
});
</script>

<style scoped lang="scss">
.perf-config-container {
	padding: 10px 10px 20px 10px;

	:deep(.el-card__body) {
		padding: 10px 10px 20px 10px;
	}

	// ---- 全局控件字体统一 ----
	:deep(.el-button > span) {
		display: inline-flex !important;
		align-items: center !important;
		line-height: 1 !important;
	}

	:deep(.el-input__inner),
	:deep(.el-textarea__inner) {
		font-size: 13.5px;
	}

	// 输入框与下拉框均使用 el-config-provider 全局 size 控制高度，不单独覆盖
	:deep(.el-input-number) {
		.el-input__inner {
			font-size: 13.5px;
		}
	}

	:deep(.el-select__placeholder),
	:deep(.el-select__selected-item) {
		font-size: 13.5px;
	}

	// ---- Tab 标题 ----
	:deep(.el-tabs__item) {
		font-size: 13.5px;
	}

	:deep(.el-tag) {
		font-size: 13px;
		padding: 0 8px;
	}

	.key-badge {
		display: inline-block;
		padding: 1px 8px;
		background: #ecf5ff;
		color: #409eff;
		border: 1px solid #b3d8ff;
		border-radius: 4px;
		font-size: 12px;
		font-weight: 600;
	}

	// ---- 表格 ----
	:deep(.el-table) {
		font-size: 13.5px;

		.el-table__header th {
			font-size: 13.5px;
			background-color: #eef3fb;
		}

		// 带 ? 图标的表头：禁止折行，文字与图标水平对齐
		.el-table__header th .cell {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			white-space: nowrap;
		}

		.el-table__cell {
			padding: 7px 0;
		}

		td.operation-col {
			background-color: #f0f2f5 !important;
		}
	}

	.config-tabs {
		:deep(.el-tabs__header) {
			margin-top: -8px;
			margin-bottom: 16px;
		}
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

	.tip-icon {
		margin-left: 4px;
		color: #909399;
		cursor: help;
		vertical-align: -2px;
		font-size: 13.5px;

		&:hover {
			color: var(--el-color-primary);
		}
	}

	.worker-form {
		:deep(.el-form-item__label) {
			display: flex !important;
			align-items: center;
			padding-right: 8px !important;
			font-size: 13.5px;

			.label-txt {
				flex: 1;
				text-align: right;

				.label-star {
					color: var(--el-color-danger);
					margin-right: 2px;
				}
			}

			.label-tip-icon,
			.label-tip-placeholder {
				flex-shrink: 0;
				width: 16px;
				margin-left: 4px;
			}

			.el-tooltip__trigger {
				display: inline-flex !important;
				align-items: center;
			}

			.label-tip-icon {
				color: #909399;
				cursor: help;
				font-size: 13.5px;

				&:hover {
					color: var(--el-color-primary);
				}
			}
		}

		:deep(.el-form-item) {
			margin-bottom: 20px;
		}

		:deep(.el-radio__label) {
			font-size: 13.5px;
		}

		:deep(.el-input__placeholder),
		:deep(.el-textarea__placeholder),
		:deep(.el-input-number .el-input__inner::placeholder) {
			font-size: 12px;
		}

		:deep(.el-input__inner::placeholder),
		:deep(.el-textarea__inner::placeholder) {
			font-size: 12px;
		}

		:deep(.el-input-number) {
			.el-input__inner {
				text-align: left;
			}
		}
	}

	.param-form {
		:deep(.el-form-item__label) {
			display: flex !important;
			align-items: center;
			padding-right: 8px !important;
			font-size: 13.5px;

			.label-txt {
				flex: 1;
				text-align: right;

				.label-star {
					color: var(--el-color-danger);
					margin-right: 2px;
				}
			}

			.label-tip-icon,
			.label-tip-placeholder {
				flex-shrink: 0;
				width: 16px;
				margin-left: 4px;
			}

			.el-tooltip__trigger {
				display: inline-flex !important;
				align-items: center;
			}

			.label-tip-icon {
				color: #909399;
				cursor: help;
				font-size: 13.5px;

				&:hover {
					color: var(--el-color-primary);
				}
			}
		}

		:deep(.el-form-item) {
			margin-bottom: 20px;
		}

		:deep(.el-radio__label) {
			font-size: 13.5px;
		}

		:deep(.el-input__inner::placeholder),
		:deep(.el-textarea__inner::placeholder) {
			font-size: 12px;
		}
	}

	:deep(.el-switch) {
		--el-switch-width: 52px;
	}

	.action-btns {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-wrap: nowrap;

		:deep(.el-button) {
			padding: 0 4px;
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
}
</style>

<style lang="scss">
/* 按钮内 slot wrapper span 设为 flex，使图标与文字垂直居中 */
.perf-config-container .el-button > span {
	display: inline-flex !important;
	align-items: center !important;
	line-height: 1 !important;
}
</style>
