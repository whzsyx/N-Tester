import { request } from '/@/utils/request';

export function usePerformanceApi() {
	return {
		// 配置管理
		getConfigList: (params?: any) => {
			return request({ url: '/v1/performance/configs', method: 'GET', params });
		},

		// 造数管理
		getDataList: (params?: any) => {
			return request({ url: '/v1/performance/data', method: 'GET', params });
		},

		// 文件管理
		getFileList: (params?: any) => {
			return request({ url: '/v1/performance/files', method: 'GET', params });
		},

		// 压测场景
		getScenarioList: (params?: any) => {
			return request({ url: '/v1/performance/scenarios', method: 'GET', params });
		},

		// 定时任务
		getSchedulerList: (params?: any) => {
			return request({ url: '/v1/performance/schedulers', method: 'GET', params });
		},

		// 测试报告
		getReportList: (params?: any) => {
			return request({ url: '/v1/performance/reports', method: 'GET', params });
		},
	};
}