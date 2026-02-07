<template>
  <el-dialog
    v-model="visible"
    :title="`项目环境管理 - ${projectName}`"
    width="900px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <!-- 工具栏 -->
    <el-row :gutter="10" style="margin-bottom: 16px">
      <el-col :span="1.5">
        <el-button type="primary" size="small" @click="handleAdd">
          <el-icon><ele-Plus /></el-icon>
          新增环境
        </el-button>
      </el-col>
    </el-row>

    <!-- 环境列表 -->
    <el-table v-loading="loading" :data="envList" border stripe>
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="name" label="环境名称" min-width="120" />
      <el-table-column prop="base_url" label="基础URL" min-width="200" show-overflow-tooltip />
      <el-table-column prop="description" label="描述" min-width="150" show-overflow-tooltip />
      <el-table-column prop="is_default" label="默认" width="80" align="center">
        <template #default="{ row }">
          <el-tag :type="row.is_default ? 'success' : 'info'" size="small">
            {{ row.is_default ? '是' : '否' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="creation_date" label="创建时间" width="180" align="center">
        <template #default="{ row }">
          {{ formatDateTime(row.creation_date) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" align="center">
        <template #default="{ row }">
          <el-button size="small" type="primary" @click="handleEdit(row)">
            编辑
          </el-button>
          <el-button size="small" type="danger" @click="handleDelete(row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑环境对话框 -->
    <el-dialog
      v-model="formDialogVisible"
      :title="formTitle"
      width="600px"
      append-to-body
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="环境名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入环境名称" />
        </el-form-item>
        <el-form-item label="基础URL" prop="base_url">
          <el-input v-model="formData.base_url" placeholder="请输入基础URL，如: http://dev.example.com" />
        </el-form-item>
        <el-form-item label="环境描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入环境描述"
          />
        </el-form-item>
        <el-form-item label="是否默认" prop="is_default">
          <el-switch v-model="formData.is_default" />
        </el-form-item>
        <el-form-item label="环境变量">
          <div style="width: 100%">
            <el-button size="small" @click="handleAddVariable">
              <el-icon><ele-Plus /></el-icon>
              添加变量
            </el-button>
            <div v-for="(item, index) in variables" :key="index" style="margin-top: 8px">
              <el-row :gutter="10">
                <el-col :span="10">
                  <el-input v-model="item.key" placeholder="变量名" size="small" />
                </el-col>
                <el-col :span="10">
                  <el-input v-model="item.value" placeholder="变量值" size="small" />
                </el-col>
                <el-col :span="4">
                  <el-button size="small" type="danger" @click="handleRemoveVariable(index)">
                    删除
                  </el-button>
                </el-col>
              </el-row>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="formDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">
          确定
        </el-button>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus';
import { useProjectApi } from '/@/api/v1/projects/project';

const props = defineProps<{
  modelValue: boolean;
  projectId?: number;
  projectName?: string;
}>();

const emit = defineEmits(['update:modelValue']);

const projectApi = useProjectApi();

const visible = ref(false);
const loading = ref(false);
const envList = ref<any[]>([]);

// 表单对话框
const formDialogVisible = ref(false);
const formTitle = ref('');
const formRef = ref<FormInstance>();
const formData = ref({
  id: undefined,
  name: '',
  base_url: '',
  description: '',
  is_default: false,
});
const formRules = {
  name: [
    { required: true, message: '请输入环境名称', trigger: 'blur' },
    { min: 1, max: 100, message: '长度在 1 到 100 个字符', trigger: 'blur' },
  ],
};
const submitLoading = ref(false);

// 环境变量
const variables = ref<Array<{ key: string; value: string }>>([]);

// 监听 modelValue 变化
watch(() => props.modelValue, (val) => {
  visible.value = val;
  if (val && props.projectId) {
    loadEnvironments();
  }
});

watch(visible, (val) => {
  emit('update:modelValue', val);
});

// 格式化日期时间
const formatDateTime = (dateStr: string) => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 加载环境列表
const loadEnvironments = async () => {
  if (!props.projectId) return;
  
  loading.value = true;
  try {
    const res = await projectApi.getEnvironmentList(props.projectId);
    if (res.code === 200) {
      envList.value = res.data;
    }
  } catch (error) {
    console.error('加载环境列表失败:', error);
  } finally {
    loading.value = false;
  }
};

// 新增环境
const handleAdd = () => {
  formTitle.value = '新增环境';
  formData.value = {
    id: undefined,
    name: '',
    base_url: '',
    description: '',
    is_default: false,
  };
  variables.value = [];
  formDialogVisible.value = true;
};

// 编辑环境
const handleEdit = (row: any) => {
  formTitle.value = '编辑环境';
  formData.value = {
    id: row.id,
    name: row.name,
    base_url: row.base_url,
    description: row.description,
    is_default: row.is_default,
  };
  
  // 转换环境变量
  variables.value = [];
  if (row.variables && typeof row.variables === 'object') {
    Object.entries(row.variables).forEach(([key, value]) => {
      variables.value.push({ key, value: String(value) });
    });
  }
  
  formDialogVisible.value = true;
};

// 添加变量
const handleAddVariable = () => {
  variables.value.push({ key: '', value: '' });
};

// 删除变量
const handleRemoveVariable = (index: number) => {
  variables.value.splice(index, 1);
};

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value || !props.projectId) return;
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return;
    
    submitLoading.value = true;
    try {
      // 转换环境变量为对象
      const variablesObj: Record<string, string> = {};
      variables.value.forEach(item => {
        if (item.key) {
          variablesObj[item.key] = item.value;
        }
      });
      
      const data = {
        name: formData.value.name,
        base_url: formData.value.base_url,
        description: formData.value.description,
        is_default: formData.value.is_default,
        variables: variablesObj,
      };
      
      if (formData.value.id) {
        await projectApi.updateEnvironment(props.projectId!, formData.value.id, data);
        ElMessage.success('更新成功');
      } else {
        await projectApi.createEnvironment(props.projectId!, data);
        ElMessage.success('创建成功');
      }
      
      formDialogVisible.value = false;
      loadEnvironments();
    } catch (error: any) {
      const errorMsg = error?.response?.data?.message || '操作失败';
      ElMessage.error(errorMsg);
    } finally {
      submitLoading.value = false;
    }
  });
};

// 删除环境
const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定要删除环境"${row.name}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    try {
      await projectApi.deleteEnvironment(props.projectId!, row.id);
      ElMessage.success('删除成功');
      loadEnvironments();
    } catch (error: any) {
      const errorMsg = error?.response?.data?.message || '删除失败';
      ElMessage.error(errorMsg);
    }
  });
};

// 关闭对话框
const handleClose = () => {
  envList.value = [];
};
</script>

<style scoped lang="scss">
</style>
