-- 为 api_requests 表添加新字段
-- 添加时间: 2026-02-07

ALTER TABLE `api_requests` ADD COLUMN `cookies` JSON COMMENT 'Cookies' AFTER `body`;

ALTER TABLE `api_requests` ADD COLUMN `verify_ssl` TINYINT(1) DEFAULT 1 COMMENT 'SSL证书验证' AFTER `assertions`;

ALTER TABLE `api_requests` ADD COLUMN `follow_redirects` TINYINT(1) DEFAULT 1 COMMENT '自动跟随重定向' AFTER `verify_ssl`;

ALTER TABLE `api_requests` ADD COLUMN `timeout` INT DEFAULT 30000 COMMENT '超时时间(毫秒)' AFTER `follow_redirects`;
