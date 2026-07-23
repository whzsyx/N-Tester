import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { directive } from '/@/directive/index';
import other from '/@/utils/other';

import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css';
import '/@/theme/index.scss';
import { initStores } from "/@/stores";
import NtestercCard from '/@/components/ntesterc/NtestercCard.vue';
import NtestercDialog from '/@/components/ntesterc/NtestercDialog.vue';
import NtestercDrawer from '/@/components/ntesterc/NtestercDrawer.vue';
import NtestercUploadImages from '/@/components/ntesterc/NtestercUploadImages.vue';
import NtestercUploadFiles from '/@/components/ntesterc/NtestercUploadFiles.vue';

async function initApplication() {
	const app = createApp(App);

	const namespace = `${import.meta.env.VITE_APP_NAMESPACE}`;
	await initStores(app, { namespace })

	// 全局注册 ntesterc 组件（支持 <ntestercCard> / <NtestercCard> 等写法）
	app.component('ntestercCard', NtestercCard);
	app.component('NtestercCard', NtestercCard);
	app.component('NtestercDialog', NtestercDialog);
	app.component('NtestercDrawer', NtestercDrawer);
	app.component('NtestercUploadImages', NtestercUploadImages);
	app.component('NtestercUploadFiles', NtestercUploadFiles);

	directive(app);
	other.apiPublicAssembly(app)
	app.use(router)
	app.use(ElementPlus)
	app.mount('#app');
}

initApplication()