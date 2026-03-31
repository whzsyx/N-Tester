<template>
  <div class="error-page">
    <div class="error-content">
      <div class="error-icon">
        <el-icon size="120" color="#409eff">
          <DocumentDelete />
        </el-icon>
      </div>
      <h1 class="error-title">404</h1>
      <p class="error-message">页面未找到</p>
      <p class="error-description">抱歉，您访问的页面不存在或组件加载失败</p>
      <div class="error-actions">
        <el-button type="primary" @click="goHome">返回首页</el-button>
        <el-button @click="goBack">返回上页</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import { DocumentDelete } from '@element-plus/icons-vue';

const router = useRouter();

const goHome = () => {
  router.push('/home');
};

const goBack = () => {
  router.go(-1);
};
</script>

<style scoped lang="scss">
.error-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

.error-content {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  max-width: 500px;
}

.error-icon {
  margin-bottom: 20px;
}

.error-title {
  font-size: 72px;
  font-weight: bold;
  color: #409eff;
  margin: 0 0 20px 0;
}

.error-message {
  font-size: 24px;
  color: #303133;
  margin: 0 0 10px 0;
}

.error-description {
  font-size: 16px;
  color: #606266;
  margin: 0 0 30px 0;
}

.error-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
}
</style>