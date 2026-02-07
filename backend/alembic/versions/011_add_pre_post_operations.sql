-- 011: 添加前置/后置操作支持
-- 将前置/后置脚本改为操作列表，支持多种操作类型

-- 修改 api_requests 表
ALTER TABLE `api_requests` 
  MODIFY COLUMN `pre_request_script` JSON COMMENT '前置操作列表',
  MODIFY COLUMN `post_request_script` JSON COMMENT '后置操作列表';

-- 创建公共脚本表
CREATE TABLE IF NOT EXISTS `api_public_scripts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT NOT NULL COMMENT '关联项目ID',
  `name` VARCHAR(200) NOT NULL COMMENT '脚本名称',
  `description` TEXT COMMENT '脚本描述',
  `script_type` VARCHAR(20) NOT NULL DEFAULT 'javascript' COMMENT '脚本类型: javascript/python',
  `script_content` TEXT NOT NULL COMMENT '脚本内容',
  `category` VARCHAR(50) COMMENT '分类',
  `is_active` TINYINT(1) DEFAULT 1 COMMENT '是否启用',
  `creation_date` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` BIGINT COMMENT '创建人ID',
  `updation_date` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` BIGINT COMMENT '更新人ID',
  `enabled_flag` TINYINT(1) DEFAULT 1 COMMENT '启用标志',
  `trace_id` VARCHAR(50) COMMENT '追踪ID',
  PRIMARY KEY (`id`),
  INDEX `idx_project_id` (`project_id`),
  INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API公共脚本表';

-- 创建数据库连接配置表
CREATE TABLE IF NOT EXISTS `api_database_configs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT NOT NULL COMMENT '关联项目ID',
  `name` VARCHAR(200) NOT NULL COMMENT '连接名称',
  `description` TEXT COMMENT '连接描述',
  `db_type` VARCHAR(20) NOT NULL COMMENT '数据库类型: mysql/postgresql/mongodb/redis',
  `host` VARCHAR(200) NOT NULL COMMENT '主机地址',
  `port` INT NOT NULL COMMENT '端口',
  `database_name` VARCHAR(200) COMMENT '数据库名',
  `username` VARCHAR(200) COMMENT '用户名',
  `password` VARCHAR(500) COMMENT '密码（加密存储）',
  `connection_params` JSON COMMENT '其他连接参数',
  `is_active` TINYINT(1) DEFAULT 1 COMMENT '是否启用',
  `creation_date` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` BIGINT COMMENT '创建人ID',
  `updation_date` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` BIGINT COMMENT '更新人ID',
  `enabled_flag` TINYINT(1) DEFAULT 1 COMMENT '启用标志',
  `trace_id` VARCHAR(50) COMMENT '追踪ID',
  PRIMARY KEY (`id`),
  INDEX `idx_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API数据库连接配置表';
