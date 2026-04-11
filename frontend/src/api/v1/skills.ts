import request from '/@/utils/request';

export function useSkillsApi() {
  return {
    list: (projectId: number, params?: Record<string, any>) =>
      request({ url: `/v1/skills/projects/${projectId}`, method: 'get', params }),
    create: (projectId: number, data: any) =>
      request({ url: `/v1/skills/projects/${projectId}`, method: 'post', data }),
    update: (projectId: number, skillId: number, data: any) =>
      request({ url: `/v1/skills/projects/${projectId}/${skillId}`, method: 'put', data }),
    remove: (projectId: number, skillId: number) =>
      request({ url: `/v1/skills/projects/${projectId}/${skillId}`, method: 'delete' }),
    content: (projectId: number, skillId: number) =>
      request({ url: `/v1/skills/projects/${projectId}/${skillId}/content`, method: 'get' }),
    manifest: (projectId: number, skillId: number) =>
      request({ url: `/v1/skills/projects/${projectId}/${skillId}/manifest`, method: 'get' }),
    execute: (projectId: number, skillId: number, data?: { arguments?: Record<string, any>; session_id?: string }) =>
      request({ url: `/v1/skills/projects/${projectId}/${skillId}/execute`, method: 'post', data: data || {} }),
    executeActionAsync: (
      projectId: number,
      skillId: number,
      data?: { action_name?: string; arguments?: Record<string, any>; session_id?: string; runner_type?: string }
    ) => request({ url: `/v1/skills/projects/${projectId}/${skillId}/actions/execute`, method: 'post', data: data || {} }),
    job: (projectId: number, jobId: number) =>
      request({ url: `/v1/skills/projects/${projectId}/jobs/${jobId}`, method: 'get' }),
    jobArtifacts: (projectId: number, jobId: number) =>
      request({ url: `/v1/skills/projects/${projectId}/jobs/${jobId}/artifacts`, method: 'get' }),
    jobStreamUrl: (projectId: number, jobId: number) => `/v1/skills/projects/${projectId}/jobs/${jobId}/stream`,
    artifactDownloadUrl: (projectId: number, artifactId: number) =>
      `/v1/skills/projects/${projectId}/artifacts/${artifactId}/download`,
    importGit: (projectId: number, data: any) =>
      request({ url: `/v1/skills/projects/${projectId}/import/git`, method: 'post', data }),
    importUpload: (projectId: number, file: File, params?: { scenario_category?: string; entry_command?: string }) => {
      const fd = new FormData();
      fd.append('file', file);
      return request({
        url: `/v1/skills/projects/${projectId}/import/upload`,
        method: 'post',
        params,
        data: fd,
        headers: { 'Content-Type': 'multipart/form-data' },
      });
    },
  };
}

export const skillsApi = useSkillsApi();

