-- 添加API测试模块缺失的字段
-- 创建时间: 2026-02-07

-- 1. 为 api_test_executions 表添加缺失字段
ALTER TABLE api_test_executions 
ADD COLUMN IF NOT EXISTS created_by BIGINT COMMENT '创建人ID' AFTER creation_date,
ADD COLUMN IF NOT EXISTS updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER created_by,
ADD COLUMN IF NOT EXISTS updated_by BIGINT COMMENT '更新人ID' AFTER updation_date,
ADD COLUMN IF NOT EXISTS enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用' AFTER updated_by,
ADD COLUMN IF NOT EXISTS trace_id VARCHAR(50) COMMENT '追踪ID' AFTER enabled_flag;

-- 2. 为 api_request_histories 表添加缺失字段（如果需要）
-- api_request_histories 表不需要这些字段，因为它是历史记录表

-- 添加索引
ALTER TABLE api_test_executions ADD INDEX IF NOT EXISTS idx_enabled (enabled_flag);
