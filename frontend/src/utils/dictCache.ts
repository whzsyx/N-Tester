import { ref } from 'vue';
import { useDictDataApi } from '/@/api/v1/system/dict';

export interface DictOption {
  label: string;
  value: string | number;
  raw?: any;
}

const dictDataApi = useDictDataApi();
const dictCache = new Map<string, DictOption[]>();
const pending = new Map<string, Promise<DictOption[]>>();
const loading = ref(false);

function normalizeItem(item: any): DictOption {
  return {
    label: String(item?.dict_label ?? item?.label ?? item?.name ?? item?.text ?? ''),
    value: item?.dict_value ?? item?.value ?? item?.id ?? '',
    raw: item,
  };
}

function normalizeList(data: any): DictOption[] {
  const list = Array.isArray(data)
    ? data
    : Array.isArray(data?.items)
      ? data.items
      : Array.isArray(data?.content)
        ? data.content
        : [];
  return list.map(normalizeItem).filter((x) => x.label !== '');
}

async function fetchDict(dictType: string): Promise<DictOption[]> {
  const key = String(dictType || '').trim();
  if (!key) return [];
  if (dictCache.has(key)) return dictCache.get(key) || [];
  if (pending.has(key)) return pending.get(key)!;

  loading.value = true;
  const request = dictDataApi
    .getByType(key)
    .then((res: any) => {
      const options = normalizeList(res?.data);
      dictCache.set(key, options);
      return options;
    })
    .finally(() => {
      pending.delete(key);
      loading.value = pending.size > 0;
    });

  pending.set(key, request);
  return request;
}

export function useDictCache() {
  const getDictOptions = async (dictType: string, withAll = false) => {
    const options = await fetchDict(dictType);
    if (!withAll) return options;
    return [{ label: '全部', value: '' }, ...options];
  };

  const getDictLabel = async (
    dictType: string,
    value: string | number,
    fallback = String(value ?? ''),
  ) => {
    const options = await fetchDict(dictType);
    const hit = options.find((x) => String(x.value) === String(value));
    return hit?.label ?? fallback;
  };

  const refreshDict = async (dictType: string) => {
    const key = String(dictType || '').trim();
    if (!key) return [];
    dictCache.delete(key);
    return fetchDict(key);
  };

  const clearDictCache = (dictType?: string) => {
    if (dictType) {
      dictCache.delete(String(dictType).trim());
      return;
    }
    dictCache.clear();
  };

  return {
    dictLoading: loading,
    getDictOptions,
    getDictLabel,
    refreshDict,
    clearDictCache,
  };
}

