<template>
  <div class="package-page">
    <!-- 顶部标题栏 -->
    <el-card class="box-card">
      <div class="package-topbar">
        <div class="package-topbar-left">
          <span class="package-title">包管理</span>
        </div>
        <div class="package-actions">
          <el-radio-group v-model="package_type" class="package-radio-group">
            <el-radio-button :value="1" class="radio-button">
              <el-icon><Download /></el-icon>
              一键装包
            </el-radio-button>
            <el-radio-button :value="2" class="radio-button">
              <el-icon><Upload /></el-icon>
              一键卸载
            </el-radio-button>
          </el-radio-group>
        </div>
      </div>
    </el-card>

    <!-- 安装配置区域 -->
    <el-card v-if="package_type === 1" class="content-card">
      <template #header>
        <div class="card-header">
          <span class="card-title">安装配置</span>
          <el-button type="primary" class="action-button primary-button" @click="add_app_list">
            <el-icon><Plus /></el-icon>
            添加配置
          </el-button>
        </div>
      </template>
      
      <div class="install-content">
        <el-form :model="app_list" label-width="120px">
          <div v-for="(app, index) in app_list" :key="index" class="config-section">
            <div class="config-header">
              <span class="config-title">配置 {{ index + 1 }}</span>
              <el-button 
                type="danger" 
                :icon="Delete" 
                circle 
                size="small" 
                @click="del_app_list(index)"
                :disabled="app_list.length === 1"
              />
            </div>
            
            <el-card class="config-card">
              <!-- 路径搜索 -->
              <div class="path-section">
                <el-form-item label="包路径">
                  <div class="path-input-group">
                    <el-input 
                      v-model="app.path" 
                      placeholder="请输入包文件路径" 
                      class="path-input"
                    />
                    <el-button 
                      type="primary" 
                      :loading="searchLoading"
                      @click="search_package(app.path)"
                      class="search-button"
                    >
                      <el-icon><Search /></el-icon>
                      搜索
                    </el-button>
                  </div>
                </el-form-item>
              </div>

              <!-- 设备配置列表 -->
              <div class="device-configs">
                <div class="device-config-header">
                  <span class="section-title">设备配置</span>
                  <el-button 
                    type="success" 
                    size="small" 
                    @click="add_config(app.config)"
                    class="add-config-btn"
                  >
                    <el-icon><Plus /></el-icon>
                    添加设备
                  </el-button>
                </div>
                
                <div v-for="(config, config_index) in app.config" :key="config_index" class="device-config-item">
                  <div class="config-row">
                    <el-form-item label="包文件" class="package-select-item">
                      <el-select 
                        v-model="config.package" 
                        filterable 
                        clearable
                        placeholder="请选择包文件"
                        class="package-select"
                      >
                        <el-option 
                          v-for="pkg in package_list" 
                          :key="pkg.id" 
                          :label="pkg.file_name"
                          :value="pkg.file_name"
                        />
                      </el-select>
                    </el-form-item>
                    
                    <el-form-item label="目标设备" class="device-select-item">
                      <el-select 
                        v-model="config.deviceid" 
                        filterable 
                        clearable
                        placeholder="请选择设备"
                        class="device-select"
                      >
                        <el-option 
                          v-for="device in device_list" 
                          :key="device.deviceid" 
                          :label="device.name"
                          :value="device.deviceid"
                        />
                      </el-select>
                    </el-form-item>
                    
                    <el-button 
                      type="danger" 
                      :icon="Delete" 
                      circle 
                      size="small" 
                      @click="del_config(config_index, app.config)"
                      :disabled="app.config.length === 1"
                      class="delete-config-btn"
                    />
                  </div>
                </div>
              </div>
            </el-card>
          </div>
        </el-form>
        
        <!-- 安装按钮 -->
        <div v-if="app_list.length > 0" class="install-actions">
          <el-button 
            type="warning" 
            size="large" 
            :loading="loading"
            @click="install_app"
            class="install-button"
          >
            <el-icon><Download /></el-icon>
            立即安装包
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 卸载配置区域 -->
    <el-card v-if="package_type === 2" class="content-card">
      <template #header>
        <div class="card-header">
          <span class="card-title">卸载配置</span>
        </div>
      </template>
      
      <div class="uninstall-content">
        <el-form :model="uninstall_form" label-width="120px" class="uninstall-form">
          <el-form-item label="目标设备" required>
            <el-select 
              v-model="uninstall_form.device_list" 
              multiple 
              clearable
              placeholder="请选择要卸载的设备"
              class="device-multi-select"
            >
              <el-option 
                v-for="device in device_list" 
                :key="device.deviceid" 
                :label="device.name"
                :value="device.deviceid"
              />
            </el-select>
          </el-form-item>
          
          <el-form-item label="包名称" required>
            <el-input 
              v-model="uninstall_form.package" 
              placeholder="请输入要卸载的包名称"
              class="package-input"
            />
          </el-form-item>
        </el-form>
        
        <!-- 卸载按钮 -->
        <div class="uninstall-actions">
          <el-button 
            type="warning" 
            size="large" 
            :loading="loading"
            @click="uninstall_app"
            class="uninstall-button"
          >
            <el-icon><Upload /></el-icon>
            立即卸载包
          </el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { MsgSuccess, NoticeError } from "@/utils/koi";
import { file_list } from "@/api/api_file/file";
import { Plus, Delete, Search, Refresh, Download, Upload } from "@element-plus/icons-vue";

const device_list = ref<any>([]);
const package_type = ref<number>(1);
const app_list = ref<any>([
  {
    path: "",
    config: [
      {
        deviceid: "",
        package: ""
      }
    ]
  }
]);

const uninstall_form = ref<any>({});
const package_list = ref<any>([]);
const loading = ref(false);
const searchLoading = ref(false);

const getDeviceList = async () => {
  try {
    const res: any = await get_device_list({});
    device_list.value = res.data;
  } catch (error) {
    NoticeError("获取设备列表失败");
  }
};

const add_app_list = async () => {
  app_list.value.push({
    path: "",
    config: [
      {
        deviceid: "",
        package: ""
      }
    ]
  });
};

const add_config = async (config: any) => {
  config.push({
    deviceid: "",
    package: ""
  });
};

const search_package = async (path: any) => {
  if (!path.trim()) {
    NoticeError("请输入搜索路径");
    return;
  }
  
  try {
    searchLoading.value = true;
    const res: any = await file_list({
      folder_path: path
    });
    package_list.value = res.data;
    MsgSuccess(`找到 ${res.data.length} 个包文件`);
  } catch (error) {
    NoticeError("搜索包文件失败");
    package_list.value = [];
  } finally {
    searchLoading.value = false;
  }
};

const del_app_list = async (index: any) => {
  app_list.value.splice(index, 1);
};

const del_config = async (index: any, data: any) => {
  if (data.length == 1) {
    NoticeError("至少保留一个配置项");
    return;
  }
  data.splice(index, 1);
};

const install_app = async () => {
  // 验证配置
  for (const app of app_list.value) {
    if (!app.path.trim()) {
      NoticeError("请填写所有路径");
      return;
    }
    for (const config of app.config) {
      if (!config.deviceid || !config.package) {
        NoticeError("请完善所有设备和包体配置");
        return;
      }
    }
  }
  
  try {
    loading.value = true;
    MsgSuccess("包体正在安装中，请稍后...");
    const res: any = await devices_install({
      config: app_list.value
    });
    MsgSuccess("安装完成");
  } catch (error) {
    NoticeError("安装失败，请重试");
  } finally {
    loading.value = false;
  }
};

const uninstall_app = async () => {
  if (!uninstall_form.value.device_list?.length || !uninstall_form.value.package?.trim()) {
    NoticeError("请选择设备和输入包体名称");
    return;
  }
  
  try {
    loading.value = true;
    MsgSuccess("包体正在卸载中，请稍后...");
    const res: any = await devices_uninstall(uninstall_form.value);
    MsgSuccess("卸载完成");
  } catch (error) {
    NoticeError("卸载失败，请重试");
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  getDeviceList();
  package_type.value = 1;
  uninstall_form.value = {
    device_list: [],
    package: ""
  };
  app_list.value = [
    {
      path: "",
      config: [{
        deviceid: "",
        package: ""
      }]
    }
  ];
});
</script>

<style scoped lang="scss">
/* 通用样式 */
.package-page {
  padding: 10px;
  min-height: 100vh;
}

.box-card {
  margin-bottom: 10px;
  border-radius: 8px;
}

.content-card {
  border-radius: 8px;
}

/* 顶部标题栏样式 */
.package-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0;
}

.package-topbar-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.package-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.package-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.package-radio-group {
  display: flex;
  gap: 8px;
}

.radio-button {
  display: flex;
  align-items: center;
  gap: 6px;
}

/* 卡片头部样式 */
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

/* 配置区域样式 */
.install-content {
  max-height: 700px;
  overflow-y: auto;
  padding-right: 8px;
}

.config-section {
  margin-bottom: 20px;
  
  &:last-child {
    margin-bottom: 0;
  }
}

.config-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.config-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.device-config-item {
  margin-bottom: 16px;
  padding: 16px;
  background: var(--el-fill-color-extra-light);
  border-radius: 8px;
  border: 1px solid var(--el-border-color-lighter);
  transition: all 0.3s ease;
  
  &:hover {
    background: var(--el-fill-color-light);
    border-color: var(--el-color-primary-light-5);
  }
  
  &:last-child {
    margin-bottom: 0;
  }
}

.config-card {
  border-radius: 8px;
  border: 1px solid var(--el-border-color-lighter);
  transition: all 0.3s ease;
  
  &:hover {
    border-color: var(--el-color-primary-light-5);
  }
}

/* 路径输入区域 */
.path-section {
  margin-bottom: 20px;
}

.path-input-group {
  display: flex;
  gap: 10px;
  align-items: flex-end;
}

.path-input {
  flex: 1;
}

.search-button {
  border-radius: 6px;
  transition: all 0.3s ease;
}

/* 设备配置区域 */
.device-configs {
  border-top: 1px solid var(--el-border-color-lighter);
  padding-top: 16px;
}

.device-config-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.add-config-btn {
  border-radius: 6px;
  transition: all 0.3s ease;
}

.config-row {
  display: flex;
  align-items: flex-end;
  gap: 16px;
}

.package-select-item,
.device-select-item {
  flex: 1;
  margin-bottom: 0;
}

.package-select,
.device-select {
  width: 100%;
}

.delete-config-btn {
  flex-shrink: 0;
  transition: all 0.3s ease;
  
  &:hover:not(:disabled) {
    transform: scale(1.1);
  }
}

/* 操作按钮样式 */
.action-button {
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.primary-button {
  background: linear-gradient(135deg, #409eff, #1890ff);
  border: none;
  color: white;
}

.primary-button:hover {
  background: linear-gradient(135deg, #66b1ff, #40a9ff);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

/* 安装/卸载按钮区域 */
.install-actions,
.uninstall-actions {
  display: flex;
  justify-content: center;
  padding: 24px 0;
  border-top: 1px solid var(--el-border-color-lighter);
  margin-top: 20px;
}

.install-button,
.uninstall-button {
  padding: 12px 32px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 8px;
  transition: all 0.3s ease;
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

/* 卸载区域样式 */
.uninstall-content {
  padding: 20px 0;
}

.uninstall-form {
  max-width: 600px;
  margin: 0 auto;
}

.device-multi-select,
.package-input {
  width: 100%;
}

/* 滚动条样式 */
.install-content::-webkit-scrollbar {
  width: 6px;
}

.install-content::-webkit-scrollbar-track {
  background: var(--el-fill-color-lighter);
  border-radius: 3px;
}

.install-content::-webkit-scrollbar-thumb {
  background: var(--el-color-primary-light-5);
  border-radius: 3px;
  transition: all 0.3s ease;
}

.install-content::-webkit-scrollbar-thumb:hover {
  background: var(--el-color-primary);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .package-topbar {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }
  
  .config-row {
    flex-direction: column;
    gap: 12px;
  }
  
  .path-input-group {
    flex-direction: column;
    gap: 12px;
  }
  
  .device-config-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }
}
</style>

