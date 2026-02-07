-- 创建编码序号表
CREATE TABLE IF NOT EXISTS `sys_code_sequence` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `business_type` varchar(100) NOT NULL COMMENT '业务类型',
  `prefix` varchar(50) DEFAULT '' COMMENT '前缀',
  `date_key` varchar(20) DEFAULT '' COMMENT '日期键（用于按日期重置）',
  `current_seq` int DEFAULT 0 COMMENT '当前序号',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint DEFAULT 1 COMMENT '启用标志 1:启用 0:禁用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_business_prefix_date` (`business_type`,`prefix`,`date_key`),
  KEY `idx_business_type` (`business_type`),
  KEY `idx_date_key` (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='编码序号表';
