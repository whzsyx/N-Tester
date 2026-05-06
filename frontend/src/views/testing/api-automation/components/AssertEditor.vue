<template>
  <div class="assert-editor">
    <!-- 每条断言规则 -->
    <div v-for="(rule, i) in rules" :key="i" class="assert-rule">
      <!-- 行头：序号 + 删除 -->
      <div class="assert-rule__head">
        <span class="assert-rule__index">{{ i + 1 }}</span>
        <el-button type="danger" link size="small" @click="rules.splice(i, 1)">
          <el-icon><Delete /></el-icon>
        </el-button>
      </div>

      <!-- 断言对象 -->
      <div class="assert-rule__field">
        <div class="assert-field-label">断言对象</div>
        <el-select v-model="rule.target" size="small" style="width:100%" @change="onTargetChange(rule)">
          <el-option-group label="响应">
            <el-option label="Response JSON" value="response_json" />
            <el-option label="Response Text" value="response_text" />
            <el-option label="Response XML" value="response_xml" />
            <el-option label="Response Header" value="response_header" />
            <el-option label="Response Cookie" value="response_cookie" />
            <el-option label="HTTP Code" value="http_code" />
            <el-option label="响应时间(ms)" value="response_time" />
          </el-option-group>
          <el-option-group label="变量">
            <el-option label="环境变量" value="env_var" />
            <el-option label="全局变量" value="global_var" />
          </el-option-group>
        </el-select>
      </div>

      <!-- 表达式路径（JSON/XML/Header/Cookie/变量 需要路径） -->
      <div
        v-if="needsPath(rule.target)"
        class="assert-rule__field"
      >
        <div class="assert-field-label">{{ pathLabel(rule.target) }}</div>
        <el-input
          v-model="rule.path"
          :placeholder="pathPlaceholder(rule.target)"
          size="small"
          style="width:100%;font-family:monospace"
        />
      </div>

      <!-- 比较符 -->
      <div class="assert-rule__field">
        <div class="assert-field-label">比较方式</div>
        <el-select v-model="rule.comparator" size="small" style="width:100%">
          <el-option-group label="相等">
            <el-option label="等于" value="eq" />
            <el-option label="不等于" value="ne" />
          </el-option-group>
          <el-option-group label="存在">
            <el-option label="存在" value="exists" />
            <el-option label="不存在" value="not_exists" />
          </el-option-group>
          <el-option-group label="数值">
            <el-option label="大于" value="gt" />
            <el-option label="大于或等于" value="gte" />
            <el-option label="小于" value="lt" />
            <el-option label="小于或等于" value="lte" />
          </el-option-group>
          <el-option-group label="字符串">
            <el-option label="包含" value="contains" />
            <el-option label="不包含" value="not_contains" />
            <el-option label="开头是" value="startswith" />
            <el-option label="结尾是" value="endswith" />
            <el-option label="正则匹配" value="regex" />
          </el-option-group>
          <el-option-group label="类型">
            <el-option label="为空(null/空字符串)" value="is_empty" />
            <el-option label="不为空" value="not_empty" />
          </el-option-group>
        </el-select>
      </div>

      <!-- 期望值（exists/not_exists/is_empty/not_empty 不需要） -->
      <div
        v-if="needsExpect(rule.comparator)"
        class="assert-rule__field"
      >
        <div class="assert-field-label">期望值</div>
        <el-input
          v-model="rule.expect"
          placeholder="期望值"
          size="small"
          style="width:100%"
        />
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="!rules.length" class="assert-empty">
      暂无断言规则，点击下方添加
    </div>

    <!-- 添加按钮 -->
    <el-button type="primary" link size="small" style="margin-top:4px" @click="addRule">
      <el-icon><Plus /></el-icon> 添加断言
    </el-button>
  </div>
</template>

<script setup lang="ts">
import { Delete, Plus } from '@element-plus/icons-vue'

const props = defineProps<{ rules: any[] }>()

// ---- Helpers ----
const needsPath = (target: string) =>
  ['response_json', 'response_xml', 'response_header', 'response_cookie', 'env_var', 'global_var'].includes(target)

const needsExpect = (comparator: string) =>
  !['exists', 'not_exists', 'is_empty', 'not_empty'].includes(comparator)

const pathLabel = (target: string) => {
  if (target === 'response_json') return 'JSONPath 表达式'
  if (target === 'response_xml')  return 'XPath 表达式'
  if (target === 'response_header') return 'Header 名称'
  if (target === 'response_cookie') return 'Cookie 名称'
  if (target === 'env_var' || target === 'global_var') return '变量名'
  return '路径'
}

const pathPlaceholder = (target: string) => {
  if (target === 'response_json') return '如: $.data.code 或 store.book[0].title'
  if (target === 'response_xml')  return '如: //book/title'
  if (target === 'response_header') return '如: Content-Type'
  if (target === 'response_cookie') return '如: session_id'
  if (target === 'env_var' || target === 'global_var') return '变量名'
  return ''
}

const onTargetChange = (rule: any) => {
  // Reset path when target changes
  rule.path = ''
  // Reset comparator for http_code / response_time to numeric
  if (['http_code', 'response_time'].includes(rule.target)) {
    rule.comparator = 'eq'
  }
}

const addRule = () => {
  props.rules.push({
    target: 'response_json',
    path: '',
    comparator: 'eq',
    expect: '',
  })
}
</script>

<style scoped lang="scss">
.assert-editor {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.assert-rule {
  display: grid;
  grid-template-columns: 28px 1fr 1fr 1fr 1fr;
  gap: 6px;
  align-items: start;
  padding: 8px;
  background: var(--el-fill-color-lighter);
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 6px;
}

.assert-rule__head {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding-top: 18px;
}

.assert-rule__index {
  font-size: 11px;
  font-weight: 700;
  color: var(--el-text-color-placeholder);
}

.assert-rule__field {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.assert-field-label {
  font-size: 11px;
  color: var(--el-text-color-secondary);
  white-space: nowrap;
}

.assert-empty {
  font-size: 12px;
  color: var(--el-text-color-placeholder);
  text-align: center;
  padding: 8px 0;
}
</style>
