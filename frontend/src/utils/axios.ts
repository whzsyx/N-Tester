import request from '/@/utils/request';

function normalizeUrl(url: string): string {
	const baseURL = ((request as any)?.defaults?.baseURL as string | undefined) || '';
	if (baseURL.includes('/api') && url.startsWith('/api/')) {
		return url.slice('/api'.length);
	}
	return url;
}

const axiosCompat = {
	post(url: string, data?: any, config?: any) {
		return (request as any).post(normalizeUrl(url), data, config);
	},
	get(url: string, params?: any, config?: any) {
		return (request as any).get(normalizeUrl(url), { params, ...(config || {}) });
	},
};

export default axiosCompat;

