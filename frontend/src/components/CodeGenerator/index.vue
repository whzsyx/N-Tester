<template>
  <div class="code-generator-wrapper">
    <el-input
      v-model="codeValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :readonly="readonly"
      class="code-input"
    >
      <template v-if="!readonly && showGenerateButton" #append>
        <el-button
          :icon="Refresh"
          :loading="loading"
          :disabled="disabled"
          @click="handleGenerate"
        >
          生成
        </el-button>
      </template>
    </el-input>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Refresh } from '@element-plus/icons-vue'
import { useCodeGeneratorApi } from '/@/api/v1/system/codeGenerator'
import type { GenerateMode, SeqResetRule } from '/@/api/v1/system/codeGenerator'

interface Props {
  modelValue?: string
  prefix?: string
  separator?: string
  generateMode?: GenerateMode
  dateFormat?: string
  seqLength?: number
  seqResetRule?: SeqResetRule
  randomLength?: number
  customTemplate?: string
  businessType?: string
  disabled?: boolean
  readonly?: boolean
  placeholder?: string
  generateOnMount?: boolean
  showGenerateButton?: boolean
  isEdit?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  prefix: '',
  separator: '-',
  generateMode: 'date_seq',
  dateFormat: 'YYYYMMDD',
  seqLength: 4,
  seqResetRule: 'daily',
  randomLength: 6,
  customTemplate: '',
  businessType: 'default',
  disabled: false,
  readonly: true,
  placeholder: '自动生成编码',
  generateOnMount: true,
  showGenerateButton: true,
  isEdit: false
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
  'change': [value: string]
}>()

const codeGeneratorApi = useCodeGeneratorApi()
const codeValue = ref('')
const loading = ref(false)
const hasGenerated = ref(false)

/**
 * 生成编码
 */
const handleGenerate = async () => {
  if (loading.value) return

  loading.value = true

  try {
    const response = await codeGeneratorApi.generate({
      prefix: props.prefix,
      separator: props.separator,
      generate_mode: props.generateMode,
      date_format: props.dateFormat,
      seq_length: props.seqLength,
      seq_reset_rule: props.seqResetRule,
      random_length: props.randomLength,
      custom_template: props.customTemplate,
      business_type: props.businessType
    })

    if (response.code === 200 && response.data?.code) {
      codeValue.value = response.data.code
      hasGenerated.value = true
      emit('update:modelValue', response.data.code)
      emit('change', response.data.code)
    } else {
      ElMessage.error(response.message || '生成编码失败')
    }
  } catch (error: any) {
    console.error('生成编码失败:', error)
    ElMessage.error(error.message || '生成编码失败，请重试')
  } finally {
    loading.value = false
  }
}

/**
 * 监听外部值变化
 */
watch(
  () => props.modelValue,
  (newVal) => {
    if (newVal !== undefined && newVal !== codeValue.value) {
      codeValue.value = newVal
      // 如果接收到非空的外部值，标记为已生成，阻止后续自动生成
      if (newVal) {
        hasGenerated.value = true
      }
    }
  },
  { immediate: true }
)

/**
 * 组件挂载时自动生成
 */
onMounted(() => {
  // 如果初始就有值，确保显示
  if (props.modelValue) {
    codeValue.value = props.modelValue
    hasGenerated.value = true
  }

  // 只有在非编辑模式下，且需要自动生成，且当前没有值时才生成
  if (
    !props.isEdit &&
    props.generateOnMount &&
    !props.modelValue &&
    !hasGenerated.value
  ) {
    handleGenerate()
  }
})

/**
 * 暴露方法给父组件
 */
defineExpose({
  generate: handleGenerate
})
</script>

<style scoped lang="scss">
.code-generator-wrapper {
  width: 100%;

  .code-input {
    width: 100%;
  }
}
</style>
