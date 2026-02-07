<template>
  <div class="oauth-login">
    <div class="oauth-login-title">第三方登录</div>
    <div class="oauth-carousel">
      <!-- 左箭头 -->
      <div 
        class="carousel-arrow carousel-arrow-left" 
        :class="{ disabled: scrollPosition <= 0 }"
        @click="scrollLeft"
      >
        <el-icon><ArrowLeft /></el-icon>
      </div>

      <!-- OAuth 按钮容器 -->
      <div class="oauth-buttons-wrapper" ref="buttonsWrapper">
        <div class="oauth-buttons-container" ref="buttonsContainer">
          <el-tooltip
            v-for="provider in oauthProviders"
            :key="provider.name"
            :content="`使用 ${provider.label} 登录`"
            placement="top"
          >
            <div
              class="oauth-button"
              :class="`oauth-button-${provider.name}`"
              @click="handleOAuthLogin(provider.name)"
            >
              <Icon v-if="provider.icon" :icon="provider.icon" :size="24" />
              <span v-else class="oauth-text">{{ provider.label.substring(0, 2) }}</span>
            </div>
          </el-tooltip>
        </div>
      </div>

      <!-- 右箭头 -->
      <div 
        class="carousel-arrow carousel-arrow-right"
        :class="{ disabled: scrollPosition >= maxScroll }"
        @click="scrollRight"
      >
        <el-icon><ArrowRight /></el-icon>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts" name="oauthLogin">
import { reactive, ref, onMounted, onUnmounted } from 'vue';
import { ElMessage } from 'element-plus';
import { ArrowLeft, ArrowRight } from '@element-plus/icons-vue';
import { useOAuthApi, type OAuthProvider } from '/@/api/v1/oauth';
import { Icon } from '@iconify/vue';

// OAuth 提供商配置
interface OAuthProviderConfig {
  name: OAuthProvider;
  label: string;
  icon: string;
  enabled: boolean;
}

const oauthProviders = reactive<OAuthProviderConfig[]>([
  { name: 'gitee', label: 'Gitee', icon: 'simple-icons:gitee', enabled: true },
  { name: 'github', label: 'GitHub', icon: 'mdi:github', enabled: true },
  { name: 'qq', label: 'QQ', icon: 'simple-icons:tencentqq', enabled: true },
  { name: 'google', label: 'Google', icon: 'logos:google-icon', enabled: true },
  { name: 'wechat', label: '微信', icon: 'simple-icons:wechat', enabled: true },
  { name: 'microsoft', label: 'Microsoft', icon: 'logos:microsoft-icon', enabled: true },
  { name: 'dingtalk', label: '钉钉', icon: 'ri:dingding-fill', enabled: true },
  { name: 'feishu', label: '飞书', icon: 'svg:oauth-feishu', enabled: true },
]);

// 滚动相关
const buttonsWrapper = ref<HTMLElement>();
const buttonsContainer = ref<HTMLElement>();
const scrollPosition = ref(0);
const maxScroll = ref(0);

/**
 * 更新滚动状态
 */
const updateScrollState = () => {
  if (buttonsWrapper.value && buttonsContainer.value) {
    const wrapper = buttonsWrapper.value;
    const container = buttonsContainer.value;
    scrollPosition.value = wrapper.scrollLeft;
    maxScroll.value = container.scrollWidth - wrapper.clientWidth;
  }
};

/**
 * 向左滚动
 */
const scrollLeft = () => {
  if (buttonsWrapper.value) {
    const scrollAmount = 240; // 每次滚动约 4 个按钮的距离
    buttonsWrapper.value.scrollBy({
      left: -scrollAmount,
      behavior: 'smooth'
    });
  }
};

/**
 * 向右滚动
 */
const scrollRight = () => {
  if (buttonsWrapper.value) {
    const scrollAmount = 240;
    buttonsWrapper.value.scrollBy({
      left: scrollAmount,
      behavior: 'smooth'
    });
  }
};

/**
 * 处理 OAuth 登录
 */
const handleOAuthLogin = async (provider: OAuthProvider) => {
  try {
    // 生成随机 state 参数（用于防止 CSRF 攻击）
    const state = Math.random().toString(36).substring(2, 15);
    
    // 保存 state 到 sessionStorage（回调时验证）
    sessionStorage.setItem('oauth_state', state);
    
    // 获取授权 URL
    const { data } = await useOAuthApi().getAuthorizeUrl(provider, state);
    
    // 跳转到授权页面
    window.location.href = data.authorize_url;
  } catch (error: any) {
    console.error('获取 OAuth 授权 URL 失败:', error);
    ElMessage.error(error.message || '获取授权链接失败，请稍后重试');
  }
};

// 生命周期
onMounted(() => {
  if (buttonsWrapper.value) {
    buttonsWrapper.value.addEventListener('scroll', updateScrollState);
    // 初始化滚动状态
    setTimeout(updateScrollState, 100);
  }
  
  // 监听窗口大小变化
  window.addEventListener('resize', updateScrollState);
});

onUnmounted(() => {
  if (buttonsWrapper.value) {
    buttonsWrapper.value.removeEventListener('scroll', updateScrollState);
  }
  window.removeEventListener('resize', updateScrollState);
});
</script>

<style scoped lang="scss">
.oauth-login {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.2);

  .oauth-login-title {
    text-align: center;
    font-size: 14px;
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: 20px;
  }

  .oauth-carousel {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;

    .carousel-arrow {
      flex-shrink: 0;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.25);
      transition: all 0.3s ease;
      color: rgba(255, 255, 255, 0.9);

      &:hover:not(.disabled) {
        background: rgba(255, 255, 255, 0.25);
        border-color: rgba(255, 255, 255, 0.4);
        transform: scale(1.05);
      }

      &:active:not(.disabled) {
        transform: scale(0.95);
      }

      &.disabled {
        opacity: 0.3;
        cursor: not-allowed;
        pointer-events: none;
      }

      .el-icon {
        font-size: 16px;
      }
    }

    .oauth-buttons-wrapper {
      flex: 1;
      overflow-x: auto;
      overflow-y: hidden;
      scroll-behavior: smooth;
      
      // 隐藏滚动条
      &::-webkit-scrollbar {
        display: none;
      }
      -ms-overflow-style: none;
      scrollbar-width: none;

      .oauth-buttons-container {
        display: flex;
        gap: 15px;
        padding: 2px 0; // 防止阴影被裁剪

        .oauth-button {
          flex-shrink: 0;
          width: 45px;
          height: 45px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s ease;
          border: 1px solid rgba(255, 255, 255, 0.2);
          position: relative;
          overflow: hidden;

          // 默认背景（半透明白色）
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(10px);

          &:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
          }

          &:active {
            transform: translateY(-1px) scale(1.02);
          }

          // 各提供商的品牌色背景
          &-gitee {
            background: linear-gradient(135deg, #c71d23 0%, #e84545 100%);
            border-color: #c71d23;
            
            :deep(svg) {
              color: #ffffff !important;
              fill: #ffffff !important;
            }
          }

          &-github {
            background: linear-gradient(135deg, #24292e 0%, #444d56 100%);
            border-color: #24292e;
            
            :deep(svg) {
              color: #ffffff !important;
              fill: #ffffff !important;
            }
          }

          &-qq {
            background: #ffffff;
            border-color: #e0e0e0;
            
            :deep(svg) {
              color: #12b7f5;
            }
          }

          &-google {
            background: #ffffff;
            border-color: #e0e0e0;
          }

          &-wechat {
            background: linear-gradient(135deg, #07c160 0%, #2aae67 100%);
            border-color: #07c160;
            
            :deep(svg) {
              color: #ffffff !important;
              fill: #ffffff !important;
            }
          }

          &-microsoft {
            background: #ffffff;
            border-color: #e0e0e0;
          }

          &-dingtalk {
            background: #ffffff;
            border-color: #e0e0e0;
            
            :deep(svg) {
              color: #0089ff;
            }
          }

          &-feishu {
            background: #ffffff;
            border-color: #e0e0e0;
            
            :deep(svg) {
              color: #00d6b9;
            }
          }

          .oauth-text {
            font-size: 14px;
            font-weight: 600;
            color: inherit;
          }

          :deep(svg) {
            // 让图标显示原始颜色
            filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.1));
            width: 24px;
            height: 24px;
          }
          
          // 只对特定按钮应用 currentColor
          &-gitee,
          &-github,
          &-wechat {
            :deep(svg path) {
              fill: currentColor;
            }
          }
        }
      }
    }
  }
}

// 响应式：小屏幕时调整按钮大小
@media (max-width: 640px) {
  .oauth-login {
    .oauth-carousel {
      gap: 8px;

      .carousel-arrow {
        width: 28px;
        height: 28px;

        .el-icon {
          font-size: 14px;
        }
      }

      .oauth-buttons-wrapper {
        .oauth-buttons-container {
          gap: 12px;

          .oauth-button {
            width: 40px;
            height: 40px;

            :deep(svg) {
              width: 20px;
              height: 20px;
            }
          }
        }
      }
    }
  }
}
</style>
