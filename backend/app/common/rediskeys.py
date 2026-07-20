"""
压测模块 Redis Key 统一定义
所有 key 以 lambda 变量形式在此声明，其他模块 import 后直接调用，禁止分散定义。
调用方式：key变量(scenario_id)，返回对应的 Redis key 字符串。
"""

# JMeter 控制台日志 List：存储 SSH 增量读取的 jmeter_nohup.out 日志行
# scenario_id：压测场景主键 ID
_log_key = lambda scenario_id: f'perf:jmeter_log:{scenario_id}'

# jmeter_nohup.out 已读取的行数偏移：存储 int，下次增量读取从该行开始（tail -n +N 的 N）
# scenario_id：压测场景主键 ID
_offset_key = lambda scenario_id: f'perf:jmeter_foffset:{scenario_id}'

# JMeter 进程 PID：存储字符串形式的进程号，用于存活检测（kill -0）和停止（kill -TERM）
# scenario_id：压测场景主键 ID
_pid_key = lambda scenario_id: f'perf:jmeter_pid:{scenario_id}'

# 日志 List 累计裁剪行数：存储 int，从 Redis List 头部已 ltrim 掉的行数，供 monitor_sse 修正客户端 offset
# scenario_id：压测场景主键 ID
_evicted_key = lambda scenario_id: f'perf:jmeter_levicted:{scenario_id}'

# 压测启动阶段最新状态：存储 JSON 字符串，定时任务 Stage1-3 最新一条 stage_start/stage_done 结构化事件，
# 供 monitor_sse 在客户端重连时补发，避免阶段进度条状态丢失
# scenario_id：压测场景主键 ID
_stage_key = lambda scenario_id: f'perf:stage:{scenario_id}'

# 实时指标快照 List（QPS / 平均RT / 并发线程数 / 错误率）：存储 JSON 字符串 List，每项为一个 metric_point：
# {"time": "HH:MM:SS", "threads": int, "labels": {label: {qps_ok, qps_err, avg_rt, err_rate}}}
# scenario_id：压测场景主键 ID
_metric_series_key = lambda scenario_id: f'perf:metric:{scenario_id}'

# result.jtl 已读取的字节偏移：存储 int，SSH 增量 tail jtl 的字节游标，避免重复计数或半行解析
# scenario_id：压测场景主键 ID
_jtl_offset_key = lambda scenario_id: f'perf:jtl_offset:{scenario_id}'

# 按 sampler(label) 累计样本数 Hash：存储 Hash，field = label，value = 累计样本数（int）
# scenario_id：压测场景主键 ID
_label_samples_key = lambda scenario_id: f'perf:label_samples:{scenario_id}'

# 按 sampler(label) 累计错误数 Hash：存储 Hash，field = label，value = 累计错误数（int）
# scenario_id：压测场景主键 ID
_label_errors_key = lambda scenario_id: f'perf:label_errors:{scenario_id}'

# 按 sampler(label) + 错误内容 累计出现次数 Hash：存储 Hash，field = "label\t错误码-错误内容"，value = 出现次数（int）
# scenario_id：压测场景主键 ID
_label_error_detail_key = lambda scenario_id: f'perf:label_error_detail:{scenario_id}'

# Top5 Errors by Sampler 最新快照：存储 JSON 字符串，_recompute_top5 每轮计算后整体覆盖写入，
# monitor_sse 读取后以 top_errors 事件推送前端
# scenario_id：压测场景主键 ID
_top5_key = lambda scenario_id: f'perf:top5:{scenario_id}'

# 上一次有效的 Active 线程数：JMeter summariser 10s 写一次 summary+ 行，LogCollector 5s 轮询一次；
# 无新 summary+ 行时沿用此值写入 metric_point，避免 threads 归零产生锯齿折线
# scenario_id：压测场景主键 ID
_last_threads_key = lambda scenario_id: f'perf:last_threads:{scenario_id}'
