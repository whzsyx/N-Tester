import request from '/@/utils/request';

/**
 * 项目管理API
 * 注意：这是业务特定功能
 */
export function useProjectApi() {
  return {

    getList: (data?: any) => {
      return request({
        url: '/project/list',
        method: 'POST',
        data,
      });
    },
    

    saveOrUpdate: (data?: any) => {
      return request({
        url: '/project/saveOrUpdate',
        method: 'POST',
        data,
      });
    },
    

    deleted: (data?: any) => {
      return request({
        url: '/project/deleted',
        method: 'POST',
        data,
      });
    },
  };
}
