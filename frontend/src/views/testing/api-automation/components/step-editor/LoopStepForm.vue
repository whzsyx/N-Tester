<template>
  <div class="loop-step-form">
    <el-radio-group v-model="req.loop_type" size="small" style="margin-bottom:10px">
      <el-radio-button value="count">次数循环</el-radio-button>
      <el-radio-button value="for">For 循环</el-radio-button>
      <el-radio-button value="while">While 循环</el-radio-button>
    </el-radio-group>

    <!-- 次数循环 -->
    <div v-if="req.loop_type === 'count'" class="loop-params">
      <el-form-item label="循环次数" size="small">
        <el-input-number v-model="req.count_number" :min="1" :max="100" controls-position="right" style="width:120px" />
      </el-form-item>
      <el-form-item label="间隔(秒)" size="small">
        <el-input-number v-model="req.count_sleep_time" :min="0" :max="60" controls-position="right" style="width:120px" />
      </el-form-item>
    </div>

    <!-- For 循环 -->
    <div v-else-if="req.loop_type === 'for'" class="loop-params">
      <el-form-item label="变量名" size="small">
        <el-input v-model="req.for_variable_name" placeholder="item" style="width:140px" />
      </el-form-item>
      <el-form-item label="遍历对象" size="small">
        <el-input v-model="req.for_variable" placeholder="${list_var} 或 [1,2,3]" style="width:220px" />
      </el-form-item>
      <el-form-item label="间隔(秒)" size="small">
        <el-input-number v-model="req.for_sleep_time" :min="0" :max="60" controls-position="right" style="width:120px" />
      </el-form-item>
    </div>

    <!-- While 循环 -->
    <div v-else-if="req.loop_type === 'while'" class="loop-params">
      <el-form-item label="条件变量" size="small">
        <el-input v-model="req.while_variable" placeholder="${var}" style="width:140px" />
      </el-form-item>
      <el-form-item label="比较器" size="small">
        <el-select v-model="req.while_comparator" size="small" style="width:100px">
          <el-option label="等于" value="eq" /><el-option label="不等于" value="ne" />
          <el-option label="大于" value="gt" /><el-option label="小于" value="lt" />
          <el-option label="包含" value="contains" />
        </el-select>
      </el-form-item>
      <el-form-item label="期望值" size="small">
        <el-input v-model="req.while_value" placeholder="期望值" style="width:140px" />
      </el-form-item>
      <el-form-item label="超时(秒)" size="small">
        <el-input-number v-model="req.while_timeout" :min="1" :max="3600" controls-position="right" style="width:120px" />
      </el-form-item>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ step: any }>()

const req = computed(() => {
  if (!props.step.request) {
    props.step.request = {
      loop_type: 'count', count_number: 3, count_sleep_time: 0,
      for_variable_name: 'item', for_variable: '', for_sleep_time: 0,
      while_variable: '', while_comparator: 'eq', while_value: '',
      while_timeout: 60, while_sleep_time: 1,
    }
  }
  return props.step.request
})
</script>

<style scoped>
.loop-step-form { padding: 4px 0; }
.loop-params { display: flex; flex-wrap: wrap; gap: 0 16px; }
.loop-params :deep(.el-form-item) { margin-bottom: 8px; }
</style>
