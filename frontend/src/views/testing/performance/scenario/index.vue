<template>
	<div class="perf-scene-container">
		<el-card shadow="never">
			<el-tabs v-model="activeTab" class="scene-tabs">

				<!-- Tab 1: 压测场景列表 -->
				<el-tab-pane label="压测场景列表" name="list">
					<!-- 工具栏 -->
					<div class="toolbar">
						<!-- 搜索框区（仅输入控件） -->
						<div class="toolbar-filters">
							<el-input
								v-model="query.name"
								placeholder="搜索场景名称"
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
							<el-select v-model="query.script_name" placeholder="查询脚本" clearable style="width: 160px" @change="handleQuery">
								<el-option v-for="s in jmxScripts" :key="s.id" :label="s.name" :value="s.name" />
							</el-select>
							<el-select v-model="query.status" placeholder="执行状态" clearable style="width: 130px" @change="handleQuery">
								<el-option label="待开始" value="pending" />
								<el-option label="进行中" value="running" />
								<el-option label="已完成" value="completed" />
								<el-option label="已取消" value="cancelled" />
								<el-option label="失败" value="failed" />
							</el-select>
							<el-select v-model="query.test_type" placeholder="测试类型" clearable style="width: 130px" @change="handleQuery">
								<el-option v-for="t in TEST_TYPE_OPTIONS" :key="t.value" :label="t.label" :value="t.value" />
							</el-select>
							<el-input
								v-model="query.created_by"
								placeholder="创建人"
								clearable
								style="width: 160px"
								@keyup.enter="handleQuery"
								@clear="handleQuery"
							/>
						</div>
						<!-- 查询/重置（宽屏：紧跟搜索框；窄屏：换行后靠左） -->
						<div class="toolbar-query-btns">
							<el-button type="primary" @click="handleQuery">
								<el-icon><ele-Search /></el-icon>查询
							</el-button>
							<el-button @click="resetQuery">
								<el-icon><ele-RefreshRight /></el-icon>重置
							</el-button>
						</div>
						<!-- 操作按钮（始终靠右） -->
						<div class="toolbar-right">
							<el-button type="primary" @click="openDrawer('add')">
								<el-icon><ele-Plus /></el-icon>新增压测场景
							</el-button>
							<el-button class="btn-debug" :disabled="selectedRows.length !== 1" @click="handleDebug">
								<el-icon><ele-Connection /></el-icon>脚本联调
							</el-button>
							<el-button
								type="success"
								:disabled="selectedRows.length !== 1 || !['completed', 'pending'].includes(selectedRows[0]?.status)"
								@click="handleStartSelected"
							>
								<el-icon><ele-VideoPlay /></el-icon>启动压测
							</el-button>
							<el-button :loading="statusRefreshing" @click="handleRefreshStatus">
								<el-icon><ele-Refresh /></el-icon>刷新状态
							</el-button>
							<el-button type="info" @click="handleViewReport(selectedRows.length === 1 ? selectedRows[0] : undefined)">
								<el-icon><ele-DataLine /></el-icon>查看报告
							</el-button>
						</div>
					</div>

					<!-- 列表 -->
					<el-table
						ref="tableRef"
						v-loading="loading"
						:data="sceneList"
						border
						stripe
						style="width: 100%"
						row-key="id"
						@selection-change="handleSelectionChange"
					>
						<!-- 左固定：多选 + 展开 + 任务名称 -->
						<el-table-column type="selection" width="45" align="center" fixed="left" :selectable="(row: any) => row.status !== 'running'">
							<template #header></template>
						</el-table-column>
						<el-table-column type="expand" width="40" fixed="left">
							<template #default="{ row }">
								<div class="expand-detail">
									<table class="expand-table">
										<thead>
											<tr>
												<th>状态</th>
												<th>单节点线程数</th>
												<th>节点数量</th>
												<th>是否分布式</th>
												<th>Ramp-up 时间</th>
												<th>循环次数</th>
												<th>持续时间</th>
												<th>启动延迟</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="cfg in row.configs" :key="cfg.id">
												<td>
													<el-switch v-model="cfg.active" @change="handleConfigActiveChange(row, cfg)" />
												</td>
												<td>{{ cfg.threads ?? '--' }}</td>
												<td>{{ cfg.distributed ? cfg.worker_count : 1 }}</td>
												<td>
													<el-tag :type="cfg.distributed ? 'primary' : 'info'" size="small" effect="light">
														{{ cfg.distributed ? '是' : '否' }}
													</el-tag>
												</td>
												<td>{{ cfg.ramp_up != null ? `${cfg.ramp_up}s` : '--' }}</td>
												<td>{{ cfg.forever ? '永远' : (cfg.loop_count ?? '--') }}</td>
												<td>{{ cfg.forever && cfg.duration ? `${cfg.duration}s` : '--' }}</td>
												<td>{{ cfg.start_delay ? `${cfg.start_delay}s` : '0s' }}</td>
												<td>
													<el-button type="primary" size="small" text style="font-weight:600" @click="openConfigDrawer(row, cfg)">
														<el-icon><ele-Edit /></el-icon>编辑
													</el-button>
													<el-button type="success" size="small" text style="font-weight:600" @click="handleCopyConfig(row, cfg)">
														<el-icon><ele-CopyDocument /></el-icon>复制
													</el-button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</template>
						</el-table-column>
						<el-table-column prop="name" label="场景名称" min-width="150" show-overflow-tooltip fixed="left" />

						<!-- 中间可滚动列 -->
						<el-table-column prop="scene_no" label="场景编号" width="140" align="center" show-overflow-tooltip />
						<el-table-column label="场景脚本" min-width="170" show-overflow-tooltip>
							<template #default="{ row }">
								<span class="script-link" @click="handleGotoFiles(row)">{{ row.script_name }}</span>
							</template>
						</el-table-column>
						<el-table-column label="测试类型" width="100" align="center">
							<template #default="{ row }">
								<el-tag v-if="row.test_type" :type="testTypeTagType(row.test_type)" size="small" effect="light">
									{{ testTypeLabel(row.test_type) }}
								</el-tag>
								<span v-else class="text-placeholder">--</span>
							</template>
						</el-table-column>
						<el-table-column label="并发数" width="100" align="center">
							<template #header>
								<span>并发数</span>
								<el-tooltip content="单节点线程数 × 节点数量" placement="top">
									<el-icon class="tip-icon"><ele-QuestionFilled /></el-icon>
								</el-tooltip>
							</template>
							<template #default="{ row }">
								{{ (() => { const c = row.configs?.find((x: any) => x.active); return c?.threads != null ? c.threads * (c.distributed ? (c.worker_count ?? 1) : 1) : '--'; })() }}
							</template>
						</el-table-column>
						<el-table-column label="运行环境" width="90" align="center">
							<template #default="{ row }">
								<el-tag :type="envTagType(row.env)" size="small" effect="light">{{ envLabel(row.env) }}</el-tag>
							</template>
						</el-table-column>
						<el-table-column label="状态" width="90" align="center">
							<template #default="{ row }">
								<el-tag :type="statusTagType(row.status)" size="small" :effect="row.status === 'running' ? 'dark' : 'light'">
									{{ statusLabel(row.status) }}
								</el-tag>
							</template>
						</el-table-column>
						<el-table-column label="压测进度" width="170" align="center">
							<template #default="{ row }">
								<div class="progress-cell">
									<el-progress
										:percentage="row.progress"
										:color="progressColor(row.status)"
										:show-text="false"
										:stroke-width="8"
										class="progress-bar"
									/>
									<span class="progress-suffix" :style="{ color: progressColor(row.status) }">
										<template v-if="row.status === 'completed'">
											<el-icon style="font-size:15px;font-weight:700"><ele-CircleCheck /></el-icon>
										</template>
										<template v-else-if="row.status === 'failed'">
											<el-icon style="font-size:15px;font-weight:700"><ele-CircleClose /></el-icon>
										</template>
										<template v-else>{{ row.progress }}%</template>
									</span>
								</div>
							</template>
						</el-table-column>
						<el-table-column label="预计耗时" width="100" align="center">
							<template #default="{ row }">{{ formatDuration(row.estimated_duration) }}</template>
						</el-table-column>
						<el-table-column prop="created_at" label="创建时间" width="160" align="center">
							<template #default="{ row }"><span style="white-space: nowrap">{{ formatDateTime(row.created_at) }}</span></template>
						</el-table-column>
						<el-table-column label="执行时间" width="160" align="center">
							<template #default="{ row }">
								<span v-if="row.started_at" style="white-space: nowrap">{{ formatDateTime(row.started_at) }}</span>
								<span v-else class="text-placeholder">--</span>
							</template>
						</el-table-column>
						<el-table-column label="错误信息" min-width="150" show-overflow-tooltip>
							<template #default="{ row }">
								<span v-if="row.error_msg" class="error-text">{{ row.error_msg }}</span>
								<span v-else class="text-placeholder">--</span>
							</template>
						</el-table-column>
						<el-table-column label="备注" min-width="120" show-overflow-tooltip>
						<template #default="{ row }">
							<span v-if="row.remark">{{ row.remark }}</span>
							<span v-else class="text-placeholder">--</span>
						</template>
					</el-table-column>
					<el-table-column prop="created_by" label="创建人" width="80" align="center" />

						<!-- 右固定：操作 -->
						<el-table-column label="操作" width="260" fixed="right" align="center" class-name="operation-col">
							<template #default="{ row }">
								<div class="action-btns">
									<!-- 进行中：立即停止 -->
									<template v-if="row.status === 'running'">
										<el-button type="danger" size="small" text @click="handleStopTask(row)">
											<el-icon><ele-VideoPause /></el-icon>立即停止
										</el-button>
									</template>

									<!-- 失败 / 已取消：恢复 + 修改 + 复制 + 删除 -->
									<template v-else-if="row.status === 'failed' || row.status === 'cancelled'">
										<el-button type="warning" size="small" text @click="handleRecover(row)">
											<el-icon><ele-RefreshRight /></el-icon>恢复
										</el-button>
										<el-button type="primary" size="small" text @click="openDrawer('edit', row)">
											<el-icon><ele-Edit /></el-icon>修改
										</el-button>
										<el-button type="success" size="small" text @click="handleCopyScene(row)">
											<el-icon><ele-CopyDocument /></el-icon>复制
										</el-button>
										<el-button type="danger" size="small" text @click="handleDelete(row)">
											<el-icon><ele-Delete /></el-icon>删除
										</el-button>
									</template>

									<!-- 已完成：修改 + 复制 + 删除（勾选行后可通过顶部工具栏启动压测） -->
									<template v-else-if="row.status === 'completed'">
										<el-button type="primary" size="small" text @click="openDrawer('edit', row)">
											<el-icon><ele-Edit /></el-icon>修改
										</el-button>
										<el-button type="success" size="small" text @click="handleCopyScene(row)">
											<el-icon><ele-CopyDocument /></el-icon>复制
										</el-button>
										<el-button type="danger" size="small" text @click="handleDelete(row)">
											<el-icon><ele-Delete /></el-icon>删除
										</el-button>
									</template>

									<!-- 待开始：修改 + 复制 + 删除（无启动压测，通过顶部工具栏勾选启动） -->
									<template v-else-if="row.status === 'pending'">
										<el-button type="primary" size="small" text @click="openDrawer('edit', row)">
											<el-icon><ele-Edit /></el-icon>修改
										</el-button>
										<el-button type="success" size="small" text @click="handleCopyScene(row)">
											<el-icon><ele-CopyDocument /></el-icon>复制
										</el-button>
										<el-button type="danger" size="small" text @click="handleDelete(row)">
											<el-icon><ele-Delete /></el-icon>删除
										</el-button>
									</template>

									<!-- 其他状态：启动压测 + 修改 + 复制 + 删除 -->
									<template v-else>
										<el-button type="success" size="small" text :disabled="hasRunningTask" @click="handleStartRow(row)">
											<el-icon><ele-VideoPlay /></el-icon>启动压测
										</el-button>
										<el-button type="primary" size="small" text @click="openDrawer('edit', row)">
											<el-icon><ele-Edit /></el-icon>修改
										</el-button>
										<el-button type="success" size="small" text @click="handleCopyScene(row)">
											<el-icon><ele-CopyDocument /></el-icon>复制
										</el-button>
										<el-button type="danger" size="small" text @click="handleDelete(row)">
											<el-icon><ele-Delete /></el-icon>删除
										</el-button>
									</template>
								</div>
							</template>
						</el-table-column>
					</el-table>

					<!-- 分页 -->
					<el-pagination
						v-show="total > 0"
						v-model:current-page="query.page"
						v-model:page-size="query.page_size"
						:page-sizes="[10, 20, 50]"
						:total="total"
						layout="total, sizes, prev, pager, next, jumper"
						class="pagination"
						@size-change="handleQuery"
						@current-change="handleQuery"
					/>
				</el-tab-pane>

				<!-- Tab 2: 压测实时监控 -->
				<el-tab-pane label="压测实时监控" name="console">
					<!-- 无任务时空态 -->
					<template v-if="!monitorScene">
						<div class="monitor-empty">
							<el-empty description="暂无压测任务，请在场景列表中启动压测" :image-size="80" />
						</div>
					</template>

					<template v-else>
						<!-- 压测进度条 -->
						<div class="monitor-progress-section">
							<div class="monitor-progress-header">
								<span class="monitor-scene-name">{{ monitorScene.name }}</span>
								<el-tag
									:type="statusTagType(monitorScene.status)"
									size="small"
									:effect="monitorScene.status === 'running' ? 'dark' : 'light'"
									style="margin-left: 10px"
								>{{ statusLabel(monitorScene.status) }}</el-tag>
							</div>
							<div class="monitor-progress-bar-row">
								<el-progress
									:percentage="monitorScene.progress ?? 0"
									:color="progressColor(monitorScene.status)"
									:stroke-width="14"
									:show-text="false"
									class="monitor-progress-bar"
								/>
								<span class="monitor-progress-suffix">
									<template v-if="monitorScene.status === 'running'">
										<span style="color:#409eff;font-weight:700;font-size:15px">{{ monitorScene.progress }}%</span>
									</template>
									<template v-else-if="monitorScene.status === 'completed'">
										<el-icon :size="20" style="color:#67c23a;font-weight:700"><ele-CircleCheck /></el-icon>
									</template>
									<template v-else-if="monitorScene.status === 'failed'">
										<el-icon :size="20" style="color:#f56c6c;font-weight:700"><ele-CircleClose /></el-icon>
									</template>
									<template v-else>
										<span style="color:#909399;font-weight:700;font-size:15px">{{ monitorScene.progress ?? 0 }}%</span>
									</template>
								</span>
							</div>
						</div>

						<!-- 控制台 + 指标看板 -->
						<div class="monitor-body">
							<!-- 左侧：控制台输出 60% -->
							<div class="monitor-console-wrap">
								<PerfConsole
									:logs="consoleLogs"
									title="压测执行日志（实时）"
									empty-text="暂无输出，启动压测后将在此显示实时日志..."
								>
									<template #actions>
										<el-button size="small" @click="consoleLogs = []">
											<el-icon><ele-Delete /></el-icon>清空
										</el-button>
									</template>
								</PerfConsole>
							</div>

							<!-- 右侧：实时指标看板 40% -->
							<div class="monitor-metrics-wrap" :class="{ 'metrics-dark': monitorDark }">
								<div class="metrics-header">
									<span><el-icon><ele-DataLine /></el-icon>实时监控指标</span>
									<el-tooltip :content="monitorDark ? '切换亮色' : '切换深色'" placement="top" :show-after="300">
										<el-button class="theme-toggle-btn" size="small" text circle @click="monitorDark = !monitorDark">
											<el-icon>
												<ele-Sunny v-if="monitorDark" />
												<ele-Moon v-else />
											</el-icon>
										</el-button>
									</el-tooltip>
								</div>
								<draggable
									class="metrics-charts-list"
									v-model="monitorMetrics"
									item-key="title"
									handle=".panel-title-handle"
									:animation="180"
									ghost-class="metric-drag-ghost"
									chosen-class="metric-drag-chosen"
								>
									<template #item="{ element: m }">
										<MetricChart
											:title="m.title"
											:unit="m.unit"
											:series="m.series"
											:time-labels="monitorTimeLabels"
											:dark-mode="monitorDark"
											:chart-height="200"
											@expand="handleChartExpand"
										/>
									</template>
								</draggable>
							</div>
						</div>
						<!-- Top 5 错误统计 -->
						<div class="monitor-errors-wrap" :class="{ 'errors-dark': monitorDark }">
							<div class="errors-header">
								<span class="errors-header-title">Top 5 Errors by Sampler（实时）</span>
								<el-tooltip content="放大查看" placement="top" :show-after="400">
									<el-button class="errors-expand-btn" size="small" text circle @click="errorsExpandVisible = true">
										<el-icon><ele-FullScreen /></el-icon>
									</el-button>
								</el-tooltip>
							</div>
							<div class="errors-table-scroll">
								<el-table :data="top5Errors" size="small" class="errors-table" border :show-header="true">
									<el-table-column label="Sample（接口）" prop="sampler" min-width="200" header-align="center">
										<template #default="{ row }">
											<span class="sampler-name">{{ row.sampler }}</span>
										</template>
									</el-table-column>
									<el-table-column label="#Samples" prop="samples" width="80" align="center" header-align="center" />
									<el-table-column label="#Errors" prop="errors" width="70" align="center" header-align="center">
										<template #default="{ row }">
											<span class="total-errors">{{ row.errors }}</span>
										</template>
									</el-table-column>
								<el-table-column label="Error 1" min-width="160" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[0]" class="error-msg">{{ row.top[0].error }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Count" width="60" align="center" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[0]" class="error-count">{{ row.top[0].count }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Error 2" min-width="160" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[1]" class="error-msg">{{ row.top[1].error }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Count" width="60" align="center" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[1]" class="error-count">{{ row.top[1].count }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Error 3" min-width="160" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[2]" class="error-msg">{{ row.top[2].error }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Count" width="60" align="center" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[2]" class="error-count">{{ row.top[2].count }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Error 4" min-width="160" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[3]" class="error-msg">{{ row.top[3].error }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Count" width="60" align="center" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[3]" class="error-count">{{ row.top[3].count }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Error 5" min-width="160" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[4]" class="error-msg">{{ row.top[4].error }}</span>
									</template>
								</el-table-column>
								<el-table-column label="Count" width="60" align="center" header-align="center">
									<template #default="{ row }">
										<span v-if="row.top[4]" class="error-count">{{ row.top[4].count }}</span>
									</template>
								</el-table-column>
								</el-table>
							</div>
						</div>
					</template>
				</el-tab-pane>

			</el-tabs>
		</el-card>

		<!-- 脚本联调抽屉 -->
		<SceneDebug
			v-model="debugDrawerVisible"
			:scene="debugScene"
			@confirm="handleDebugConfirm"
		/>

		<!-- 放大图表 Dialog -->
		<el-dialog
			v-model="expandVisible"
			width="75%"
			destroy-on-close
			class="expand-chart-dialog"
		>
			<MetricChart
				v-if="expandConfig"
				:title="expandConfig!.title"
				:unit="expandConfig!.unit"
				:series="expandConfig!.series"
				:time-labels="expandConfig!.timeLabels"
				:dark-mode="monitorDark"
				:expandable="false"
				:chart-height="460"
			/>
		</el-dialog>

		<!-- Top5 Errors 放大 抽屉（从顶部滑出） -->
		<el-drawer
			v-model="errorsExpandVisible"
			direction="ttb"
			size="88vh"
			destroy-on-close
			class="errors-expand-drawer"
			:class="{ 'errors-expand-dark': monitorDark }"
		>
			<template #header>
				<span class="errors-dialog-header-title">Top 5 Errors by Sampler（详情）</span>
			</template>
			<el-table :data="top5Errors" size="small" class="errors-table-full" border :show-header="true"
				style="width: 100%"
			>
				<el-table-column label="Sample（接口）" prop="sampler" min-width="180" header-align="center">
					<template #default="{ row }">
						<span class="sampler-name">{{ row.sampler }}</span>
					</template>
				</el-table-column>
				<el-table-column label="#Samples" prop="samples" width="90" align="center" header-align="center" />
				<el-table-column label="#Errors" prop="errors" width="80" align="center" header-align="center">
					<template #default="{ row }">
						<span class="total-errors">{{ row.errors }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Error 1" min-width="130" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[0]" class="error-msg-full">{{ row.top[0].error }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Count" width="60" align="center" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[0]" class="error-count">{{ row.top[0].count }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Error 2" min-width="130" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[1]" class="error-msg-full">{{ row.top[1].error }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Count" width="60" align="center" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[1]" class="error-count">{{ row.top[1].count }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Error 3" min-width="130" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[2]" class="error-msg-full">{{ row.top[2].error }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Count" width="60" align="center" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[2]" class="error-count">{{ row.top[2].count }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Error 4" min-width="130" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[3]" class="error-msg-full">{{ row.top[3].error }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Count" width="60" align="center" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[3]" class="error-count">{{ row.top[3].count }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Error 5" min-width="130" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[4]" class="error-msg-full">{{ row.top[4].error }}</span>
					</template>
				</el-table-column>
				<el-table-column label="Count" width="60" align="center" header-align="center">
					<template #default="{ row }">
						<span v-if="row.top[4]" class="error-count">{{ row.top[4].count }}</span>
					</template>
				</el-table-column>
			</el-table>
		</el-drawer>

		<!-- 新增 / 编辑 抽屉 -->
		<el-drawer
			v-model="drawerVisible"
			:title="drawerTitle"
			direction="rtl"
			size="716px"
			:close-on-click-modal="false"
			class="perf-scene-drawer"
			@close="resetForm"
		>
			<el-form
				ref="formRef"
				:model="form"
				:rules="formRules"
				size="default"
				label-width="130px"
				hide-required-asterisk
				class="scene-form"
			>
				<!-- 任务名称 -->
				<el-form-item v-if="drawerMode === 'full'" prop="name">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>任务名称</span>
						<span class="label-tip-placeholder" />
					</template>
					<div class="input-with-unit">
						<el-input v-model="form.name" placeholder="请输入任务名称" maxlength="100" show-word-limit style="width: 100%" />
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- JMX脚本 -->
				<el-form-item v-if="drawerMode === 'full'" prop="script_id">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>场景脚本</span>
						<el-tooltip content="选择已上传的JMX压测脚本" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<div class="input-with-unit">
						<el-select
							v-model="form.script_id"
							placeholder="请选择JMX脚本"
							filterable
							style="width: 100%"
							@change="handleScriptChange"
						>
							<el-option
								v-for="s in jmxScripts"
								:key="s.id"
								:label="`${String(s.id).padStart(8, '0')}：${s.name}`"
								:value="s.id"
								/>
						</el-select>
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- 测试类型 -->
				<el-form-item v-if="drawerMode === 'full'" prop="test_type">
					<template #label>
						<span class="label-txt">测试类型</span>
						<el-tooltip content="用于标识本次压测的场景类型" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<div class="input-with-unit">
						<el-select
							v-model="form.test_type"
							placeholder="请选择测试类型"
							clearable
							style="width: 100%"
							popper-class="test-type-select-dropdown"
						>
							<el-option v-for="t in TEST_TYPE_OPTIONS" :key="t.value" :label="t.label" :value="t.value">
								<div class="test-type-option">
									<span class="test-type-name">{{ t.label }}</span>
									<span class="test-type-desc">{{ t.desc }}</span>
								</div>
							</el-option>
						</el-select>
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- 备注 -->
				<el-form-item v-if="drawerMode === 'full'" prop="remark">
					<template #label>
						<span class="label-txt">备注</span>
						<span class="label-tip-placeholder" />
					</template>
					<div class="input-with-unit">
						<el-input v-model="form.remark" placeholder="选填，最多200个字符" maxlength="200" show-word-limit style="width: 100%" />
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- 是否分布式 -->
				<el-form-item prop="distributed">
					<template #label>
						<span class="label-txt">是否分布式</span>
						<el-tooltip content="开启后将使用多个Worker节点并发执行压测" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<el-switch v-model="form.distributed" active-text="是" inactive-text="否" inline-prompt />
				</el-form-item>

				<!-- Worker数量（分布式时显示） -->
				<el-form-item v-if="form.distributed" prop="worker_count">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>Worker数量</span>
						<el-tooltip content="分布式压测时使用的Slave节点数量" placement="top">
							<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
						</el-tooltip>
					</template>
					<div class="input-with-unit">
						<el-input-number
							v-model="form.worker_count"
							:min="1"
							:max="20"
							placeholder="请输入Worker节点数"
							style="width: 100%"
							controls-position="right"
						/>
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- 运行环境 -->
				<el-form-item v-if="drawerMode === 'full'" prop="env">
					<template #label>
						<span class="label-txt"><span class="label-star">*</span>运行环境</span>
						<span class="label-tip-placeholder" />
					</template>
					<div class="input-with-unit">
						<el-select v-model="form.env" placeholder="请选择运行环境" style="width: 100%">
							<el-option v-for="opt in ENV_OPTIONS" :key="opt.value" :label="opt.label" :value="opt.value" />
						</el-select>
						<span class="unit-placeholder" />
					</div>
				</el-form-item>

				<!-- 高级设置分割线（仅新增/修改模式显示） -->
				<el-divider v-if="drawerMode === 'full'">
					<span class="divider-advanced">
						高级设置
						<el-switch v-model="form.advanced" style="margin-left: 8px; vertical-align: middle" />
					</span>
				</el-divider>

				<!-- 高级设置备注 -->
				<div v-if="drawerMode === 'config' || form.advanced" class="advanced-remark">
					<el-icon class="advanced-remark__icon"><ele-InfoFilled /></el-icon>
					<span>高级设置：默认未设置时使用 JMX 脚本中的配置。修改高级设置中的参数配置，会覆盖 JMX 脚本中已设置的参数配置，请留意。</span>
				</div>

				<template v-if="drawerMode === 'config' || form.advanced">
					<!-- 线程数 -->
					<el-form-item prop="threads">
						<template #label>
							<span class="label-txt"><span class="label-star">*</span>线程数</span>
							<el-tooltip content="并发用户数，即单节点同时运行的虚拟线程数量" placement="top">
								<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
							</el-tooltip>
						</template>
						<div class="input-with-unit">
							<el-input-number
								v-model="form.threads"
								:min="1"
								:max="10000"
								:precision="0"
								:step="1"
								placeholder="并发线程数，如100"
								style="width: 100%"
								controls-position="right"
							/>
							<span class="unit-placeholder" />
						</div>
					</el-form-item>

					<!-- Ramp-up时间 -->
					<el-form-item prop="ramp_up">
						<template #label>
							<span class="label-txt"><span class="label-star">*</span>Ramp-up 时间</span>
							<el-tooltip content="所有线程全部启动完毕所需的时间（秒），0表示同时启动" placement="top">
								<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
							</el-tooltip>
						</template>
						<div class="input-with-unit">
							<el-input-number
								v-model="form.ramp_up"
								:min="0"
								placeholder="如60"
								style="width: 100%"
								controls-position="right"
							/>
							<span class="unit-label">秒</span>
						</div>
					</el-form-item>

					<!-- 循环次数 -->
					<el-form-item prop="loop_count">
						<template #label>
							<span class="label-txt">循环次数</span>
							<el-tooltip content="每个线程执行测试计划的循环次数；若勾选永远循环，则必须设置持续时间" placement="top">
								<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
							</el-tooltip>
						</template>
						<div class="input-with-unit">
							<el-input-number
								v-model="form.loop_count"
								:min="1"
								:precision="0"
								:step="1"
								:disabled="form.forever"
								placeholder="如10"
								style="width: 100%"
								controls-position="right"
							/>
							<el-checkbox v-model="form.forever" class="unit-checkbox">永远</el-checkbox>
						</div>
					</el-form-item>

					<!-- 持续时间（永远时显示，必填） -->
					<el-form-item v-if="form.forever" prop="duration">
						<template #label>
							<span class="label-txt"><span class="label-star">*</span>持续时间</span>
							<el-tooltip content="压测持续运行的时间（秒），勾选永远循环时必须大于 0" placement="top">
								<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
							</el-tooltip>
						</template>
						<div class="input-with-unit">
							<el-input-number
								v-model="form.duration"
								:min="1"
								placeholder="如 3600（至少 1 秒）"
								style="width: 100%"
								controls-position="right"
							/>
							<span class="unit-label">秒</span>
						</div>
					</el-form-item>

					<!-- 启动延迟 -->
					<el-form-item prop="start_delay">
						<template #label>
							<span class="label-txt">启动延迟</span>
							<el-tooltip content="压测任务启动前的延迟等待时间（秒）" placement="top">
								<el-icon class="label-tip-icon"><ele-QuestionFilled /></el-icon>
							</el-tooltip>
						</template>
						<div class="input-with-unit">
							<el-input-number
								v-model="form.start_delay"
								:min="0"
								placeholder="如0"
								style="width: 100%"
								controls-position="right"
							/>
							<span class="unit-label">秒</span>
						</div>
					</el-form-item>
				</template>
			</el-form>

			<template #footer>
				<el-button size="default" @click="drawerVisible = false">取 消</el-button>
				<el-button size="default" type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
			</template>
		</el-drawer>
	</div>
</template>

<script setup lang="ts" name="PerformanceScenario">
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus';
import PerfConsole from '../components/PerfConsole.vue';
import MetricChart from '../components/MetricChart.vue';
import SceneDebug from './SceneDebug.vue';
import draggable from 'vuedraggable';

const router = useRouter();
const route = useRoute();

const handleGotoFiles = (row: any) => {
	router.push({ path: '/performance/files', query: { name: row.script_name } });
};

// ======================== 常量 ========================
const ENV_OPTIONS = [
	{ value: 'dev', label: '开发' },
	{ value: 'test', label: '测试' },
	{ value: 'perf', label: '性能' },
	{ value: 'staging', label: '预发布' },
	{ value: 'prod', label: '生产' },
];

const TEST_TYPE_OPTIONS = [
	{ value: 'benchmark', label: '基准测试', tagType: 'info',    desc: '在低压力下，测试系统的性能基线。' },
	{ value: 'load',      label: '负载测试', tagType: 'success', desc: '梯度增加负载，直到达到预定的性能指标。' },
	{ value: 'stress',    label: '压力测试', tagType: 'warning', desc: '施加正常或超出系统预期峰值的负载，检查系统在高并发压力下的性能表现。' },
	{ value: 'spike',     label: '尖峰测试', tagType: 'danger',  desc: '短时间内突然施加远超正常水平的极端负载或高并发，测试系统的弹性恢复能力。' },
];

const testTypeLabel = (v: string) => TEST_TYPE_OPTIONS.find(t => t.value === v)?.label ?? '--';
const testTypeTagType = (v: string): '' | 'success' | 'warning' | 'danger' | 'info' =>
	(TEST_TYPE_OPTIONS.find(t => t.value === v)?.tagType ?? '') as any;

// 模拟 JMX 脚本列表（来自文件管理模块已上传的 JMX 文件）
const jmxScripts = [
	{ id: 11, name: 'login_stress.jmx' },
	{ id: 12, name: 'order_stress.jmx' },
	{ id: 13, name: 'search_perf.jmx' },
];

// ======================== 工具函数 ========================
const formatDateTime = (val: string) => {
	if (!val) return '--';
	return val.replace('T', ' ').substring(0, 19);
};

const formatDuration = (seconds: number) => {
	if (!seconds) return '--';
	if (seconds < 3600) return `${seconds}s`;
	if (seconds < 86400) {
		const h = Math.floor(seconds / 3600);
		const m = Math.floor((seconds % 3600) / 60);
		return m > 0 ? `${h}h ${m}m` : `${h}h`;
	}
	const d = Math.floor(seconds / 86400);
	const h = Math.floor((seconds % 86400) / 3600);
	const m = Math.floor((seconds % 3600) / 60);
	let result = `${d}天`;
	if (h > 0) result += ` ${h}h`;
	if (m > 0) result += ` ${m}m`;
	return result;
};

const envLabel = (env: string) => ENV_OPTIONS.find(o => o.value === env)?.label ?? env;

const envTagType = (env: string): '' | 'success' | 'warning' | 'danger' | 'info' => {
	const map: Record<string, '' | 'success' | 'warning' | 'danger' | 'info'> = {
		dev: '', test: 'warning', perf: 'danger', staging: 'info', prod: 'success',
	};
	return map[env] ?? '';
};

const statusLabel = (status: string) => {
	const map: Record<string, string> = {
		pending: '待开始', running: '进行中', completed: '已完成', cancelled: '已取消', failed: '失败',
	};
	return map[status] ?? status;
};

const statusTagType = (status: string): '' | 'success' | 'warning' | 'danger' | 'info' => {
	const map: Record<string, '' | 'success' | 'warning' | 'danger' | 'info'> = {
		pending: 'warning', running: '', completed: 'success', cancelled: 'info', failed: 'danger',
	};
	return map[status] ?? '';
};

const progressColor = (status: string) => {
	const map: Record<string, string> = {
		running: '#409eff', completed: '#67c23a', failed: '#f56c6c', cancelled: '#909399',
	};
	return map[status] ?? '#409eff';
};

// ======================== 列表 ========================
const activeTab = ref('list');
const loading = ref(false);
const tableRef = ref();
const sceneList = ref<any[]>([]);
const total = ref(0);
const selectedRows = ref<any[]>([]);

const query = reactive({
	name: '',
	scene_no: '',
	script_name: undefined as string | undefined,
	status: undefined as string | undefined,
	test_type: undefined as string | undefined,
	created_by: '',
	page: 1,
	page_size: 10,
});

let nextId = 5;
let configNextId = 100;
const mockData: any[] = [
	{
		id: 1, scene_no: 'JMX00000001', name: '登录接口压测-v1',
		script_name: 'login_stress.jmx', script_id: 11,
		ref_files: ['user_data_10w.csv', 'token_list.csv'],
		env: 'perf', status: 'running', progress: 65, started_at: '2026-04-10T10:05:00',
		estimated_duration: 1800, error_msg: '', test_type: 'load', remark: '每日高峰期登录压测',
		created_at: '2026-04-08T10:00:00', created_by: 'admin',
		configs: [
			{ id: 11, active: true, distributed: true, worker_count: 3, threads: 100, ramp_up: 60, loop_count: 10, forever: false, duration: undefined, start_delay: 0 },
		],
	},
	{
		id: 2, scene_no: 'JMX00000002', name: '订单查询压测',
		script_name: 'order_stress.jmx', script_id: 12,
		ref_files: ['order_ids.csv'],
		env: 'test', status: 'completed', progress: 100, started_at: '2026-04-07T16:00:00',
		estimated_duration: 3600, error_msg: '', test_type: 'stress', remark: '',
		created_at: '2026-04-07T15:30:00', created_by: 'admin',
		configs: [
			{ id: 21, active: true, distributed: false, worker_count: 1, threads: 50, ramp_up: 30, loop_count: 5, forever: false, duration: undefined, start_delay: 0 },
		],
	},
	{
		id: 3, scene_no: 'JMX00000003', name: '全链路压测场景',
		script_name: 'search_perf.jmx', script_id: 13,
		ref_files: [],
		env: 'staging', status: 'failed', progress: 38, started_at: '2026-04-06T09:30:00',
		estimated_duration: 7200, error_msg: 'Connection refused: jmeter-slave-2:1099', test_type: 'spike', remark: '模拟大促流量尖峰',
		created_at: '2026-04-06T09:00:00', created_by: 'tester',
		configs: [
			{ id: 31, active: true, distributed: true, worker_count: 2, threads: 200, ramp_up: 120, loop_count: 1, forever: false, duration: undefined, start_delay: 10 },
		],
	},
	{
		id: 4, scene_no: 'JMX00000004', name: '搜索接口基准测试',
		script_name: 'search_perf.jmx', script_id: 13,
		ref_files: ['search_keywords.csv'],
		env: 'dev', status: 'cancelled', progress: 22, started_at: '2026-04-05T14:30:00',
		estimated_duration: 90000, error_msg: '', test_type: 'benchmark', remark: '建立性能基线',
		created_at: '2026-04-05T14:20:00', created_by: 'admin',
		configs: [
			{ id: 41, active: true, distributed: false, worker_count: 1, threads: 20, ramp_up: 10, loop_count: 3, forever: false, duration: undefined, start_delay: 0 },
		],
	},
	{
		id: 5, scene_no: 'JMX00000005', name: '支付接口压测',
		script_name: 'payment_scenario.jmx', script_id: 14,
		ref_files: [],
		env: 'perf', status: 'pending', progress: 0,
		estimated_duration: 3600, error_msg: '', test_type: 'load', remark: '',
		created_at: '2026-04-10T08:00:00', created_by: 'admin',
		configs: [
			{ id: 51, active: true, distributed: false, worker_count: 1, threads: undefined, ramp_up: undefined, loop_count: undefined, forever: false, duration: undefined, start_delay: 0 },
		],
	},
];

const hasRunningTask = computed(() => mockData.some(r => r.status === 'running'));

const handleQuery = () => {
	loading.value = true;
	setTimeout(() => {
		let data = [...mockData];
		if (query.name) data = data.filter(r => r.name.includes(query.name));
		if (query.scene_no) data = data.filter(r => r.scene_no.includes(query.scene_no));
		if (query.script_name) data = data.filter(r => r.script_name === query.script_name);
		if (query.status) data = data.filter(r => r.status === query.status);
		if (query.test_type) data = data.filter(r => r.test_type === query.test_type);
		if (query.created_by) data = data.filter(r => r.created_by.includes(query.created_by));
		total.value = data.length;
		const start = (query.page - 1) * query.page_size;
		sceneList.value = data.slice(start, start + query.page_size);
		loading.value = false;
	}, 200);
};

const resetQuery = () => {
	query.name = '';
	query.scene_no = '';
	query.script_name = undefined;
	query.status = undefined;
	query.test_type = undefined;
	query.created_by = '';
	query.page = 1;
	handleQuery();
};

const handleSelectionChange = (rows: any[]) => {
	if (rows.length > 1) {
		const latest = rows[rows.length - 1];
		rows.slice(0, -1).forEach(r => tableRef.value?.toggleRowSelection(r, false));
		selectedRows.value = [latest];
	} else {
		selectedRows.value = rows;
	}
};

// ======================== 刷新状态 ========================
const statusRefreshing = ref(false);

const handleRefreshStatus = () => {
	statusRefreshing.value = true;
	setTimeout(() => {
		statusRefreshing.value = false;
		handleQuery();
		ElMessage.success('执行状态已刷新');
	}, 800);
};

// ======================== 脚本联调 ========================
const debugDrawerVisible = ref(false);
const debugScene = ref<any>(null);

const handleDebug = () => {
	const row = selectedRows.value[0];
	if (!row) return;
	debugScene.value = row;
	debugDrawerVisible.value = true;
};

const handleDebugConfirm = (scene: any) => {
	// 联调核实通过后直接启动压测
	handleStartRow(scene);
};

// ======================== 启动 / 停止 ========================
const handleStartSelected = () => {
	if (selectedRows.value.length !== 1) return;
	handleStartRow(selectedRows.value[0]);
};

const handleStartRow = (row: any) => {
	if (hasRunningTask.value) {
		ElMessage.warning('当前已有压测任务正在运行，请等待完成或停止后再启动');
		return;
	}
	const item = mockData.find(r => r.id === row.id);
	if (item) {
		item.status = 'running';
		item.progress = 0;
		item.error_msg = '';
	}
	handleQuery();
	monitorScene.value = mockData.find(r => r.id === row.id) ?? row;
	activeTab.value = 'console';
	startMockConsole(row);
	ElMessage.success(`「${row.name}」已启动压测`);
};

const handleStopTask = (row: any) => {
	ElMessageBox.confirm(
		`确认立即停止「${row.name}」的压测任务？`,
		'立即停止',
		{ type: 'warning', confirmButtonText: '立即停止', cancelButtonText: '取消', confirmButtonClass: 'el-button--danger' }
	).then(() => {
		const item = mockData.find(r => r.id === row.id);
		if (item) item.status = 'cancelled';
		handleQuery();
		ElMessage.success('压测任务已停止');
	}).catch(() => {});
};

// ======================== 查看报告 ========================
const handleViewReport = (row?: any) => {
	if (row) {
		router.push({ path: '/performance/report', query: { scene_no: row.scene_no } });
	} else {
		router.push({ path: '/performance/report' });
	}
};

// ======================== 恢复执行 ========================
const handleRecover = (row: any) => {
	if (hasRunningTask.value) {
		ElMessage.warning('当前已有压测任务正在运行，无法恢复执行');
		return;
	}
	const item = mockData.find(r => r.id === row.id);
	if (item) {
		item.status = 'running';
		item.error_msg = '';
	}
	handleQuery();
	ElMessage.success(`「${row.name}」已恢复执行`);
};

// ======================== 删除 ========================
const handleDelete = (row: any) => {
	if (row.status === 'running') {
		ElMessage.warning('压测任务进行中，不支持删除');
		return;
	}
	ElMessageBox.confirm(
		`确认删除压测场景「${row.name}」？`,
		'删除确认',
		{ type: 'warning', confirmButtonText: '确认删除', cancelButtonText: '取消', confirmButtonClass: 'el-button--danger' }
	).then(() => {
		const idx = mockData.findIndex(r => r.id === row.id);
		if (idx > -1) mockData.splice(idx, 1);
		handleQuery();
		ElMessage.success('删除成功');
	}).catch(() => {});
};

// ======================== 控制台模拟输出 ========================
const consoleLogs = ref<{ time: string; text: string; level: string }[]>([]);
const monitorScene = ref<any>(null);

// ======================== 实时监控指标看板 ========================
const monitorDark = ref(true);
const expandVisible = ref(false);
const expandConfig = ref<{ title: string; unit: string; series: any[]; timeLabels: string[] } | null>(null);
const errorsExpandVisible = ref(false);

// 生成最近 16 分钟的时间轴标签
const _now = new Date();
const monitorTimeLabels = Array.from({ length: 16 }, (_, i) => {
	const t = new Date(_now.getTime() - (15 - i) * 60000);
	return `${t.getHours().toString().padStart(2, '0')}:${t.getMinutes().toString().padStart(2, '0')}`;
});

const monitorMetrics = ref([
	{
		title: 'QPS',
		unit: '次/秒',
		series: [
			{ name: 'jmeter-slave-1', data: [235, 248, 261, 243, 278, 312, 328, 341, 319, 302, 287, 295, 315, 338, 351, 344] },
			{ name: 'jmeter-slave-2', data: [198, 212, 225, 207, 241, 275, 289, 298, 281, 264, 249, 258, 277, 301, 314, 308] },
		],
	},
	{
		title: '平均响应时间（RT）',
		unit: 'ms',
		series: [
			{ name: 'jmeter-slave-1', data: [42, 45, 48, 44, 52, 68, 74, 79, 72, 65, 58, 61, 71, 78, 83, 81] },
			{ name: 'jmeter-slave-2', data: [38, 41, 44, 40, 47, 62, 68, 72, 66, 59, 53, 56, 64, 71, 76, 74] },
		],
	},
	{
		title: '并发线程数',
		unit: '个',
		series: [
			{ name: 'jmeter-slave-1', data: [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100] },
			{ name: 'jmeter-slave-2', data: [80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80] },
		],
	},
	{
		title: '错误率',
		unit: '%',
		series: [
			{ name: 'jmeter-slave-1', data: [0, 0, 0.1, 0, 0.2, 1.8, 2.1, 2.4, 2.0, 1.5, 0.9, 1.1, 1.8, 2.2, 2.5, 2.3] },
			{ name: 'jmeter-slave-2', data: [0, 0, 0, 0, 0.1, 1.5, 1.8, 2.1, 1.7, 1.2, 0.7, 0.9, 1.5, 1.9, 2.2, 2.0] },
		],
	},
]);

const top5Errors = [
	{
		sampler: 'HTTP请求-用户登录接口 /api/v2/auth/login',
		samples: 3500,
		errors: 156,
		top: [
			{ error: 'java.net.ConnectException: Connection refused: connect to 192.168.10.55:8080', count: 89 },
			{ error: 'HTTP/1.1 500 Internal Server Error - NullPointerException in AuthService.validate()', count: 45 },
			{ error: 'java.net.SocketTimeoutException: Read timed out after 30000ms waiting for response', count: 14 },
			{ error: 'HTTP/1.1 429 Too Many Requests - Rate limit exceeded for endpoint /auth/login', count: 8 },
			null,
		],
	},
	{
		sampler: 'HTTP请求-分页查询商品数据列表 /api/v2/product/page',
		samples: 4200,
		errors: 89,
		top: [
			{ error: 'HTTP/1.1 503 Service Unavailable - Upstream product-service is temporarily down', count: 52 },
			{ error: 'java.net.ConnectException: Connection refused: no available instance in registry', count: 22 },
			{ error: 'HTTP/1.1 504 Gateway Timeout - Product query exceeded 60s threshold', count: 15 },
			null, null,
		],
	},
	{
		sampler: 'HTTP请求-创建并提交购物车订单 /api/v2/order/submit',
		samples: 2800,
		errors: 67,
		top: [
			{ error: 'java.net.SocketTimeoutException: Read timed out after 45000ms - DB connection pool exhausted', count: 35 },
			{ error: 'HTTP/1.1 500 Internal Server Error - DeadlockLoserDataAccessException in OrderService', count: 18 },
			{ error: 'HTTP/1.1 503 Service Unavailable - Inventory service circuit breaker open', count: 14 },
			null, null,
		],
	},
	{
		sampler: 'HTTP请求-查询用户收货地址与订单详情 /api/v2/order/detail',
		samples: 3100,
		errors: 34,
		top: [
			{ error: 'HTTP/1.1 503 Service Unavailable - address-service unhealthy in nacos registry', count: 20 },
			{ error: 'java.net.ConnectException: Failed to connect Redis cluster node 192.168.10.88:6379', count: 14 },
			null, null, null,
		],
	},
	{
		sampler: 'HTTP请求-获取系统全局配置项 /api/v2/config/global',
		samples: 1500,
		errors: 22,
		top: [
			{ error: 'HTTP/1.1 404 Not Found - Config key "feature.payment.v3" does not exist in namespace', count: 22 },
			null, null, null, null,
		],
	},
];

const handleChartExpand = (cfg: { title: string; unit: string; series: any[]; timeLabels: string[] }) => {
	expandConfig.value = cfg;
	expandVisible.value = true;
};

const startMockConsole = (row: any) => {
	consoleLogs.value = [];
	const logs = [
		{ level: 'info', text: `[JMeter] 初始化压测任务：${row.name}` },
		{ level: 'info', text: `[JMeter] 加载脚本：${row.script_name}` },
		{ level: 'info', text: `[JMeter] 线程数：${row.threads}，Ramp-up：${row.ramp_up}s` },
		{ level: 'success', text: '[JMeter] 脚本加载完成，开始执行...' },
		{ level: 'info', text: '[Worker-1] 连接成功 192.168.1.101:1099' },
		{ level: 'info', text: '[Worker-2] 连接成功 192.168.1.102:1099' },
		{ level: 'success', text: '[JMeter] 所有Worker节点就绪，启动并发线程' },
		{ level: 'info', text: '[Thread-1] 开始执行 HTTP 请求...' },
		{ level: 'info', text: '[Thread-2] 开始执行 HTTP 请求...' },
		{ level: 'warn', text: '[Thread-5] 响应时间超过阈值：2350ms' },
	];
	logs.forEach((log, i) => {
		setTimeout(() => {
			const now = new Date();
			const time = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}`;
			consoleLogs.value.push({ time, text: log.text, level: log.level });
		}, i * 600);
	});
};

// ======================== 新增 / 编辑 抽屉 ========================
const drawerVisible = ref(false);
const drawerTitle = ref('新增压测场景');
const drawerMode = ref<'full' | 'config'>('full');  // full=新增/修改全字段, config=仅编辑配置参数
const submitLoading = ref(false);
const formRef = ref<FormInstance>();
const editId = ref<number | null>(null);        // scenario id (full mode)
const editConfigId = ref<number | null>(null);  // config id (config mode)

const defaultForm = () => ({
	name: '',
	script_id: undefined as number | undefined,
	test_type: undefined as string | undefined,
	remark: '',
	distributed: false,
	worker_count: 2,
	env: undefined as string | undefined,
	advanced: false,
	threads: undefined as number | undefined,
	ramp_up: undefined as number | undefined,
	loop_count: undefined as number | undefined,
	forever: false,
	duration: undefined as number | undefined,
	start_delay: 0,
});

const form = reactive(defaultForm());

const formRules = {
	name: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
	script_id: [{ required: true, message: '请选择JMX脚本', trigger: 'change' }],
	worker_count: [{ required: true, message: '请输入Worker数量', trigger: 'blur' }],
	env: [{ required: true, message: '请选择运行环境', trigger: 'change' }],
	threads: [{ required: true, message: '请输入线程数', trigger: 'blur' }],
	ramp_up: [{ required: true, message: '请输入 Ramp-up 时间', trigger: 'blur' }],
	duration: [{
		validator: (_rule: any, value: any, callback: (e?: Error) => void) => {
			if (form.forever) {
				if (value === undefined || value === null) {
					callback(new Error('勾选永远循环时，持续时间必填'));
				} else if (value < 1) {
					callback(new Error('持续时间必须大于 0（至少 1 秒）'));
				} else {
					callback();
				}
			} else {
				callback();
			}
		},
		trigger: ['blur', 'change'],
	}],
};

const openDrawer = (type: 'add' | 'edit', row?: any) => {
	resetForm();
	drawerMode.value = 'full';
	if (type === 'edit' && row) {
		drawerTitle.value = '修改压测场景';
		editId.value = row.id;
		Object.assign(form, {
			name: row.name,
			script_id: row.script_id,
			test_type: row.test_type,
			remark: row.remark ?? '',
			distributed: row.distributed,
			worker_count: row.worker_count,
			env: row.env,
			advanced: row.advanced,
			threads: row.threads,
			ramp_up: row.ramp_up,
			loop_count: row.loop_count,
			forever: row.forever,
			duration: row.duration,
			start_delay: row.start_delay,
		});
	} else {
		drawerTitle.value = '新增压测场景';
		editId.value = null;
	}
	drawerVisible.value = true;
};

// 复制场景：进入新增弹窗并回显被复制行的数据
const handleCopyScene = (row: any) => {
	resetForm();
	drawerMode.value = 'full';
	drawerTitle.value = '新增压测场景';
	editId.value = null;
	const activeConfig = row.configs?.find((c: any) => c.active) ?? row.configs?.[0];
	Object.assign(form, {
		name: `${row.name}-副本`,
		script_id: row.script_id,
		test_type: row.test_type,
		remark: row.remark ?? '',
		distributed: row.distributed ?? activeConfig?.distributed ?? false,
		worker_count: row.worker_count ?? activeConfig?.worker_count ?? 2,
		env: row.env,
		advanced: !!(activeConfig?.threads),
		threads: activeConfig?.threads,
		ramp_up: activeConfig?.ramp_up,
		loop_count: activeConfig?.loop_count,
		forever: activeConfig?.forever ?? false,
		duration: activeConfig?.duration,
		start_delay: activeConfig?.start_delay ?? 0,
	});
	drawerVisible.value = true;
};
const openConfigDrawer = (row: any, cfg: any) => {
	resetForm();
	drawerMode.value = 'config';
	drawerTitle.value = '编辑压测配置';
	editId.value = row.id;
	editConfigId.value = cfg.id;
	Object.assign(form, {
		distributed: cfg.distributed,
		worker_count: cfg.worker_count,
		threads: cfg.threads,
		ramp_up: cfg.ramp_up,
		loop_count: cfg.loop_count,
		forever: cfg.forever,
		duration: cfg.duration,
		start_delay: cfg.start_delay,
	});
	drawerVisible.value = true;
};

// 子列表"复制"：在同场景下新增一条 config 行
const handleCopyConfig = (row: any, cfg: any) => {
	row.configs.push({
		id: configNextId++,
		active: false,
		distributed: cfg.distributed,
		worker_count: cfg.worker_count,
		threads: cfg.threads,
		ramp_up: cfg.ramp_up,
		loop_count: cfg.loop_count,
		forever: cfg.forever,
		duration: cfg.duration,
		start_delay: cfg.start_delay,
	});
	ElMessage.success('配置已复制');
};

// 状态开关互斥：同场景下只允许一条 config 激活
const handleConfigActiveChange = (row: any, activated: any) => {
	if (activated.active) {
		row.configs.forEach((c: any) => {
			if (c.id !== activated.id) c.active = false;
		});
	}
};

const resetForm = () => {
	formRef.value?.resetFields();
	Object.assign(form, defaultForm());
	editId.value = null;
	editConfigId.value = null;
};

const handleScriptChange = (id: number) => {
	const script = jmxScripts.find(s => s.id === id);
	if (script && !form.name) {
		form.name = script.name.replace('.jmx', '') + '-压测';
	}
};

const handleSubmit = () => {
	formRef.value?.validate((valid) => {
		if (!valid) return;
		submitLoading.value = true;
		setTimeout(() => {
			const script = jmxScripts.find(s => s.id === form.script_id);
			if (drawerMode.value === 'config') {
				// config mode: update the specific config row inside the scenario
				const scenario = mockData.find(r => r.id === editId.value);
				const cfg = scenario?.configs?.find((c: any) => c.id === editConfigId.value);
				if (cfg) {
					Object.assign(cfg, {
						distributed: form.distributed,
						worker_count: form.worker_count,
						threads: form.threads,
						ramp_up: form.ramp_up,
						loop_count: form.loop_count,
						forever: form.forever,
						duration: form.duration,
						start_delay: form.start_delay,
					});
				}
				ElMessage.success('配置已更新');
			} else if (editId.value) {
				// full mode edit: update scenario (keep existing configs)
				const item = mockData.find(r => r.id === editId.value);
				if (item) {
					Object.assign(item, {
						name: form.name,
						script_id: form.script_id,
						script_name: script?.name ?? '',
						test_type: form.test_type,
						remark: form.remark,
						distributed: form.distributed,
						worker_count: form.worker_count,
						env: form.env,
					});
				}
				ElMessage.success('修改成功');
			} else {
				// add new scenario with one default config
				const newId = nextId++;
				mockData.unshift({
					id: newId,
					scene_no: `JMX${String(newId).padStart(8, '0')}`,
					name: form.name,
					script_id: form.script_id,
					script_name: script?.name ?? '',
					env: form.env,
					ref_files: [],
					status: 'cancelled',
					progress: 0,
					estimated_duration: 0,
					error_msg: '',
					test_type: form.test_type,
					remark: form.remark,
					created_at: new Date().toISOString(),
					created_by: 'admin',
					configs: [{
						id: configNextId++,
						active: true,
						distributed: form.distributed,
						worker_count: form.worker_count,
						threads: form.threads,
						ramp_up: form.ramp_up,
						loop_count: form.loop_count,
						forever: form.forever,
						duration: form.duration,
						start_delay: form.start_delay,
					}],
				});
				ElMessage.success('新增成功');
			}
			submitLoading.value = false;
			drawerVisible.value = false;
			handleQuery();
		}, 400);
	});
};

// ======================== 初始化 ========================
onMounted(() => {
	if (route.query.scene_no) {
		query.scene_no = route.query.scene_no as string;
	}
	handleQuery();
	// 自动显示正在运行中的场景
	const running = mockData.find(r => r.status === 'running');
	if (running) monitorScene.value = running;
});
</script>

<style scoped lang="scss">
.perf-scene-container {
	// 外间距：上/左/右缩减一半，下保留
	padding: 10px 10px 20px 10px;

	// 卡片内间距：上/左/右缩减一半，下保留
	:deep(.el-card__body) {
		padding: 10px 10px 20px 10px;
	}

	.scene-tabs {
		:deep(.el-tabs__header) {
			margin-top: -8px;
		}
	}

	// 隐藏列表表头的全选复选框，不支持多选
	:deep(.el-table__header th.el-table-column--selection .cell) {
		display: none;
	}

	:deep(.el-button > span) {
		display: inline-flex !important;
		align-items: center !important;
		line-height: 1 !important;
	}

	:deep(.el-input__inner),
	:deep(.el-textarea__inner) {
		font-size: 13.5px;
	}

	:deep(.el-select__placeholder),
	:deep(.el-select__selected-item) {
		font-size: 13.5px;
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
		}

		// 带 ? 图标的表头：禁止折行，文字与图标水平对齐
		.el-table__header th .cell {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			white-space: nowrap;
		}

		.el-table__cell {
			padding: 11px 0;
		}

		td.operation-col {
			background-color: #f0f2f5 !important;
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

	// 展开行背景 — el-table__expanded-cell 自带白色 padding，需清除
	:deep(.el-table__expanded-cell) {
		padding: 0 !important;
		background-color: #f9fafc !important;
	}

	// 展开行详情
	.expand-detail {
		// 选择列45px + 展开列40px = 85px，与展开列右侧竖线对齐
		padding: 8px 0 8px 85px;
		background: #f9fafc;

		.expand-table {
			width: 100%;
			border-collapse: collapse;
			font-size: 13px;
			table-layout: fixed;

			th, td {
				border: 1px solid #e4e7ed;
				padding: 7px 14px;
				text-align: center;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}

			// 首列（状态开关）固定宽度
			th:first-child,
			td:first-child {
				width: 140px;
				min-width: 140px;
			}

			thead th {
				color: var(--el-table-header-text-color, #909399);
				font-weight: 600;
				font-size: 13px;
			}

			tbody td {
				background: #fff;
				color: #303133;
			}

			// 最后一列（操作）锁定右侧，与父表操作列对齐
			th:last-child,
			td:last-child {
				position: sticky;
				right: 0;
				z-index: 2;
				width: 260px;
				min-width: 260px;
			}

			th:last-child {
				background: #f0f2f5;
				box-shadow: -2px 0 6px -1px rgba(0, 21, 41, 0.1);
			}

			td:last-child {
				background: #f0f2f5 !important;
				box-shadow: -2px 0 6px -1px rgba(0, 21, 41, 0.1);
			}
		}
	}

	.toolbar {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 10px;
		margin-bottom: 16px;

		// 搜索框区：内部允许换行，宽度由内容撑开
		.toolbar-filters {
			display: flex;
			align-items: center;
			gap: 10px;
			flex-wrap: wrap;
			flex-shrink: 0;
		}

		// 查询/重置：宽屏时紧跟搜索框，窄屏换行后靠左
		.toolbar-query-btns {
			display: flex;
			align-items: center;
			gap: 10px;
			flex-shrink: 0;
		}

		// 操作按钮：始终靠右（margin-left:auto 在任何行上都把它推到最右）
		.toolbar-right {
			display: flex;
			align-items: center;
			gap: 10px;
			margin-left: auto;

			// 脚本联调按钮：黄褐色背景标识
			.btn-debug {
				background-color: #c07828;
				border-color: #c07828;
				color: #fff;

				&:hover, &:focus {
					background-color: #d08a35;
					border-color: #d08a35;
					color: #fff;
				}

				&.is-disabled {
					background-color: #ddb87a;
					border-color: #ddb87a;
					color: #fff;
				}
			}
		}
	}

	.progress-cell {
		display: flex;
		align-items: center;
		gap: 6px;
		padding: 0 6px;

		.progress-bar {
			flex: 1;
			min-width: 0;
		}

		.progress-suffix {
			font-size: 13px;
			font-weight: 700;
			flex-shrink: 0;
			line-height: 1;
		}
	}

	.script-link {
		color: var(--el-color-primary);
		cursor: pointer;
		font-size: 13.5px;

		&:hover {
			text-decoration: underline;
		}
	}

	.error-text {
		color: var(--el-color-danger);
		font-size: 13px;
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
			white-space: nowrap;

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

	// ---- 实时监控 Tab ----
	.monitor-empty {
		padding: 80px 0;
		display: flex;
		justify-content: center;
	}

	.monitor-progress-section {
		padding: 6px 0 8px;
		border-bottom: 1px solid var(--el-border-color-light);
		margin-bottom: 8px;

		.monitor-progress-header {
			display: flex;
			align-items: center;
			margin-bottom: 5px;

			.monitor-scene-name {
				font-size: 14px;
				font-weight: 600;
				color: var(--el-text-color-primary);
			}
		}

		.monitor-progress-bar-row {
			display: flex;
			align-items: center;
			gap: 12px;

			.monitor-progress-bar {
				flex: 1;
			}

			.monitor-progress-suffix {
				flex-shrink: 0;
				width: 52px;
				display: flex;
				align-items: center;
				justify-content: center;
			}
		}
	}

	.monitor-body {
		display: flex;
		gap: 14px;

		.monitor-console-wrap {
			flex: 0 0 60%;
			min-width: 0;
		}

		.monitor-metrics-wrap {
			flex: 1;
			min-width: 0;
			display: flex;
			flex-direction: column;
			gap: 0;

			// 深色模式：标题栏风格与 PerfConsole 统一
			&.metrics-dark {
				.metrics-header {
					background: #111217;
					color: #7ec8e3;
					border-color: #1e2028;

					.theme-toggle-btn {
						color: #7ec8e3 !important;

						&:hover {
							color: #b0dff0 !important;
							background: rgba(255, 255, 255, 0.08) !important;
						}
					}
				}
			}

			.metrics-header {
				display: flex;
				align-items: center;
				justify-content: space-between;
				// 高度与 PerfConsole 标题栏对齐
				padding: 8px 14px;
				font-size: 13.5px;
				font-weight: 600;
				color: var(--el-text-color-primary);
				background: var(--el-fill-color-light);
				border: 1px solid var(--el-border-color);
				border-radius: 6px;
				flex-shrink: 0;

				span {
					display: flex;
					align-items: center;
					gap: 6px;
				}

				.theme-toggle-btn {
					color: var(--el-text-color-secondary);

					// 图标加大加粗
					:deep(.el-icon) {
						font-size: 17px !important;
					}
				}
			}

			.metrics-charts-list {
				display: flex;
				flex-direction: column;
				gap: 10px;
				overflow-y: auto;
				padding: 0;
			}
		}
	}

	.monitor-errors-wrap {
		margin-top: 14px;
		border: 1px solid var(--e-border-color);
		border-radius: 8px;
		overflow: hidden;
		background: var(--el-fill-color-blank);

		// CSS 变量定义（亮色模式默认值）
		--e-cell-bg: var(--el-fill-color-blank);
		--e-cell-color: var(--el-text-color-primary);
		--e-header-bg: var(--el-fill-color-light);
		--e-header-color: var(--el-text-color-secondary);
		--e-border-color: var(--el-border-color);
		--e-hover-bg: var(--el-fill-color-light);
		--e-row-alt-bg: var(--el-fill-color-lighter);   // 浅色交替行背景

		&.errors-dark {
			border-color: #32333a;
			background: #181b1f;

			// 深色模式覆盖变量——切换类时自动生效
			--e-cell-bg: #181b1f;
			--e-cell-color: #d8d9da;
			--e-header-bg: #22252b;
			--e-header-color: #9fa7b3;
			--e-border-color: #32333a;
			--e-hover-bg: rgba(255, 255, 255, 0.06);
			--e-row-alt-bg: rgba(255, 255, 255, 0.04);  // 深色交替行背景（微弱区分）

			.errors-header {
				background: #111217;
				color: #7ec8e3;
				border-bottom-color: #1e2028;
			}

			.errors-expand-btn {
				color: #7ec8e3 !important;
				&:hover { color: #b0dff0 !important; background: rgba(255,255,255,0.08) !important; }
			}
		}

		.errors-header {
			position: relative;
			display: flex;
			align-items: center;
			justify-content: center;
			padding: 8px 40px 8px 14px;
			font-size: 13.5px;
			font-weight: 600;
			color: var(--el-text-color-primary);
			background: var(--el-fill-color-light);
			border-bottom: 1px solid var(--el-border-color);
		}

		.errors-header-title {
			display: flex;
			align-items: center;
			gap: 6px;
		}

		.errors-expand-btn {
			position: absolute;
			right: 8px;
			top: 50%;
			transform: translateY(-50%);
			color: var(--el-text-color-secondary) !important;
			&:hover { color: var(--el-text-color-primary) !important; background: var(--el-fill-color-dark) !important; }
		}

		.errors-table-scroll {
			overflow-x: auto;
		}

		// ─── 关键：el-table 在自身元素上定义了所有内置 CSS 变量，父级设置无效。
		// 必须用 :deep() 在 .errors-table 元素上直接覆盖，才能压过 el-table 的默认值。
		:deep(.errors-table) {
			--el-table-border-color: var(--e-border-color);
			--el-table-border: 1px solid var(--e-border-color);
			--el-table-row-hover-bg-color: var(--e-hover-bg);
			--el-table-header-bg-color: var(--e-header-bg);
			--el-table-bg-color: var(--e-cell-bg);
			--el-table-tr-bg-color: var(--e-cell-bg);
			--el-table-text-color: var(--e-cell-color);
			--el-table-header-text-color: var(--e-header-color);
		}

		// 常驻表格主题覆盖（双重保险 !important，防止 el-table 内部高优先级规则干扰）
		:deep(.errors-table td.el-table__cell) {
			background-color: var(--e-cell-bg) !important;
			color: var(--e-cell-color) !important;
			border-bottom-color: var(--e-border-color) !important;
			border-right-color: var(--e-border-color) !important;
		}

		// 浅色模式：偶数行用稍深背景区分
		:deep(.errors-table .el-table__row:nth-child(even) td.el-table__cell) {
			background-color: var(--e-row-alt-bg) !important;
		}

		:deep(.errors-table th.el-table__cell) {
			background-color: var(--e-header-bg) !important;
			color: var(--e-header-color) !important;
			border-bottom-color: var(--e-border-color) !important;
			border-right-color: var(--e-border-color) !important;
			text-align: center !important;
		}

		:deep(.errors-table .hover-row > td.el-table__cell) {
			background-color: var(--e-hover-bg) !important;
		}

		// el-table border 伪元素全覆盖（::before/::after 均使用 --el-table-border-color）
		:deep(.errors-table.el-table--border::before),
		:deep(.errors-table.el-table--border::after),
		:deep(.errors-table.el-table--border .el-table__inner-wrapper::after),
		:deep(.errors-table .el-table__inner-wrapper::before),
		:deep(.errors-table .el-table__border-left-patch),
		:deep(.errors-table .el-table__border-right-patch),
		:deep(.errors-table .el-table__border-bottom-patch) {
			background-color: var(--e-border-color) !important;
		}

		:deep(.errors-table) {
			.total-errors { color: #f56c6c; font-weight: 600; }
			.error-count { color: #e6a23c; }
			.sampler-name {
				display: block;
				white-space: normal;
				word-break: break-all;
				max-width: 240px;
				font-size: 12px;
			}
			.error-msg {
				font-size: 12px;
				white-space: normal;
				word-break: break-all;
				max-width: 280px;
				display: block;
			}
		}
	}
}

// ---- 抽屉表单 ----
.scene-form {
	padding: 24px 20px 0;

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

		// el-tooltip 在 label 中会包一层 trigger span，需设为 flex 保证图标居中
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

	:deep(.el-input__inner::placeholder),
	:deep(.el-input-number .el-input__inner::placeholder),
	:deep(.el-textarea__inner::placeholder) {
		font-size: 12px;
	}

	:deep(.el-select__placeholder) {
		font-size: 12px;
	}

	:deep(.el-divider__text) {
		font-size: 13px;
		color: #606266;
	}

	:deep(.el-divider) {
		margin-top: 36px;
		margin-bottom: 36px;
	}

	.divider-advanced {
		font-size: 13px;
		color: #606266;
		display: flex;
		align-items: center;
	}

	.advanced-remark {
		display: flex;
		align-items: flex-start;
		gap: 6px;
		margin: 4px 58px 32px 130px;
		padding: 10px 14px;
		background: #f0f7ff;
		border: 1px solid #cce0ff;
		border-radius: 4px;
		font-size: 12px;
		color: #4a6fa5;
		line-height: 1.7;

		.advanced-remark__icon {
			flex-shrink: 0;
			margin-top: 2px;
			font-size: 13.5px;
			color: #409eff;
		}
	}

	.input-with-unit {
		display: flex;
		align-items: center;
		width: 100%;
		gap: 8px;

		.unit-label {
			color: #606266;
			font-size: 13.5px;
			flex-shrink: 0;
			min-width: 50px;
		}

		.unit-placeholder {
			flex-shrink: 0;
			min-width: 50px;
		}

		.unit-checkbox {
			flex-shrink: 0;
			white-space: nowrap;
		}
	}
}
</style>

<style lang="scss">
/* 按钮内 slot wrapper span 设为 flex，使图标与文字垂直居中 */
.perf-scene-container .el-button > span {
	display: inline-flex !important;
	align-items: center !important;
	line-height: 1 !important;
}

// 抽屉底部按钮区域间距（drawer 传送至 body，需非 scoped 规则）
.el-drawer.perf-scene-drawer .el-drawer__footer {
	padding: 16px 24px;
	border-top: 1px solid #e4e7ed;
	display: flex;
	justify-content: flex-end;
	gap: 12px;
}

// 测试类型下拉选项样式（teleport 到 body，需非 scoped）
.test-type-select-dropdown {
	.el-select-dropdown__item {
		height: auto !important;
		padding: 8px 12px;
		line-height: 1.4;
	}

	.test-type-option {
		display: flex;
		flex-direction: column;

		.test-type-name {
			font-size: 13px;
			font-weight: 500;
			color: var(--el-text-color-primary);
		}

		.test-type-desc {
			font-size: 12px;
			color: var(--el-text-color-secondary);
			margin-top: 3px;
			white-space: normal;
			line-height: 1.5;
		}
	}
}

/* 图表拖拽排序 */
.metric-drag-ghost { opacity: 0.25; }
.metric-drag-chosen { opacity: 0.9; box-shadow: 0 4px 16px rgba(0,0,0,0.18); }

/* 放大图表弹窗：隐藏头部，仅保留图表内容 */
.expand-chart-dialog {
	.el-dialog__header {
		display: none;
	}
	.el-dialog__body {
		padding: 0 !important;
	}
}

/* errors-expand-drawer 抽屉样式已移至非 scoped 全局块 */
</style>

<style lang="scss">
/* ─── errors-expand-drawer 全局样式（必须非 scoped，因为 el-drawer 使用 teleport） ─── */

/* 亮色：抽屉基础布局 */
.errors-expand-drawer {
  .el-drawer__header {
    position: relative !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    padding: 10px 48px !important;
    margin-bottom: 0 !important;
    border-bottom: 1px solid var(--el-border-color) !important;
    background: var(--el-fill-color-light) !important;
    overflow: visible !important;
  }

  /* El Plus 给 header > :first-child 设了 flex:1，导致文字左对齐；强制居中 */
  .el-drawer__header > :first-child {
    text-align: center !important;
  }

  .el-drawer__close-btn {
    position: absolute !important;
    right: 12px !important;
    top: 50% !important;
    transform: translateY(-50%) !important;
    color: var(--el-text-color-regular) !important;
    font-size: 20px !important;
  }

  .el-drawer__body {
    padding: 0;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }

  .errors-dialog-header-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--el-text-color-primary);
  }

  /* 表格基础样式（亮色） */
  .errors-table-full th.el-table__cell {
    text-align: center !important;
  }
  /* 亮色偶数行背景区分 */
  .errors-table-full .el-table__row:nth-child(even) td.el-table__cell {
    background-color: var(--el-fill-color-lighter) !important;
  }
  .errors-table-full .total-errors { color: #f56c6c; font-weight: 600; }
  .errors-table-full .error-count   { color: #e6a23c; }
  .errors-table-full .sampler-name  {
    display: block; white-space: normal; word-break: break-all; font-size: 12px;
  }
  .errors-table-full .error-msg-full {
    font-size: 12.5px; white-space: normal; word-break: break-all; display: block;
  }
}

/* 深色模式 */
.errors-expand-drawer.errors-expand-dark {
  .el-drawer__header {
    background: #111217 !important;
    border-bottom-color: #1e2028 !important;
  }

  .el-drawer__close-btn {
    color: #9fa7b3 !important;
  }

  .errors-dialog-header-title { color: #d8d9da !important; }

  .el-drawer__body { background: #181b1f; }

  /* el-table 深色变量覆盖 */
  .el-drawer__body {
    --el-table-border-color: #32333a;
    --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.06);
  }

  /* 直接覆盖单元格样式，双重保险 */
  .errors-table-full td.el-table__cell {
    background-color: #181b1f !important;
    color: #d8d9da !important;
    border-bottom-color: #32333a !important;
    border-right-color: #32333a !important;
  }

  /* 深色偶数行背景区分 */
  .errors-table-full .el-table__row:nth-child(even) td.el-table__cell {
    background-color: #1f2128 !important;
  }

  .errors-table-full th.el-table__cell {
    background-color: #22252b !important;
    color: #9fa7b3 !important;
    border-bottom-color: #32333a !important;
    border-right-color: #32333a !important;
    text-align: center !important;
  }

  .errors-table-full .el-table__inner-wrapper::before,
  .errors-table-full .el-table__border-left-patch {
    background-color: #32333a !important;
  }

  .errors-table-full .hover-row > td.el-table__cell {
    background-color: rgba(255, 255, 255, 0.06) !important;
  }
}
</style>