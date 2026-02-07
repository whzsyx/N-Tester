/**
 * 测试用例管理API
 */
import request from '/@/utils/request';

// ========== 测试用例相关接口 ==========

/**
 * 创建测试用例
 */
export function createTestCase(projectId: number, data: any) {
	return request({
		url: `/v1/testcases?project_id=${projectId}`,
		method: 'post',
		data,
	});
}

/**
 * 获取测试用例列表
 */
export function getTestCaseList(params: any) {
	return request({
		url: '/v1/testcases',
		method: 'get',
		params,
	});
}

/**
 * 获取测试用例详情
 */
export function getTestCaseDetail(id: number) {
	return request({
		url: `/v1/testcases/${id}`,
		method: 'get',
	});
}

/**
 * 更新测试用例
 */
export function updateTestCase(id: number, data: any) {
	return request({
		url: `/v1/testcases/${id}`,
		method: 'put',
		data,
	});
}

/**
 * 删除测试用例
 */
export function deleteTestCase(id: number) {
	return request({
		url: `/v1/testcases/${id}`,
		method: 'delete',
	});
}

// ========== 版本管理相关接口 ==========

/**
 * 创建版本
 */
export function createVersion(data: any) {
	return request({
		url: '/v1/testcases/versions',
		method: 'post',
		data,
	});
}

/**
 * 获取版本列表
 */
export function getVersionList(params: any) {
	return request({
		url: '/v1/testcases/versions',
		method: 'get',
		params,
	});
}

/**
 * 获取版本详情
 */
export function getVersionDetail(id: number) {
	return request({
		url: `/v1/testcases/versions/${id}`,
		method: 'get',
	});
}

/**
 * 更新版本
 */
export function updateVersion(id: number, data: any) {
	return request({
		url: `/v1/testcases/versions/${id}`,
		method: 'put',
		data,
	});
}

/**
 * 删除版本
 */
export function deleteVersion(id: number) {
	return request({
		url: `/v1/testcases/versions/${id}`,
		method: 'delete',
	});
}

/**
 * 关联测试用例到版本
 */
export function associateTestCases(data: any) {
	return request({
		url: '/v1/testcases/versions/associate',
		method: 'post',
		data,
	});
}
