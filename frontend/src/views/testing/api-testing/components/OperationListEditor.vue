<template>
  <div class="operation-list-editor">
    <div class="operation-header">
      <span class="operation-title">{{ title }}</span>
      <el-button type="primary" size="small" @click="showAddDialog = true">
        <el-icon><ele-Plus /></el-icon>
        添加操作
      </el-button>
    </div>

    <div v-if="localOperations.length === 0" class="empty-state">
      <el-empty description="暂无操作" :image-size="80">
        <el-button type="primary" @click="showAddDialog = true">添加第一个操作</el-button>
      </el-empty>
    </div>

    <draggable
      v-else
      v-model="localOperations"
      item-key="id"
      handle=".drag-handle"
      @end="handleDragEnd"
      class="operation-list"
    >
      <template #item="{ element, index }">
        <div class="operation-item" :class="{ disabled: !element.enabled }">
          <div class="operation-item-header">
            <el-icon class="drag-handle"><ele-Rank /></el-icon>
            <el-switch
              v-model="element.enabled"
              size="small"
              @change="emitChange"
            />
            <span class="operation-type-badge" :class="`type-${element.type}`">
              {{ getOperationTypeName(element.type) }}
            </span>
            <span class="operation-description">{{ element.description || '未命名操作' }}</span>
            <div class="operation-actions">
              <el-button type="primary" text size="small" @click="editOperation(index)">
                <el-icon><ele-Edit /></el-icon>
              </el-button>
              <el-button type="danger" text size="small" @click="deleteOperation(index)">
                <el-icon><ele-Delete /></el-icon>
              </el-button>
            </div>
          </div>
          <div v-if="element.enabled" class="operation-item-content">
            <div class="operation-preview">
              {{ getOperationPreview(element) }}
            </div>
          </div>
        </div>
      </template>
    </draggable>

    <!-- 添加/编辑操作对话框 -->
    <el-dialog
      v-model="showAddDialog"
      :title="editingIndex === -1 ? '添加操作' : '编辑操作'"
      width="700px"
      @close="handleDialogClose"
    >
      <el-form :model="currentOperation" label-width="100px">
        <el-form-item label="操作类型">
          <el-select
            v-model="currentOperation.type"
            placeholder="选择操作类型"
            :disabled="editingIndex !== -1"
            @change="handleTypeChange"
          >
            <el-option label="自定义脚本" value="script" />
            <el-option label="公共脚本" value="public_script" />
            <el-option label="数据库操作" value="database" />
            <el-option label="等待时间" value="wait" />
            <el-option label="提取变量" value="extract" />
            <el-option label="导入接口" value="import_request" />
          </el-select>
        </el-form-item>

        <el-form-item label="操作描述">
          <el-input v-model="currentOperation.description" placeholder="请输入操作描述" />
        </el-form-item>

        <!-- 根据操作类型显示不同的表单 -->
        <component
          :is="getOperationFormComponent(currentOperation.type)"
          v-model="currentOperation"
          :project-id="projectId"
          :api-project-id="apiProjectId"
        />
      </el-form>

      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveOperation">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import draggable from 'vuedraggable'
import ScriptOperationForm from './operations/ScriptOperationForm.vue'
import PublicScriptOperationForm from './operations/PublicScriptOperationForm.vue'
import DatabaseOperationForm from './operations/DatabaseOperationForm.vue'
import WaitOperationForm from './operations/WaitOperationForm.vue'
import ExtractOperationForm from './operations/ExtractOperationForm.vue'
import ImportRequestOperationForm from './operations/ImportRequestOperationForm.vue'

const props = defineProps<{
  modelValue: any[]
  title?: string
  projectId?: number
  apiProjectId?: number
}>()

const emit = defineEmits(['update:modelValue'])

// 本地操作列表
const localOperations = ref<any[]>([])
const showAddDialog = ref(false)
const editingIndex = ref(-1)
const currentOperation = ref<any>({
  type: 'script',
  enabled: true,
  description: '',
  script: ''
})

// 初始化
watch(() => props.modelValue, (newVal) => {
  if (newVal && Array.isArray(newVal)) {
    localOperations.value = newVal.map((op, index) => ({
      ...op,
      id: `${op.type}_${index}_${Date.now()}`
    }))
  } else {
    localOperations.value = []
  }
}, { immediate: true, deep: true })

// 发送变更
const emitChange = () => {
  emit('update:modelValue', localOperations.value.map(op => {
    const { id, ...rest } = op
    return rest
  }))
}

// 拖拽结束
const handleDragEnd = () => {
  emitChange()
}

// 获取操作类型名称
const getOperationTypeName = (type: string) => {
  const typeMap: Record<string, string> = {
    script: '脚本',
    public_script: '公共脚本',
    database: '数据库',
    wait: '等待',
    extract: '提取变量',
    import_request: '导入接口'
  }
  return typeMap[type] || type
}

// 获取操作预览
const getOperationPreview = (operation: any) => {
  switch (operation.type) {
    case 'script':
      return operation.script ? operation.script.substring(0, 100) + '...' : '无脚本内容'
    case 'public_script':
      return `公共脚本ID: ${operation.script_id || '未设置'}`
    case 'database':
      return operation.sql ? operation.sql.substring(0, 100) + '...' : '无SQL语句'
    case 'wait':
      return `等待 ${operation.wait_time || 0} 毫秒`
    case 'extract':
      return `从 ${operation.source} 提取 ${operation.var_name}`
    case 'import_request':
      return `导入请求ID: ${operation.request_id || '未设置'}`
    default:
      return '未知操作'
  }
}

// 获取操作表单组件
const getOperationFormComponent = (type: string) => {
  const componentMap: Record<string, any> = {
    script: ScriptOperationForm,
    public_script: PublicScriptOperationForm,
    database: DatabaseOperationForm,
    wait: WaitOperationForm,
    extract: ExtractOperationForm,
    import_request: ImportRequestOperationForm
  }
  return componentMap[type] || ScriptOperationForm
}

// 类型变更
const handleTypeChange = () => {
  // 重置当前操作的特定字段
  const baseFields = {
    type: currentOperation.value.type,
    enabled: currentOperation.value.enabled,
    description: currentOperation.value.description
  }
  
  // 根据类型设置默认值
  switch (currentOperation.value.type) {
    case 'script':
      currentOperation.value = { ...baseFields, script: '' }
      break
    case 'public_script':
      currentOperation.value = { ...baseFields, script_id: null }
      break
    case 'database':
      currentOperation.value = { ...baseFields, db_config_id: null, sql: '', save_to_var: '' }
      break
    case 'wait':
      currentOperation.value = { ...baseFields, wait_time: 1000 }
      break
    case 'extract':
      currentOperation.value = { ...baseFields, extract_type: 'jsonpath', source: 'body', expression: '', var_name: '' }
      break
    case 'import_request':
      currentOperation.value = { ...baseFields, request_id: null, environment_id: null }
      break
  }
}

// 编辑操作
const editOperation = (index: number) => {
  editingIndex.value = index
  currentOperation.value = { ...localOperations.value[index] }
  showAddDialog.value = true
}

// 删除操作
const deleteOperation = (index: number) => {
  ElMessageBox.confirm('确定要删除这个操作吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    localOperations.value.splice(index, 1)
    emitChange()
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// 保存操作
const saveOperation = () => {
  // 验证
  if (!currentOperation.value.description) {
    ElMessage.warning('请输入操作描述')
    return
  }

  if (editingIndex.value === -1) {
    // 添加
    localOperations.value.push({
      ...currentOperation.value,
      id: `${currentOperation.value.type}_${Date.now()}`
    })
  } else {
    // 更新
    localOperations.value[editingIndex.value] = {
      ...currentOperation.value,
      id: localOperations.value[editingIndex.value].id
    }
  }

  emitChange()
  showAddDialog.value = false
  ElMessage.success(editingIndex.value === -1 ? '添加成功' : '更新成功')
}

// 对话框关闭
const handleDialogClose = () => {
  editingIndex.value = -1
  currentOperation.value = {
    type: 'script',
    enabled: true,
    description: '',
    script: ''
  }
}
</script>

<style scoped lang="scss">
.operation-list-editor {
  .operation-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    
    .operation-title {
      font-size: 14px;
      font-weight: 500;
      color: #303133;
    }
  }

  .empty-state {
    padding: 40px 0;
    text-align: center;
  }

  .operation-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .operation-item {
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    background: #fff;
    transition: all 0.3s;

    &.disabled {
      opacity: 0.6;
      background: #f5f7fa;
    }

    &:hover {
      border-color: #409eff;
      box-shadow: 0 2px 8px rgba(64, 158, 255, 0.1);
    }

    .operation-item-header {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 12px 15px;
      border-bottom: 1px solid #ebeef5;

      .drag-handle {
        cursor: move;
        color: #909399;
        font-size: 16px;

        &:hover {
          color: #409eff;
        }
      }

      .operation-type-badge {
        padding: 2px 8px;
        border-radius: 3px;
        font-size: 12px;
        font-weight: 500;
        
        &.type-script {
          background: #e1f3d8;
          color: #67c23a;
        }
        
        &.type-public_script {
          background: #d9ecff;
          color: #409eff;
        }
        
        &.type-database {
          background: #fef0f0;
          color: #f56c6c;
        }
        
        &.type-wait {
          background: #fdf6ec;
          color: #e6a23c;
        }
        
        &.type-extract {
          background: #f4f4f5;
          color: #909399;
        }
        
        &.type-import_request {
          background: #f0f9ff;
          color: #409eff;
        }
      }

      .operation-description {
        flex: 1;
        font-size: 14px;
        color: #606266;
      }

      .operation-actions {
        display: flex;
        gap: 5px;
      }
    }

    .operation-item-content {
      padding: 12px 15px;
      background: #fafafa;

      .operation-preview {
        font-size: 12px;
        color: #909399;
        font-family: 'Courier New', monospace;
        white-space: pre-wrap;
        word-break: break-all;
      }
    }
  }
}
</style>
