<template>
	<div class="perf-files-container">
		<el-card shadow="hover">
			<!-- 工具栏 -->
			<div class="toolbar">
				<div class="toolbar-left">
					<el-input
						v-model="query.name"
						placeholder="搜索文件名称"
						clearable
						style="width: 300px"
						@keyup.enter="handleQuery"
					>
						<template #prefix><el-icon><ele-Search /></el-icon></template>
					</el-input>
					<el-select v-model="query.env" placeholder="所属环境" clearable style="width: 160px" @change="handleQuery">
						<el-option v-for="e in ENV_OPTIONS" :key="e.value" :label="e.label" :value="e.value" />
					</el-select>
					<el-select v-model="query.file_type" placeholder="文件类型" clearable style="width: 160px" @change="handleQuery">
						<el-option v-for="t in FILE_TYPE_OPTIONS" :key="t.value" :label="t.label" :value="t.value" />
					</el-select>
					<el-select v-model="query.status" placeholder="文件状态" clearable style="width: 160px" @change="handleQuery">
						<el-option v-for="s in STATUS_OPTIONS" :key="s.value" :label="s.label" :value="s.value" />
					</el-select>
					<el-button type="primary" @click="handleQuery">
						<el-icon><ele-Search /></el-icon>搜索
					</el-button>
					<el-button @click="resetQuery">
						<el-icon><ele-Refresh /></el-icon>重置
					</el-button>
				</div>
				<div class="toolbar-right">
					<el-upload
						v-if="!selectingDownload"
						:show-file-list="false"
						:before-upload="handleBeforeUpload"
						:http-request="handleUpload"
						accept=".csv,.txt,.xlsx,.xls,.json,.yaml,.yml,.jmx"
					>
						<el-button type="primary">
							<el-icon><ele-Upload /></el-icon>上传文件
						</el-button>
					</el-upload>
					<el-button v-if="!selectingDownload" type="success" @click="enterDownloadMode">
						<el-icon><ele-Download /></el-icon>下载文件
					</el-button>
					<template v-else>
						<el-button type="success" @click="startDownload">
							<el-icon><ele-Download /></el-icon>开始下载
						</el-button>
						<el-button @click="cancelDownload">取 消</el-button>
					</template>
					<el-button v-if="!selectingDownload" :loading="statusRefreshing" @click="handleRefreshStatus">
						<el-icon><ele-Refresh /></el-icon>刷新状态
					</el-button>
				</div>
			</div>

			<!-- 表格 -->
			<el-table v-loading="loading" :data="fileList" border stripe style="width: 100%">
				<el-table-column width="60" align="center">
					<template #header>
						<span>{{ (selectingRefForId || selectingDownload) ? '选择' : '编号' }}</span>
					</template>
					<template #default="{ row, $index }">
						<span v-if="!selectingRefForId && !selectingDownload">{{ (query.page - 1) * query.page_size + $index + 1 }}</span>
						<el-checkbox
							v-else-if="selectingRefForId"
							:model-value="selectedRefIds.has(row.id)"
							:disabled="row.file_type === 'jmx'"
							@change="(val: boolean) => toggleRef(row.id, val)"
						/>
						<el-checkbox
							v-else
							:model-value="selectedDownloadIds.has(row.id)"
							@change="(val: boolean) => toggleDownload(row.id, val)"
						/>
					</template>
				</el-table-column>
				<el-table-column prop="name" min-width="200" align="center">
					<template #header><span>文件名称</span></template>
					<template #default="{ row }">
						<span class="file-type-badge" :style="{ background: fileIconBg(row.file_type) }">
							{{ fileTypeLabel(row.file_type) }}
						</span>
						<el-tooltip :content="row.name" placement="top" :show-after="300">
							<span class="file-name-text">{{ row.name }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="env" label="所属环境" min-width="100" align="center">
					<template #default="{ row }">
						<el-tag :type="envTagType(row.env)" size="small">{{ envLabel(row.env) }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="status" min-width="90" align="center">
					<template #header>
						<span>文件状态</span>
						<el-tooltip content="未引用：未被 JMX 脚本使用；已引用：被脚本引用；使用中：引用中且正在压测" placement="top">
							<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<template #default="{ row }">
						<el-tag :type="statusTagType(row.status)" size="small" :effect="row.status === 'running' ? 'dark' : 'light'">
							{{ statusLabel(row.status) }}
						</el-tag>
					</template>
				</el-table-column>
				<el-table-column min-width="90" align="center">
					<template #header>
						<span>分发状态</span>
						<el-tooltip placement="top">
							<template #content>
								<div style="max-width:220px;line-height:1.6">
									<b>共享分发：</b>文件完整复制，各节点独立持有相同副本<br>
									<b>分割分发：</b>文件按节点数等比分片，各节点仅持有对应分片
								</div>
							</template>
							<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<template #default="{ row }">
						<span v-if="row.file_type === 'jmx'" class="text-placeholder">--</span>
						<el-tag v-else-if="row.distribute_type === 'shared'" type="success" size="small" effect="light">已共享</el-tag>
						<el-tag v-else-if="row.distribute_type === 'split'" type="warning" size="small" effect="light">已分割</el-tag>
						<el-tag v-else type="info" size="small" effect="light">未分发</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="size" label="文件大小" min-width="80" align="center">
					<template #default="{ row }">{{ formatSize(row.size) }}</template>
				</el-table-column>
				<el-table-column min-width="140" show-overflow-tooltip align="center">
					<template #header>
						<span>引用文件</span>
						<el-tooltip content="JMX 脚本所引用的数据文件列表" placement="top">
							<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<template #default="{ row }">
						<template v-if="row.jmx_refs && row.jmx_refs.length">
							<el-tooltip :content="row.jmx_refs.join('、')" placement="top" :show-after="300">
								<span class="jmx-ref-text">{{ row.jmx_refs.join('、') }}</span>
							</el-tooltip>
						</template>
						<span v-else class="text-placeholder">--</span>
					</template>
				</el-table-column>
				<el-table-column prop="created_at" label="上传时间" min-width="160" align="center">
					<template #default="{ row }">
						<span style="white-space: nowrap">{{ formatDateTime(row.created_at) }}</span>
					</template>
				</el-table-column>
				<el-table-column label="分发时间" min-width="160" align="center">
					<template #default="{ row }">
						<span style="white-space: nowrap">{{ row.distributed_at ? formatDateTime(row.distributed_at) : '--' }}</span>
					</template>
				</el-table-column>
				<el-table-column prop="operator" label="操作人" min-width="80" align="center" show-overflow-tooltip />
				<el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip />
				<el-table-column label="操作" width="230" fixed="right" align="center" class-name="operation-col">
					<template #default="{ row }">
						<div class="action-btns">
							<!-- 更新区域 -->
							<div class="update-slot">
								<!-- JMX · 引用选择确认模式 -->
								<template v-if="row.file_type === 'jmx' && selectingRefForId === row.id">
									<el-button type="primary" size="small" :disabled="selectedRefIds.size === 0" @click="confirmRefs(row)">
										确 定
									</el-button>
									<el-button size="small" text @click="cancelRefs">
										取 消
									</el-button>
								</template>

								<!-- JMX · 正常模式 -->
								<template v-else-if="row.file_type === 'jmx'">
									<el-dropdown trigger="hover" popper-class="perf-files-dropdown" @command="(cmd: string) => handleJmxDropdown(cmd, row)">
										<el-button type="warning" size="small" text>
											<el-icon><ele-Upload /></el-icon>更新<el-icon style="margin-left:2px;font-size:11px"><ele-ArrowDown /></el-icon>
										</el-button>
										<template #dropdown>
											<el-dropdown-menu>
												<el-dropdown-item command="file">更新文件</el-dropdown-item>
												<el-dropdown-item command="refs">更新引用</el-dropdown-item>
											</el-dropdown-menu>
										</template>
									</el-dropdown>
								</template>

								<!-- 非 JMX · 正常更新 -->
								<template v-else>
									<el-upload
										:show-file-list="false"
										:before-upload="handleBeforeUpload"
										:http-request="(opt: any) => handleUpdate(opt, row)"
										:accept="'.' + row.file_type"
										style="display:inline-flex"
									>
										<el-button type="warning" size="small" text>
											<el-icon><ele-Upload /></el-icon>更新
										</el-button>
									</el-upload>
								</template>
							</div>

							<!-- 分发（仅非 JMX，且非引用选择模式） -->
							<el-dropdown
								v-if="row.file_type !== 'jmx' && selectingRefForId !== row.id"
								trigger="hover"
								popper-class="perf-files-dropdown"
								@command="(cmd: string) => handleDistribute(cmd, row)"
							>
								<el-button type="primary" size="small" text>
									<el-icon><ele-Share /></el-icon>分发<el-icon style="margin-left:2px;font-size:11px"><ele-ArrowDown /></el-icon>
								</el-button>
								<template #dropdown>
									<el-dropdown-menu>
										<el-dropdown-item command="shared">共享分发</el-dropdown-item>
										<el-dropdown-item command="split">分割分发</el-dropdown-item>
									</el-dropdown-menu>
								</template>
							</el-dropdown>

							<!-- 删除 -->
							<el-button v-if="selectingRefForId !== row.id" type="danger" size="small" text @click="handleDelete(row)">
								<el-icon><ele-Delete /></el-icon>删除
							</el-button>
						</div>
					</template>
				</el-table-column>
			</el-table>

			<!-- 分页 -->
			<el-pagination
				v-show="total > 0"
				v-model:current-page="query.page"
				v-model:page-size="query.page_size"
			:page-sizes="[20, 50, 100]"
				:total="total"
				layout="total, sizes, prev, pager, next, jumper"
				class="pagination"
				@size-change="handleQuery"
				@current-change="handleQuery"
			/>
		</el-card>
		<!-- 隐藏的 JMX 文件更新 input -->
		<input ref="jmxFileInputRef" type="file" accept=".jmx" style="display:none" @change="onJmxFileInputChange" />
	</div>
</template>

<script setup lang="ts" name="PerformanceFiles">
import { ref, reactive, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';

const route = useRoute();

// ======================== 常量 ========================
const ENV_OPTIONS = [
	{ value: 'test', label: '测试环境' },
	{ value: 'perf', label: '性能环境' },
	{ value: 'staging', label: '预发环境' },
	{ value: 'prod', label: '生产环境' },
];

const FILE_TYPE_OPTIONS = [
	{ value: 'csv', label: 'CSV' },
	{ value: 'txt', label: 'TXT' },
	{ value: 'xlsx', label: 'Excel' },
	{ value: 'xls', label: 'XLS' },
	{ value: 'json', label: 'JSON' },
	{ value: 'yaml', label: 'YAML' },
	{ value: 'jmx', label: 'JMX' },
];

const STATUS_OPTIONS = [
	{ value: 'unused', label: '未引用' },
	{ value: 'referenced', label: '已引用' },
	{ value: 'running', label: '使用中' },
];

// ======================== 工具函数 ========================
const formatDateTime = (val: string) => {
	if (!val) return '-';
	return val.replace('T', ' ').substring(0, 19);
};

const formatSize = (bytes: number) => {
	if (bytes >= 1024 ** 3) return (bytes / 1024 ** 3).toFixed(1) + ' G';
	if (bytes >= 1024 ** 2) return (bytes / 1024 ** 2).toFixed(1) + ' M';
	return (bytes / 1024).toFixed(1) + ' KB';
};

const envLabel = (env: string) => ENV_OPTIONS.find((e) => e.value === env)?.label ?? env;
const envTagType = (env: string): '' | 'success' | 'warning' | 'danger' | 'info' => {
	const map: Record<string, '' | 'success' | 'warning' | 'danger' | 'info'> = {
		test: 'info', perf: '', staging: 'warning', prod: 'danger',
	};
	return map[env] ?? 'info';
};

const statusLabel = (s: string) => STATUS_OPTIONS.find((o) => o.value === s)?.label ?? s;
const statusTagType = (s: string): '' | 'success' | 'warning' | 'danger' | 'info' => {
	const map: Record<string, '' | 'success' | 'warning' | 'danger' | 'info'> = {
		unused: 'info', referenced: 'success', running: 'warning',
	};
	return map[s] ?? 'info';
};

const fileIconBg = (type: string) => {
	const map: Record<string, string> = {
		csv: '#67c23a', txt: '#909399', xlsx: '#1d6f42', xls: '#1d6f42',
		json: '#e6a23c', yaml: '#409eff', yml: '#409eff', jmx: '#f56c6c',
	};
	return map[type] ?? '#909399';
};

const fileTypeLabel = (type: string) => {
	const map: Record<string, string> = {
		csv: 'CSV', txt: 'TXT', xlsx: 'XLS', xls: 'XLS',
		json: 'JSON', yaml: 'YAML', yml: 'YAML', jmx: 'JMX',
	};
	return map[type] ?? type.toUpperCase().substring(0, 4);
};

// ======================== 列表 ========================
const loading = ref(false);
const fileList = ref<any[]>([]);
const total = ref(0);

const query = reactive({
	name: '',
	env: undefined as string | undefined,
	file_type: undefined as string | undefined,
	status: undefined as string | undefined,
	page: 1,
	page_size: 20,
});

const mockData: any[] = [
	{ id: 1, name: 'user_data_10w.csv', env: 'perf', file_type: 'csv', status: 'running', size: 10485760, operator: 'admin', remark: '10万用户账号数据', created_at: '2026-04-01T09:00:00', updated_at: '2026-04-08T10:00:00', jmx_refs: ['login_stress.jmx'], distribute_type: 'shared', distributed_at: '2026-04-08T10:00:00' },
	{ id: 2, name: 'order_ids.csv', env: 'perf', file_type: 'csv', status: 'referenced', size: 524288, operator: 'admin', remark: '订单ID压测数据', created_at: '2026-04-02T09:00:00', updated_at: '2026-04-02T09:00:00', jmx_refs: ['order_query.jmx'], distribute_type: 'split', distributed_at: '2026-04-02T09:00:00' },
	{ id: 3, name: 'product_list.xlsx', env: 'test', file_type: 'xlsx', status: 'unused', size: 204800, operator: 'tester01', remark: '商品列表测试数据', created_at: '2026-04-03T09:00:00', updated_at: '2026-04-03T09:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 4, name: 'config_prod.yaml', env: 'prod', file_type: 'yaml', status: 'referenced', size: 2048, operator: 'admin', remark: '生产环境配置参数', created_at: '2026-04-04T09:00:00', updated_at: '2026-04-05T10:00:00', jmx_refs: ['smoke_test.jmx'], distribute_type: null, distributed_at: null },
	{ id: 5, name: 'token_pool.txt', env: 'perf', file_type: 'txt', status: 'unused', size: 1048576, operator: 'tester02', remark: '预生成 token 池', created_at: '2026-04-05T09:00:00', updated_at: '2026-04-05T09:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 6, name: 'address_data.csv', env: 'staging', file_type: 'csv', status: 'unused', size: 307200, operator: 'tester01', remark: '地址信息测试数据', created_at: '2026-04-06T09:00:00', updated_at: '2026-04-06T09:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 7, name: 'payment_scenario.jmx', env: 'perf', file_type: 'jmx', status: 'referenced', size: 15360, operator: 'admin', remark: '支付场景脚本', created_at: '2026-04-07T09:00:00', updated_at: '2026-04-08T08:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 8, name: 'sku_ids.json', env: 'test', file_type: 'json', status: 'unused', size: 51200, operator: 'tester02', remark: 'SKU ID 列表', created_at: '2026-04-08T09:00:00', updated_at: '2026-04-08T09:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 9, name: 'stress_users.csv', env: 'prod', file_type: 'csv', status: 'running', size: 5368709120, operator: 'admin', remark: '生产压测用户数据，5G大文件', created_at: '2026-04-01T08:00:00', updated_at: '2026-04-08T11:00:00', jmx_refs: ['prod_stress.jmx'], distribute_type: 'split', distributed_at: '2026-04-08T11:00:00' },
	{ id: 10, name: 'headers.txt', env: 'test', file_type: 'txt', status: 'unused', size: 1024, operator: 'tester01', remark: 'HTTP 请求头模板', created_at: '2026-04-08T10:00:00', updated_at: '2026-04-08T10:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 11, name: 'login_stress.jmx', env: 'perf', file_type: 'jmx', status: 'running', size: 20480, operator: 'admin', remark: '登录压测主脚本', created_at: '2026-03-28T09:00:00', updated_at: '2026-04-08T10:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
	{ id: 12, name: 'region_codes.xlsx', env: 'staging', file_type: 'xlsx', status: 'unused', size: 102400, operator: 'tester02', remark: '区域编码数据', created_at: '2026-04-07T14:00:00', updated_at: '2026-04-07T14:00:00', jmx_refs: [], distribute_type: null, distributed_at: null },
];

const handleQuery = () => {
	loading.value = true;
	setTimeout(() => {
		let data = [...mockData];
		if (query.name) data = data.filter((r) => r.name.toLowerCase().includes(query.name.toLowerCase()));
		if (query.env) data = data.filter((r) => r.env === query.env);
		if (query.file_type) data = data.filter((r) => r.file_type === query.file_type);
		if (query.status) data = data.filter((r) => r.status === query.status);
		total.value = data.length;
		const start = (query.page - 1) * query.page_size;
		fileList.value = data.slice(start, start + query.page_size);
		loading.value = false;
	}, 200);
};

const resetQuery = () => {
	query.name = '';
	query.env = undefined;
	query.file_type = undefined;
	query.status = undefined;
	query.page = 1;
	handleQuery();
};

// ======================== 刷新状态 ========================
const statusRefreshing = ref(false);

const handleRefreshStatus = () => {
	statusRefreshing.value = true;
	setTimeout(() => {
		statusRefreshing.value = false;
		handleQuery();
		ElMessage.success('文件使用状态已刷新');
	}, 800);
};

// ======================== 上传 ========================
const handleBeforeUpload = (file: File) => {
	const maxSize = 500 * 1024 * 1024;
	if (file.size > maxSize) {
		ElMessage.error('文件大小不能超过 500MB');
		return false;
	}
	return true;
};

const handleUpload = ({ file }: { file: File }) => {
	const ext = file.name.split('.').pop()?.toLowerCase() ?? 'txt';
	mockData.unshift({
		id: Date.now(),
		name: file.name,
		env: 'test',
		file_type: ext,
		status: 'unused',
		size: file.size,
		operator: 'admin',
		remark: '',
		created_at: new Date().toISOString(),
		updated_at: new Date().toISOString(),
		jmx_refs: [],
	});
	handleQuery();
	ElMessage.success(`「${file.name}」上传成功`);
};

// ======================== 更新（替换） ========================
const handleUpdate = ({ file }: { file: File }, row: any) => {
	const ext = file.name.split('.').pop()?.toLowerCase() ?? row.file_type;
	if (ext !== row.file_type) {
		ElMessage.error(`文件类型不匹配，请上传 .${row.file_type} 格式的文件`);
		return;
	}
	const item = mockData.find((r) => r.id === row.id);
	if (item) {
		item.size = file.size;
		item.updated_at = new Date().toISOString();
		item.created_at = new Date().toISOString();
		item.operator = 'admin';
	}
	handleQuery();
	ElMessage.success(`「${row.name}」已更新`);
};

// ======================== JMX 更新文件 ========================
const jmxFileInputRef = ref<HTMLInputElement | null>(null);
const currentUpdateRow = ref<any>(null);

const triggerJmxFileUpdate = (row: any) => {
	currentUpdateRow.value = row;
	jmxFileInputRef.value?.click();
};

const onJmxFileInputChange = (e: Event) => {
	const file = (e.target as HTMLInputElement).files?.[0];
	if (!file || !currentUpdateRow.value) return;
	const ok = handleBeforeUpload(file);
	if (ok !== false) handleUpdate({ file }, currentUpdateRow.value);
	(e.target as HTMLInputElement).value = '';
	currentUpdateRow.value = null;
};

// ======================== JMX 更新引用 ========================
const selectingRefForId = ref<number | null>(null);
const selectedRefIds = ref<Set<number>>(new Set());

const handleJmxDropdown = (cmd: string, row: any) => {
	if (cmd === 'file') {
		triggerJmxFileUpdate(row);
	} else if (cmd === 'refs') {
		selectingRefForId.value = row.id;
		// 预选当前已关联的数据文件
		const pre = new Set(
			mockData.filter(r => r.file_type !== 'jmx' && r.jmx_refs.includes(row.name)).map(r => r.id)
		);
		selectedRefIds.value = pre;
	}
};

const toggleRef = (id: number, val: boolean) => {
	const set = new Set(selectedRefIds.value);
	val ? set.add(id) : set.delete(id);
	selectedRefIds.value = set;
};

const confirmRefs = (jmxRow: any) => {
	if (selectedRefIds.value.size === 0) return;
	const selectedNames = mockData.filter(r => selectedRefIds.value.has(r.id)).map(r => r.name);

	// 更新 JMX 行的引用文件列表
	const jmxItem = mockData.find(r => r.id === jmxRow.id);
	if (jmxItem) jmxItem.jmx_refs = selectedNames;

	// 同步各数据文件的 jmx_refs 和 status
	mockData.forEach(r => {
		if (r.file_type === 'jmx') return;
		if (selectedRefIds.value.has(r.id)) {
			if (!r.jmx_refs.includes(jmxRow.name)) r.jmx_refs.push(jmxRow.name);
			if (r.status === 'unused') r.status = 'referenced';
		} else {
			r.jmx_refs = r.jmx_refs.filter((n: string) => n !== jmxRow.name);
			if (r.jmx_refs.length === 0 && r.status === 'referenced') r.status = 'unused';
		}
	});

	cancelRefs();
	handleQuery();
	ElMessage.success('引用关系更新成功');
};

const cancelRefs = () => {
	selectingRefForId.value = null;
	selectedRefIds.value = new Set();
};


// ======================== 分发 ========================
const handleDistribute = (type: string, row: any) => {
	const typeLabel = type === 'shared' ? '共享分发' : '分割分发';
	const typeDesc = type === 'shared'
		? '将文件完整复制并独立分发到各压力机节点'
		: '将文件按压力机节点数量等比例分割后，各节点分别接收对应分片';
	ElMessageBox.confirm(
		`<b>分发方式：</b>${typeLabel}<br><br>${typeDesc}<br><br>确认对文件「${row.name}」发起${typeLabel}？`,
		'文件分发',
		{
			type: 'info',
			dangerouslyUseHTMLString: true,
			confirmButtonText: '确认分发',
			cancelButtonText: '取消',
		}
	).then(() => {
		const item = mockData.find(r => r.id === row.id);
		if (item) {
			item.distribute_type = type;
			item.distributed_at = new Date().toISOString();
		}
		handleQuery();
		ElMessage.success(`「${row.name}」${typeLabel}已发起`);
	}).catch(() => {});
};

// ======================== 下载 ========================
const selectingDownload = ref(false);
const selectedDownloadIds = ref<Set<number>>(new Set());

const enterDownloadMode = () => {
	selectingDownload.value = true;
	selectedDownloadIds.value = new Set();
};

const cancelDownload = () => {
	selectingDownload.value = false;
	selectedDownloadIds.value = new Set();
};

const toggleDownload = (id: number, val: boolean) => {
	const set = new Set(selectedDownloadIds.value);
	val ? set.add(id) : set.delete(id);
	selectedDownloadIds.value = set;
};

const startDownload = () => {
	if (selectedDownloadIds.value.size === 0) {
		ElMessage.warning('请至少勾选一个文件');
		return;
	}
	const selected = mockData.filter(r => selectedDownloadIds.value.has(r.id));
	const totalSize = selected.reduce((sum, r) => sum + r.size, 0);
	const limit = 1 * 1024 * 1024 * 1024;
	if (totalSize > limit) {
		ElMessage.error(`所选文件总大小（${formatSize(totalSize)}）超过 1G 限制，请减少勾选数量`);
		return;
	}
	selected.forEach(r => handleDownload(r));
	cancelDownload();
};

const handleDownload = (row: any) => {
	ElMessage.success(`开始下载：${row.name}`);
};

// ======================== 删除 ========================
const handleDelete = (row: any) => {
	if (row.status === 'running') {
		ElMessageBox.alert(
			`文件「${row.name}」当前正在压测任务中使用，无法删除。<br>请等待压测任务结束后再操作。`,
			'无法删除',
			{ type: 'warning', dangerouslyUseHTMLString: true, confirmButtonText: '我知道了' }
		);
		return;
	}
	if (row.status === 'referenced') {
		ElMessageBox.confirm(
			`文件「${row.name}」已被以下 JMX 脚本引用：<br><b>${row.jmx_refs.join('、')}</b><br><br>删除后相关脚本将无法正常运行，确认删除？`,
			'文件已被引用',
			{
				type: 'warning',
				dangerouslyUseHTMLString: true,
				confirmButtonText: '仍然删除',
				cancelButtonText: '取消',
				confirmButtonClass: 'el-button--danger',
			}
		).then(() => doDelete(row)).catch(() => {});
		return;
	}
	ElMessageBox.confirm(`确定要删除文件「${row.name}」吗？`, '提示', {
		type: 'warning',
		confirmButtonText: '确定',
		cancelButtonText: '取消',
	}).then(() => doDelete(row)).catch(() => {});
};

const doDelete = (row: any) => {
	const idx = mockData.findIndex((r) => r.id === row.id);
	if (idx > -1) mockData.splice(idx, 1);
	handleQuery();
	ElMessage.success('删除成功');
};

// ======================== 初始化 ========================
onMounted(() => {
	if (route.query.name) {
		query.name = route.query.name as string;
	}
	handleQuery();
});
</script>

<style scoped lang="scss">
.perf-files-container {
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

	:deep(.el-select__placeholder),
	:deep(.el-select__selected-item) {
		font-size: 13.5px;
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

			:deep(.el-upload) {
				display: inline-flex;
				align-items: center;
			}
		}
	}

	:deep(.el-tag) {
		font-size: 13px;
		padding: 0 8px;
	}

	.tip-icon {
		margin-left: 4px;
		color: #909399;
		cursor: help;
		vertical-align: middle;
		font-size: 13.5px;

		&:hover {
			color: var(--el-color-primary);
		}
	}

	.file-type-badge {
		display: inline-block;
		padding: 1px 5px;
		border-radius: 3px;
		font-size: 12px;
		font-weight: 600;
		color: #fff;
		margin-right: 6px;
		vertical-align: middle;
		line-height: 18px;
	}

	:deep(.el-table) {
		font-size: 13.5px;

		.el-table__header th {
			font-size: 13.5px;
			background-color: #eef3fb;
		}

		// 让带 ? 图标的表头文案与图标垂直居中
		.el-table__header th .cell {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			white-space: nowrap;
		}

		.el-table__cell {
			padding: 10px 0;
		}

		td.operation-col {
			background-color: #f0f2f5 !important;
		}
	}

	.file-name-text {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		max-width: calc(100% - 52px);
		display: inline-block;
		vertical-align: middle;
	}

	// 选择引用模式下的复选框：只放大视觉方块，不改变元素高度，不撑高行
	:deep(.el-table .el-table__cell .el-checkbox) {
		height: auto !important;
		display: inline-flex;
		align-items: center;
	}

	:deep(.el-table .el-table__cell .el-checkbox__inner) {
		transform: scale(1.3);
		transform-origin: center;
	}

	.jmx-ref-text {
		color: var(--el-color-primary);
		font-size: 13.5px;
		cursor: default;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		display: inline-block;
		max-width: 100%;
		vertical-align: middle;
	}

	.text-placeholder {
		color: #c0c4cc;
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

		// 确定按钮（实心）覆盖 padding
		:deep(.el-button:not(.is-text)) {
			padding: 0 8px;
		}

		.update-slot {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			gap: 2px;
		}

		:deep(.el-dropdown-menu__item) {
			font-size: 13.5px;
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
.perf-files-container .el-button > span {
	display: inline-flex !important;
	align-items: center !important;
	line-height: 1 !important;
}

/* 文件管理操作列下拉菜单（teleport 到 body，需非 scoped 覆盖） */
.perf-files-dropdown .el-dropdown-menu__item {
	font-size: 13.5px;
}
</style>