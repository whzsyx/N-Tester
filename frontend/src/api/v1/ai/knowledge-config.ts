import request from '/@/utils/request';

export function useAiKnowledgeConfigApi() {
  return {
    getGlobal: () =>
      request({ url: '/v1/ai/knowledge-config/global', method: 'get' }),
    saveGlobal: (data: any) =>
      request({ url: '/v1/ai/knowledge-config/global', method: 'put', data }),
    testEmbedding: (data: any) =>
      request({ url: '/v1/ai/knowledge-config/test-embedding', method: 'post', data }),
    testVectorDb: (data: any) =>
      request({ url: '/v1/ai/knowledge-config/test-vector-db', method: 'post', data }),
  };
}

export const aiKnowledgeConfigApi = useAiKnowledgeConfigApi();
