<template>
  <div class="assertion-editor">
    <el-table :data="assertions" style="width: 100%">
      <el-table-column label="断言类型" width="150">
        <template #default="{ row }">
          <el-select v-model="row.type" placeholder="选择类型" size="small">
            <el-option label="状态码" value="status_code" />
            <el-option label="响应时间" value="response_time" />
            <el-option label="JSONPath" value="jsonpath" />
            <el-option label="包含文本" value="body_contains" />
            <el-option label="响应头" value="header" />
          </el-select>
        </template>
      </el-table-column>
      
      <el-table-column label="JSONPath" width="200" v-if="hasJsonPath">
        <template #default="{ row }">
          <el-input
            v-if="row.type === 'jsonpath'"
            v-model="row.jsonpath"
            placeholder="$.data.id"
            size="small"
          />
        </template>
      </el-table-column>
      
      <el-table-column label="Header名称" width="150" v-if="hasHeader">
        <template #default="{ row }">
          <el-input
            v-if="row.type === 'header'"
            v-model="row.header_name"
            placeholder="Content-Type"
            size="small"
          />
        </template>
      </el-table-column>
      
      <el-table-column label="比较运算符" width="150">
        <template #default="{ row }">
          <el-select v-model="row.operator" placeholder="选择运算符" size="small">
            <el-option label="等于" value="equals" />
            <el-option label="不等于" value="not_equals" />
            <el-option label="大于" value="greater_than" />
            <el-option label="小于" value="less_than" />
            <el-option label="大于等于" value="greater_or_equal" />
            <el-option label="小于等于" value="less_or_equal" />
            <el-option label="包含" value="contains" />
            <el-option label="不包含" value="not_contains" />
            <el-option label="开始于" value="starts_with" />
            <el-option label="结束于" value="ends_with" />
          </el-select>
        </template>
      </el-table-column>
      
      <el-table-column label="期望值" min-width="200">
        <template #default="{ row }">
          <el-input v-model="row.expected" placeholder="期望值" size="small" />
        </template>
      </el-table-column>
      
      <el-table-column label="操作" width="80">
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
      添加断言
    </el-button>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed, nextTick } from 'vue'

const props = defineProps<{
  modelValue?: any[]
}>()

const emit = defineEmits(['update:modelValue'])

const assertions = ref<any[]>([])

// 是否有JSONPath类型
const hasJsonPath = computed(() => {
  return assertions.value.some(item => item.type === 'jsonpath')
})

// 是否有Header类型
const hasHeader = computed(() => {
  return assertions.value.some(item => item.type === 'header')
})

// 初始化数据
watch(() => props.modelValue, (newVal) => {
  // 使用 JSON 比较避免不必要的更新
  if (JSON.stringify(newVal) !== JSON.stringify(assertions.value)) {
    if (newVal && Array.isArray(newVal)) {
      assertions.value = [...newVal]
    } else {
      assertions.value = []
    }
  }
}, { deep: true })

// 监听assertions变化
watch(assertions, (newVal) => {
  nextTick(() => {
    emit('update:modelValue', newVal)
  })
}, { deep: true })

// 添加断言
const handleAdd = () => {
  assertions.value.push({
    type: 'status_code',
    operator: 'equals',
    expected: '200'
  })
}

// 删除断言
const handleDelete = (index: number) => {
  assertions.value.splice(index, 1)
}

// 初始化
if (props.modelValue && Array.isArray(props.modelValue)) {
  assertions.value = [...props.modelValue]
}
</script>

<style scoped lang="scss">
.assertion-editor {
  :deep(.el-table) {
    .el-table__cell {
      padding: 8px 0;
    }
  }
}
</style>
