<template>
  <div>
    <el-card class="box-card">
      <div class="result-topbar">
        <div class="result-topbar-left">
          <span class="result-title">APP自动化 - 执行结果</span>
        </div>
        <div class="result-topbar-right">
          <el-input 
            v-model="searchParams.search.task_name__icontaints" 
            placeholder="请输入任务名称" 
            clearable 
            style="width: 300px; margin-right: 10px;"
            @keyup.enter="get_result_list_data"
          >
            <template #append>
              <el-button @click="get_result_list_data">搜索</el-button>
            </template>
          </el-input>
          <el-button type="danger" @click="reset_search">重置</el-button>
        </div>
      </div>
    </el-card>

    <el-card class="box-card mt-10px">
      <el-table :data="table_data" stripe v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="task_name" label="任务名称" />
        <el-table-column prop="device_list" label="设备详情" width="120">
          <template #default="{ row }">
            <el-popover placement="top" :width="350" trigger="hover">
              <div>
                <el-steps direction="vertical" :active="99">
                  <el-step v-for="device in row.device_list" :key="device.deviceid">
                    <template #title>
                      <span>{{ device.name }}</span>
                      <span style="float: right">{{ '(系统：' + device.os_type + ' ' + device.version + ')' }}</span>
                    </template>
                  </el-step>
                </el-steps>
              </div>
              <template #reference>
                <el-button type="text">设备详情</el-button>
              </template>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="通过率" width="200">
          <template #default="{ row }">
            <el-progress :percentage="row.percent || 0" :color="customColors" />
          </template>
        </el-table-column>
        <el-table-column prop="username" label="执行人" width="120" />
        <el-table-column label="开始时间" width="200">
          <template #default="{ row }">
            {{ row.start_time ? String(row.start_time).replace('T', ' ') : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="结束时间" width="200">
          <template #default="{ row }">
            {{ row.end_time ? String(row.end_time).replace('T', ' ') : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="view_result(row)">查看详情</el-button>
            <el-button type="success" size="small" @click="view_report(row.result_id)">查看测试报告</el-button>
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
          @size-change="get_result_list_data"
          @current-change="get_result_list_data"
        />
      </div>
    </el-card>
  </div>
</template>
<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { get_result_list } from "@/api/api_app/app.ts";

const route = useRoute();
const router = useRouter();

const table_data = ref<any>([]);
const loading = ref<any>(false);
const customColors = ref<any>([
  { color: "#ea2e2e", percentage: 99.99 },
  { color: "#81d36f", percentage: 100 }
]);

const searchParams = ref({
  currentPage: 1,
  pageSize: 10,
  search: {
    task_name__icontaints: ""
  }
});

const total = ref<number>(0);

const get_result_list_data = async () => {
  loading.value = true;
  try {
    const res: any = await get_result_list(searchParams.value);
    const raw = res?.data;
    const list = Array.isArray(raw?.content) ? raw.content : (Array.isArray(raw) ? raw : []);
    table_data.value = list;
    total.value = typeof raw?.total === 'number' ? raw.total : list.length;
  } catch (error) {
    console.error('获取结果列表失败:', error);
    table_data.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
};

const reset_search = () => {
  searchParams.value.currentPage = 1;
  searchParams.value.pageSize = 10;
  searchParams.value.search.task_name__icontaints = '';
  get_result_list_data();
};

const view_report = async (result_id: any) => {
  // 使用后端配置的路由路径
  router.push({ 
    path: '/app_report',
    query: { result_id: result_id } 
  });
};

const view_result = async (data: any) => {
  const basePath = route.path.replace(/\/results\/?$/, "/automation");
  router.push({ path: basePath, query: { result_id: data.result_id } });
};

onMounted(() => {
  get_result_list_data();
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

/* 结果页面样式 */
.result-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.result-topbar-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.result-topbar-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.result-title {
  font-size: 16px;
  font-weight: bold;
  color: var(--el-text-color-primary);
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style>