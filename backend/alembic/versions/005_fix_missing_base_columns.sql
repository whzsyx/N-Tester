-- 修复：为关联表添加缺失的基础字段
-- 创建时间：2026-02-06

-- 1. 为 project_versions 表添加缺失字段
ALTER TABLE project_versions 
ADD COLUMN updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER created_by,
ADD COLUMN updated_by BIGINT COMMENT '更新人ID' AFTER updation_date,
ADD COLUMN trace_id VARCHAR(50) COMMENT '追踪ID' AFTER enabled_flag;

-- 2. 为 test_case_versions 表添加缺失字段
ALTER TABLE test_case_versions 
ADD COLUMN updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER created_by,
ADD COLUMN updated_by BIGINT COMMENT '更新人ID' AFTER updation_date,
ADD COLUMN trace_id VARCHAR(50) COMMENT '追踪ID' AFTER enabled_flag;
