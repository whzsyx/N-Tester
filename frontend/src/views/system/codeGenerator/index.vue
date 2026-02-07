<template>
  <div class="code-generator-page">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span class="title">编码生成器</span>
          <span class="subtitle">用于生成各种业务编号，如订单号、合同号、流水号等</span>
        </div>
      </template>

      <el-form :model="form" label-width="120px" class="generator-form">
        <!-- 基本配置 -->
        <el-divider content-position="left">基本配置</el-divider>
        
        <el-form-item label="业务类型">
          <el-input
            v-model="form.businessType"
            placeholder="请输入业务类型，如：order、contract"
            clearable
          />
          <div class="form-tip">不同业务类型使用不同的序号计数器</div>
        </el-form-item>

        <el-form-item label="前缀">
          <el-input
            v-model="form.prefix"
            placeholder="请输入前缀，如：ORDER、CONTRACT"
            clearable
          />
          <div class="form-tip">编码的前缀部分</div>
        </el-form-item>

        <el-form-item label="分隔符">
          <el-input
            v-model="form.separator"
            placeholder="请输入分隔符，如：-"
            clearable
            maxlength="5"
          />
          <div class="form-tip">各部分之间的分隔符，留空则无分隔符</div>
        </el-form-item>

        <!-- 生成方式 -->
        <el-divider content-position="left">生成方式</el-divider>

        <el-form-item label="生成方式">
          <el-select
            v-model="form.generateMode"
            placeholder="请选择生成方式"
            style="width: 100%"
          >
            <el-option
              v-for="mode in modes"
              :key="mode.value"
              :label="mode.label"
              :value="mode.value"
            >
              <div class="mode-option">
                <span>{{ mode.label }}</span>
                <span class="mode-example">{{ mode.example }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>

        <!-- 日期格式（datetime 和 date_seq 模式） -->
        <el-form-item
          v-if="['datetime', 'date_seq'].includes(form.generateMode)"
          label="日期格式"
        >
          <el-select v-model="form.dateFormat" style="width: 100%">
            <el-option label="YYYYMMDD (20260205)" value="YYYYMMDD" />
            <el-option label="YYMMDD (260205)" value="YYMMDD" />
            <el-option label="YYYY-MM-DD (2026-02-05)" value="YYYY-MM-DD" />
            <el-option label="YYYYMM (202602)" value="YYYYMM" />
            <el-option label="YYYY (2026)" value="YYYY" />
          </el-select>
        </el-form-item>

        <!-- 序号配置（date_seq 和 custom 模式） -->
        <template v-if="['date_seq', 'custom'].includes(form.generateMode)">
          <el-form-item label="序号位数">
            <el-input-number
              v-model="form.seqLength"
              :min="1"
              :max="10"
              style="width: 100%"
            />
            <div class="form-tip">序号的位数，不足时前面补0</div>
          </el-form-item>

          <el-form-item label="序号重置规则">
            <el-select v-model="form.seqResetRule" style="width: 100%">
              <el-option
                v-for="rule in resetRules"
                :key="rule.value"
                :label="rule.label"
                :value="rule.value"
              />
            </el-select>
            <div class="form-tip">序号何时重置为1</div>
          </el-form-item>
        </template>

        <!-- 随机字符长度（random 模式） -->
        <el-form-item v-if="form.generateMode === 'random'" label="随机字符长度">
          <el-input-number
            v-model="form.randomLength"
            :min="4"
            :max="20"
            style="width: 100%"
          />
          <div class="form-tip">生成的随机字符长度</div>
        </el-form-item>

        <!-- 自定义模板（custom 模式） -->
        <el-form-item v-if="form.generateMode === 'custom'" label="自定义模板">
          <el-input
            v-model="form.customTemplate"
            type="textarea"
            :rows="3"
            placeholder="例如：{PREFIX}{YYYY}{MM}-{SEQ:6}"
          />
          <div class="form-tip">
            支持变量：{PREFIX} {YYYY} {YY} {MM} {DD} {HH} {mm} {ss} {SEQ} {SEQ:N} {UUID} {RANDOM} {RANDOM:N}
          </div>
        </el-form-item>

        <!-- 生成按钮 -->
        <el-form-item>
          <el-button
            type="primary"
            :loading="generating"
            @click="handleGenerate"
          >
            生成编码
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 生成结果 -->
    <el-card v-if="generatedCodes.length > 0" shadow="hover" class="result-card">
      <template #header>
        <div class="card-header">
          <span class="title">生成结果</span>
          <el-button
            type="primary"
            size="small"
            @click="handleBatchGenerate"
          >
            批量生成（10个）
          </el-button>
        </div>
      </template>

      <div class="result-list">
        <div
          v-for="(code, index) in generatedCodes"
          :key="index"
          class="result-item"
        >
          <span class="result-index">{{ index + 1 }}.</span>
          <span class="result-code">{{ code }}</span>
          <el-button
            type="primary"
            link
            :icon="CopyDocument"
            @click="handleCopy(code)"
          >
            复制
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 使用示例 -->
    <el-card shadow="hover" class="example-card">
      <template #header>
        <span class="title">使用示例</span>
      </template>

      <el-collapse>
        <el-collapse-item title="订单号生成" name="1">
          <div class="example-content">
            <p><strong>配置：</strong></p>
            <ul>
              <li>业务类型：order</li>
              <li>前缀：ORDER</li>
              <li>分隔符：-</li>
              <li>生成方式：日期+序号</li>
              <li>日期格式：YYYYMMDD</li>
              <li>序号位数：4</li>
              <li>重置规则：每日重置</li>
            </ul>
            <p><strong>生成结果：</strong>ORDER-20260205-0001</p>
          </div>
        </el-collapse-item>

        <el-collapse-item title="合同号生成" name="2">
          <div class="example-content">
            <p><strong>配置：</strong></p>
            <ul>
              <li>业务类型：contract</li>
              <li>前缀：CONTRACT</li>
              <li>分隔符：（无）</li>
              <li>生成方式：自定义模板</li>
              <li>自定义模板：{PREFIX}{YYYY}{MM}-{SEQ:6}</li>
              <li>重置规则：每月重置</li>
            </ul>
            <p><strong>生成结果：</strong>CONTRACT202602-000001</p>
          </div>
        </el-collapse-item>

        <el-collapse-item title="优惠券码生成" name="3">
          <div class="example-content">
            <p><strong>配置：</strong></p>
            <ul>
              <li>业务类型：coupon</li>
              <li>前缀：COUPON</li>
              <li>分隔符：-</li>
              <li>生成方式：随机字符</li>
              <li>随机字符长度：8</li>
            </ul>
            <p><strong>生成结果：</strong>COUPON-A1B2C3D4</p>
          </div>
        </el-collapse-item>
      </el-collapse>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { CopyDocument } from '@element-plus/icons-vue'
import { useCodeGeneratorApi } from '/@/api/v1/system/codeGenerator'
import type { GenerateMode, SeqResetRule } from '/@/api/v1/system/codeGenerator'

defineOptions({
  name: 'CodeGeneratorPage'
})

const codeGeneratorApi = useCodeGeneratorApi()

// 表单数据
const form = reactive({
  businessType: 'test',
  prefix: 'ORDER',
  separator: '-',
  generateMode: 'date_seq' as GenerateMode,
  dateFormat: 'YYYYMMDD',
  seqLength: 4,
  seqResetRule: 'daily' as SeqResetRule,
  randomLength: 6,
  customTemplate: ''
})

// 生成方式列表
const modes = ref<Array<{ value: string; label: string; example: string }>>([])

// 重置规则列表
const resetRules = ref<Array<{ value: string; label: string }>>([])

// 生成状态
const generating = ref(false)

// 生成的编码列表
const generatedCodes = ref<string[]>([])

/**
 * 加载生成方式列表
 */
const loadModes = async () => {
  try {
    const response = await codeGeneratorApi.getModes()
    if (response.code === 200 && response.data) {
      modes.value = response.data.modes || []
      resetRules.value = response.data.reset_rules || []
    }
  } catch (error) {
    console.error('加载生成方式失败:', error)
  }
}

/**
 * 生成编码
 */
const handleGenerate = async () => {
  generating.value = true

  try {
    const response = await codeGeneratorApi.generate({
      business_type: form.businessType,
      prefix: form.prefix,
      separator: form.separator,
      generate_mode: form.generateMode,
      date_format: form.dateFormat,
      seq_length: form.seqLength,
      seq_reset_rule: form.seqResetRule,
      random_length: form.randomLength,
      custom_template: form.customTemplate
    })

    if (response.code === 200 && response.data?.code) {
      generatedCodes.value.unshift(response.data.code)
      // 只保留最近20个
      if (generatedCodes.value.length > 20) {
        generatedCodes.value = generatedCodes.value.slice(0, 20)
      }
      ElMessage.success('生成成功')
    } else {
      ElMessage.error(response.message || '生成失败')
    }
  } catch (error: any) {
    console.error('生成编码失败:', error)
    ElMessage.error(error.message || '生成失败，请重试')
  } finally {
    generating.value = false
  }
}

/**
 * 批量生成
 */
const handleBatchGenerate = async () => {
  generating.value = true

  try {
    const promises = Array.from({ length: 10 }, () =>
      codeGeneratorApi.generate({
        business_type: form.businessType,
        prefix: form.prefix,
        separator: form.separator,
        generate_mode: form.generateMode,
        date_format: form.dateFormat,
        seq_length: form.seqLength,
        seq_reset_rule: form.seqResetRule,
        random_length: form.randomLength,
        custom_template: form.customTemplate
      })
    )

    const results = await Promise.all(promises)
    const codes = results
      .filter(res => res.code === 200 && res.data?.code)
      .map(res => res.data.code)

    generatedCodes.value = [...codes, ...generatedCodes.value].slice(0, 20)
    ElMessage.success(`批量生成成功，共生成 ${codes.length} 个编码`)
  } catch (error: any) {
    console.error('批量生成失败:', error)
    ElMessage.error(error.message || '批量生成失败')
  } finally {
    generating.value = false
  }
}

/**
 * 复制编码
 */
const handleCopy = async (code: string) => {
  try {
    await navigator.clipboard.writeText(code)
    ElMessage.success('复制成功')
  } catch (error) {
    console.error('复制失败:', error)
    ElMessage.error('复制失败')
  }
}

/**
 * 重置表单
 */
const handleReset = () => {
  form.businessType = 'test'
  form.prefix = 'ORDER'
  form.separator = '-'
  form.generateMode = 'date_seq'
  form.dateFormat = 'YYYYMMDD'
  form.seqLength = 4
  form.seqResetRule = 'daily'
  form.randomLength = 6
  form.customTemplate = ''
  generatedCodes.value = []
}

onMounted(() => {
  loadModes()
})
</script>

<style scoped lang="scss">
.code-generator-page {
  padding: 20px;

  .card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .title {
      font-size: 16px;
      font-weight: 600;
      color: #303133;
    }

    .subtitle {
      margin-left: 12px;
      font-size: 13px;
      color: #909399;
    }
  }

  .generator-form {
    max-width: 800px;

    .form-tip {
      margin-top: 4px;
      font-size: 12px;
      color: #909399;
      line-height: 1.5;
    }

    .mode-option {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .mode-example {
        font-size: 12px;
        color: #909399;
      }
    }
  }

  .result-card {
    margin-top: 20px;

    .result-list {
      .result-item {
        display: flex;
        align-items: center;
        padding: 12px;
        margin-bottom: 8px;
        background-color: #f5f7fa;
        border-radius: 4px;
        transition: all 0.3s;

        &:hover {
          background-color: #ecf5ff;
        }

        .result-index {
          margin-right: 12px;
          font-weight: 600;
          color: #909399;
        }

        .result-code {
          flex: 1;
          font-family: 'Courier New', monospace;
          font-size: 14px;
          font-weight: 500;
          color: #409eff;
        }
      }
    }
  }

  .example-card {
    margin-top: 20px;

    .example-content {
      p {
        margin: 8px 0;
        font-size: 14px;
        color: #606266;
      }

      ul {
        margin: 8px 0;
        padding-left: 20px;

        li {
          margin: 4px 0;
          font-size: 13px;
          color: #606266;
        }
      }

      strong {
        color: #303133;
      }
    }
  }
}
</style>
