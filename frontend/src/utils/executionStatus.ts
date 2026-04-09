export type ExecutionStatusType = 0 | 1 | 2;

export interface ExecutionStatusMeta {
  text: string;
  tagType: 'warning' | 'success' | 'danger' | 'info';
  isRunning: boolean;
  isStopped: boolean;
  canViewReport: boolean;
  canRerun: boolean;
}

export function getExecutionStatusMeta(status: number): ExecutionStatusMeta {
  const s = Number(status) as ExecutionStatusType;
  if (s === 2) {
    return {
      text: '已停止',
      tagType: 'danger',
      isRunning: false,
      isStopped: true,
      canViewReport: true,
      canRerun: true,
    };
  }
  if (s === 1) {
    return {
      text: '执行完成',
      tagType: 'success',
      isRunning: false,
      isStopped: false,
      canViewReport: true,
      canRerun: true,
    };
  }
  return {
    text: '执行中',
    tagType: 'warning',
    isRunning: true,
    isStopped: false,
    canViewReport: false,
    canRerun: false,
  };
}

