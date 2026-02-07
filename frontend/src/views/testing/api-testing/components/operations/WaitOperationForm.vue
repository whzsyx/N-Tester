<template>
  <div class="wait-operation-form">
    <el-form-item label="等待时间">
      <el-input-number
        v-model="localValue.wait_time"
        :min="0"
        :max="60000"
        :step="100"
        @change="emitChange"
      />
      <span style="margin-left: 10px; color: #909399; font-size: 12px;">毫秒</span>
    </el-form-item>
    <div class="form-tip">
      <el-icon><ele-InfoFilled /></el-icon>
      <span>设置操作之间的延迟时间，范围：0-60000毫秒</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  modelValue: any
}>()

const emit = defineEmits(['update:modelValue'])

const localValue = ref({
  wait_time: props.modelValue?.wait_time || 1000
})

watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    localValue.value = {
      wait_time: newVal.wait_time || 1000
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
.wait-operation-form {
  .form-tip {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 8px;
    padding: 8px 12px;
    background: #fdf6ec;
    border-radius: 4px;
    font-size: 12px;
    color: #e6a23c;

    .el-icon {
      font-size: 14px;
    }
  }
}
</style>
