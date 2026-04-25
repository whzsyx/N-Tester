<template>
  <div class="wait-step-form">
    <el-form-item label="等待时间" size="small">
      <el-input-number v-model="req.wait_time" :min="0.1" :max="300" :step="0.5"
        controls-position="right" style="width:140px" />
      <span style="margin-left:8px;font-size:12px;color:var(--el-text-color-placeholder)">秒</span>
    </el-form-item>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ step: any }>()

const req = computed(() => {
  if (!props.step.request) props.step.request = { wait_time: 1 }
  return props.step.request
})
</script>

<style scoped>
.wait-step-form { padding: 4px 0; display: flex; align-items: center; }
.wait-step-form :deep(.el-form-item) { margin-bottom: 0; }
</style>
