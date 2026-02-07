<template>
  <el-dialog
    v-model="visible"
    :title="`项目成员管理 - ${projectName}`"
    width="800px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <!-- 工具栏 -->
    <el-row :gutter="10" style="margin-bottom: 16px">
      <el-col :span="1.5">
        <el-button type="primary" size="small" @click="handleAdd">
          <el-icon><ele-Plus /></el-icon>
          添加成员
        </el-button>
      </el-col>
    </el-row>

    <!-- 成员列表 -->
    <el-table v-loading="loading" :data="memberList" border stripe>
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="username" label="用户名" min-width="120" />
      <el-table-column prop="nickname" label="昵称" min-width="120" />
      <el-table-column prop="email" label="邮箱" min-width="150" show-overflow-tooltip />
      <el-table-column prop="role" label="角色" width="120" align="center">
        <template #default="{ row }">
          <el-tag :type="getRoleType(row.role)">
            {{ getRoleText(row.role) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="creation_date" label="加入时间" width="180" align="center">
        <template #default="{ row }">
          {{ formatDateTime(row.creation_date) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" align="center">
        <template #default="{ row }">
          <el-button size="small" type="primary" @click="handleEditRole(row)">
            修改角色
          </el-button>
          <el-button size="small" type="danger" @click="handleRemove(row)">
            移除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加成员对话框 -->
    <el-dialog
      v-model="addDialogVisible"
      title="添加成员"
      width="500px"
      append-to-body
      :close-on-click-modal="false"
    >
      <el-form ref="addFormRef" :model="addForm" :rules="addFormRules" label-width="80px">
        <el-form-item label="选择用户" prop="user_id">
          <el-select
            v-model="addForm.user_id"
            placeholder="请选择用户"
            filterable
            style="width: 100%"
          >
            <el-option
              v-for="user in userList"
              :key="user.id"
              :label="`${user.nickname} (${user.username})`"
              :value="user.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="addForm.role" placeholder="请选择角色">
            <el-option label="负责人" value="owner" />
            <el-option label="管理员" value="admin" />
            <el-option label="开发者" value="developer" />
            <el-option label="测试人员" value="tester" />
            <el-option label="查看者" value="viewer" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAddSubmit" :loading="addLoading">
          确定
        </el-button>
      </template>
    </el-dialog>

    <!-- 修改角色对话框 -->
    <el-dialog
      v-model="editRoleDialogVisible"
      title="修改角色"
      width="400px"
      append-to-body
      :close-on-click-modal="false"
    >
      <el-form :model="editRoleForm" label-width="80px">
        <el-form-item label="用户">
          <el-input :value="currentMember?.nickname" disabled />
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="editRoleForm.role" placeholder="请选择角色">
            <el-option label="负责人" value="owner" />
            <el-option label="管理员" value="admin" />
            <el-option label="开发者" value="developer" />
            <el-option label="测试人员" value="tester" />
            <el-option label="查看者" value="viewer" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editRoleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleEditRoleSubmit" :loading="editRoleLoading">
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
import { useUserApi } from '/@/api/v1/system/user';

const props = defineProps<{
  modelValue: boolean;
  projectId?: number;
  projectName?: string;
}>();

const emit = defineEmits(['update:modelValue']);

const projectApi = useProjectApi();
const userApi = useUserApi();

const visible = ref(false);
const loading = ref(false);
const memberList = ref<any[]>([]);

// 添加成员
const addDialogVisible = ref(false);
const addFormRef = ref<FormInstance>();
const addForm = ref({
  user_id: undefined,
  role: 'tester',
});
const addFormRules = {
  user_id: [{ required: true, message: '请选择用户', trigger: 'change' }],
  role: [{ required: true, message: '请选择角色', trigger: 'change' }],
};
const addLoading = ref(false);
const userList = ref<any[]>([]);

// 修改角色
const editRoleDialogVisible = ref(false);
const currentMember = ref<any>(null);
const editRoleForm = ref({
  role: '',
});
const editRoleLoading = ref(false);

// 监听 modelValue 变化
watch(() => props.modelValue, (val) => {
  visible.value = val;
  if (val && props.projectId) {
    loadMembers();
  }
});

watch(visible, (val) => {
  emit('update:modelValue', val);
});

// 获取角色类型
const getRoleType = (role: string) => {
  const typeMap: Record<string, string> = {
    owner: 'danger',
    admin: 'warning',
    developer: 'primary',
    tester: 'success',
    viewer: 'info',
  };
  return typeMap[role] || '';
};

// 获取角色文本
const getRoleText = (role: string) => {
  const textMap: Record<string, string> = {
    owner: '负责人',
    admin: '管理员',
    developer: '开发者',
    tester: '测试人员',
    viewer: '查看者',
  };
  return textMap[role] || role;
};

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

// 加载成员列表
const loadMembers = async () => {
  if (!props.projectId) return;
  
  loading.value = true;
  try {
    const res = await projectApi.getMemberList(props.projectId);
    if (res.code === 200) {
      memberList.value = res.data;
      console.log('成员列表:', memberList.value); // 调试日志
    }
  } catch (error) {
    console.error('加载成员列表失败:', error);
    ElMessage.error('加载成员列表失败');
  } finally {
    loading.value = false;
  }
};

// 加载用户列表
const loadUsers = async () => {
  try {
    // 后端限制 page_size 最大为 100，需要分页加载所有用户
    let allUsers: any[] = [];
    let page = 1;
    const pageSize = 100;
    
    while (true) {
      const res = await userApi.getList({ page, page_size: pageSize, status: 1 });
      if (res.code === 200) {
        const items = res.data.items || [];
        allUsers = allUsers.concat(items);
        
        // 如果当前页数据少于 pageSize，说明已经是最后一页
        if (items.length < pageSize) {
          break;
        }
        page++;
      } else {
        break;
      }
    }
    
    // 过滤掉已经是项目成员的用户
    const memberUserIds = memberList.value.map(m => m.user_id);
    userList.value = allUsers.filter((user: any) => !memberUserIds.includes(user.id));
  } catch (error) {
    console.error('加载用户列表失败:', error);
    ElMessage.error('加载用户列表失败');
  }
};

// 添加成员
const handleAdd = () => {
  addForm.value = {
    user_id: undefined,
    role: 'tester',
  };
  loadUsers();
  addDialogVisible.value = true;
};

// 提交添加成员
const handleAddSubmit = async () => {
  if (!addFormRef.value || !props.projectId) return;
  
  await addFormRef.value.validate(async (valid) => {
    if (!valid) return;
    
    addLoading.value = true;
    try {
      await projectApi.addMember(props.projectId!, addForm.value);
      ElMessage.success('添加成功');
      addDialogVisible.value = false;
      loadMembers();
    } catch (error: any) {
      const errorMsg = error?.response?.data?.message || '添加失败';
      ElMessage.error(errorMsg);
    } finally {
      addLoading.value = false;
    }
  });
};

// 修改角色
const handleEditRole = (row: any) => {
  currentMember.value = row;
  editRoleForm.value.role = row.role;
  editRoleDialogVisible.value = true;
};

// 提交修改角色
const handleEditRoleSubmit = async () => {
  if (!currentMember.value || !props.projectId) return;
  
  editRoleLoading.value = true;
  try {
    await projectApi.updateMemberRole(props.projectId, currentMember.value.id, editRoleForm.value);
    ElMessage.success('修改成功');
    editRoleDialogVisible.value = false;
    loadMembers();
  } catch (error: any) {
    const errorMsg = error?.response?.data?.message || '修改失败';
    ElMessage.error(errorMsg);
  } finally {
    editRoleLoading.value = false;
  }
};

// 移除成员
const handleRemove = (row: any) => {
  ElMessageBox.confirm(`确定要移除成员"${row.nickname}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    if (!props.projectId) return;
    
    try {
      await projectApi.removeMember(props.projectId, row.id);
      ElMessage.success('移除成功');
      loadMembers();
    } catch (error: any) {
      const errorMsg = error?.response?.data?.message || '移除失败';
      ElMessage.error(errorMsg);
    }
  });
};

// 关闭对话框
const handleClose = () => {
  memberList.value = [];
};
</script>

<style scoped lang="scss">
</style>
