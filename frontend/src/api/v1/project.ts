import request from '/@/utils/request';

/**
 * 项目管理API
 */
const projectApi = {
  getProjectList(params?: {
    page?: number;
    page_size?: number;
    name?: string;
    status?: string;
  }) {
    return request({
      url: '/v1/projects/',
      method: 'GET',
      params,
    });
  },
  getProjectDetail(id: number) {
    return request({
      url: `/v1/projects/${id}`,
      method: 'GET',
    });
  },
  createProject(data: { name: string; description?: string; status?: string }) {
    return request({
      url: '/v1/projects/',
      method: 'POST',
      data,
    });
  },
  updateProject(
    id: number,
    data: { name?: string; description?: string; status?: string },
  ) {
    return request({
      url: `/v1/projects/${id}`,
      method: 'PUT',
      data,
    });
  },
  deleteProject(id: number) {
    return request({
      url: `/v1/projects/${id}`,
      method: 'DELETE',
    });
  },
};

export function useProjectApi() {
  return projectApi;
}

export const getProjectList = projectApi.getProjectList.bind(projectApi);
export const getProjectDetail = projectApi.getProjectDetail.bind(projectApi);
export const createProject = projectApi.createProject.bind(projectApi);
export const updateProject = projectApi.updateProject.bind(projectApi);
export const deleteProject = projectApi.deleteProject.bind(projectApi);
