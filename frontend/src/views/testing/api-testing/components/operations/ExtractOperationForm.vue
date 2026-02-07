<template>
  <div class="extract-operation-form">
    <el-form-item label="提取类型">
      <el-select v-model="localValue.extract_type" @change="emitChange">
        <el-option label="JSONPath" value="jsonpath" />
        <el-option label="正则表达式" value="regex" />
        <el-option label="响应头" value="header" />
      </el-select>
    </el-form-item>

    <el-form-item label="数据源">
      <el-select v-model="localValue.source" @change="emitChange">
        <el-option label="响应Body" value="body" />
        <el-option label="响应Header" value="header" />
        <el-option label="完整响应" value="response" />
      </el-select>
    </el-form-item>

    <el-form-item :label="getExpressionLabel()">
      <el-input
        v-model="localValue.expression"
        :placeholder="getExpressionPlaceholder()"
        @input="emitChange"
      />
    </el-form-item>

    <el-form-item label="保存到变量">
      <el-input
        v-model="localValue.var_name"
        placeholder="变量名，如：user_id"
        @input="emitChange"
      />
    </el-form-item>

    <div class="form-tip">
      <el-icon><ele-InfoFilled /></el-icon>
      <span>{{ getTipText() }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'

const props = defineProps<{
  modelValue: any
}>()

const emit = defineEmits(['update:modelValue'])

const localValue = ref({
  extract_type: props.modelValue?.extract_type || 'jsonpath',
  source: props.modelValue?.source || 'body',
  expression: props.modelValue?.expression || '',
  var_name: props.modelValue?.var_name || ''
})

watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    localValue.value = {
      extract_type: newVal.extract_type || 'jsonpath',
      source: newVal.source || 'body',
      expression: newVal.expression || '',
      var_name: newVal.var_name || ''
    }
  }
}, { deep: true })

const emitChange = () => {
  emit('update:modelValue', {
    ...props.modelValue,
    ...localValue.value
  })
}

const getExpressionLabel = () => {
  const labelMap: Record<string, string> = {
    jsonpath: 'JSONPath表达式',
    regex: '正则表达式',
    header: 'Header名称'
  }
  return labelMap[localValue.value.extract_type] || '表达式'
}

const getExpressionPlaceholder = () => {
  const placeholderMap: Record<string, string> = {
    jsonpath: '例如：$.data.user_id',
    regex: '例如：user_id":\\s*(\\d+)',
    header: '例如：Authorization'
  }
  return placeholderMap[localValue.value.extract_type] || ''
}

const getTipText = () => {
  const tipMap: Record<string, string> = {
    jsonpath: 'JSONPath示例：$.data.user_id 提取响应中的用户ID',
    regex: '正则表达式示例：使用括号()捕获需要提取的内容',
    header: 'Header示例：直接输入响应头的名称，如 Authorization'
  }
  return tipMap[localValue.value.extract_type] || ''
}
</script>

<style scoped lang="scss">
.extract-operation-form {
  .form-tip {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 8px;
    padding: 8px 12px;
    background: #f4f4f5;
    border-radius: 4px;
    font-size: 12px;
    color: #909399;

    .el-icon {
      font-size: 14px;
    }
  }
}
</style>
