<template>
  <div class="script-operation-form">
    <el-form-item label="脚本内容">
      <el-input
        v-model="localValue.script"
        type="textarea"
        :rows="10"
        placeholder="# 编写Python脚本&#10;# 可以使用 env 访问和修改环境变量&#10;# 例如：&#10;import time&#10;env['timestamp'] = int(time.time())"
        @input="emitChange"
      />
      <div class="form-tip">
        <el-icon><ele-InfoFilled /></el-icon>
        <span>可用变量：env（环境变量）、request（请求数据）、response（响应数据）</span>
      </div>
    </el-form-item>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  modelValue: any
}>()

const emit = defineEmits(['update:modelValue'])

const localValue = ref({
  script: props.modelValue?.script || ''
})

watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    localValue.value = {
      script: newVal.script || ''
    }
  }
}, { deep: true })

const emitChange = () => {
  emit('update:modelValue', {
    ...props.modelValue,
    ...localValue.value
  })
}
</script>

<style scoped lang="scss">
.script-operation-form {
  :deep(textarea) {
    font-family: 'Courier New', monospace;
    font-size: 13px;
  }

  .form-tip {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 8px;
    padding: 8px 12px;
    background: #f0f9ff;
    border-radius: 4px;
    font-size: 12px;
    color: #409eff;

    .el-icon {
      font-size: 14px;
    }
  }
}
</style>
