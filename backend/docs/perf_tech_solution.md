# 性能测试技术方案文档

> 本文档覆盖文件上传、下载、替换、删除，以及共享分发、分割分发、清除分发的完整技术方案。
> 重点说明各 MinIO 交互场景下平台机、Master、压力机三者的角色分工，以及单机/分布式模式的差异和方案选择逻辑。

---

## 目录

1. [架构角色说明](#1-架构角色说明)
2. [MinIO 交互方式总览](#2-minio-交互方式总览)
3. [前置配置](#3-前置配置)
4. [文件上传](#4-文件上传)
5. [文件下载（前端）](#5-文件下载前端)
6. [文件替换与删除](#6-文件替换与删除)
7. [共享分发](#7-共享分发)
8. [分割分发](#8-分割分发)
9. [清除分发](#9-清除分发)
10. [SSH 连接机制](#10-ssh-连接机制)
11. [常见问题](#11-常见问题)
12. [SSH 连接测试指南](#12-ssh-连接测试指南)

---

## 1. 架构角色说明

本模块涉及三类机器，概念不同，请勿混淆：

| 角色 | 说明 |
|------|------|
| **平台机** | 部署本测试平台后端服务（FastAPI）的机器。所有业务逻辑、MinIO SDK 调用、SSH 指令均从此处发出 |
| **Master（主控机）** | JMeter 分布式压测的主控节点（machine_type=1）。平台机通过 SSH 连接 Master，由 Master 中继到各 Slave；**单机模式下不存在 Master** |
| **Slave / Worker（压力机）** | 执行 JMeter 压测的节点（machine_type=2 或 3）。文件分发的最终目标机器 |
| **MinIO** | 对象存储，持久化保存所有上传文件（JMX、CSV 等）。可与平台机同机部署，也可单独部署，可经 Cloudflare 等代理暴露公网访问 |

**文件核心状态字段：**

| 字段 | 说明 | 取值 |
|------|------|------|
| `upload_status` | 上传状态 | `0` 上传中 / `1` 已完成 |
| `ref_status` | 是否被 JMX 引用 | `0` 未引用 / `1` 已引用 |
| `dist_status` | 分发状态 | `0` 未分发 / `1` 已共享 / `2` 已分割 |

---

## 2. MinIO 交互方式总览

系统中所有涉及 MinIO 的操作，按**交互主体**和**认证方式**可分为以下几类：

| 编号 | 操作 | 交互主体 | 认证方式 | 触发场景 |
|------|------|---------|---------|---------|
| **SDK-Auth** | 平台机调用 MinIO SDK | 平台机 ↔ MinIO | Authorization 请求头（AWS4-HMAC-SHA256） | 文件上传、压测 JMX 下载、方案C/分割分发的平台机下载 |
| **预签名 PUT** | 前端直传 MinIO | 浏览器 ↔ MinIO | 预签名 PUT URL（X-Amz-Signature 查询参数） | 大文件两阶段直传 |
| **预签名 GET** | 前端直接下载 | 浏览器 ↔ MinIO | 预签名 GET URL | 前端文件下载 |
| **SSH curl/wget** | 压力机/Master 拉取 MinIO | 压力机/Master ↔ MinIO | 预签名 GET URL（SSH 执行命令中携带） | 分发方案A、方案B |

> **关键区别**：使用预签名 URL（X-Amz-Signature 查询参数）时，Cloudflare WAF 的托管规则可能因识别到 S3 签名参数而触发拦截（403）。SDK-Auth 方式使用标准 HTTP Authorization 请求头，不受此影响。因此平台机自身下载 MinIO 文件统一使用 SDK-Auth，不使用预签名 URL。

---

### 2.1 分发方案速查表

共享分发支持 3 个方案（A/B/C），根据网络拓扑自动选择；分割分发始终走方案C逻辑（平台机中转）。

| 方案 | 适用模式 | 下载主体 | MinIO 认证 | 触发条件 |
|-----|---------|---------|-----------|---------|
| **方案A** — 压力机直拉 MinIO | 单机 & 分布式 | 压力机/Slave 自己 | 预签名 URL（SSH curl/wget） | 探测到压力机能直连 MinIO |
| **方案B** — Master 中转 MinIO | **仅分布式** | Master 自己 | 预签名 URL（SSH curl/wget） | 压力机不能直连 MinIO，但 Master 能 |
| **方案C** — 平台机中转 SFTP | **仅单机** | **平台机自己** | **SDK-Auth（流式）** | 单机模式且压力机不能直连 MinIO |
| **分割分发**（无方案字母） | 单机 & 分布式 | **平台机自己** | **SDK-Auth（流式）** | 用户主动选择分割分发 |

> 方案A/B 中，压力机/Master 通过 SSH 命令执行 curl/wget 下载 MinIO 预签名 URL，平台机只发 SSH 指令，不接触文件内容。
>
> 方案C 和分割分发中，平台机使用 MinIO SDK 的流式接口（`get_object` + 1MB 分块）将文件下载到本地临时目录，再通过 SFTP 推送到压力机，全程不使用预签名 URL。

---

## 3. 前置配置

### 3.1 MinIO 连接配置

在 `config.py` 或 `.env` 中配置：

```env
MINIO_ENDPOINT   = 127.0.0.1:9000       # MinIO API 访问地址（IP:端口 或 域名，不含协议头）
MINIO_ACCESS_KEY = minioadmin           # MinIO 登录用户名
MINIO_SECRET_KEY = minioadmin           # MinIO 登录密码
MINIO_BUCKET     = performance          # Bucket 名称（建议不要修改）
MINIO_SECURE     = False                # HTTPS 时改为 True；经 Cloudflare 代理暴露公网时通常为 True
```

**Cloudflare 代理注意事项：**
- 平台机通过 SDK（Authorization 头）访问 MinIO，不受 WAF 预签名 URL 规则影响，正常可用
- 若压力机需要直连 MinIO（方案A），需在 Cloudflare 中将压力机 IP 加入白名单，或关闭对应域名的 WAF 托管规则
- Master 从 MinIO 拉取文件（方案B）同上，Master IP 也需加白

### 3.2 SSH 连接配置（分发功能必需）

```env
SSH_DEFAULT_USER     = root              # 登录 Master/压力机的用户名（建议 root）
SSH_DEFAULT_KEY_PATH = /root/.ssh/id_rsa # 【首选】平台机私钥绝对路径，用于 SSH 登录
SSH_DEFAULT_PASSWORD =                   # 【备用】SSH 密码，私钥认证失败或未配置时自动降级
```

SSH 公钥分发到 Master：
```bash
ssh-copy-id -p <port> root@<Master IP>
```

SSH 公钥分发到所有压力机（多台循环）：
```bash
for i in $(seq 1 n); do
    ssh-copy-id root@jmeter-worker-${i}
done
```

### 3.3 系统参数（参数配置页面维护，实时生效）

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `PROXY_UPLOAD_MAX_BYTES` | `200MB` | 后端代理上传的文件大小上限，超过此值改用预签名直传 |
| `PERF_WORKER_DATA_DIR` | `data/jmeter/` | 压力机上存放数据文件的目录（POSIX 路径） |
| `SHARE_DIST_MAX_WORKERS` | `10` | 共享分发最大并发节点数，方案A/B/C 均受此约束 |
| `CTRL_BANDWIDTH_MBPS` | `500` | 平台机上行带宽（Mbps），仅方案C（平台机中转 SFTP）时生效，用于动态计算并发数 |

### 3.4 文件类型白名单

在「数据字典 → 性能测试数据文件类型（perf_file_type）」中维护允许上传的扩展名，默认支持：`jmx`、`csv`、`txt`、`json`、`yaml`、`jtl`。

---

## 4. 文件上传

### 4.1 小文件代理上传（≤ PROXY_UPLOAD_MAX_BYTES）

**接口**：`POST /v1/performance/files/upload`（multipart/form-data）

```
浏览器 ──multipart──▶ 平台机 ──SDK put_object──▶ MinIO
```

- 平台机接收全部内容后调用 `MinioClient.put_object()` 上传，使用 SDK-Auth
- 校验扩展名白名单 → 校验大小 → 上传 MinIO → 写 DB（upload_status=1）
- object_key 格式：`{file_type}/{yyyyMMdd}/{uuid}_{原始文件名}`

### 4.2 大文件预签名两阶段直传（> PROXY_UPLOAD_MAX_BYTES）

文件内容完全不经过平台机，由浏览器直接推送到 MinIO：

```
① 浏览器 ──请求预签名──▶ 平台机（写 DB 占位 upload_status=0，签发预签名 PUT URL）
② 浏览器 ──PUT 文件──▶ MinIO（直传，URL 有效期 30 分钟，使用预签名认证）
③ 浏览器 ──确认上传──▶ 平台机（stat_object 验证文件实际存在 → upload_status=1）
```

**接口：**
- `POST /v1/performance/files/presign-upload` → `{ file_id, upload_url, object_key }`
- `POST /v1/performance/files/confirm-upload` → 传入 `{ file_id, object_key }`

> ⚠️ 若浏览器上传中途取消且未调用 confirm-upload，DB 中会留有 upload_status=0 的僵尸记录，需定期清理。

### 4.3 单机 vs 分布式差异

上传操作仅在平台机和 MinIO 之间发生，与单机/分布式模式无关，行为完全一致。

---

## 5. 文件下载（前端）

**接口**：`GET /v1/performance/files/{file_id}/download-url`

平台机签发带 `Content-Disposition` 头的预签名 GET URL（有效期 5 分钟），前端直接跳转由浏览器下载，文件内容不经过平台机：

```
浏览器 ──① 请求──▶ 平台机（签发预签名 GET URL）
浏览器 ──② 跳转──▶ MinIO（直接下载）
```

> 此处使用预签名 GET URL，若 MinIO 经 Cloudflare 代理且浏览器的 TLS 指纹被 WAF 识别，可能出现 403。通常浏览器不受影响（User-Agent 非 curl），如遇问题可在 Cloudflare 中对该域名的 GET 请求放行。

下载链接有时效性（5 分钟），不可缓存或分享。

### 单机 vs 分布式差异

与上传相同，文件下载仅在浏览器和 MinIO 之间发生，与部署模式无关。

---

## 6. 文件替换与删除

### 6.1 替换上传

**接口**：`PUT /v1/performance/files/{file_id}/upload`（multipart/form-data）

- 保留原 file_id，JMX 引用关系不中断
- 先删除 MinIO 旧对象，再上传新文件（生成新 object_key），使用 SDK-Auth
- 分发状态重置为未分发，需重新分发

### 6.2 软删除

**接口**：`DELETE /v1/performance/files/{file_id}`

1. MinIO 删除对象（upload_status=1 时，SDK-Auth）
2. DB 记录 enabled_flag=0（软删除，保留历史）

> 已被 JMX 引用或已分发的文件仍可删除，但引用关系和分发记录不会自动清除。

---

## 7. 共享分发

### 7.1 使用场景

将**同一份完整文件**分发到多台压力机，每台机器持有相同副本。

**典型场景：** 通用账号池 CSV、公共配置文件、JMX 参数文件（各机内容相同）。

**前置条件：**
- 文件 upload_status=1
- 压力机 SSH 可达，可用机器数量 ≥ worker_count

---

### 7.2 方案选择决策树

系统在分发前自动探测网络连通性，无需手动选择方案：

```
启动共享分发
  │
  ├─ [单机模式 machine_type=3]
  │     │
  │     ├─ 探测单机压力机能直连 MinIO？
  │     │     ├─ 是 ──▶ 方案A：压力机直拉 MinIO
  │     │     └─ 否 ──▶ 方案C：平台机 SDK 下载 → SFTP 推压力机
  │     │
  │     └─ （无 Master，方案B 不适用）
  │
  └─ [分布式模式 machine_type=2]
        │
        ├─ 探测 Slave 能直连 MinIO？
        │     ├─ 是 ──▶ 方案A：各 Slave 直拉 MinIO（并发）
        │     └─ 否 ──▶ 继续探测 Master 能否直连 MinIO？
        │                   ├─ 是 ──▶ 方案B：Master 拉取后 SCP 到各 Slave
        │                   └─ 否 ──▶ 分发失败（Slave/Master 均无法访问 MinIO）
```

> 分布式模式下方案C**不适用**——Master 可以中继，平台机无需再自己下载。
> 若分布式场景下三方均无法访问 MinIO，需从网络层面解决（如将 Master IP 加 Cloudflare 白名单）。

---

### 7.3 方案A — 压力机直拉 MinIO（单机 & 分布式，优先）

**适用条件：** 压力机/Slave 能直接访问 MinIO HTTP 端口

```
平台机 ──SSH 命令──▶ Worker1 ──HTTP GET（预签名 URL）──▶ MinIO ┐
        ──SSH 命令──▶ Worker2 ──HTTP GET（预签名 URL）──▶ MinIO │  并发
        ──SSH 命令──▶ WorkerN ──HTTP GET（预签名 URL）──▶ MinIO ┘
```

**关键特征：**
- 文件内容**完全不经过平台机**，平台机仅发 SSH 指令
- 压力机自动降级选工具：`curl` → `wget（含 busybox）` → `python3 urllib`
- 并发数 = `min(SHARE_DIST_MAX_WORKERS, 实际节点数)`
- MinIO 认证：预签名 GET URL（由平台机签发后嵌入 SSH 命令中）

**单机 vs 分布式：**
- 单机：平台机直接 SSH 到单机压力机执行下载命令
- 分布式：平台机通过 Master SSH 隧道（direct-tcpip 或 SSH Relay）中继到各 Slave，并发执行

---

### 7.4 方案B — Master 中转 MinIO（仅分布式）

**适用条件：** Slave 不能直连 MinIO，但 Master 能直连

```
平台机 ──SSH 命令──▶ Master ──HTTP GET（预签名 URL）──▶ MinIO
                     │（文件落在 Master /tmp）
                     ├─ SCP ──▶ Slave1 ┐
                     ├─ SCP ──▶ Slave2 │  并发
                     └─ SCP ──▶ SlaveN ┘
                     └─ 清理 /tmp 临时文件
```

**关键特征：**
- 平台机只发 SSH 指令，文件数据经由 Master 中转，不落平台机磁盘
- Master 下载使用预签名 URL（SSH 执行 curl/wget）
- Master SCP 到各 Slave 的并发数受 `SHARE_DIST_MAX_WORKERS` 约束
- **单机模式不适用**（无 Master）

---

### 7.5 方案C — 平台机中转 SFTP（仅单机，兜底）

**适用条件：** 单机模式，且压力机不能直连 MinIO

```
MinIO ──SDK get_object（1MB分块流式）──▶ 平台机临时目录
平台机 ──SFTP──▶ 单机压力机
平台机 ──自动清理──▶ 临时文件
```

**关键特征：**
- 平台机使用 **MinIO SDK**（Authorization 请求头）下载，不用预签名 URL，不触发 Cloudflare WAF
- 流式分块写入临时文件（1MB/块），内存占用低，支持任意大小文件
- 下载过程中文件持续增长，前端进度条轮询 `os.path.getsize()` 实时展示百分比
- 并发数受 `CTRL_BANDWIDTH_MBPS` 和文件大小联合约束（单机只有 1 台目标机，无并发概念）
- **分布式模式不适用**

---

### 7.6 方案对比

| 维度 | 方案A | 方案B | 方案C |
|-----|-------|-------|-------|
| **适用模式** | 单机 & 分布式 | 仅分布式 | 仅单机 |
| **平台机磁盘占用** | 无 | 无 | 需完整文件空间 |
| **平台机带宽占用** | 无 | 无 | MinIO→平台机 + 平台机→压力机 |
| **压力机工具依赖** | curl/wget/python3 | 仅 sshd（SCP 不需要额外工具） | 仅 sshd |
| **MinIO 访问方式** | 预签名 URL | 预签名 URL | SDK-Auth（无预签名） |
| **Cloudflare WAF 兼容** | 压力机 IP 需加白 | Master IP 需加白 | ✅ 无需特殊配置 |
| **并发传输** | 各压力机并发拉 MinIO | Master 并发 SCP 到 Slave | SFTP 到单台，无并发 |
| **SFTP 断点续传** | ✗ | ✗（curl 不支持） | ✅ 支持 |

---

### 7.7 并发控制策略

#### 方案A & 方案B

```
max_workers = min(SHARE_DIST_MAX_WORKERS, 实际节点数)
```

#### 方案C（平台机中转 SFTP）

并发数由**平台机带宽**和**文件大小**联合决定，目标每个并发传输时间 ≤ 5 分钟：

```python
ctrl_bw_mb_s = CTRL_BANDWIDTH_MBPS / 8                          # Mbps → MB/s
bw_limit     = int(300 × ctrl_bw_mb_s / file_size_mb)           # 5 分钟完成所需上限
max_workers  = min(SHARE_DIST_MAX_WORKERS, node_count, max(1, bw_limit))
```

| 文件大小 | 100Mbps（12.5MB/s） | 500Mbps（62.5MB/s） | 1000Mbps（125MB/s） |
|---------|--------------------|--------------------|---------------------|
| ≤ 200MB | 10 | 10 | 10 |
| 500MB | 7 | 10 | 10 |
| 1000MB | 3 | 10 | 10 |
| 2000MB | 1（串行） | 9 | 10 |
| 5000MB | 1（串行） | 3 | 7 |

> 默认 `CTRL_BANDWIDTH_MBPS=500`，对应第二列。

---

### 7.8 分发结果字段

| 情况 | dist_status | dist_worker_ids | remark |
|------|------------|-----------------|--------|
| 全部成功 | `1`（已共享） | 全部机器 ID | null（清空） |
| 部分成功 | `1`（已共享） | 成功机器 ID | 失败详情（换行分隔） |
| 全部失败 | 不变 | 不变 | 失败详情 |

---

## 8. 分割分发

### 8.1 使用场景

将文件**按压力机数量等比切割**，每台压力机得到独立分片，数据不重叠。

**典型场景：** 千万级账号 CSV 按节点分片（每台压力机执行不同账号段，避免冲突），节省压力机磁盘（每台只存 1/N）。

**前置条件：**
- 文件 upload_status=1，平台机有足够临时磁盘空间（需完整下载文件）
- SSH 可达，可用压力机数量 ≥ worker_count，且 ≥ 2 台

---

### 8.2 工作原理（单机 & 分布式均适用）

分割分发始终由**平台机自身**完成 MinIO 下载，使用 SDK-Auth，不走预签名 URL：

```
① MinIO ──SDK get_object（1MB分块流式）──▶ 平台机临时目录（完整文件）
          （SDK-Auth，无预签名 URL，Cloudflare 不拦截）

② 平台机本地切割：
     file.csv ──▶ file.csv.part0（字节 0 ~ chunk-1）
              ──▶ file.csv.part1（字节 chunk ~ 2*chunk-1）
              ──▶ ...
              ──▶ file.csv.partN-1（余下全部字节）

③ 并发 SFTP 推送（落盘文件名均为原始文件名 file.csv）：
     单机模式：平台机 ──SFTP──▶ 单机压力机（仅 1 台，无并发）
     分布式：  平台机 ──SFTP──▶ Slave1  ┐
                       ──SFTP──▶ Slave2  │  并发（经 Master SSH 隧道中继）
                       ──SFTP──▶ SlaveN  ┘

④ 平台机自动清理临时目录（完整文件 + 所有分片）
```

### 8.3 单机 vs 分布式差异

| 维度 | 单机模式 | 分布式模式 |
|-----|---------|-----------|
| **MinIO 下载** | 平台机 SDK 下载（相同） | 平台机 SDK 下载（相同） |
| **SFTP 推送路径** | 平台机 → 单机压力机（直连） | 平台机 → 经 Master 隧道 → 各 Slave |
| **并发数** | 1（仅 1 台目标机） | min(20, max(10, N//2))，多台并发 |
| **Master SSH** | 不需要 | 需要，连接 Master 后复用隧道并发推送 |

---

### 8.4 并发控制

```
max_chunk_size = file_size // N + remainder       # 末片最大（包含余数字节）
max_workers    =
  N ≤ 20 且 max_chunk_size ≤ 200MB → max_workers = N（全并发）
  否则                              → max_workers = min(20, max(10, N // 2))
```

---

### 8.5 关键设计细节

- **原始文件名落盘**：各压力机上的文件名与原始文件名相同（不带 .partN 后缀），JMX 脚本中的 CSV 文件名引用无需修改
- **字节切割**：不识别行边界，CSV 最后一行可能被截断跨片。建议数据准备阶段预先确保行数能被 N 整除，或在 JMeter CSV Data Set Config 中配置 Recycle on EOF
- **进度展示**：SSE node_pending 事件携带 chunk_size 字段，分发前即可展示各节点分配的文件大小

---

### 8.6 分发结果字段

| 情况 | dist_status | dist_worker_ids | remark |
|------|------------|-----------------|--------|
| 全部成功 | `2`（已分割） | 全部机器 ID | null |
| 部分成功 | `2`（已分割） | 成功机器 ID | 失败详情 |
| 全部失败 | 不变 | 不变 | 失败详情 |

---

## 9. 清除分发

**使用场景：** 删除压力机上已分发的文件，释放磁盘或为重新分发准备。

```
读取 dist_worker_ids
  │
  └─ 并发 SSH 到各压力机
        执行：rm -f '{PERF_WORKER_DATA_DIR}/{file_name}'
        汇总结果 → 更新 DB
```

- 仅操作上次成功分发的节点（dist_worker_ids），不影响其他机器
- `rm -f` 文件不存在时静默退出（幂等，重复执行安全）
- 共享分发和分割分发的文件在压力机上均以原始文件名存储，清除命令无差异

### 单机 vs 分布式差异

| 维度 | 单机 | 分布式 |
|-----|------|--------|
| SSH 路径 | 平台机 → 单机压力机（直连） | 平台机 → 经 Master 隧道 → 各 Slave |
| 并发 | 1 台 | 多台并发 |

### 结果处理

| 情况 | DB 更新行为 |
|------|-----------|
| 全部成功 | dist_status=0、dist_worker_ids=[]、dist_time=null、remark=null |
| 部分成功 | dist_worker_ids 更新为**失败节点 ID**（可再次清除重试），remark 记录详情 |
| 全部失败 | dist_worker_ids 保持原值，remark 记录详情 |

---

## 10. SSH 连接机制

### 10.1 重试策略

每个节点 SSH 连接失败后自动重试，最多 3 次（含首次），间隔 3 秒，单次超时 30 秒。
认证：优先私钥（SSH_DEFAULT_KEY_PATH），备选密码（SSH_DEFAULT_PASSWORD）。

### 10.2 断点续传（仅 SFTP 中转模式）

每次 SFTP 上传前检查压力机已有字节数：

| 远端文件状态 | 处理行为 |
|-------------|---------|
| 不存在 | 全量上传 |
| 0 < 远端 < 本地 | 从断点追加（跳过已传字节） |
| 远端 = 本地 | 已完整，跳过，直接返回成功 |
| 远端 > 本地 | 远端文件损坏，覆盖重传 |

> 方案A/B（curl 下载）不支持断点续传；网络中断后需重新发起分发。

### 10.3 Master SSH 连接复用

整个分发任务（共享/分割/清除）共享同一条 Master SSH 连接，避免每台压力机各自重复握手：

1. 步骤4（Master 连通性检测）建立连接后不关闭，全程复用
2. N 台压力机的任务所用 `_RelayClient` 均共享同一 Master Transport（paramiko Transport 线程安全）
3. 任务全部完成（或异常）后由 `finally` 块统一关闭

### 10.4 隧道类型自动选择

平台机通过 Master 连接压力机时，自动尝试两种隧道方式：

| 隧道方式 | 触发条件 | Master 要求 |
|---------|---------|-------------|
| `direct-tcpip`（优先） | 正常情况 | AllowTcpForwarding yes |
| **SSH Relay**（自动回退） | 收到 Administratively prohibited | 能 SSH 到 Worker 即可 |

Relay 模式下文件传输走「SFTP 到 Master /tmp → Master scp 到 Worker」两步，性能略低于直连但功能等价。

---

## 11. 常见问题

**Q：什么情况下选方案A？什么情况下选方案C？**

系统自动选择，无需手动干预。简要规则：
- 压力机能直连 MinIO → 方案A（最优，文件不经平台机）
- 单机模式且不能直连 → 方案C（平台机 SDK 下载，绕过 Cloudflare WAF）
- 分布式且 Slave 不能直连但 Master 能 → 方案B

---

**Q：方案A 出现 403 如何处理？**

方案A 使用预签名 URL，若 MinIO 经 Cloudflare 代理，需将压力机 IP 加入 Cloudflare 白名单，或在 Cloudflare 中对 MinIO 域名关闭 WAF 托管规则。平台机下载（方案C/分割分发）使用 SDK-Auth 不受此影响。

---

**Q：共享分发和分割分发如何选择？**

| | 共享分发 | 分割分发 |
|---|---------|---------|
| 每台机器数据 | 完整副本（相同） | 独立分片（不重叠） |
| 平台机临时磁盘 | 方案C 需要 | 始终需要 |
| 适合场景 | 所有机器用同一份数据 | 大数据集拆分执行，避免重复 |

---

**Q：压力机没有 curl/wget，方案A 会失败吗？**

方案A 的工具探测按 `curl → wget → python3 urllib` 顺序降级。若三者均不可用，探测失败，自动切换到方案B（分布式）或方案C（单机），后两者仅依赖 sshd，无需额外工具。

---

**Q：分布式模式下 Slave 和 Master 都无法访问 MinIO 怎么办？**

分布式模式没有平台机中转兜底（方案C 仅限单机）。需从基础设施层面解决：
1. 将 Master IP 加入 Cloudflare IP 白名单（推荐）
2. 或在 Cloudflare 对 MinIO 域名关闭 WAF 托管规则
3. 或在内网为压力机/Master 另开一条不经 Cloudflare 的访问路径

---

**Q：CTRL_BANDWIDTH_MBPS 填错了影响什么？**

- 偏大：方案C 并发数超过实际安全值，大文件传输可能打满带宽导致超时
- 偏小：并发被不必要限制，传输退化为串行，效率低

修改后下次分发实时生效，无需重启服务。

---

**Q：共享分发报错 "Administratively prohibited"**

Master 的 sshd 将 `AllowTcpForwarding` 设为 `no`，系统已内置自动回退到 SSH Relay 方案，无需修改任何配置，重新发起分发即可自动采用 Relay 路由。

---

## 12. SSH 连接测试指南

运行 `python ssh_connection.py` 可验证三机链路。脚本从 `.env` 和数据库自动读取配置。

### 12.1 三机架构与认证总览

```
平台机（脚本运行处）
  │
  ├─ SSH 私钥/密码 ──▶ Master（machine_type=1）
  │                       │
  │                       ├─ direct-tcpip 隧道 ──▶ Slave（场景3，需 AllowTcpForwarding yes）
  │                       └─ SSH Relay 中继    ──▶ Slave（场景4，无需 TCP 转发）
  │
  └─ 认证凭据来自 .env：
       SSH_DEFAULT_KEY_PATH = 平台机私钥路径（优先）
       SSH_DEFAULT_PASSWORD = 密码（备用）
```

### 12.2 场景1 — 平台机私钥连接 Master（基础）

```bash
# 生成平台机密钥（已有则跳过）
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# 将公钥授权到 Master
ssh-copy-id -i ~/.ssh/id_rsa.pub -p <MASTER_PORT> root@<MASTER_IP>

# 验证免密登录
ssh -p <MASTER_PORT> -i ~/.ssh/id_rsa root@<MASTER_IP> echo ok

# .env 配置
SSH_DEFAULT_KEY_PATH=/root/.ssh/id_rsa
```

### 12.3 场景2 — 平台机密码连接 Master（备用）

```bash
# 确认 Master 允许密码认证
grep PasswordAuthentication /etc/ssh/sshd_config
# 若为 no：sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#          systemctl reload sshd

# .env 配置（私钥路径留空）
SSH_DEFAULT_KEY_PATH=
SSH_DEFAULT_PASSWORD=your_password
```

### 12.4 场景3 — direct-tcpip 连接 Slave（平台机→Master→Slave）

```bash
# 将平台机公钥授权到 Slave
ssh-copy-id -i ~/.ssh/id_rsa.pub root@<WORKER_IP>

# 确认 Master 允许 TCP 转发
grep AllowTcpForwarding /etc/ssh/sshd_config
# 若为 no，可改为 yes 或改用场景4（推荐）
```

### 12.5 场景4 — SSH Relay 连接 Slave（推荐，无需 TCP 转发）

```bash
# 在 Master 上生成密钥并授权到 Slave
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""   # Master 上执行
ssh-copy-id -i ~/.ssh/id_rsa.pub root@<WORKER_IP>   # Master 上执行
ssh root@<WORKER_IP> echo ok                        # 验证无密码提示
```

### 12.6 分发功能就绪判断

| 场景1（平台→Master） | 场景4（Master→Slave） | 状态 |
|--------------------|----------------------|------|
| ✓ | ✓ | **正常可用**，走 SSH Relay |
| ✓ | ✓ + 场景3 ✓ | **正常可用**，优先 direct-tcpip |
| ✓ | ✗ | 不可用，需在 Master 上完成到 Slave 的免密授权 |
| ✗ | — | 不可用，需先完成平台机→Master 的 SSH 认证 |