-- 010_create_ssl_certificate_table.sql
-- 创建SSL证书管理表

-- SSL证书表
CREATE TABLE IF NOT EXISTS `api_ssl_certificate` (
    `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `project_id` INT NOT NULL COMMENT '关联项目ID',
    `name` VARCHAR(200) NOT NULL COMMENT '证书名称',
    `cert_type` VARCHAR(50) NOT NULL COMMENT '证书类型: CA/CLIENT',
    `domain` VARCHAR(500) NULL COMMENT '适用域名（支持通配符）',
    `ca_cert` TEXT NULL COMMENT 'CA证书内容（PEM格式）',
    `client_cert` TEXT NULL COMMENT '客户端证书内容（CRT/PEM格式）',
    `client_key` TEXT NULL COMMENT '客户端私钥内容（KEY/PEM格式）',
    `passphrase` VARCHAR(500) NULL COMMENT '私钥密码（加密存储）',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
    `description` TEXT NULL COMMENT '描述',
    `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `created_by` INT NULL COMMENT '创建人ID',
    `updation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `updated_by` INT NULL COMMENT '更新人ID',
    `enabled_flag` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '启用标志',
    `trace_id` VARCHAR(100) NULL COMMENT '追踪ID',
    PRIMARY KEY (`id`),
    INDEX `idx_project_id` (`project_id`),
    INDEX `idx_domain` (`domain`(255)),
    INDEX `idx_cert_type` (`cert_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SSL证书管理表';
