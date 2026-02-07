-- 修复：为 test_case_steps 表添加缺失的 trace_id 字段
-- 创建时间：2026-02-06

ALTER TABLE test_case_steps 
ADD COLUMN trace_id VARCHAR(50) COMMENT '追踪ID' AFTER enabled_flag;
