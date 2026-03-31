import axios from '@/utils/axios.ts';

enum API {
	FILE_LIST = '/api/v1/system/file/list',
}

export const file_list = (params: any) => axios.post(API.FILE_LIST, params);

