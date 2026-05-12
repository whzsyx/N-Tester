<template>
  <div class="personal layout-pd">
    <el-row>
      <!-- 个人信息 -->
      <el-col :xs="24" :sm="8" style="padding: 0 10px">
        <z-card>
          <div class="personal-user">
            <div class="personal-user-avatar" @click="onCropperDialogOpen">

              <el-avatar :size="100"
                         :src="state.userInfoForm.avatar"
                         title="点击更换头像"
                         :style="state.userInfoForm.avatar? {'--el-avatar-bg-color': 'transparent'}: {}"
                         style="cursor: pointer; ">
                <span style="font-size: 40px">{{
                    state.userInfoForm?.nickname ? state.userInfoForm?.nickname.slice(0, 1).toUpperCase() : ""
                  }}</span>
              </el-avatar>

            </div>
            <div class="personal-user-right">
              <el-row>
                <el-col :span="24">
                  <div class="personal-user-name">
                    <strong>{{ state.userInfoForm.nickname }}</strong>
                  </div>
                </el-col>
                <el-col :span="24">
                  <div class="personal-user-description">
                    <div>
                      <span>{{ state.userInfoForm.remarks }}</span>
                    </div>
                  </div>
                </el-col>

                <el-col :span="24">
                  <el-divider content-position="left">个人信息</el-divider>
                </el-col>
                <el-col :span="24">
                  <div class="personal-item">
                    <div class="personal-item-label">昵称：</div>
                    <div class="personal-item-value">{{ userStores.userInfos.nickname }}</div>
                  </div>
                </el-col>

                <el-col :span="24">
                  <div class="personal-item">
                    <div class="personal-item-label">身份：</div>
                    <div class="personal-item-value">超级管理</div>
                  </div>
                </el-col>

                <el-col :span="24">
                  <div class="personal-item">
                    <div class="personal-item-label">登录IP：</div>
                    <div class="personal-item-value">{{ state.userInfoForm.last_login_ip || '未知' }}</div>
                  </div>
                </el-col>

                <el-col :span="24">
                  <div class="personal-item">
                    <div class="personal-item-label">登录时间：</div>
                    <div class="personal-item-value">{{ formatLoginTime(state.userInfoForm.last_login_time) }}</div>
                  </div>
                </el-col>

                <el-col :span="24">
                  <div class="personal-item">
                    <div class="personal-item-label">密码：</div>
                    <div class="personal-item-value">
                      <el-button text type="primary" @click="updatePassword">修改密码</el-button>
                    </div>
                  </div>
                </el-col>
                <el-col :span="24">
                  <el-button type="primary" @click="state.showEditPage = !state.showEditPage">
                    <el-icon>
                      <ele-Position/>
                    </el-icon>
                    更新个人信息
                  </el-button>
                </el-col>

                <el-col :span="24">
                  <el-divider content-position="left">个性标签</el-divider>
                </el-col>
                <el-col :span="24">
                  <div class="personal-item-tag">
                    <el-tag
                        v-for="tag in state.userInfoForm.tags"
                        :key="tag"
                        size="default"
                        type="success"
                        style="{margin-left: 0.25rem;margin-right: 0.25rem;}"
                        :disable-transitions="false"
                    >{{ tag }}
                    </el-tag>
                  </div>
                </el-col>

              </el-row>
            </div>
          </div>
        </z-card>
      </el-col>

      <!-- 消息通知 -->
      <el-col :xs="24" :sm="16" class="pl15 personal-info">
        <z-card shadow="hover">
          <template #header>
            <span>消息通知</span>
          </template>
          <div class="personal-info-box">
            <ul class="personal-info-ul">
              <li v-for="(v, k) in state.newsInfoList" :key="k" class="personal-info-li">
                <a :href="v.link" target="_block" class="personal-info-li-title">{{ v.title }}</a>
              </li>
            </ul>
          </div>
        </z-card>
      </el-col>


    </el-row>
    <!-- 更新信息 -->
    <el-dialog title="更新"
               destroy-on-close
               v-model="state.showEditPage">
      <el-row>
        <el-col :span="24" style="padding: 0 10px">
          <z-card class="personal-edit">
            <div class="personal-edit-title">基本信息</div>
            <el-form 
              ref="profileFormRef" 
              :model="state.userInfoForm" 
              :rules="state.profileRules"
              size="default" 
              label-width="auto" 
              class="mt35 mb35">
              <el-row :gutter="35">
                <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24" class="mb20">
                  <el-form-item 
                    label="昵称" 
                    prop="nickname"
                    :rules="[
                      { required: true, message: '请输入昵称', trigger: 'blur' },
                      { min: 1, max: 255, message: '昵称长度在 1 到 255 个字符', trigger: 'blur' }
                    ]">
                    <el-input v-model="state.userInfoForm.nickname" placeholder="请输入昵称" clearable></el-input>
                  </el-form-item>
                </el-col>
                <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24" class="mb20">
                  <el-form-item 
                    label="签名" 
                    prop="remarks"
                    :rules="[
                      { max: 500, message: '签名长度不能超过 500 个字符', trigger: 'blur' }
                    ]">
                    <el-input v-model="state.userInfoForm.remarks" placeholder="请输入签名" clearable></el-input>
                  </el-form-item>
                </el-col>

                <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24" class="mb20">
                  <el-form-item label="个性标签">
                    <el-tag
                        v-for="tag in state.userInfoForm.tags"
                        :key="tag"
                        size="default"
                        type="success"
                        closable
                        style="{margin-left: 0.25rem;margin-right: 0.25rem;}"
                        :disable-transitions="false"
                        @close="removeTag(tag)"
                    >{{ tag }}
                    </el-tag>

                    <el-input
                        v-if="state.editTag"
                        ref="UserTagInputRef"
                        v-model="state.tagValue"
                        class="ml-1 w-20"
                        size="small"
                        @keyup.enter="addTag"
                        @blur="addTag"
                        style="width: 100px"
                    />
                    <el-button v-else size="small" @click="showEditTag">
                      + New Tag
                    </el-button>
                    <!--                  <el-input v-model="state.userInfoForm.tags" placeholder="请输入签名" clearable></el-input>-->
                  </el-form-item>
                </el-col>

                <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24" class="mb20">
                  <el-form-item 
                    label="邮箱" 
                    prop="email"
                    :rules="[
                      { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
                    ]">
                    <el-input v-model="state.userInfoForm.email" placeholder="请输入邮箱" clearable></el-input>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form>
          </z-card>
        </el-col>
      </el-row>
      <template #footer>
        <el-button type="primary" @click="save">
          更新
        </el-button>
      </template>
    </el-dialog>

    <SeePictures ref="SeePicturesRef" @updateAvatar="updateAvatar"></SeePictures>

    <ResetPassword ref="ResetPasswordRef"></ResetPassword>
  </div>
</template>

<script setup lang="ts" name="personal">
import {computed, defineAsyncComponent, nextTick, onMounted, reactive, ref} from 'vue';
import {formatAxis, formatDateTime} from '/@/utils/formatTime';
import {useUserStore} from "/@/stores/user";
import {useUserApi} from "/@/api/v1/system/user";
import {getBaseApiUrl} from "/@/utils/config";
import {ElMessage} from "element-plus";
import {storeToRefs} from "pinia";
import ResetPassword from "/@/views/system/personal/ResetPassword.vue";

const SeePictures = defineAsyncComponent(() => import("/@/components/seePictures/index.vue"))
const SeePicturesRef = ref();
const UserTagInputRef = ref();
const ResetPasswordRef = ref();
const profileFormRef = ref(); // 个人信息表单引用

// 用户信息
const userStores = useUserStore()
const {userInfos} = storeToRefs(userStores);


// 定义变量内容
const state = reactive({
  newsInfoList: [],
  recommendList: [],
  userInfoForm: {
    id: null,
    username: '',
    nickname: '',
    avatar: '',
    remarks: '',
    email: '',
    tags: [],
  } as any,
  editTag: false,
  tagValue: "",
  showEditPage: false,
  cropperImg: '',
  // 表单验证规则
  profileRules: {
    nickname: [
      { required: true, message: '请输入昵称', trigger: 'blur' },
      { min: 1, max: 255, message: '昵称长度在 1 到 255 个字符', trigger: 'blur' }
    ],
    remarks: [
      { max: 500, message: '签名长度不能超过 500 个字符', trigger: 'blur' }
    ],
    email: [
      { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
    ]
  }
});

const getUserInfo = async () => {
  console.log(userInfos.value, '---> userInfos')
  let {data} = await useUserApi().getUserInfo({id: userInfos.value.id})
  
  // 处理头像URL：如果是相对路径，添加完整的基础URL
  if (data.avatar && data.avatar.startsWith('/static/')) {
    data.avatar = `${getBaseApiUrl()}${data.avatar}`;
  }
  
  state.userInfoForm = data
}

// 当前时间提示语
const currentTime = computed(() => {
  return formatAxis(new Date());
});

// 格式化登录时间
const formatLoginTime = (time: any) => {
  if (!time) return '未登录';
  return formatDateTime(time);
};

// 打开裁剪弹窗
const onCropperDialogOpen = () => {
  SeePicturesRef.value.openDialog(state.userInfoForm.avatar);
};


// tags
const showEditTag = () => {
  state.editTag = true
  nextTick(() => {
    UserTagInputRef.value?.input.focus()
  })
}

const removeTag = (tag) => {
  state.userInfoForm.tags.splice(state.userInfoForm.tags.indexOf(tag), 1)
}

const addTag = () => {
  if (state.editTag && state.tagValue) {
    if (!state.userInfoForm.tags) state.userInfoForm.tags = []
    state.userInfoForm.tags.push(state.tagValue)
  }
  state.editTag = false
  state.tagValue = ''
}

const save = async () => {
  // 先进行表单验证
  if (!profileFormRef.value) return;
  
  try {
    const valid = await profileFormRef.value.validate();
    if (!valid) return;
  } catch (error) {
    ElMessage.error('请检查表单输入');
    return;
  }
  
  // 准备提交数据，过滤空值
  const profileData: any = {};
  
  // 昵称是必填项
  if (state.userInfoForm.nickname && state.userInfoForm.nickname.trim()) {
    profileData.nickname = state.userInfoForm.nickname.trim();
  } else {
    ElMessage.error('昵称不能为空');
    return;
  }
  
  // 签名是可选项，但如果有值则添加
  if (state.userInfoForm.remarks !== undefined && state.userInfoForm.remarks !== null) {
    profileData.remarks = state.userInfoForm.remarks.trim();
  }
  
  // 邮箱是可选项，但如果有值则添加
  if (state.userInfoForm.email && state.userInfoForm.email.trim()) {
    profileData.email = state.userInfoForm.email.trim();
  }
  
  // 标签
  profileData.tags = state.userInfoForm.tags || [];
  
  try {
    await useUserApi().updateProfile(profileData);
    ElMessage.success("更新成功!╰(*°▽°*)╯😍");
    state.showEditPage = false;
    // 刷新用户信息
    await getUserInfo();
  } catch (error: any) {
    ElMessage.error(error.message || '更新失败');
  }
}

const updateAvatar = async (img: string) => {
  try {
    // 上传头像
    await useUserApi().updateUserAvatar({id: state.userInfoForm.id, avatar: img})
    
    // 重新获取用户信息以获取正确的头像URL
    await getUserInfo()
    
    // 更新store中的用户信息
    userInfos.value.avatar = state.userInfoForm.avatar
    await userStores.updateUserInfo(userInfos.value)
    
    ElMessage.success("更新成功!╰(*°▽°*)╯😍")
  } catch (error: any) {
    ElMessage.error(error.message || '头像更新失败')
  }
}

const updatePassword = () => {
  ResetPasswordRef.value.openDialog(userInfos.value)
}

onMounted(() => {
  nextTick(() => {
    getUserInfo()
  })
})
</script>

<style scoped lang="scss">
@import '../../../theme/mixins/index.scss';

.personal {
  .personal-user {
    //height: 130px;
    //display: flex;
    align-items: center;
    padding: 20px;


    .personal-user-avatar {
      width: 100px;
      height: 100px;
      margin: auto;
      border-radius: 3px;
      margin-bottom: 20px;

      img {
        cursor: pointer;
        width: 100%;
        height: 100%;
        border-radius: 50%;
      }
    }


    .personal-user-right {
      flex: 1;
      padding: 0 15px;

      .personal-user-name {
        text-align: center;
        font-size: 20px;
        margin-bottom: 10px;
      }

      .personal-user-description {
        text-align: center;
      }

      .personal-title {
        font-size: 18px;
        @include text-ellipsis(1);
      }

      .personal-item {
        display: flex;
        align-items: center;
        font-size: 13px;
        height: 30px;
        width: 100%;
        flex-flow: wrap;

        .personal-item-label {
          color: var(--el-text-color-secondary);
          @include text-ellipsis(1);
        }

        .personal-item-value {
          @include text-ellipsis(1);
        }
      }

      .personal-item-tag {
        .personal-item-tag-item {
          margin: 5px;
          float: left;
        }
      }
    }
  }

  .personal-info {

    .personal-info-box {
      height: 130px;
      overflow: hidden;

      .personal-info-ul {
        list-style: none;

        .personal-info-li {
          font-size: 13px;
          padding-bottom: 10px;

          .personal-info-li-title {
            display: inline-block;
            @include text-ellipsis(1);
            color: var(--el-text-color-secondary);
            text-decoration: none;
          }

          & a:hover {
            color: var(--el-color-primary);
            cursor: pointer;
          }
        }
      }
    }
  }

  .personal-recommend-row {
    .personal-recommend-col {
      .personal-recommend {
        position: relative;
        height: 100px;
        border-radius: 3px;
        overflow: hidden;
        cursor: pointer;

        &:hover {
          i {
            right: 0px !important;
            bottom: 0px !important;
            transition: all ease 0.3s;
          }
        }

        i {
          position: absolute;
          right: -10px;
          bottom: -10px;
          font-size: 70px;
          transform: rotate(-30deg);
          transition: all ease 0.3s;
        }

        .personal-recommend-auto {
          padding: 15px;
          position: absolute;
          left: 0;
          top: 5%;
          color: var(--next-color-white);

          .personal-recommend-msg {
            font-size: 12px;
            margin-top: 10px;
          }
        }
      }
    }
  }

  .personal-edit {
    .personal-edit-title {
      position: relative;
      padding-left: 10px;
      color: var(--el-text-color-regular);

      &::after {
        content: '';
        width: 2px;
        height: 10px;
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        background: var(--el-color-primary);
      }
    }

    .personal-edit-safe-box {
      border-bottom: 1px solid var(--el-border-color-light, #ebeef5);
      padding: 15px 0;

      .personal-edit-safe-item {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;

        .personal-edit-safe-item-left {
          flex: 1;
          overflow: hidden;

          .personal-edit-safe-item-left-label {
            color: var(--el-text-color-regular);
            margin-bottom: 5px;
          }

          .personal-edit-safe-item-left-value {
            color: var(--el-text-color-secondary);
            @include text-ellipsis(1);
            margin-right: 15px;
          }
        }
      }

      &:last-of-type {
        padding-bottom: 0;
        border-bottom: none;
      }
    }
  }
}
</style>
