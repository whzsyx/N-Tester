<template>
	<div class="perf-report-container">
		<el-card shadow="hover">
			<el-tabs v-model="activeTab" class="report-tabs">

				<!-- Tab 1: 压测报告记录 -->
				<el-tab-pane label="压测报告记录" name="records">
					<!-- 工具栏 -->
					<div class="toolbar">
						<div class="toolbar-left">
							<el-input
								v-model="query.report_name"
								placeholder="报告文件名称"
								clearable
								style="width: 300px"
								@keyup.enter="handleQuery"
								@clear="handleQuery"
							>
								<template #prefix><el-icon><ele-Search /></el-icon></template>
							</el-input>
							<el-input
								v-model="query.scene_no"
								placeholder="场景编号"
								clearable
								style="width: 160px"
								@keyup.enter="handleQuery"
								@clear="handleQuery"
							>
								<template #prefix><el-icon><ele-Search /></el-icon></template>
							</el-input>
							<el-date-picker
								v-model="query.generated_at_range"
								type="datetimerange"
								range-separator="至"
								start-placeholder="报告生成开始时间"
								end-placeholder="结束时间"
								style="width: 400px"
								format="YYYY-MM-DD HH:mm:ss"
								value-format="YYYY-MM-DD HH:mm:ss"
								clearable
								@change="handleQuery"
							/>
							<el-input
								v-model="query.created_by"
								placeholder="报告人"
								clearable
								style="width: 140px"
								@keyup.enter="handleQuery"
								@clear="handleQuery"
							/>
							<el-button type="primary" @click="handleQuery">
								<el-icon><ele-Search /></el-icon>查询
							</el-button>
							<el-button @click="resetQuery">
								<el-icon><ele-RefreshRight /></el-icon>重置
							</el-button>
						</div>
					</div>

					<!-- 列表 -->
					<el-table v-loading="loading" :data="reportList" border stripe style="width: 100%">
						<el-table-column label="编号" width="100" align="center">
							<template #default="{ $index }">{{ (query.page - 1) * query.page_size + $index + 1 }}</template>
						</el-table-column>
						<el-table-column width="220" align="center" show-overflow-tooltip>
							<template #header>
								<span>报告ID</span>
								<el-tooltip placement="top">
									<template #content>
										<div style="max-width:280px;line-height:1.7">
											命名规则：<br>
											<b>RPT + 报告生成日期时间 + 00 + 2位随机数</b><br>
											日期时间格式：年月日时分秒（年取后2位）<br>
											示例：RPT2604101035220047
										</div>
									</template>
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
							<template #default="{ row }">{{ row.report_id }}</template>
						</el-table-column>
						<el-table-column label="压测场景编号" width="200" align="center">
							<template #default="{ row }">
								<span class="scene-no-link" @click="handleGotoScene(row)">{{ row.scene_no }}</span>
							</template>
						</el-table-column>
						<el-table-column min-width="220" show-overflow-tooltip align="center">
							<template #header>
								<span>报告文件名称</span>
								<el-tooltip placement="top">
									<template #content>
										<div style="max-width:260px;line-height:1.7">
											命名规则：<br>
											<b>Report-压测场景名称-执行日期时间</b><br>
											日期时间格式：年月日时分（年取后2位）<br>
											示例：Report-登录压测-2604101005
										</div>
									</template>
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
							<template #default="{ row }">{{ row.report_name }}</template>
						</el-table-column>
						<el-table-column label="报告生成时间" width="180" align="center">
							<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.generated_at) }}</span></template>
						</el-table-column>
						<el-table-column label="文件大小" width="150" align="center">
							<template #default="{ row }">{{ formatSize(row.file_size) }}</template>
						</el-table-column>
						<el-table-column prop="created_by" label="报告人" width="150" align="center" show-overflow-tooltip />
						<el-table-column label="操作" width="360" fixed="right" align="center" class-name="operation-col">
							<template #default="{ row }">
								<div class="action-btns">
									<el-button type="primary" size="small" text style="font-weight:600" @click="handleDownload(row)">
										<el-icon><ele-Download /></el-icon>下载
									</el-button>
									<el-button type="success" size="small" text style="font-weight:600" @click="handleViewOnline(row)">
										<el-icon><ele-View /></el-icon>在线报告
									</el-button>
									<el-button type="warning" size="small" text style="font-weight:600" @click="openConsoleDialog(row)">
										<el-icon><ele-Monitor /></el-icon>控制台日志
									</el-button>
									<el-button type="danger" size="small" text style="font-weight:600" @click="handleDelete(row)">
										<el-icon><ele-Delete /></el-icon>删除
									</el-button>
								</div>
							</template>
						</el-table-column>
					</el-table>

					<!-- 分页 -->
					<div class="pagination">
						<el-pagination
							v-model:current-page="query.page"
							v-model:page-size="query.page_size"
							:page-sizes="[20, 50, 100]"
							:total="total"
							layout="total, sizes, prev, pager, next, jumper"
							@size-change="handleQuery"
							@current-change="handleQuery"
						/>
					</div>
				</el-tab-pane>

				<!-- Tab 2: 压测报告文档（待实现） -->
				<el-tab-pane label="压测报告文档" name="docs">
					<el-empty description="压测报告文档功能正在开发中，敬请期待..." :image-size="100">
						<template #image>
							<el-icon :size="100" color="#c0c4cc"><ele-Document /></el-icon>
						</template>
					</el-empty>
				</el-tab-pane>

			</el-tabs>
		</el-card>

		<!-- 控制台日志抽屉 -->
		<el-drawer
			v-model="consoleVisible"
			:title="`控制台日志 — ${currentReport?.report_name ?? ''}`"
			direction="rtl"
			size="calc(50% - 50px)"
			class="perf-report-console-drawer"
			destroy-on-close
		>
			<div class="console-wrap">
				<div class="console-toolbar">
					<span class="console-label">
						<el-icon><ele-Monitor /></el-icon>压测执行日志
					</span>
					<el-button size="small" @click="handleCopyLog">
						<el-icon><ele-CopyDocument /></el-icon>复制
					</el-button>
				</div>
				<div ref="consoleBodyRef" class="console-body">
					<div
						v-for="(line, idx) in currentLogs"
						:key="idx"
						class="console-line"
						:class="`log-${line.level}`"
					>
						<span class="log-time">{{ line.time }}</span>
						<span class="log-text">{{ line.text }}</span>
					</div>
					<div v-if="!currentLogs.length" class="console-empty">暂无日志</div>
				</div>
			</div>
			<template #footer>
				<el-button @click="consoleVisible = false">关 闭</el-button>
			</template>
		</el-drawer>
	</div>
</template>

<script setup lang="ts" name="PerformanceReport">
import { ref, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';

const router = useRouter();
const route = useRoute();

const handleGotoScene = (row: any) => {
	router.push({ path: '/performance/scenario', query: { scene_no: row.scene_no } });
};

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

// 报告ID格式：RPT + 报告生成日期时间（年取后2位） + 00 + 2位随机数
const buildReportId = (generatedAt: string) => {
	const d = new Date(generatedAt);
	const yy = String(d.getFullYear()).slice(2);
	const mm = String(d.getMonth() + 1).padStart(2, '0');
	const dd = String(d.getDate()).padStart(2, '0');
	const hh = String(d.getHours()).padStart(2, '0');
	const mi = String(d.getMinutes()).padStart(2, '0');
	const ss = String(d.getSeconds()).padStart(2, '0');
	const rand = String(Math.floor(Math.random() * 100)).padStart(2, '0');
	return `RPT${yy}${mm}${dd}${hh}${mi}${ss}00${rand}`;
};

// 报告文件名格式：Report-场景名称-年月日时分（年份取后2位）
const buildReportName = (sceneName: string, startedAt: string) => {
	const d = new Date(startedAt);
	const yy = String(d.getFullYear()).slice(2);
	const mm = String(d.getMonth() + 1).padStart(2, '0');
	const dd = String(d.getDate()).padStart(2, '0');
	const hh = String(d.getHours()).padStart(2, '0');
	const mi = String(d.getMinutes()).padStart(2, '0');
	return `Report-${sceneName}-${yy}${mm}${dd}${hh}${mi}`;
};

// ======================== 列表 ========================
const activeTab = ref('records');
const loading = ref(false);
const reportList = ref<any[]>([]);
const total = ref(0);

const query = reactive({
	scene_no: '',
	report_name: '',
	created_by: '',
	generated_at_range: [] as string[],
	page: 1,
	page_size: 20,
});

const mockData: any[] = [
	{
		id: 1,
		scene_no: 'JMX00000001',
		scene_name: '登录接口压测-v1',
		started_at: '2026-04-10T10:05:00',
		generated_at: '2026-04-10T10:35:22',
		file_size: 4718592,
		created_by: 'admin',
		get report_id() { return buildReportId(this.generated_at); },
		get report_name() { return buildReportName(this.scene_name, this.started_at); },
	},
	{
		id: 2,
		scene_no: 'JMX00000002',
		scene_name: '订单查询压测',
		started_at: '2026-04-07T16:00:00',
		generated_at: '2026-04-07T17:02:10',
		file_size: 2621440,
		created_by: 'admin',
		get report_id() { return buildReportId(this.generated_at); },
		get report_name() { return buildReportName(this.scene_name, this.started_at); },
	},
	{
		id: 3,
		scene_no: 'JMX00000003',
		scene_name: '全链路压测场景',
		started_at: '2026-04-06T09:30:00',
		generated_at: '2026-04-06T10:08:44',
		file_size: 9437184,
		created_by: 'tester',
		get report_id() { return buildReportId(this.generated_at); },
		get report_name() { return buildReportName(this.scene_name, this.started_at); },
	},
	{
		id: 4,
		scene_no: 'JMX00000004',
		scene_name: '搜索接口基准测试',
		started_at: '2026-04-05T14:30:00',
		generated_at: '2026-04-05T14:55:30',
		file_size: 1048576,
		created_by: 'admin',
		get report_id() { return buildReportId(this.generated_at); },
		get report_name() { return buildReportName(this.scene_name, this.started_at); },
	},
];

const handleQuery = () => {
	loading.value = true;
	setTimeout(() => {
		let data = [...mockData];
		if (query.scene_no) data = data.filter(r => r.scene_no.includes(query.scene_no));
		if (query.report_name) data = data.filter(r => r.report_name.includes(query.report_name));
		if (query.created_by) data = data.filter(r => r.created_by.includes(query.created_by));
		if (query.generated_at_range?.length === 2) {
			const [start, end] = query.generated_at_range;
			data = data.filter(r => {
				const dt = r.generated_at.replace('T', ' ');
				return dt >= start && dt <= end;
			});
		}
		total.value = data.length;
		const start = (query.page - 1) * query.page_size;
		reportList.value = data.slice(start, start + query.page_size);
		loading.value = false;
	}, 200);
};

const resetQuery = () => {
	query.scene_no = '';
	query.report_name = '';
	query.created_by = '';
	query.generated_at_range = [];
	query.page = 1;
	handleQuery();
};

// ======================== 下载 ========================
const handleDownload = (row: any) => {
	ElMessage.success(`「${row.report_name}.zip」开始下载...`);
};

// ======================== 在线查看报告 ========================
const handleViewOnline = (row: any) => {
	ElMessage.info(`正在加载「${row.report_name}」在线报告...`);
	// 实际调用后端预览接口，后端解压 zip 并返回静态地址
	// previewApi(row.report_id).then(url => window.open(url, '_blank'))
	const mockUrl = `/static/reports/${row.report_id}/index.html`;
	window.open(mockUrl, '_blank');
};

// ======================== 删除 ========================
const handleDelete = (row: any) => {
	ElMessageBox.confirm(
		`<div>确认删除报告「<b>${row.report_name}</b>」？</div>
		<div style="margin-top:8px;color:#606266;font-size:13px">
			将同步删除 Milo 文件服务器上的报告文件，以及 Master 服务器上的 zip 文件（如存在）。
		</div>`,
		'删除确认',
		{
			type: 'warning',
			dangerouslyUseHTMLString: true,
			confirmButtonText: '确认删除',
			cancelButtonText: '取消',
			confirmButtonClass: 'el-button--danger',
		}
	).then(() => {
		const idx = mockData.findIndex(r => r.id === row.id);
		if (idx > -1) mockData.splice(idx, 1);
		handleQuery();
		ElMessage.success('报告已删除');
	}).catch(() => {});
};

// ======================== 控制台日志 ========================
const consoleVisible = ref(false);
const currentReport = ref<any>(null);
const currentLogs = ref<{ time: string; level: string; text: string }[]>([]);

const mockLogs: Record<number, { time: string; level: string; text: string }[]> = {
	1: [
		{ time: '10:05:00', level: 'info',    text: '[JMeter] 初始化压测任务：登录接口压测-v1' },
		{ time: '10:05:01', level: 'info',    text: '[JMeter] 加载脚本：login_stress.jmx' },
		{ time: '10:05:02', level: 'info',    text: '[JMeter] 线程数：100，Ramp-up：60s，分布式节点：3' },
		{ time: '10:05:03', level: 'success', text: '[JMeter] 脚本加载完成，开始执行...' },
		{ time: '10:05:04', level: 'info',    text: '[Worker-1] 连接成功 192.168.1.101:1099' },
		{ time: '10:05:04', level: 'info',    text: '[Worker-2] 连接成功 192.168.1.102:1099' },
		{ time: '10:05:04', level: 'info',    text: '[Worker-3] 连接成功 192.168.1.103:1099' },
		{ time: '10:05:05', level: 'success', text: '[JMeter] 所有 Worker 节点就绪，启动并发线程' },
		{ time: '10:06:05', level: 'info',    text: '[Thread Group] Ramp-up 完成，全量线程已启动' },
		{ time: '10:15:30', level: 'warn',    text: '[Thread-42] 响应时间超过阈值：2350ms（URL: /api/login）' },
		{ time: '10:28:10', level: 'warn',    text: '[Worker-2] 连接延迟 >500ms，可能存在网络抖动' },
		{ time: '10:35:00', level: 'info',    text: '[JMeter] 压测时长已到，开始收尾...' },
		{ time: '10:35:05', level: 'success', text: '[JMeter] 压测执行完成，正在生成报告...' },
		{ time: '10:35:18', level: 'info',    text: '[Report] JMeter HTML Report 生成完毕' },
		{ time: '10:35:20', level: 'info',    text: '[Report] results.jtl 写入完毕' },
		{ time: '10:35:22', level: 'success', text: '[Report] 报告压缩打包完成，上传至 Milo 文件服务器' },
	],
	2: [
		{ time: '16:00:00', level: 'info',    text: '[JMeter] 初始化压测任务：订单查询压测' },
		{ time: '16:00:01', level: 'info',    text: '[JMeter] 加载脚本：order_stress.jmx' },
		{ time: '16:00:02', level: 'success', text: '[JMeter] 脚本加载完成，开始执行...' },
		{ time: '16:00:03', level: 'info',    text: '[Thread Group] 线程数：50，Ramp-up：30s' },
		{ time: '16:00:33', level: 'info',    text: '[Thread Group] Ramp-up 完成，全量线程已启动' },
		{ time: '17:00:00', level: 'info',    text: '[JMeter] 压测时长已到，开始收尾...' },
		{ time: '17:00:05', level: 'success', text: '[JMeter] 压测执行完成，正在生成报告...' },
		{ time: '17:02:10', level: 'success', text: '[Report] 报告压缩打包完成，上传至 Milo 文件服务器' },
	],
	3: [
		{ time: '09:30:00', level: 'info',    text: '[JMeter] 初始化压测任务：全链路压测场景' },
		{ time: '09:30:01', level: 'info',    text: '[JMeter] 加载脚本：search_perf.jmx' },
		{ time: '09:30:03', level: 'info',    text: '[Worker-1] 连接成功 192.168.1.101:1099' },
		{ time: '09:30:04', level: 'error',   text: '[Worker-2] 连接失败：Connection refused jmeter-slave-2:1099' },
		{ time: '09:30:04', level: 'warn',    text: '[JMeter] Worker-2 连接失败，继续使用剩余节点执行' },
		{ time: '09:30:05', level: 'success', text: '[JMeter] 使用 1 个 Worker 节点，启动并发线程' },
		{ time: '09:45:20', level: 'error',   text: '[Thread-15] 请求异常：ReadTimeout（URL: /api/search）' },
		{ time: '10:08:44', level: 'success', text: '[Report] 报告压缩打包完成，上传至 Milo 文件服务器' },
	],
	4: [
		{ time: '14:30:00', level: 'info',    text: '[JMeter] 初始化压测任务：搜索接口基准测试' },
		{ time: '14:30:01', level: 'info',    text: '[JMeter] 加载脚本：search_perf.jmx' },
		{ time: '14:30:02', level: 'success', text: '[JMeter] 脚本加载完成，开始执行...' },
		{ time: '14:30:12', level: 'info',    text: '[Thread Group] Ramp-up 完成，全量线程已启动' },
		{ time: '14:55:00', level: 'info',    text: '[JMeter] 循环执行完毕，开始收尾...' },
		{ time: '14:55:28', level: 'success', text: '[JMeter] 压测执行完成，正在生成报告...' },
		{ time: '14:55:30', level: 'success', text: '[Report] 报告压缩打包完成，上传至 Milo 文件服务器' },
	],
};

const openConsoleDialog = (row: any) => {
	currentReport.value = row;
	currentLogs.value = mockLogs[row.id] ?? [];
	consoleVisible.value = true;
};

const handleCopyLog = () => {
	const text = currentLogs.value.map(l => `[${l.time}] ${l.text}`).join('\n');
	navigator.clipboard?.writeText(text).then(() => {
		ElMessage.success('日志已复制到剪贴板');
	}).catch(() => {
		ElMessage.warning('复制失败，请手动选择日志文本');
	});
};

// ======================== 初始化 ========================
onMounted(() => {
	if (route.query.scene_no) {
		query.scene_no = route.query.scene_no as string;
	}
	handleQuery();
});
</script>

<style scoped lang="scss">
.perf-report-container {
	padding: 10px 10px 20px 10px;

	:deep(.el-card__body) {
		padding: 10px 10px 20px 10px;
	}

	.report-tabs {
		:deep(.el-tabs__header) {
			margin-top: -8px;
		}
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
			padding: 0 5px;
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

	.scene-no-link {
		color: var(--el-color-primary);
		cursor: pointer;
		font-size: 13.5px;

		&:hover {
			text-decoration: underline;
		}
	}

	// 控制台日志抽屉内容
	.console-wrap {
		display: flex;
		flex-direction: column;
		height: 100%;
		border: 1px solid #2a2a3a;
		border-radius: 6px;
		overflow: hidden;

		.console-toolbar {
			display: flex;
			align-items: center;
			justify-content: space-between;
			padding: 8px 14px;
			background: #1a1a2e;
			color: #7ec8e3;
			font-size: 13.5px;
			flex-shrink: 0;

			.console-label {
				display: flex;
				align-items: center;
				gap: 6px;
			}
		}

		.console-body {
			flex: 1;
			min-height: 0;
			background: #0d0d1a;
			overflow-y: auto;
			padding: 12px 16px;
			font-family: 'Ubuntu Mono', 'DejaVu Sans Mono', 'Liberation Mono',
				'WenQuanYi Micro Hei Mono', 'Noto Sans Mono CJK SC', 'Source Han Mono SC',
				'Courier New', monospace;
			font-size: 13.5px;
			line-height: 1.8;

			.console-line {
				display: flex;
				gap: 12px;

				.log-time {
					color: #5f6b7c;
					flex-shrink: 0;
					user-select: none;
				}

				.log-text {
					word-break: break-all;
				}

				&.log-info    .log-text { color: #c8d0e0; }
				&.log-success .log-text { color: #67c23a; }
				&.log-warn    .log-text { color: #e6a23c; }
				&.log-error   .log-text { color: #f56c6c; }
			}

			.console-empty {
				color: #5f6b7c;
				text-align: center;
				padding: 40px 0;
			}
		}
	}
}
</style>

<style lang="scss">
/* 按钮内 slot wrapper span 设为 flex，使图标与文字垂直居中 */
.perf-report-container .el-button > span {
	display: inline-flex !important;
	align-items: center !important;
	line-height: 1 !important;
}

/* 控制台日志抽屉（teleport 到 body） */
.perf-report-console-drawer {
	.el-drawer__header {
		background: #1a1a2e;
		padding: 14px 20px;
		margin-bottom: 0;

		.el-drawer__title {
			color: #7ec8e3;
			font-size: 13.5px;
		}

		.el-drawer__close-btn .el-icon {
			color: #7ec8e3;
		}
	}

	.el-drawer__body {
		padding: 12px;
		background: #0d0d1a;
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}

	.el-drawer__footer {
		background: #1a1a2e;
		padding: 10px 20px;
		text-align: right;
	}
}
</style>