<template>
	<el-drawer
		v-model="visible"
		:title="title"
		:size="size"
		:direction="direction"
		:close-on-click-modal="closeOnClickModel"
		:destroy-on-close="destroyOnClose"
		:before-close="ntestercClose"
	>
		<div class="formDrawer">
			<div class="body">
				<slot name="content"></slot>
			</div>
			<div class="footer" v-if="!footerHidden">
				<el-button type="primary" :loading="confirmLoading" v-throttle="ntestercConfirm">{{ confirmText }}</el-button>
				<el-button type="danger" @click="ntestercCancel">{{ cancelText }}</el-button>
			</div>
		</div>
	</el-drawer>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { MsgWarning, MsgBox, MsgSuccess } from '/@/utils/ntesterc';

interface IDrawerProps {
	title?: string;
	visible?: boolean;
	size?: string;
	destroyOnClose?: boolean;
	closeOnClickModel?: boolean;
	confirmText?: string;
	cancelText?: string;
	direction?: any;
	loading?: boolean;
	footerHidden?: boolean;
	beforeCloseCheck?: boolean;
}

const props = withDefaults(defineProps<IDrawerProps>(), {
	title: 'NtestercDrawer',
	visible: false,
	size: '450',
	closeOnClickModel: false,
	destroyOnClose: false,
	confirmText: '确定',
	cancelText: '取消',
	direction: 'rtl',
	loading: false,
	footerHidden: false,
	beforeCloseCheck: true,
});

const visible = ref(false);
watch(
	() => props.visible,
	(v) => (visible.value = !!v),
	{ immediate: true }
);

const confirmLoading = ref(false);
watch(
	() => props.loading,
	(v) => {
		confirmLoading.value = !!v;
	},
	{ immediate: true }
);

const ntestercOpen = () => (visible.value = true);

/** el-drawer 规范：before-close 需要 done()，否则 element-plus 可能出现 DOM 清理时序问题 */
const ntestercClose = (done?: () => void) => {
	// beforeCloseCheck=false：不弹确认，直接关闭并调用 done（如果有）
	if (props.beforeCloseCheck === false) {
		visible.value = false;
		done?.();
		return;
	}

	MsgBox('您确认进行关闭么？')
		.then(() => {
			visible.value = false;
			done?.();
		})
		.catch(() => {
			done?.();
		});
};

const ntestercQuickClose = (data: any) => {
	visible.value = false;
	if (data !== undefined && data !== null && data !== '') MsgSuccess(data);
};

const emits = defineEmits(['ntestercConfirm', 'ntestercCancel']);
const ntestercConfirm = () => emits('ntestercConfirm');
const ntestercCancel = () => emits('ntestercCancel');

defineExpose({ ntestercOpen, ntestercClose, ntestercQuickClose });
</script>

<style lang="scss" scoped>
.formDrawer {
	display: flex;
	flex-direction: column;
	width: 100%;
	height: 100%;
	.body {
		flex: 1;
		overflow-y: auto;
	}
	.footer {
		display: flex;
		align-items: center;
		height: 50px;
		margin-top: auto;
	}
}
</style>

