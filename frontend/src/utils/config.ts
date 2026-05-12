/** 构建期注入的 API 根（不含路径前缀）；空字符串表示与页面同源 */
function envApiBaseRaw(): string {
	const v = import.meta.env.VITE_API_BASE_URL;
	if (v === undefined || v === null) return '';
	return String(v).trim().replace(/\/$/, '');
}

export function getEnv() {
	return import.meta.env.ENV;
}

/** axios baseURL：同源时为 "/api"，分离部署时为 "https://host/api" */
export function getApiBaseUrl(): string {
	const base = envApiBaseRaw();
	const prefix = String(import.meta.env.VITE_API_PREFIX ?? '/api');
	if (!base) return prefix;
	return `${base}${prefix}`;
}

export function getWebSocketUrl() {
	return (window.location.protocol === 'https:' ? 'wss' : 'ws') + '://' + import.meta.env.VITE_WBE_SOCKET_URL;
}

/**
 * 用于拼接静态资源、头像等绝对 URL。
 * 未配置 VITE_API_BASE_URL 时回退为当前页 origin（便携/同源部署）。
 */
export function getBaseApiUrl(): string {
	const base = envApiBaseRaw();
	if (base) return base;
	if (typeof window !== 'undefined' && window.location?.origin) {
		return window.location.origin;
	}
	return '';
}
