<template>
  <div class="app-report-page" v-loading="loading" element-loading-text="加载中...">
    <!-- 顶部汇总区域 -->
    <el-card shadow="hover" class="report-card">
      <div class="report-summary">
        <!-- 基本信息 -->
        <div class="summary-block">
          <el-descriptions border :column="1" size="small">
            <el-descriptions-item label="任务名称">{{ res_form.task_name }}</el-descriptions-item>
            <el-descriptions-item label="执行人">{{ res_form.username }}</el-descriptions-item>
            <el-descriptions-item label="开始时间">{{ formatDateTime(res_form.start_time) }}</el-descriptions-item>
            <el-descriptions-item label="结束时间">{{ formatDateTime(res_form.end_time) }}</el-descriptions-item>
          </el-descriptions>
        </div>
        
        <!-- 统计数据 -->
        <div class="summary-block stats">
          <div class="stat-card stat-card--blue">
            <div class="stat-label">脚本总数</div>
            <div class="stat-value">{{ res_form.total || 0 }}</div>
          </div>
          <div class="stat-card stat-card--orange">
            <div class="stat-label">未执行</div>
            <div class="stat-value">{{ res_form.un_run || 0 }}</div>
          </div>
          <div class="stat-card stat-card--green">
            <div class="stat-label">通过数</div>
            <div class="stat-value">{{ res_form.passed || 0 }}</div>
          </div>
          <div class="stat-card stat-card--red">
            <div class="stat-label">失败数</div>
            <div class="stat-value">{{ res_form.fail || 0 }}</div>
          </div>
        </div>
        
        <!-- 通过率圆环 -->
        <div class="summary-block progress-block">
          <el-progress type="dashboard" :percentage="res_form.percent || 0" status="success">
            <template #default="{ percentage }">
              <span class="percentage-value">{{ percentage }}%</span>
              <span class="percentage-label">通过率</span>
            </template>
          </el-progress>
        </div>
      </div>
    </el-card>

    <!-- 主体内容区域 - 保持原布局 -->
    <el-card shadow="hover" class="report-body">
      <div class="report-layout">
        <!-- 左侧设备列表 -->
        <div class="device-sidebar">
          <el-tabs v-model="device_active" @tab-click="handleTabClick">
            <el-tab-pane label="全部" name="all">
              <div v-for="(device, index) in device_list" :key="index" class="device-item">
                <div :style="get_card_style(device.status)" :class="{ highlight: selectedIndex === index }" class="device-card">
                  <el-button v-if="device.status === 0" text :icon="CircleClose" class="device-btn fail" @click="device_click(device, index)">
                    {{ device.name }}
                  </el-button>
                  <el-button v-else text :icon="CircleCheck" class="device-btn pass" @click="device_click(device, index)">
                    {{ device.name }}
                  </el-button>
                </div>
              </div>
            </el-tab-pane>
            <el-tab-pane label="通过" name="pass">
              <div v-for="(device, index) in device_list" :key="index" class="device-item">
                <div v-if="device.status === 1" :style="get_card_style(1)" :class="{ highlight: selectedIndex === index }" class="device-card">
                  <el-button text :icon="CircleCheck" class="device-btn pass" @click="device_click(device, index)">
                    {{ device.name }}
                  </el-button>
                </div>
              </div>
            </el-tab-pane>
            <el-tab-pane label="失败" name="fail">
              <div v-for="(device, index) in device_list" :key="index" class="device-item">
                <div v-if="device.status === 0" :style="get_card_style(0)" :class="{ highlight: selectedIndex === index }" class="device-card">
                  <el-button text :icon="CircleClose" class="device-btn fail" @click="device_click(device, index)">
                    {{ device.name }}
                  </el-button>
                </div>
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
        
        <!-- 右侧主要内容 -->
        <div class="report-main">
          <div class="main-content">
            <el-tabs v-model="log_active" @tab-click="handle_script">
              <el-tab-pane label="结果总览" name="first">
                <!-- 设备信息 -->
                <div class="device-info">
                  <el-card class="device-info-card">
                    <el-descriptions column="4">
                      <el-descriptions-item label="设备：">{{ device_form.name }}</el-descriptions-item>
                      <el-descriptions-item label="操作系统：">{{ device_form.os_type }}</el-descriptions-item>
                      <el-descriptions-item label="系统版本： ">{{ device_form.version }}</el-descriptions-item>
                      <el-descriptions-item label="进程id： ">{{ device_form.pid }}</el-descriptions-item>
                    </el-descriptions>
                  </el-card>
                </div>
                
                <!-- 执行结果内容 -->
                <div class="result-content">
                  <el-card class="result-card">
                    <div class="result-layout">
                      <!-- 时间线区域 -->
                      <div class="timeline-section">
                        <el-card class="timeline-card">
                          <el-timeline class="result-timeline">
                            <el-timeline-item 
                              center 
                              v-for="(res, index) in run_result" 
                              :key="index"
                              :icon="getIcon(res.status)" 
                              type="primary" 
                              :color="colors(res.status)"
                              size="large" 
                              :timestamp="'执行时间：' + formatDateTime(res.create_time)" 
                              placement="top"
                            >
                              <div :class="res.status === 1 ? 'step-card step-card--pass' : 'step-card step-card--fail'">
                                <div class="step-name">步骤：{{ res.name }}</div>
                                <div class="step-log" v-if="res.log">{{ res.log }}</div>
                                <div class="step-actions">
                                  <el-popover placement="right" :width="200" trigger="click">
                                    <template #reference>
                                      <el-button v-if="Object.keys(res.assert_value || {}).length !== 0" :icon="Search" type="text" size="small">
                                        断言详情
                                      </el-button>
                                    </template>
                                    <div>
                                      <span>{{ "断言结果：" + res.assert_value.result }}</span>
                                      <el-button :icon="Picture" type="text" style="float: right" @click="pre_view(res.assert_value.img)">
                                        查看详情
                                      </el-button>
                                    </div>
                                  </el-popover>
                                  <el-button :icon="Picture" type="text" size="small" @click="pre_view(res.before_img)">
                                    执行前
                                  </el-button>
                                  <el-button :icon="Picture" type="text" size="small" @click="pre_view(res.after_img)">
                                    执行后
                                  </el-button>
                                </div>
                              </div>
                            </el-timeline-item>
                          </el-timeline>
                        </el-card>
                      </div>
                      
                      <!-- 统计汇总区域 -->
                      <div class="summary-section">
                        <el-card class="summary-card">
                          <div class="progress-section">
                            <el-progress type="dashboard" :percentage="result_form.percent || 0" status="success">
                              <template #default="{ percentage }">
                                <span class="percentage-value">{{ percentage }}%</span>
                                <span class="percentage-label">通过率</span>
                              </template>
                            </el-progress>
                          </div>
                          <div class="stats-section">
                            <el-descriptions column="2">
                              <el-descriptions-item label="脚本总数：">{{ result_form.total || 0 }}个</el-descriptions-item>
                              <el-descriptions-item label="未执行：">{{ result_form.un_run || 0 }}个</el-descriptions-item>
                            </el-descriptions>
                            <el-descriptions column="2">
                              <el-descriptions-item label="执行通过：">
                                <el-tag type="success"> {{ result_form.passed || 0 }} 个 </el-tag>
                              </el-descriptions-item>
                              <el-descriptions-item label="执行失败：">
                                <el-tag type="danger"> {{ result_form.fail || 0 }} 个 </el-tag>
                              </el-descriptions-item>
                            </el-descriptions>
                            <el-descriptions column="1">
                              <el-descriptions-item v-if="pre_video !== ''" label="视频详情：">
                                <el-button :icon="VideoPlay" type="text" @click="pre_view_video">查看视频详情</el-button>
                              </el-descriptions-item>
                            </el-descriptions>
                          </div>
                        </el-card>
                      </div>
                    </div>
                  </el-card>
                </div>
              </el-tab-pane>
            </el-tabs>
          </div>
          
          <!-- 性能图表区域 -->
          <div class="chart-section">
            <el-card class="chart-card">
              <div class="chart-header">{{ device_form.name }}：性能情况</div>
              <div id="chart" class="echarts-container"></div>
            </el-card>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 图片查看器 -->
    <el-image-viewer v-if="img_show" :url-list="pre_img" @close="close_img" />
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute } from "vue-router";
import { app_result, get_app_result_detail, get_result_log } from "@/api/api_app/app.ts";
import * as echarts from "echarts";
import {
  Check,
  Close,
  CircleCheck,
  CircleClose,
  Picture,
  Search,
  VideoPlay
} from "@element-plus/icons-vue";
import { formatDateTime } from "@/utils/formatTime";

const device_active = ref<any>("all");
const log_active = ref<any>("first");
const device_list = ref<any>([]);
const loading = ref(false);
const selectedIndex = ref<any>(null);

const handleTabClick = (tab: any) => {
  if (tab.props.name === "all") {
    device_list.value = res_form.value.device_list;
  } else if (tab.props.name === "pass") {
    device_list.value = res_form.value.device_list.filter((item: any) => item.status === 1);
  } else if (tab.props.name === "fail") {
    device_list.value = res_form.value.device_list.filter((item: any) => item.status === 0);
  }
};

const device_form = ref<any>({});
const res_form = ref<any>({});
const result_id = ref<any>("");

const get_app_result = async () => {
  const route = useRoute();
  result_id.value = route.query.result_id;
  
  if (!result_id.value) {
    console.warn('result_id 参数缺失，显示空白页面');
    loading.value = false;
    return;
  }
  
  try {
    const res: any = await get_app_result_detail({ result_id: result_id.value });
    res_form.value = res.data;
    device_list.value = res.data.device_list;
    if (res.data.device_list && res.data.device_list.length > 0) {
      await device_click(res.data.device_list[0], 0);
    }
  } catch (error) {
    console.error('获取报告详情失败:', error);
  } finally {
    loading.value = false;
  }
};

const device_id = ref<any>("");
const result_form = ref<any>({});
const device_click = async (device: any, index: any) => {
  device_form.value = device;
  device_id.value = device.deviceid;
  selectedIndex.value = index;
  
  if (res_form.value.script_status && Array.isArray(res_form.value.script_status)) {
    res_form.value.script_status.forEach((item: any) => {
      if (item.device === device_id.value) {
        result_form.value = item;
      }
    });
  }
  
  await get_result();
};

const handle_script = async (tab: any) => {
  if (!result_id.value) {
    console.error('result_id 参数缺失');
    return;
  }
  
  if (tab.props.label !== "结果总览") {
    try {
      const res: any = await get_result_log({
        device: device_id.value,
        menu_id: tab.props.name,
        result_id: result_id.value
      });
      run_result.value = res.data;
    } catch (error) {
      console.error('获取脚本日志失败:', error);
    }
  } else {
    await get_result();
  }
};

const run_result = ref<any>([]);
const pre_video = ref<any>("");
const get_result = async () => {
  if (!result_id.value || !device_id.value) {
    console.error('result_id 或 device_id 参数缺失');
    return;
  }
  
  try {
    const res = await app_result({
      result_id: result_id.value,
      device: device_id.value
    });
    await perform_result(res.data);
    run_result.value = res.data;
    res.data.forEach((item: any) => {
      if (item.name == "执行结束") {
        pre_video.value = item.video;
      }
    });
    await getEcharts();
  } catch (error) {
    console.error('获取执行结果失败:', error);
  }
};

const per_time = ref<any>([]);
const cpu = ref<any>([]);
const memory = ref<any>([]);
const up_network = ref<any>([]);
const down_network = ref<any>([]);
const temperature = ref<any>([]);
const perform_result = async (result: any) => {
  if (result.length > 0) {
    const res: any = result[0];
    per_time.value = res.performance.time;
    cpu.value = res.performance.cpu;
    memory.value = res.performance.memory;
    up_network.value = res.performance.up_network;
    down_network.value = res.performance.down_network;
    temperature.value = res.performance.temperature;
  }
};

const getEcharts = async () => {
  const dom = document.getElementById("chart");
  if (!dom) return;
  const chartRefs = echarts.init(dom);
  const rq = per_time.value;
  const seriesArr: any = [];
  const list = [
    { name: "CPU(%)", children: cpu.value },
    { name: "内存(%)", children: memory.value },
    { name: "温度(℃)", children: temperature.value },
    { name: "上传网速(KB/s)", children: up_network.value },
    { name: "下载网速(KB/s)", children: down_network.value }
  ];
  const colorArr = ["0, 62, 246", "0, 193, 142", "253, 148, 67", "211, 225, 96", "234, 66, 66"];
  list.forEach((val, index) => {
    seriesArr.push({
      name: val.name,
      type: "line",
      symbolSize: 6,
      data: val.children,
      areaStyle: {
        normal: {
          color: new echarts.graphic.LinearGradient(
            0,
            0,
            0,
            1,
            [
              { offset: 0, color: `rgba(${colorArr[index]},.2)` },
              { offset: 1, color: "rgba(255, 255, 255,0)" }
            ],
            false
          )
        }
      },
      itemStyle: {
        normal: {
          color: `rgb(${colorArr[index]})`
        }
      },
      lineStyle: {
        normal: {
          width: 2,
          shadowColor: `rgba(${colorArr[index]}, .2)`,
          shadowBlur: 4,
          shadowOffsetY: 25
        }
      }
    });
  });
  const option = {
    backgroundColor: "#fff",
    tooltip: {
      trigger: "axis",
      axisPointer: {
        lineStyle: {
          color: "#ddd"
        }
      },
      backgroundColor: "rgba(255,255,255,1)",
      padding: [5, 10],
      textStyle: {
        color: "#000"
      }
    },
    legend: {
      right: "center",
      top: "6%",
      textStyle: {
        color: "#000",
        fontSize: 12,
        fontWeight: 600
      },
      data: list.map((val) => val.name)
    },
    grid: {
      left: "2%",
      right: "5%",
      bottom: "6%",
      top: "18%",
      containLabel: true
    },
    xAxis: {
      type: "category",
      data: rq,
      boundaryGap: false,
      splitLine: {
        show: true,
        interval: "auto",
        lineStyle: {
          type: "dashed",
          color: ["#cfcfcf"]
        }
      },
      axisTick: {
        show: false
      },
      axisLine: {
        lineStyle: {
          color: "#cfcfcf"
        }
      },
      axisLabel: {
        textStyle: {
          fontSize: 12,
          color: "#9e9d9f",
          fontWeight: 600
        }
      }
    },
    yAxis: [
      {
        name: "(%)",
        type: "value",
        splitLine: {
          show: true,
          lineStyle: {
            type: "dashed",
            color: ["#cfcfcf"]
          }
        },
        axisTick: {
          show: false
        },
        axisLine: {
          show: true,
          lineStyle: {
            fontSize: 12,
            color: "#cfcfcf"
          }
        },
        axisLabel: {
          textStyle: {
            fontSize: 12,
            color: "#9e9d9f",
            fontWeight: 600
          }
        },
        max: 100
      }
    ],
    series: seriesArr
  };
  chartRefs.setOption(option);
};

const getIcon = (status: any) => {
  if (status === 1 || status === 2) {
    return Check;
  } else {
    return Close;
  }
};
const colors = (status: any) => {
  if (status === 1 || status === 2) {
    return "#0bbd87";
  } else {
    return "#d70e0e";
  }
};

const get_card_style = (type: any) => {
  if (type === 0) {
    return "border-radius: 10px; border-color: #f3050d; text-align: left;";
  } else {
    return "border-radius: 10px; border-color: #67c23ae0; text-align: left";
  }
};

const img_show = ref<any>(false);
const pre_img = ref<any>("");
const pre_view = async (img: any) => {
  pre_img.value = [img];
  img_show.value = true;
};
const close_img = async () => {
  img_show.value = false;
};
const pre_view_video = async () => {
  if (pre_video.value) window.open(pre_video.value);
};

const get_colors = (status: any) => {
  if (status === 1 || status === 2) {
    return "color: #0bbd87";
  } else {
    return "color: #d70e0e";
  }
};

onMounted(() => {
  loading.value = true;
  get_app_result();
});
</script>


<style scoped lang="scss">
.app-report-page {
  padding: 10px;
}

.report-card {
  margin-bottom: 10px;
}

.report-summary {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  padding: 10px 0;
}

.summary-block {
  flex: 0 0 auto;
}

.summary-block.stats {
  flex: 1;
  display: flex;
  gap: 10px;
  align-items: stretch;
  min-width: 0;
}

.progress-block {
  display: flex;
  justify-content: center;
  align-items: center;
  padding-left: 20px;
}

.percentage-value {
  display: block;
  font-size: 24px;
}

.percentage-label {
  font-size: 12px;
  color: #909399;
}

.report-body {
  margin-top: 10px;
}

.report-layout {
  display: flex;
  gap: 10px;
}

.device-sidebar {
  width: 15%;
  flex-shrink: 0;
  max-height: 750px;
  overflow: auto;
}

.device-item {
  margin-bottom: 10px;
}

.device-btn {
  padding: 0;
  width: 100%;
  justify-content: flex-start;
  white-space: normal;
  height: auto;
  line-height: 1.4;
}

.device-btn.pass { color: #0bbd87; }
.device-btn.fail { color: #f3050d; }

.report-main {
  flex: 1;
  min-width: 0;
}

.main-content {
  width: 66%;
  float: left;
}

.device-info {
  margin-bottom: 5px;
}

.device-info-card {
  background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  border-radius: 8px;
}

.result-content {
  .result-card {
    height: 510px;
    
    .result-layout {
      display: flex;
      width: 100%;
      
      .timeline-section {
        width: 45%;
        
        .timeline-card {
          height: 487px;
          overflow: auto;
          
          .result-timeline {
            width: 90%;
          }
        }
      }
      
      .summary-section {
        width: 50%;
        margin-left: 5%;
        
        .summary-card {
          height: 487px;
          overflow: auto;
          
          .progress-section {
            text-align: center;
            padding: 35% 0 20px;
            
            .percentage-value {
              display: block;
              font-size: 24px;
              font-weight: bold;
            }
            
            .percentage-label {
              font-size: 12px;
              color: #909399;
            }
          }
          
          .stats-section {
            padding: 0 16px;
          }
        }
      }
    }
  }
}

.chart-section {
  width: 33%;
  float: left;
  padding-left: 5px;
}

.chart-card {
  width: 100%;
  height: 660px;
  overflow: auto;
}

.chart-header {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 16px;
  text-align: center;
}

.echarts-container {
  width: 100%;
  height: 600px;
}

/* 统计卡片样式 - 参考api_report */
.stat-card {
  flex: 1; 
  display: flex; 
  flex-direction: column;
  align-items: center; 
  justify-content: center;
  border-radius: 8px; 
  padding: 16px 10px; 
  min-width: 0;
  
  .stat-label { 
    font-size: 13px; 
    color: rgba(255,255,255,0.85); 
    margin-bottom: 8px; 
    white-space: nowrap;
  }
  
  .stat-value { 
    font-size: 32px; 
    font-weight: 700; 
    color: #fff; 
    line-height: 1;
  }
}

.stat-card--blue  { background: linear-gradient(135deg, #4096ff, #1677ff) }
.stat-card--green { background: linear-gradient(135deg, #52c41a, #389e0d) }
.stat-card--orange{ background: linear-gradient(135deg, #fa8c16, #d46b08) }
.stat-card--red   { background: linear-gradient(135deg, #ff4d4f, #cf1322) }

/* 步骤卡片样式 */
.step-card {
  border-radius: 6px; 
  padding: 8px 10px; 
  border-left: 3px solid;
  background: var(--el-bg-color);
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.step-card--pass { border-left-color: #0bbd87 }
.step-card--fail { border-left-color: #f3050d }

.step-name { 
  font-size: 13px; 
  font-weight: 600; 
  margin-bottom: 4px; 
  color: var(--el-text-color-primary);
}

.step-log  { 
  font-size: 12px; 
  color: var(--el-text-color-secondary); 
  margin-bottom: 6px; 
  word-break: break-all;
}

.step-actions { 
  display: flex; 
  flex-wrap: wrap; 
  gap: 4px;
}

/* 设备卡片样式 */
.device-card { 
  border: 1px solid var(--el-border-color); 
  padding: 4px 6px; 
  border-radius: 6px;
}

.highlight { 
  background-color: rgba(182, 230, 239, 0.25);
}

/* 通用优化 */
.el-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.el-button {
  border-radius: 6px;
  transition: all 0.3s ease;
}

.el-button:hover {
  transform: translateY(-1px);
}

.el-tag {
  border-radius: 12px;
}

.el-progress {
  .el-progress__text {
    font-weight: 600;
  }
}
</style>