-- 更新项目管理表字段名以匹配现有架构
-- 执行时间: 2026-02-06

-- 1. 更新 projects 表
ALTER TABLE `projects` 
  CHANGE COLUMN `created_at` `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  CHANGE COLUMN `updated_at` `updation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  ADD COLUMN `enabled_flag` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除' AFTER `updated_by`,
  ADD COLUMN `trace_id` VARCHAR(255) NULL COMMENT 'trace_id' AFTER `enabled_flag`;

-- 2. 更新 project_members 表
ALTER TABLE `project_members`
  CHANGE COLUMN `created_at` `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  CHANGE COLUMN `updated_at` `updation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  ADD COLUMN `enabled_flag` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除' AFTER `updated_by`,
  ADD COLUMN `trace_id` VARCHAR(255) NULL COMMENT 'trace_id' AFTER `enabled_flag`;

-- 3. 更新 project_environments 表
ALTER TABLE `project_environments`
  CHANGE COLUMN `created_at` `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  CHANGE COLUMN `updated_at` `updation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  ADD COLUMN `enabled_flag` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除' AFTER `updated_by`,
  ADD COLUMN `trace_id` VARCHAR(255) NULL COMMENT 'trace_id' AFTER `enabled_flag`;
