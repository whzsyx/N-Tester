<template>
  <div class="key-value-editor">
    <el-table :data="items" style="width: 100%">
      <el-table-column label="启用" width="60">
        <template #default="{ row }">
          <el-checkbox v-model="row.enabled" />
        </template>
      </el-table-column>
      
      <el-table-column :label="placeholderKey" min-width="150">
        <template #default="{ row }">
          <el-input v-model="row.key" :placeholder="placeholderKey" size="small" />
        </template>
      </el-table-column>
      
      <el-table-column label="类型" width="120" v-if="showType">
        <template #default="{ row }">
          <el-select v-model="row.type" placeholder="类型" size="small">
            <el-option label="string" value="string" />
            <el-option label="integer" value="integer" />
            <el-option label="number" value="number" />
            <el-option label="boolean" value="boolean" />
            <el-option label="array" value="array" />
            <el-option label="file" value="file" />
          </el-select>
        </template>
      </el-table-column>
      
      <el-table-column :label="placeholderValue" min-width="200">
        <template #default="{ row }">
          <el-input 
            v-if="row.type !== 'file'"
            v-model="row.value" 
            :placeholder="placeholderValue" 
            size="small" 
          />
          <el-upload
            v-else
            :auto-upload="false"
            :show-file-list="false"
            :on-change="(file: any) => handleFileChange(row, file)"
          >
            <el-button size="small" type="primary">选择文件</el-button>
            <span v-if="row.fileName" style="margin-left: 10px; font-size: 12px;">
              {{ row.fileName }}
            </span>
          </el-upload>
        </template>
      </el-table-column>
      
      <el-table-column label="示例值" min-width="150" v-if="showExample">
        <template #default="{ row }">
          <el-input v-model="row.example" placeholder="示例值" size="small" />
        </template>
      </el-table-column>
      
      <el-table-column label="描述" min-width="150">
        <template #default="{ row }">
          <el-input v-model="row.description" placeholder="描述" size="small" />
        </template>
      </el-table-column>
      
      <el-table-column label="操作" width="80" fixed="right">
        <template #default="{ $index }">
          <el-button
            type="danger"
            size="small"
            text
            @click="handleDelete($index)"
          >
            <el-icon><ele-Delete /></el-icon>
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-button
      type="primary"
      size="small"
      @click="handleAdd"
      style="margin-top: 10px"
    >
      <el-icon><ele-Plus /></el-icon>
      添加
    </el-button>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from 'vue'

const props = defineProps<{
  modelValue?: any
  placeholderKey?: string
  placeholderValue?: string
  showType?: boolean  // 是否显示类型列
  showExample?: boolean  // 是否显示示例值列
}>()

const emit = defineEmits(['update:modelValue'])

const items = ref<any[]>([])

// 初始化数据
const initItems = () => {
  if (!props.modelValue) {
    items.value = []
    return
  }
  
  if (Array.isArray(props.modelValue)) {
    items.value = [...props.modelValue]
  } else if (typeof props.modelValue === 'object') {
    items.value = Object.entries(props.modelValue).map(([key, value]) => ({
      key,
      value,
      type: 'string',
      enabled: true,
      description: '',
      example: ''
    }))
  }
}

// 监听props变化
watch(() => props.modelValue, (newVal) => {
  // 使用 JSON 比较避免不必要的更新
  const currentData = items.value
  if (JSON.stringify(newVal) !== JSON.stringify(toObject(currentData))) {
    initItems()
  }
}, { deep: true })

// 转换为对象格式
const toObject = (items: any[]) => {
  const result: any = {}
  items.forEach(item => {
    if (item.enabled && item.key) {
      result[item.key] = item.value || ''
    }
  })
  return result
}

// 监听items变化
watch(items, (newItems) => {
  nextTick(() => {
    emit('update:modelValue', toObject(newItems))
  })
}, { deep: true })

// 添加行
const handleAdd = () => {
  items.value.push({
    key: '',
    value: '',
    type: 'string',
    enabled: true,
    description: '',
    example: '',
    fileName: ''
  })
}

// 删除行
const handleDelete = (index: number) => {
  items.value.splice(index, 1)
}

// 处理文件选择
const handleFileChange = (row: any, file: any) => {
  row.fileName = file.name
  row.value = file.raw
}

// 初始化
initItems()
</script>

<style scoped lang="scss">
.key-value-editor {
  :deep(.el-table) {
    .el-table__cell {
      padding: 8px 0;
    }
  }
}
</style>
