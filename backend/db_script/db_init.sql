/*
 Navicat Premium Dump SQL

 Source Server         : rebort-测试开发平台开发
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : ntester

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 31/03/2026 10:35:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_assistant_configs
-- ----------------------------
DROP TABLE IF EXISTS `ai_assistant_configs`;
CREATE TABLE `ai_assistant_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '助手名称',
  `dify_api_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Dify API Key',
  `dify_base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Dify Base URL',
  `assistant_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'chatbot' COMMENT '助手类型: chatbot/workflow/agent',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `created_by` bigint NOT NULL COMMENT '创建者ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI助手配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_assistant_configs
-- ----------------------------
INSERT INTO `ai_assistant_configs` VALUES (5, '测试机器人', '88', 'https://api.dify.ai', 'chatbot', 1, 1, '2026-03-05 12:10:25', '2026-03-05 12:27:03', 1, '2026-03-05 12:10:25', NULL, '2026-03-05 12:27:03', NULL, NULL);
INSERT INTO `ai_assistant_configs` VALUES (6, '工作流', '8888', 'https://api.dify.ai', 'workflow', 1, 1, '2026-03-05 13:33:32', '2026-03-05 13:33:32', 1, '2026-03-05 13:33:32', NULL, '2026-03-05 13:33:32', NULL, NULL);
INSERT INTO `ai_assistant_configs` VALUES (7, '00', '00', 'https://api.dify.ai', 'agent', 1, 1, '2026-03-05 13:34:54', '2026-03-05 13:34:54', 1, '2026-03-05 13:34:54', NULL, '2026-03-05 13:34:54', NULL, NULL);

-- ----------------------------
-- Table structure for ai_browser_batch_tasks
-- ----------------------------
DROP TABLE IF EXISTS `ai_browser_batch_tasks`;
CREATE TABLE `ai_browser_batch_tasks`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `batch_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '批次ID(UUID)',
  `task_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务描述',
  `case_ids` json NOT NULL COMMENT '用例ID列表(JSON数组)',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行模式: headless-无头, headed-有头',
  `parallel_count` int NULL DEFAULT 1 COMMENT '并行执行数量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态: pending-待执行, running-执行中, completed-已完成, failed-失败, stopped-已停止',
  `progress` int NULL DEFAULT 0 COMMENT '进度百分比(0-100)',
  `current_case_index` int NULL DEFAULT 0 COMMENT '当前执行用例索引',
  `total_cases` int NULL DEFAULT 0 COMMENT '总用例数',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长(秒)',
  `success_count` int NULL DEFAULT 0 COMMENT '成功数量',
  `failed_count` int NULL DEFAULT 0 COMMENT '失败数量',
  `stopped_count` int NULL DEFAULT 0 COMMENT '停止数量',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `batch_id`(`batch_id` ASC) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI智能浏览器批量执行任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_browser_batch_tasks
-- ----------------------------
INSERT INTO `ai_browser_batch_tasks` VALUES (1, 'ddf3ca5f-292f-4f78-b215-f86af0b1ad8b', '批量执行任务_1772256723660', NULL, '[2]', 'headless', 1, 'pending', 0, 0, 1, NULL, NULL, NULL, 0, 0, 0, '2026-02-28 13:32:05', 1, '2026-02-28 13:32:05', NULL, 1, NULL);
INSERT INTO `ai_browser_batch_tasks` VALUES (2, '41c50ab5-5502-4549-b71d-ad690f9dc7fd', '批量执行任务_1772264872214', NULL, '[5, 6, 7, 8, 16]', 'headless', 1, 'pending', 0, 0, 5, NULL, NULL, NULL, 0, 0, 0, '2026-02-28 15:47:55', 1, '2026-02-28 15:47:55', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ai_browser_cases
-- ----------------------------
DROP TABLE IF EXISTS `ai_browser_cases`;
CREATE TABLE `ai_browser_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `case_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用例编号',
  `title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用例标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用例描述',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT '来源类型: manual-手动创建, import-导入, testcase-测试用例',
  `source_project_id` bigint NULL DEFAULT NULL COMMENT '来源项目ID',
  `source_testcase_id` bigint NULL DEFAULT NULL COMMENT '来源测试用例ID',
  `source_module_id` bigint NULL DEFAULT NULL COMMENT '来源模块ID',
  `priority` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'P2' COMMENT '优先级: P0/P1/P2/P3',
  `precondition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '前置条件',
  `test_steps` json NOT NULL COMMENT '测试步骤(JSON格式)',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '预期结果',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'headless' COMMENT '执行模式: headless-无头, headed-有头',
  `timeout` int NULL DEFAULT 300 COMMENT '超时时间(秒)',
  `retry_count` int NULL DEFAULT 0 COMMENT '重试次数',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'draft' COMMENT '状态: draft-草稿, active-激活, archived-归档',
  `last_execution_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后执行状态: success/failed/running',
  `last_execution_time` datetime NULL DEFAULT NULL COMMENT '最后执行时间',
  `execution_count` int NULL DEFAULT 0 COMMENT '执行次数',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_case_id`(`case_id` ASC) USING BTREE,
  INDEX `idx_source_project`(`source_project_id` ASC) USING BTREE,
  INDEX `idx_source_testcase`(`source_testcase_id` ASC) USING BTREE,
  INDEX `idx_source_module`(`source_module_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI智能浏览器用例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_browser_cases
-- ----------------------------
INSERT INTO `ai_browser_cases` VALUES (1, '99', '9', '99', 'manual', NULL, NULL, NULL, 'P2', '99', '[{\"expected\": \"99\", \"step_num\": 1, \"description\": \"99\"}]', NULL, 'headless', 300, 0, 'draft', NULL, NULL, 0, '2026-02-28 12:34:57', 1, '2026-02-28 12:35:21', NULL, 0, NULL);
INSERT INTO `ai_browser_cases` VALUES (2, '00', '00', '00', 'manual', NULL, NULL, NULL, 'P2', '00', '[{\"expected\": \"000\", \"step_num\": 1, \"description\": \"00\"}]', NULL, 'headless', 300, 0, 'draft', NULL, NULL, 0, '2026-02-28 12:36:32', 1, '2026-02-28 12:36:32', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ai_browser_execution_records
-- ----------------------------
DROP TABLE IF EXISTS `ai_browser_execution_records`;
CREATE TABLE `ai_browser_execution_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `case_id` bigint NOT NULL COMMENT '关联用例ID',
  `execution_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行ID(UUID)',
  `batch_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '批次ID(批量执行时使用)',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行模式: headless-无头, headed-有头',
  `execution_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'single' COMMENT '执行类型: single-单个, batch-批量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态: pending-待执行, running-执行中, success-成功, failed-失败, stopped-已停止',
  `progress` int NULL DEFAULT 0 COMMENT '进度百分比(0-100)',
  `current_step` int NULL DEFAULT 0 COMMENT '当前步骤序号',
  `total_steps` int NULL DEFAULT 0 COMMENT '总步骤数',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长(秒)',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `execution_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '执行日志',
  `ai_model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '使用的AI模型',
  `ai_thinking_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'AI思考过程日志',
  `actions_taken` json NULL COMMENT '执行的动作列表(JSON)',
  `screenshots` json NULL COMMENT '截图列表(JSON)',
  `steps_passed` int NULL DEFAULT 0 COMMENT '通过步骤数',
  `steps_failed` int NULL DEFAULT 0 COMMENT '失败步骤数',
  `api_calls_count` int NULL DEFAULT 0 COMMENT 'API调用次数',
  `tokens_used` int NULL DEFAULT 0 COMMENT '使用的Token数',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `execution_id`(`execution_id` ASC) USING BTREE,
  INDEX `idx_case_id`(`case_id` ASC) USING BTREE,
  INDEX `idx_execution_id`(`execution_id` ASC) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  CONSTRAINT `ai_browser_execution_records_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `ai_browser_cases` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI智能浏览器执行记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_browser_execution_records
-- ----------------------------
INSERT INTO `ai_browser_execution_records` VALUES (1, 2, '54db08f9-629c-4c70-903d-f863c9a439ab', NULL, 'headless', 'single', 'pending', 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, '2026-02-28 12:36:38', 1, '2026-02-28 12:36:38', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ai_browser_execution_statistics
-- ----------------------------
DROP TABLE IF EXISTS `ai_browser_execution_statistics`;
CREATE TABLE `ai_browser_execution_statistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `stat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'daily' COMMENT '统计类型: daily-每日, weekly-每周, monthly-每月',
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目ID(可选)',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID(可选)',
  `total_executions` int NULL DEFAULT 0 COMMENT '总执行次数',
  `success_executions` int NULL DEFAULT 0 COMMENT '成功次数',
  `failed_executions` int NULL DEFAULT 0 COMMENT '失败次数',
  `stopped_executions` int NULL DEFAULT 0 COMMENT '停止次数',
  `total_cases` int NULL DEFAULT 0 COMMENT '总用例数',
  `active_cases` int NULL DEFAULT 0 COMMENT '激活用例数',
  `avg_duration` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '平均执行时长(秒)',
  `total_duration` int NULL DEFAULT 0 COMMENT '总执行时长(秒)',
  `avg_steps` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '平均步骤数',
  `total_api_calls` int NULL DEFAULT 0 COMMENT '总API调用次数',
  `total_tokens` int NULL DEFAULT 0 COMMENT '总Token使用量',
  `success_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '成功率(%)',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stat`(`stat_date` ASC, `stat_type` ASC, `project_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE,
  INDEX `idx_stat_type`(`stat_type` ASC) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI智能浏览器执行统计表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_browser_execution_statistics
-- ----------------------------
INSERT INTO `ai_browser_execution_statistics` VALUES (1, '2026-02-28', 'daily', NULL, NULL, 0, 0, 0, 0, 0, 0, 0.00, 0, 0.00, 0, 0, 0.00, '2026-02-28 11:57:32', NULL, '2026-02-28 11:57:32', NULL, 1, NULL);
INSERT INTO `ai_browser_execution_statistics` VALUES (2, '2026-02-28', 'daily', NULL, NULL, 0, 0, 0, 0, 0, 0, 0.00, 0, 0.00, 0, 0, 0.00, '2026-02-28 12:19:14', NULL, '2026-02-28 12:19:14', NULL, 1, NULL);
INSERT INTO `ai_browser_execution_statistics` VALUES (3, '2026-02-28', 'daily', NULL, NULL, 0, 0, 0, 0, 1, 0, 0.00, 0, 0.00, 0, 0, 0.00, '2026-02-28 12:37:54', NULL, '2026-02-28 12:37:54', NULL, 1, NULL);
INSERT INTO `ai_browser_execution_statistics` VALUES (4, '2026-02-28', 'daily', NULL, NULL, 0, 0, 0, 0, 1, 0, 0.00, 0, 0.00, 0, 0, 0.00, '2026-02-28 12:38:32', NULL, '2026-02-28 12:38:32', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ai_cases
-- ----------------------------
DROP TABLE IF EXISTS `ai_cases`;
CREATE TABLE `ai_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ui_project_id` bigint NULL DEFAULT NULL COMMENT '所属UI项目ID',
  `source_project_id` bigint NULL DEFAULT NULL COMMENT '来源项目ID（测试管理项目）',
  `source_module_id` bigint NULL DEFAULT NULL COMMENT '来源模块ID（测试管理模块）',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `task_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务描述',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'active' COMMENT '状态: draft-草稿, active-激活, archived-归档',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'manual' COMMENT '来源类型: manual-手动创建, import-Excel导入, testcase-测试用例',
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'P2' COMMENT '优先级: P0-最高, P1-高, P2-中, P3-低',
  `precondition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '前置条件',
  `test_steps` json NULL COMMENT '测试步骤',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '预期结果',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'headless' COMMENT '执行模式',
  `timeout` int NULL DEFAULT 300 COMMENT '超时时间(秒)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project`(`ui_project_id` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_source_project`(`source_project_id` ASC) USING BTREE,
  INDEX `idx_source_module`(`source_module_id` ASC) USING BTREE,
  INDEX `idx_ai_cases_status`(`status` ASC) USING BTREE,
  INDEX `idx_ai_cases_source_type`(`source_type` ASC) USING BTREE,
  INDEX `idx_ai_cases_priority`(`priority` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 152 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI智能浏览器用例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_cases
-- ----------------------------

-- ----------------------------
-- Table structure for ai_conversations
-- ----------------------------
DROP TABLE IF EXISTS `ai_conversations`;
CREATE TABLE `ai_conversations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `assistant_config_id` bigint NOT NULL COMMENT '助手配置ID',
  `conversation_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Dify会话ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对话标题',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_assistant_config`(`assistant_config_id` ASC) USING BTREE,
  INDEX `idx_conversation_id`(`conversation_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI对话记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_conversations
-- ----------------------------
INSERT INTO `ai_conversations` VALUES (6, 1, 6, NULL, '与工作流的对话', '2026-03-05 13:44:26', '2026-03-05 13:44:26', 1, '2026-03-05 13:44:25', NULL, '2026-03-05 13:44:25', NULL, NULL);
INSERT INTO `ai_conversations` VALUES (7, 1, 6, NULL, '与工作流的对话', '2026-03-05 13:44:29', '2026-03-05 13:44:29', 1, '2026-03-05 13:44:29', NULL, '2026-03-05 13:44:29', NULL, NULL);
INSERT INTO `ai_conversations` VALUES (8, 1, 5, NULL, '与测试机器人的对话', '2026-03-05 14:19:44', '2026-03-05 14:19:44', 1, '2026-03-05 14:19:43', NULL, '2026-03-05 14:19:43', NULL, NULL);
INSERT INTO `ai_conversations` VALUES (9, 1, 7, NULL, '与00的对话', '2026-03-05 14:19:51', '2026-03-05 14:19:51', 1, '2026-03-05 14:19:50', NULL, '2026-03-05 14:19:50', NULL, NULL);

-- ----------------------------
-- Table structure for ai_execution_records
-- ----------------------------
DROP TABLE IF EXISTS `ai_execution_records`;
CREATE TABLE `ai_execution_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ui_project_id` bigint NULL DEFAULT NULL COMMENT '所属UI项目ID',
  `ai_case_id` bigint NULL DEFAULT NULL COMMENT '关联AI用例ID',
  `case_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例名称快照',
  `task_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '任务描述',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'text' COMMENT '执行模式',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '执行状态',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` float NULL DEFAULT NULL COMMENT '执行时长(秒)',
  `logs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '执行日志',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `steps_completed` json NULL COMMENT '已完成步骤',
  `planned_tasks` json NULL COMMENT '规划任务',
  `executed_by` bigint NULL DEFAULT NULL COMMENT '执行人ID',
  `gif_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'GIF录制路径',
  `screenshots_sequence` json NULL COMMENT '截图序列',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建者ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `total_tokens` int NULL DEFAULT 0 COMMENT 'Token总使用量',
  `prompt_tokens` int NULL DEFAULT 0 COMMENT '提示词Token数',
  `completion_tokens` int NULL DEFAULT 0 COMMENT '完成Token数',
  `api_calls` int NULL DEFAULT 0 COMMENT 'API调用次数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project`(`ui_project_id` ASC) USING BTREE,
  INDEX `idx_case`(`ai_case_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_executed_by`(`executed_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI执行记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_execution_records
-- ----------------------------

-- ----------------------------
-- Table structure for ai_messages
-- ----------------------------
DROP TABLE IF EXISTS `ai_messages`;
CREATE TABLE `ai_messages`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint NOT NULL COMMENT '对话ID',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色: user/assistant',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_conversation`(`conversation_id` ASC) USING BTREE,
  INDEX `idx_role`(`role` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI消息记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_messages
-- ----------------------------

-- ----------------------------
-- Table structure for ai_model_configs
-- ----------------------------
DROP TABLE IF EXISTS `ai_model_configs`;
CREATE TABLE `ai_model_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名称',
  `model_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型类型: deepseek/qwen/siliconflow/zhipu/other',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色: writer/reviewer/browser_use_text',
  `api_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API Key',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API Base URL',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型名称',
  `max_tokens` int NULL DEFAULT 4096 COMMENT '最大Token数',
  `temperature` float NULL DEFAULT 0.7 COMMENT '温度参数',
  `top_p` float NULL DEFAULT 0.9 COMMENT 'Top P参数',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `created_by` bigint NOT NULL COMMENT '创建者ID',
  `llm_config_id` bigint NULL DEFAULT NULL COMMENT '关联的LLM配置ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_model_role`(`model_type` ASC, `role` ASC) USING BTREE,
  INDEX `idx_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI模型配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_model_configs
-- ----------------------------

-- ----------------------------
-- Table structure for ai_test_reports
-- ----------------------------
DROP TABLE IF EXISTS `ai_test_reports`;
CREATE TABLE `ai_test_reports`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `report_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报告ID',
  `report_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报告名称',
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目ID',
  `project_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目名称',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `date_range` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时间范围',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'generated' COMMENT '报告状态',
  `total_cases` int NULL DEFAULT 0 COMMENT '总用例数',
  `total_executions` int NULL DEFAULT 0 COMMENT '总执行次数',
  `success_count` int NULL DEFAULT 0 COMMENT '成功次数',
  `failed_count` int NULL DEFAULT 0 COMMENT '失败次数',
  `success_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '成功率',
  `total_duration` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总执行时长(秒)',
  `avg_duration` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '平均时长(秒)',
  `total_tokens` bigint NULL DEFAULT 0 COMMENT '总Token使用量',
  `report_data` json NULL COMMENT '报告详细数据',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `report_id`(`report_id` ASC) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_report_id`(`report_id` ASC) USING BTREE,
  INDEX `idx_date_range`(`start_date` ASC, `end_date` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI测试报告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_test_reports
-- ----------------------------

-- ----------------------------
-- Table structure for ai_test_suite_executions
-- ----------------------------
DROP TABLE IF EXISTS `ai_test_suite_executions`;
CREATE TABLE `ai_test_suite_executions`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `suite_id` int NOT NULL COMMENT '套件ID',
  `suite_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '套件名称（冗余字段）',
  `execution_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行名称',
  `execution_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'headless' COMMENT '执行模式：headless/headed',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'running' COMMENT '状态：running/completed/failed',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` decimal(10, 2) NULL DEFAULT NULL COMMENT '执行时长（秒）',
  `total_modules` int NULL DEFAULT 0 COMMENT '总模块数',
  `completed_modules` int NULL DEFAULT 0 COMMENT '已完成模块数',
  `failed_modules` int NULL DEFAULT 0 COMMENT '失败模块数',
  `total_cases` int NULL DEFAULT 0 COMMENT '总用例数',
  `passed_cases` int NULL DEFAULT 0 COMMENT '通过用例数',
  `failed_cases` int NULL DEFAULT 0 COMMENT '失败用例数',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_suite`(`suite_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI测试套件执行记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_test_suite_executions
-- ----------------------------
INSERT INTO `ai_test_suite_executions` VALUES (1, 4, '77', '77 - 2026/3/1 17:40:53', 'headless', 'failed', '2026-03-01 17:40:55', '2026-03-01 17:41:05', 9.50, 4, 2, 2, 2, 0, 2, NULL, 1, '2026-03-01 17:40:55', 1, NULL, '2026-03-01 17:41:04', NULL);
INSERT INTO `ai_test_suite_executions` VALUES (2, 4, '测试', '测试 - 2026/3/1 17:45:48', 'headed', 'failed', '2026-03-01 17:45:51', '2026-03-01 17:45:54', 2.89, 4, 2, 2, 2, 0, 2, NULL, 1, '2026-03-01 17:45:51', 1, NULL, '2026-03-01 17:45:53', NULL);
INSERT INTO `ai_test_suite_executions` VALUES (3, 4, '测试', '测试 - 2026/3/2 09:18:52', 'headless', 'failed', '2026-03-02 09:18:56', '2026-03-02 09:19:06', 9.86, 4, 2, 2, 2, 0, 2, NULL, 1, '2026-03-02 09:18:55', 1, NULL, '2026-03-02 09:19:05', NULL);
INSERT INTO `ai_test_suite_executions` VALUES (4, 4, '测试', '测试 - 2026/3/2 11:02:25', 'headless', 'failed', '2026-03-02 11:02:28', '2026-03-02 11:02:38', 10.03, 4, 2, 2, 2, 0, 2, NULL, 1, '2026-03-02 11:02:27', 1, NULL, '2026-03-02 11:02:38', NULL);
INSERT INTO `ai_test_suite_executions` VALUES (5, 4, '测试', '测试 - 2026/3/2 11:33:14', 'headless', 'failed', '2026-03-02 11:33:16', '2026-03-02 11:33:25', 9.35, 4, 2, 2, 2, 0, 2, NULL, 1, '2026-03-02 11:33:16', 1, NULL, '2026-03-02 11:33:25', NULL);

-- ----------------------------
-- Table structure for ai_test_suite_module_executions
-- ----------------------------
DROP TABLE IF EXISTS `ai_test_suite_module_executions`;
CREATE TABLE `ai_test_suite_module_executions`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `suite_execution_id` int NOT NULL COMMENT '套件执行记录ID',
  `module_id` int NOT NULL COMMENT '模块ID',
  `module_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模块名称',
  `execution_order` int NULL DEFAULT NULL COMMENT '执行顺序',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '状态：pending/running/completed/failed',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` decimal(10, 2) NULL DEFAULT NULL COMMENT '执行时长（秒）',
  `total_cases` int NULL DEFAULT 0 COMMENT '总用例数',
  `passed_cases` int NULL DEFAULT 0 COMMENT '通过用例数',
  `failed_cases` int NULL DEFAULT 0 COMMENT '失败用例数',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_suite_execution`(`suite_execution_id` ASC) USING BTREE,
  INDEX `idx_module`(`module_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI测试套件模块执行记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_test_suite_module_executions
-- ----------------------------
INSERT INTO `ai_test_suite_module_executions` VALUES (1, 1, 80, '搜索', 1, 'failed', '2026-03-01 17:40:55', '2026-03-01 17:41:03', 8.09, 1, 0, 1, NULL, 1, '2026-03-01 17:40:55', 1, NULL, '2026-03-01 17:41:03', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (2, 1, 79, '注册', 2, 'failed', '2026-03-01 17:41:03', '2026-03-01 17:41:04', 1.19, 1, 0, 1, NULL, 1, '2026-03-01 17:40:55', 1, NULL, '2026-03-01 17:41:04', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (3, 1, 78, '登录', 3, 'completed', '2026-03-01 17:41:04', '2026-03-01 17:41:04', 0.01, 0, 0, 0, NULL, 1, '2026-03-01 17:40:55', 1, NULL, '2026-03-01 17:41:04', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (4, 1, 6, '默认模块', 4, 'completed', '2026-03-01 17:41:04', '2026-03-01 17:41:04', 0.01, 0, 0, 0, NULL, 1, '2026-03-01 17:40:55', 1, NULL, '2026-03-01 17:41:04', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (5, 2, 80, '搜索', 1, 'failed', '2026-03-01 17:45:51', '2026-03-01 17:45:53', 1.53, 1, 0, 1, NULL, 1, '2026-03-01 17:45:51', 1, NULL, '2026-03-01 17:45:52', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (6, 2, 79, '注册', 2, 'failed', '2026-03-01 17:45:53', '2026-03-01 17:45:54', 1.22, 1, 0, 1, NULL, 1, '2026-03-01 17:45:51', 1, NULL, '2026-03-01 17:45:53', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (7, 2, 78, '登录', 3, 'completed', '2026-03-01 17:45:54', '2026-03-01 17:45:54', 0.01, 0, 0, 0, NULL, 1, '2026-03-01 17:45:51', 1, NULL, '2026-03-01 17:45:53', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (8, 2, 6, '默认模块', 4, 'completed', '2026-03-01 17:45:54', '2026-03-01 17:45:54', 0.00, 0, 0, 0, NULL, 1, '2026-03-01 17:45:51', 1, NULL, '2026-03-01 17:45:53', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (9, 3, 80, '搜索', 1, 'failed', '2026-03-02 09:18:56', '2026-03-02 09:19:04', 8.50, 1, 0, 1, NULL, 1, '2026-03-02 09:18:55', 1, NULL, '2026-03-02 09:19:04', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (10, 3, 79, '注册', 2, 'failed', '2026-03-02 09:19:05', '2026-03-02 09:19:06', 1.28, 1, 0, 1, NULL, 1, '2026-03-02 09:18:55', 1, NULL, '2026-03-02 09:19:05', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (11, 3, 78, '登录', 3, 'completed', '2026-03-02 09:19:06', '2026-03-02 09:19:06', 0.01, 0, 0, 0, NULL, 1, '2026-03-02 09:18:55', 1, NULL, '2026-03-02 09:19:05', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (12, 3, 6, '默认模块', 4, 'completed', '2026-03-02 09:19:06', '2026-03-02 09:19:06', 0.00, 0, 0, 0, NULL, 1, '2026-03-02 09:18:55', 1, NULL, '2026-03-02 09:19:05', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (13, 4, 80, '搜索', 1, 'failed', '2026-03-02 11:02:28', '2026-03-02 11:02:36', 8.77, 1, 0, 1, NULL, 1, '2026-03-02 11:02:27', 1, NULL, '2026-03-02 11:02:36', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (14, 4, 79, '注册', 2, 'failed', '2026-03-02 11:02:36', '2026-03-02 11:02:38', 1.44, 1, 0, 1, NULL, 1, '2026-03-02 11:02:27', 1, NULL, '2026-03-02 11:02:37', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (15, 4, 78, '登录', 3, 'completed', '2026-03-02 11:02:38', '2026-03-02 11:02:38', 0.02, 0, 0, 0, NULL, 1, '2026-03-02 11:02:27', 1, NULL, '2026-03-02 11:02:38', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (16, 4, 6, '默认模块', 4, 'completed', '2026-03-02 11:02:38', '2026-03-02 11:02:38', 0.01, 0, 0, 0, NULL, 1, '2026-03-02 11:02:27', 1, NULL, '2026-03-02 11:02:38', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (17, 5, 80, '搜索', 1, 'failed', '2026-03-02 11:33:16', '2026-03-02 11:33:24', 7.61, 1, 0, 1, NULL, 1, '2026-03-02 11:33:16', 1, NULL, '2026-03-02 11:33:24', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (18, 5, 79, '注册', 2, 'failed', '2026-03-02 11:33:24', '2026-03-02 11:33:25', 1.14, 1, 0, 1, NULL, 1, '2026-03-02 11:33:16', 1, NULL, '2026-03-02 11:33:25', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (19, 5, 78, '登录', 3, 'completed', '2026-03-02 11:33:25', '2026-03-02 11:33:25', 0.02, 0, 0, 0, NULL, 1, '2026-03-02 11:33:16', 1, NULL, '2026-03-02 11:33:25', NULL);
INSERT INTO `ai_test_suite_module_executions` VALUES (20, 5, 6, '默认模块', 4, 'completed', '2026-03-02 11:33:25', '2026-03-02 11:33:25', 0.01, 0, 0, 0, NULL, 1, '2026-03-02 11:33:16', 1, NULL, '2026-03-02 11:33:25', NULL);

-- ----------------------------
-- Table structure for ai_test_suite_modules
-- ----------------------------
DROP TABLE IF EXISTS `ai_test_suite_modules`;
CREATE TABLE `ai_test_suite_modules`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `suite_id` int NOT NULL COMMENT '套件ID',
  `module_id` int NOT NULL COMMENT '模块ID',
  `module_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模块名称（冗余字段，方便查询）',
  `execution_order` int NOT NULL COMMENT '执行顺序',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_suite_module`(`suite_id` ASC, `module_id` ASC) USING BTREE,
  INDEX `idx_suite`(`suite_id` ASC) USING BTREE,
  INDEX `idx_module`(`module_id` ASC) USING BTREE,
  INDEX `idx_order`(`execution_order` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI测试套件模块关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_test_suite_modules
-- ----------------------------
INSERT INTO `ai_test_suite_modules` VALUES (5, 4, 80, '搜索', 1, 1, '2026-03-01 17:45:00', 0, NULL, '2026-03-23 09:07:08', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (6, 4, 79, '注册', 2, 1, '2026-03-01 17:45:00', 0, NULL, '2026-03-23 09:07:08', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (7, 4, 78, '登录', 3, 1, '2026-03-01 17:45:00', 0, NULL, '2026-03-23 09:07:08', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (8, 4, 6, '默认模块', 4, 1, '2026-03-01 17:45:00', 0, NULL, '2026-03-23 09:07:08', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (9, 5, 58, '9999', 1, 1, '2026-03-01 17:45:27', 0, NULL, '2026-03-01 17:45:35', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (10, 6, 54, '0000000000000000099888', 1, 1, '2026-03-02 08:56:27', 0, NULL, '2026-03-02 08:56:47', NULL);
INSERT INTO `ai_test_suite_modules` VALUES (11, 7, 54, '0000000000000000099888', 1, 1, '2026-03-02 08:56:39', 0, NULL, '2026-03-02 08:56:53', NULL);

-- ----------------------------
-- Table structure for ai_test_suites
-- ----------------------------
DROP TABLE IF EXISTS `ai_test_suites`;
CREATE TABLE `ai_test_suites`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套件名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '套件描述',
  `project_id` int NOT NULL COMMENT '关联项目ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态：active/archived',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI测试套件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_test_suites
-- ----------------------------
INSERT INTO `ai_test_suites` VALUES (4, '测试', '测试执行', 6, 'active', 1, '2026-03-01 17:38:47', 1, '2026-03-23 09:07:08', 0, NULL);
INSERT INTO `ai_test_suites` VALUES (5, '88', NULL, 15, 'active', 1, '2026-03-01 17:45:27', NULL, '2026-03-01 17:45:35', 0, NULL);
INSERT INTO `ai_test_suites` VALUES (6, '99', '99', 16, 'active', 1, '2026-03-02 08:56:27', NULL, '2026-03-02 08:56:47', 0, NULL);
INSERT INTO `ai_test_suites` VALUES (7, '99', '99', 16, 'active', 1, '2026-03-02 08:56:39', NULL, '2026-03-02 08:56:53', 0, NULL);

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('20260313_1601');
INSERT INTO `alembic_version` VALUES ('20260319_1500');
INSERT INTO `alembic_version` VALUES ('28632f2b9509');

-- ----------------------------
-- Table structure for api_automation_apis
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_apis`;
CREATE TABLE `api_automation_apis`  (
  `url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '接口URL',
  `req` json NULL COMMENT '请求配置',
  `document` json NULL COMMENT '接口文档',
  `api_service_id` bigint NOT NULL COMMENT '服务ID',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '接口名称',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '接口描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_apis
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_codes
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_codes`;
CREATE TABLE `api_automation_codes`  (
  `code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '错误码',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '错误码名称',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '错误码描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_codes
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_databases
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_databases`;
CREATE TABLE `api_automation_databases`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '数据库名称',
  `config` json NULL COMMENT '数据库配置',
  `db_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '数据库类型',
  `host` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '主机地址',
  `port` int NULL DEFAULT NULL COMMENT '端口',
  `database_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '数据库名',
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '密码',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_databases
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_edits
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_edits`;
CREATE TABLE `api_automation_edits`  (
  `api_id` bigint NOT NULL COMMENT '接口ID',
  `edit` json NULL COMMENT '变更内容',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_edits
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_environments
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_environments`;
CREATE TABLE `api_automation_environments`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '环境名称',
  `config` json NULL COMMENT '环境配置',
  `variable` json NULL COMMENT '环境变量',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '环境描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_environments
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_functions
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_functions`;
CREATE TABLE `api_automation_functions`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '公共函数名称',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '公共函数描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_functions
-- ----------------------------
INSERT INTO `api_automation_functions` VALUES ('', '', 1, '2026-03-15 16:47:21', 1, '2026-03-15 16:47:25', 1, 0, NULL);
INSERT INTO `api_automation_functions` VALUES ('00', '00', 2, '2026-03-16 09:51:17', 1, '2026-03-16 10:30:15', 1, 0, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{randomuuid()}}', '使用${{randomuuid()}}，返回随机uuid', 3, '2026-03-16 10:31:16', 1, '2026-03-16 10:31:16', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{Mobile()}}', '使用${{Mobile()}}，返回随机11位手机号', 4, '2026-03-16 10:31:47', 1, '2026-03-16 10:31:47', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{randomString(num)}}', '使用${{randomString(num)}}，返回随机字符串，num：长度', 5, '2026-03-16 10:32:06', 1, '2026-03-16 10:32:06', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{randomInt(start,end)}}', '使用${{randomInt(start,end)}}，返回[start-end]之间的随机整数', 6, '2026-03-16 10:32:31', 1, '2026-03-16 10:32:31', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{__timestamp__(s或ms)}}', '使用${{__timestamp__(s/ms)}}，s：返回当前秒级时间戳，ms：返回当前毫秒级时间戳', 7, '2026-03-16 10:33:15', 1, '2026-03-16 10:33:15', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{ID_card(sex,age)}}', '使用${{ID_card(1,18)}}，该表达式代表生成一名18岁的男生的身份证，sex：1男，2女', 8, '2026-03-16 10:33:37', 1, '2026-03-16 10:33:37', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{__base64__(xxx)}}', '使用${{__base64__(1234)}}，加密后返回对应字符串', 9, '2026-03-16 10:34:02', 1, '2026-03-16 10:34:02', 1, 1, NULL);
INSERT INTO `api_automation_functions` VALUES ('${{__md5__(xxx)}}', '使用${{__md5__(1234)}}，加密后返回对应字符串', 10, '2026-03-16 10:34:23', 1, '2026-03-16 10:34:23', 1, 1, NULL);

-- ----------------------------
-- Table structure for api_automation_menus
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_menus`;
CREATE TABLE `api_automation_menus`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '菜单名称',
  `type` int NOT NULL COMMENT '菜单类型',
  `pid` bigint NOT NULL COMMENT '父菜单ID',
  `api_id` bigint NULL DEFAULT NULL COMMENT '接口ID',
  `api_service_id` bigint NOT NULL COMMENT '服务ID',
  `status` int NOT NULL COMMENT '状态',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_menus
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_params
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_params`;
CREATE TABLE `api_automation_params`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '参数名称',
  `value` json NULL COMMENT '参数值',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_params
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_projects
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_projects`;
CREATE TABLE `api_automation_projects`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '项目名称',
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '项目图标',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '项目描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_projects
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_results
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_results`;
CREATE TABLE `api_automation_results`  (
  `req` json NULL COMMENT '请求数据',
  `res` json NULL COMMENT '响应数据',
  `api_id` bigint NOT NULL COMMENT '接口ID',
  `status_code` int NULL DEFAULT NULL COMMENT '状态码',
  `response_time` float NULL DEFAULT NULL COMMENT '响应时间',
  `error_message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '错误信息',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_results
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_script_result_lists
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_script_result_lists`;
CREATE TABLE `api_automation_script_result_lists`  (
  `result_id` bigint NOT NULL COMMENT '执行ID',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '场景名称',
  `script` json NULL COMMENT '场景配置',
  `config` json NULL COMMENT '执行配置',
  `result` json NULL COMMENT '执行结果',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_script_result_lists
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_script_results
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_script_results`;
CREATE TABLE `api_automation_script_results`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '步骤名称',
  `uuid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '唯一标识',
  `menu_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '菜单ID',
  `result_id` bigint NOT NULL COMMENT '执行ID',
  `status` int NULL DEFAULT NULL COMMENT '执行状态',
  `req` json NULL COMMENT '请求数据',
  `res` json NULL COMMENT '响应数据',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_script_results
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_scripts
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_scripts`;
CREATE TABLE `api_automation_scripts`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '场景名称',
  `type` int NULL DEFAULT NULL COMMENT '场景类型',
  `script` json NOT NULL COMMENT '场景步骤',
  `config` json NULL COMMENT '场景配置',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '场景描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_scripts
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_services
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_services`;
CREATE TABLE `api_automation_services`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务名称',
  `api_project_id` bigint NOT NULL COMMENT '项目ID',
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '服务图标',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '服务描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_services
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_updates
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_updates`;
CREATE TABLE `api_automation_updates`  (
  `req` json NULL COMMENT '变更内容',
  `api_id` bigint NOT NULL COMMENT '接口ID',
  `api_service_id` bigint NOT NULL COMMENT '服务ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_updates
-- ----------------------------

-- ----------------------------
-- Table structure for api_automation_variables
-- ----------------------------
DROP TABLE IF EXISTS `api_automation_variables`;
CREATE TABLE `api_automation_variables`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '变量名',
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '变量值',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '变量描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_automation_variables
-- ----------------------------

-- ----------------------------
-- Table structure for api_collections
-- ----------------------------
DROP TABLE IF EXISTS `api_collections`;
CREATE TABLE `api_collections`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `api_project_id` bigint NOT NULL COMMENT 'API项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '集合名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '集合描述',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父级集合ID',
  `order_num` int NULL DEFAULT 0 COMMENT '排序',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_api_project`(`api_project_id` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API集合表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_collections
-- ----------------------------
INSERT INTO `api_collections` VALUES (16, 1, '登录测试', '', NULL, 0, '2026-02-07 10:18:22', NULL, '2026-02-07 10:18:22', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (17, 1, '888', '', NULL, 0, '2026-02-07 10:21:38', NULL, '2026-02-07 10:21:38', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (18, 1, '999', '', 16, 0, '2026-02-07 13:32:03', NULL, '2026-02-07 13:32:03', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (19, 1, '9999', '', 18, 0, '2026-02-07 13:32:08', NULL, '2026-02-07 13:32:08', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (23, 19, 'VSS平台接口', '', NULL, 1, '2026-02-07 15:38:22', NULL, '2026-02-07 15:38:22', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (24, 19, 'VSS平台接口/4G流量消耗统计记录接口', '', NULL, 2, '2026-02-07 15:38:22', NULL, '2026-02-07 15:38:22', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (25, 19, 'VSS平台接口/语音下发接口', '', NULL, 3, '2026-02-07 15:38:22', NULL, '2026-02-07 15:38:22', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (29, 21, '登录测试', '', NULL, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 15:52:18', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (30, 21, '888', '', NULL, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 15:52:18', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (31, 22, 'Default', 'Default collection', NULL, 0, '2026-02-07 15:52:57', NULL, '2026-02-07 15:52:57', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (32, 23, 'Default', 'Default collection', NULL, 0, '2026-02-07 15:59:35', NULL, '2026-02-07 15:59:35', NULL, 1, NULL);
INSERT INTO `api_collections` VALUES (33, 26, 'Default', 'Default collection', NULL, 0, '2026-02-07 17:45:34', NULL, '2026-02-07 17:45:34', NULL, 1, NULL);

-- ----------------------------
-- Table structure for api_database_configs
-- ----------------------------
DROP TABLE IF EXISTS `api_database_configs`;
CREATE TABLE `api_database_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '连接名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '连接描述',
  `db_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据库类型: mysql/postgresql/mongodb/redis',
  `host` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主机地址',
  `port` int NOT NULL COMMENT '端口',
  `database_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据库名',
  `username` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码（加密存储）',
  `connection_params` json NULL COMMENT '其他连接参数',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API数据库连接配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_database_configs
-- ----------------------------
INSERT INTO `api_database_configs` VALUES (2, 1, '0000', '00', 'mysql', 'localhost', 3306, '000', '00', '00', 'null', 1, '2026-02-07 17:35:55', 1, '2026-02-07 17:35:55', 1, 1, NULL);
INSERT INTO `api_database_configs` VALUES (4, 8, '5767', '75675', 'mysql', 'localhost', 3306, '7657', '757', '5765', 'null', 1, '2026-02-07 17:47:21', 1, '2026-02-07 17:47:21', 1, 1, NULL);

-- ----------------------------
-- Table structure for api_environments
-- ----------------------------
DROP TABLE IF EXISTS `api_environments`;
CREATE TABLE `api_environments`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '环境名称',
  `scope` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'LOCAL' COMMENT '作用域: GLOBAL/LOCAL',
  `variables` json NULL COMMENT '环境变量',
  `is_active` tinyint(1) NULL DEFAULT 0 COMMENT '是否激活',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API环境变量表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_environments
-- ----------------------------

-- ----------------------------
-- Table structure for api_projects
-- ----------------------------
DROP TABLE IF EXISTS `api_projects`;
CREATE TABLE `api_projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'API项目名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目描述',
  `project_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'HTTP' COMMENT '类型: HTTP/WEBSOCKET',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基础URL',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_projects
-- ----------------------------
INSERT INTO `api_projects` VALUES (21, 8, '测试API项目', '这是一个测试API项目', 'HTTP', 'https://api.example.com', '2026-02-07 15:52:18', NULL, '2026-02-07 15:52:18', NULL, 1, NULL);

-- ----------------------------
-- Table structure for api_public_scripts
-- ----------------------------
DROP TABLE IF EXISTS `api_public_scripts`;
CREATE TABLE `api_public_scripts`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '脚本名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '脚本描述',
  `script_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'javascript' COMMENT '脚本类型: javascript/python',
  `script_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '脚本内容',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API公共脚本表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_public_scripts
-- ----------------------------
INSERT INTO `api_public_scripts` VALUES (2, 1, '00', '00', 'python', '00', '00', 1, '2026-02-07 17:35:05', 1, '2026-02-07 17:35:05', 1, 1, NULL);
INSERT INTO `api_public_scripts` VALUES (3, 1, '00', '00', 'python', '00', '00', 1, '2026-02-07 17:35:11', 1, '2026-02-07 17:35:11', 1, 1, NULL);
INSERT INTO `api_public_scripts` VALUES (4, 8, '7', '', 'python', '7', '77', 1, '2026-02-07 17:46:34', 1, '2026-02-07 17:46:34', 1, 1, NULL);

-- ----------------------------
-- Table structure for api_request_histories
-- ----------------------------
DROP TABLE IF EXISTS `api_request_histories`;
CREATE TABLE `api_request_histories`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `request_id` bigint NOT NULL COMMENT '关联请求ID',
  `environment_id` bigint NULL DEFAULT NULL COMMENT '使用环境ID',
  `request_data` json NULL COMMENT '请求数据',
  `response_data` json NULL COMMENT '响应数据',
  `status_code` int NULL DEFAULT NULL COMMENT '状态码',
  `response_time` float NULL DEFAULT NULL COMMENT '响应时间(ms)',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `assertions_results` json NULL COMMENT '断言结果',
  `executed_by` bigint NOT NULL COMMENT '执行者ID',
  `executed_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '执行时间',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  `environment_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '环境名称',
  `assertions_passed` tinyint(1) NULL DEFAULT NULL COMMENT '断言是否通过',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_request`(`request_id` ASC) USING BTREE,
  INDEX `idx_executed_at`(`executed_at` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API请求历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_request_histories
-- ----------------------------
INSERT INTO `api_request_histories` VALUES (1, 4, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 320.495, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:23:33', NULL, '2026-02-07 09:23:33', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (2, 4, 4, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 271.648, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:23:44', NULL, '2026-02-07 09:23:44', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (3, 5, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 251.101, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:26:03', NULL, '2026-02-07 09:26:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (4, 5, 5, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 251.118, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:26:14', NULL, '2026-02-07 09:26:14', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (5, 6, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 251.012, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:28:19', NULL, '2026-02-07 09:28:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (6, 6, 6, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 253.117, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:28:30', NULL, '2026-02-07 09:28:30', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (7, 7, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 247.092, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:29:34', NULL, '2026-02-07 09:29:34', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (8, 7, 7, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 253.774, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:29:44', NULL, '2026-02-07 09:29:44', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (9, 8, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 250.944, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:32:05', NULL, '2026-02-07 09:32:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (10, 8, 8, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 376.729, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:32:16', NULL, '2026-02-07 09:32:16', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (11, 9, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 249.752, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:33:59', NULL, '2026-02-07 09:33:59', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (12, 9, 9, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 271.569, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:34:10', NULL, '2026-02-07 09:34:10', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (13, 10, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 251.977, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:35:07', NULL, '2026-02-07 09:35:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (14, 10, 10, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 250.126, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:35:18', NULL, '2026-02-07 09:35:18', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (15, 11, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 292.986, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:38:01', NULL, '2026-02-07 09:38:01', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (16, 11, 11, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 262.269, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:38:11', NULL, '2026-02-07 09:38:11', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (17, 12, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 248.977, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:39:38', NULL, '2026-02-07 09:39:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (18, 12, 12, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 250.44, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:39:49', NULL, '2026-02-07 09:39:49', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (19, 13, NULL, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 250.649, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:41:54', NULL, '2026-02-07 09:41:54', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (20, 13, 13, '{\"url\": \"/posts\", \"body\": null, \"method\": \"GET\", \"params\": {}, \"headers\": {\"Content-Type\": \"application/json\"}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 249.562, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, NULL, '2026-02-07 09:42:05', NULL, '2026-02-07 09:42:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (21, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 02:25:22 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 305.83858489990234}', 404, 305.839, NULL, '[]', 1, NULL, '2026-02-07 10:25:22', NULL, '2026-02-07 10:25:22', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (22, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 02:30:55 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 270.5044746398926}', 404, 270.504, NULL, '[]', 1, NULL, '2026-02-07 10:30:55', NULL, '2026-02-07 10:30:55', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (23, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 02:37:53 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 372.2958564758301}', 404, 372.296, NULL, '[]', 1, NULL, '2026-02-07 10:37:53', NULL, '2026-02-07 10:37:53', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (24, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:23:32 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 303.2965660095215}', 404, 303.297, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, NULL, '2026-02-07 11:23:32', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (25, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:26:21 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 265.6724452972412}', 404, 265.672, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, NULL, '2026-02-07 11:26:21', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (26, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:26:37 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 263.5924816131592}', 404, 263.592, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, NULL, '2026-02-07 11:26:37', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (27, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:30:18 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 275.7606506347656}', 404, 275.761, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, NULL, '2026-02-07 11:30:18', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (28, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:32:49 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 273.32043647766113}', 404, 273.32, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 11:32:49', '2026-02-07 11:32:49', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (29, 15, NULL, '{\"url\": \"http://172.16.60.204:3000/api/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:42:45 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 267.6241397857666}', 404, 267.624, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 11:42:45', '2026-02-07 11:42:45', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (30, 15, NULL, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI1NWRhM2MxMGQyZmQ0NDY4ODdiMDZlZjI1NGI1MGNhZiIsImV4cCI6MTc3MDUyMjI3OX0.sB2sfMDPPnSZXRCaO-VSxrDv8yIz_kbcD1xe-NNAEOo\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI1NWRhM2MxMGQyZmQ0NDY4ODdiMDZlZjI1NGI1MGNhZiIsImV4cCI6MTc3MTA0MDY3OSwidHlwZSI6InJlZnJlc2gifQ.2KrzLqsINfLjSHGGkibi4hMiw4gYE7Vn6MLru_FweZI\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:44:38 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"e8513b6a249b4c158a6ea321d681f128\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 738.6252880096436}', 200, 738.625, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 11:44:40', '2026-02-07 11:44:39', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (31, 15, NULL, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI5YzAzMmRmNTEzZWU0YzkxYWM1OTIwYjQ5MjdiZDcxOCIsImV4cCI6MTc3MDUyMjMxMH0.9r1sqN1WzdjTZJDnFyVuQ5LkYiycn7h_d_xG0-dZz8w\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI5YzAzMmRmNTEzZWU0YzkxYWM1OTIwYjQ5MjdiZDcxOCIsImV4cCI6MTc3MTA0MDcxMCwidHlwZSI6InJlZnJlc2gifQ.6SJwKuodjGMJszsIKMB6JrFGwS4zX3hrF4DCvJMS8ss\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:45:09 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"37169e06c9034629a68f6481901890a2\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 613.3041381835938}', 200, 613.304, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 11:45:10', '2026-02-07 11:45:10', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (32, 15, NULL, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJhOGZhMTliNzA3ZTE0MWE1ODJjYjIyNzZjNjc4ODZlNSIsImV4cCI6MTc3MDUyMjQ3MX0.lat3maJaC7EeBanQG-3Z6o2NUnRWmzq9DvmPet4NfUc\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJhOGZhMTliNzA3ZTE0MWE1ODJjYjIyNzZjNjc4ODZlNSIsImV4cCI6MTc3MTA0MDg3MSwidHlwZSI6InJlZnJlc2gifQ.7LjSw7mnPCtLcRH80xbx8SkoAJ18lbn3dY_RYPaFjQQ\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:47:50 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"544122e0ce3049518e9ec1bf15f8695e\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 706.9718837738037}', 200, 706.972, NULL, '[{\"type\": \"status_code\", \"actual\": 200, \"passed\": false, \"message\": \"状态码断言: 200 equals 200\", \"expected\": \"200\", \"operator\": \"equals\"}]', 1, '2026-02-07 11:47:51', '2026-02-07 11:47:51', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (33, 15, NULL, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIwYmVlZDFlNjFmNmI0OWRjOGNmMWJkNTA0NTE3YjUzYiIsImV4cCI6MTc3MDUyMjUxNX0.2TFkMZ4xL_QxyKC9z7gTDHyZEddqkOMIxPNNfsX3Krg\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIwYmVlZDFlNjFmNmI0OWRjOGNmMWJkNTA0NTE3YjUzYiIsImV4cCI6MTc3MTA0MDkxNSwidHlwZSI6InJlZnJlc2gifQ.gV3LjfctLPyQvw5YSaMjlZanoT4MblolU2NbQfkAqdc\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:48:34 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"fd973544db7946509758ad076da41f8f\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 564.8164749145508}', 200, 564.816, NULL, '[{\"type\": \"jsonpath\", \"passed\": false, \"message\": \"断言执行失败: Parse error at 1:1 near token data (ID)\", \"expected\": \"200\", \"operator\": \"equals\"}]', 1, '2026-02-07 11:48:35', '2026-02-07 11:48:35', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (34, 15, NULL, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJlZTkwN2M3YTYxMzY0YTBmOGY1NzA5NzM2NDMzNjdmMCIsImV4cCI6MTc3MDUyMjg4M30.6aRnDU9ByrNYTMCvT1c2GjPX3s-YEBpHSrjiSbjUKRU\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJlZTkwN2M3YTYxMzY0YTBmOGY1NzA5NzM2NDMzNjdmMCIsImV4cCI6MTc3MTA0MTI4MywidHlwZSI6InJlZnJlc2gifQ.EDJIFDr4pNU1A8EMzBccQRGtybfbUvRZDxrNDHq03K8\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 03:54:42 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"d44fefa4a888431cad63ebeb70ede44e\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 629.7807693481445}', 200, 629.781, NULL, '[{\"type\": \"body_contains\", \"passed\": true, \"message\": \"响应体包含断言: 通过\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 11:54:44', '2026-02-07 11:54:43', NULL, '2026-02-07 11:59:45', NULL, 1, NULL, NULL, 1);
INSERT INTO `api_request_histories` VALUES (35, 15, NULL, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 304.782, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:33:42', '2026-02-07 13:33:42', NULL, '2026-02-07 13:33:42', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (36, 15, NULL, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 264, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:34:48', '2026-02-07 13:34:48', NULL, '2026-02-07 13:34:48', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (37, 15, NULL, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 267.028, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:36:21', '2026-02-07 13:36:20', NULL, '2026-02-07 13:36:20', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (38, 15, NULL, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 280.03, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:38:05', '2026-02-07 13:38:04', NULL, '2026-02-07 13:38:04', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (39, 15, 14, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 292.591, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:45:43', '2026-02-07 13:45:42', NULL, '2026-02-07 13:45:42', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (40, 15, 14, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 299.555, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:48:06', '2026-02-07 13:48:05', NULL, '2026-02-07 13:48:05', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (41, 15, 14, '{\"url\": \" {{baseurl}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 270.171, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:48:35', '2026-02-07 13:48:35', NULL, '2026-02-07 13:48:35', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (42, 15, 14, '{\"url\": \" {{baseurl}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 287.172, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:48:45', '2026-02-07 13:48:44', NULL, '2026-02-07 13:48:44', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (43, 15, 14, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 278.909, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:56:02', '2026-02-07 13:56:01', NULL, '2026-02-07 13:56:01', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (44, 15, 14, '{\"url\": \" {base_url}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 260.026, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:56:28', '2026-02-07 13:56:27', NULL, '2026-02-07 13:56:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (45, 15, 15, '{\"url\": \" {{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 257.02, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 13:57:55', '2026-02-07 13:57:54', NULL, '2026-02-07 13:57:54', NULL, 1, NULL, '开发环境', NULL);
INSERT INTO `api_request_histories` VALUES (46, 15, 15, '{\"url\": \" http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 263.166, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 14:02:00', '2026-02-07 14:01:59', NULL, '2026-02-07 14:01:59', NULL, 1, NULL, '开发环境', NULL);
INSERT INTO `api_request_histories` VALUES (47, 15, 15, '{\"url\": \" http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 265.958, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 14:05:03', '2026-02-07 14:05:02', NULL, '2026-02-07 14:05:02', NULL, 1, NULL, '开发环境', NULL);
INSERT INTO `api_request_histories` VALUES (48, 15, 15, '{\"url\": \" http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 264.004, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 14:06:02', '2026-02-07 14:06:01', NULL, '2026-02-07 14:06:01', NULL, 1, NULL, '开发环境', NULL);
INSERT INTO `api_request_histories` VALUES (49, 15, 15, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:07:09 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 316.2252902984619}', 404, 316.225, NULL, '[{\"type\": \"body_contains\", \"passed\": false, \"message\": \"响应体包含断言: 失败\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:07:09', '2026-02-07 14:07:09', NULL, '2026-02-07 14:07:09', NULL, 1, NULL, '开发环境', 0);
INSERT INTO `api_request_histories` VALUES (50, 15, 15, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:09:25 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 293.17641258239746}', 404, 293.176, NULL, '[{\"type\": \"body_contains\", \"passed\": false, \"message\": \"响应体包含断言: 失败\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:09:26', '2026-02-07 14:09:25', NULL, '2026-02-07 14:09:25', NULL, 1, NULL, '开发环境', 0);
INSERT INTO `api_request_histories` VALUES (51, 15, 15, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:09:38 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 266.4206027984619}', 404, 266.421, NULL, '[{\"type\": \"body_contains\", \"passed\": false, \"message\": \"响应体包含断言: 失败\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:09:38', '2026-02-07 14:09:38', NULL, '2026-02-07 14:09:38', NULL, 1, NULL, '开发环境', 0);
INSERT INTO `api_request_histories` VALUES (52, 15, 15, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:09:57 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 278.2473564147949}', 404, 278.247, NULL, '[]', 1, '2026-02-07 14:09:58', '2026-02-07 14:09:57', NULL, '2026-02-07 14:09:57', NULL, 1, NULL, '开发环境', NULL);
INSERT INTO `api_request_histories` VALUES (53, 15, 15, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:10:27 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 274.6093273162842}', 404, 274.609, NULL, '[]', 1, '2026-02-07 14:10:28', '2026-02-07 14:10:27', NULL, '2026-02-07 14:10:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (54, 15, NULL, '{\"url\": \"http://127.0.0.1:3000/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": \"\", \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:10:49 GMT\", \"vary\": \"Origin\", \"connection\": \"keep-alive\", \"keep-alive\": \"timeout=5\", \"content-length\": \"0\"}, \"status_code\": 404, \"response_time\": 266.4990425109863}', 404, 266.499, NULL, '[]', 1, '2026-02-07 14:10:49', '2026-02-07 14:10:49', NULL, '2026-02-07 14:10:49', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (55, 15, 16, '{\"url\": \"127.0.0.1:3000/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 261.817, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 14:13:45', '2026-02-07 14:13:44', NULL, '2026-02-07 14:13:44', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (56, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:14:57 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"032ff7e633524ebcba3362c468c203c8\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 442.9004192352295}', 422, 442.9, NULL, '[{\"type\": \"status_code\", \"actual\": 422, \"passed\": false, \"message\": \"状态码断言: 422 equals 200\", \"expected\": \"200\", \"operator\": \"equals\"}]', 1, '2026-02-07 14:14:58', '2026-02-07 14:14:57', NULL, '2026-02-07 14:14:57', NULL, 1, NULL, '测试环境', 0);
INSERT INTO `api_request_histories` VALUES (57, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:15:37 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"b7203aab41dd422ebab434d5dd48426c\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 294.4216728210449}', 422, 294.422, NULL, '[{\"type\": \"body_contains\", \"passed\": false, \"message\": \"响应体包含断言: 失败\", \"expected\": \"200\", \"operator\": \"equals\"}]', 1, '2026-02-07 14:15:39', '2026-02-07 14:15:38', NULL, '2026-02-07 14:15:38', NULL, 1, NULL, '测试环境', 0);
INSERT INTO `api_request_histories` VALUES (58, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:15:50 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"9fdbbe510e484f62bc6bc9177abb8e93\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 288.0105972290039}', 422, 288.011, NULL, '[{\"type\": \"body_contains\", \"passed\": false, \"message\": \"响应体包含断言: 失败\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:15:52', '2026-02-07 14:15:51', NULL, '2026-02-07 14:15:51', NULL, 1, NULL, '测试环境', 0);
INSERT INTO `api_request_histories` VALUES (59, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:16:08 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"b32926aa691b49498b7e9aa636305e4d\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 292.6666736602783}', 422, 292.667, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:16:08', '2026-02-07 14:16:08', NULL, '2026-02-07 14:16:08', NULL, 1, NULL, '测试环境', 0);
INSERT INTO `api_request_histories` VALUES (60, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:18:05 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"fb0d93613d484b0fac39562796b1decb\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 280.43055534362793}', 422, 280.431, NULL, '[{\"type\": \"header\", \"actual\": null, \"passed\": false, \"message\": \"响应头断言: None = None contains 200\", \"expected\": \"200\", \"operator\": \"contains\"}]', 1, '2026-02-07 14:18:07', '2026-02-07 14:18:06', NULL, '2026-02-07 14:18:06', NULL, 1, NULL, '测试环境', 0);
INSERT INTO `api_request_histories` VALUES (61, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:18:13 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"2ce9d0090fd94b608454b41745606b7d\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 281.9690704345703}', 422, 281.969, NULL, '[]', 1, '2026-02-07 14:18:15', '2026-02-07 14:18:14', NULL, '2026-02-07 14:18:14', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (62, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": null, \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": -1, \"data\": null, \"message\": \"参数错误\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:18:49 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"eef290aa4b284319bea6eb1d6050aba8\", \"content-length\": \"48\"}, \"status_code\": 422, \"response_time\": 288.03014755249023}', 422, 288.03, NULL, '[]', 1, '2026-02-07 14:18:50', '2026-02-07 14:18:50', NULL, '2026-02-07 14:18:50', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (63, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJiMDY0MzA2YjE1MjI0M2FhYjllOGI0MWJiYjc0M2VjYSIsImV4cCI6MTc3MDUzMTU3NX0.TOrhdLejg6lRXopxWKOeMRQMNymLVeP9Sr7XSWMmjo8\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJiMDY0MzA2YjE1MjI0M2FhYjllOGI0MWJiYjc0M2VjYSIsImV4cCI6MTc3MTA0OTk3NSwidHlwZSI6InJlZnJlc2gifQ.vyvq6pgGdWWoKjcy2DgQ_0FJU9irdA0Nj04CZzjUBAY\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:19:34 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"81a8d78e79694782af0a7b8666acef69\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 583.3499431610107}', 200, 583.35, NULL, '[]', 1, '2026-02-07 14:19:36', '2026-02-07 14:19:36', NULL, '2026-02-07 14:19:36', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (64, 15, 15, '{\"url\": \"{{base_url}}/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}', 0, 272.337, 'Request URL is missing an \'http://\' or \'https://\' protocol.', '[]', 1, '2026-02-07 14:35:00', '2026-02-07 14:34:59', NULL, '2026-02-07 14:34:59', NULL, 1, NULL, NULL, NULL);
INSERT INTO `api_request_histories` VALUES (65, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIyOWQ5NmU0NGI0MGI0NzhjYjgwNzM4Y2I3NmRiODA1ZiIsImV4cCI6MTc3MDUzMjU1MH0.ftu3vZs3Y7nbgRdvcPLIkHe6fpgo8qHkWzPp5UeUodI\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIyOWQ5NmU0NGI0MGI0NzhjYjgwNzM4Y2I3NmRiODA1ZiIsImV4cCI6MTc3MTA1MDk1MCwidHlwZSI6InJlZnJlc2gifQ.wqYvF0xWdYpYeXA0KkIHV3dFdrr5_I5E8HkSLP9KLMM\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:35:49 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"16308a9e49f745f5afad9fa34aaea9ff\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 592.6196575164795}', 200, 592.62, NULL, '[]', 1, '2026-02-07 14:35:50', '2026-02-07 14:35:50', NULL, '2026-02-07 14:35:50', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (66, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJmMzUwZTBjOGU3NTg0MWU3YmIzM2QxMDFiZTUzNmQ4NyIsImV4cCI6MTc3MDUzMjc4N30.6bABFgCGXjTxJ6QuS60x56oA6USu_KzG2EIy32HxObw\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiJmMzUwZTBjOGU3NTg0MWU3YmIzM2QxMDFiZTUzNmQ4NyIsImV4cCI6MTc3MTA1MTE4NywidHlwZSI6InJlZnJlc2gifQ.zrKYN4qAPdgQSnG8TUByGGVR1dBzsPw5mfEugmvjxYw\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:39:47 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"5ada1147e0a945559ec1e412afbeb26f\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 794.1465377807617}', 200, 794.147, NULL, '[]', 1, '2026-02-07 14:39:48', '2026-02-07 14:39:48', NULL, '2026-02-07 14:39:48', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (67, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI3MTUzYmEyYWJmMzM0YzVkYjI3N2UwZGY4NzZkYjUxMCIsImV4cCI6MTc3MDUzMjg2OH0.RhF2Ebi1OFScv4P-SHJcBGyu4jHxh55ctoA3kpqIEng\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI3MTUzYmEyYWJmMzM0YzVkYjI3N2UwZGY4NzZkYjUxMCIsImV4cCI6MTc3MTA1MTI2OCwidHlwZSI6InJlZnJlc2gifQ.E-oiV-i75hpKEd25kmG9SsbsWnQTsoL9XQ1izcIaJKo\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:41:08 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"9815c13a5aeb47a9a2d150a0ebe9ea3d\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 728.6155223846436}', 200, 728.616, NULL, '[]', 1, '2026-02-07 14:41:09', '2026-02-07 14:41:08', NULL, '2026-02-07 14:41:08', NULL, 1, NULL, '测试环境', NULL);
INSERT INTO `api_request_histories` VALUES (68, 15, 16, '{\"url\": \"http://127.0.0.1:8100/api/v1/system/auth/login\", \"body\": \"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\", \"method\": \"POST\", \"params\": {}, \"headers\": {}}', '{\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI2M2E4MTcxZGZjNTM0NzM4ODE0ZjdhMjZiZmY2NDFiMCIsImV4cCI6MTc3MDU0NDUwOX0.Y7lQoglrjlq7yxi2vlh-nh679fXeIReBXdzjHj5-O70\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiI2M2E4MTcxZGZjNTM0NzM4ODE0ZjdhMjZiZmY2NDFiMCIsImV4cCI6MTc3MTA2MjkwOSwidHlwZSI6InJlZnJlc2gifQ.57ZoIiS5mS-Pfr7dkao5yK2LvzNwQl4Rr0jfbUt9kXQ\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 09:55:08 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"04a275a872304325ae9a7078d2eb29c6\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 1003.1952857971193}', 200, 1003.2, NULL, '[]', 1, '2026-02-07 17:55:10', '2026-02-07 17:55:09', NULL, '2026-02-07 17:55:09', NULL, 1, NULL, '测试环境', NULL);

-- ----------------------------
-- Table structure for api_requests
-- ----------------------------
DROP TABLE IF EXISTS `api_requests`;
CREATE TABLE `api_requests`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `collection_id` bigint NOT NULL COMMENT '所属集合ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求描述',
  `request_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'HTTP' COMMENT '请求类型: HTTP/WEBSOCKET',
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'GET' COMMENT '请求方法: GET/POST/PUT/DELETE/PATCH/HEAD/OPTIONS',
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求URL',
  `headers` json NULL COMMENT '请求头',
  `params` json NULL COMMENT 'URL参数',
  `body` json NULL COMMENT '请求体',
  `cookies` json NULL COMMENT 'Cookies',
  `auth` json NULL COMMENT '认证信息',
  `pre_request_script` json NULL COMMENT '前置操作列表',
  `post_request_script` json NULL COMMENT '后置操作列表',
  `assertions` json NULL COMMENT '断言规则',
  `verify_ssl` tinyint(1) NULL DEFAULT 1 COMMENT 'SSL证书验证',
  `follow_redirects` tinyint(1) NULL DEFAULT 1 COMMENT '自动跟随重定向',
  `timeout` int NULL DEFAULT 30000 COMMENT '超时时间(毫秒)',
  `order_num` int NULL DEFAULT 0 COMMENT '排序',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_collection`(`collection_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API请求表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_requests
-- ----------------------------
INSERT INTO `api_requests` VALUES (1, 1, '获取用户列表', '获取所有用户列表', 'HTTP', 'GET', '/api/users', '{\"Content-Type\": \"application/json\"}', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 1, '2026-02-07 09:09:23', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (14, 14, '77', '', 'HTTP', 'GET', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:17:20', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (15, 16, '登录', '登录调试接口', 'HTTP', 'POST', '{{base_url}}/api/v1/system/auth/login', '{}', '{}', '\"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\"', '{}', '{\"data\": {\"password\": \"123456\", \"username\": \"admin\"}, \"type\": \"basic\"}', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 10:18:53', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (16, 17, '777', '', 'HTTP', 'GET', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:01', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (17, 17, '77', '', 'HTTP', 'PUT', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:11', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (18, 17, '77', '', 'HTTP', 'DELETE', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (19, 17, '77', '', 'HTTP', 'PATCH', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:26', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (20, 17, '77', '', 'HTTP', 'HEAD', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:36', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (21, 17, '77', '77', 'HTTP', 'OPTIONS', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 10:23:43', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (22, 19, '99', '', 'HTTP', 'GET', '99', 'null', 'null', 'null', 'null', 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 13:32:16', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (23, 20, '登录VSS接口', '', 'HTTP', 'POST', '///vss/user/login.action', '{\"Host\": {\"type\": \"string\", \"value\": \"47.115.83.226:9966\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"3118610f1b7944efa76104b0e30cd687\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"application/json, text/plain, */*\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"194ECB40BE3701AF6634B8E578729C7D\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"application/json\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"gzip, deflate\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"zh-CN,zh;q=0.9\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:28:46', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (24, 21, '下发语音播报指令', '', 'HTTP', 'POST', '/vss/voice/openVoice.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:33:40', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (25, 22, '查询宠物详情', '', 'HTTP', 'GET', '/pet/{petId}', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{\"petId\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"宠物 ID\"}}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (26, 22, '删除宠物信息', '', 'HTTP', 'DELETE', '/pet/{petId}', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"api_key\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{\"petId\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"Pet id to delete\"}}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 1, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (27, 22, '新建宠物信息', '', 'HTTP', 'POST', '/pet', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 2, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (28, 22, '修改宠物信息', '', 'HTTP', 'PUT', '/pet', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 3, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (29, 22, '根据状态查找宠物列表', '', 'HTTP', 'GET', '/pet/findByStatus', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{\"status\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"Status values that need to be considered for filter\"}}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 4, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (30, 24, '查询统计4G流量', '', 'HTTP', 'POST', '/vss/flowrecord/findPage.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 5, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (31, 25, '登录VSS接口', '', 'HTTP', 'POST', '///vss/user/login.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 6, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (32, 25, '添加上传语音包', '', 'HTTP', 'POST', '///vss/voice/addVoiceFile.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 7, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (33, 25, '查询语音是不是上传成功', '', 'HTTP', 'POST', '//vss/voice/getVoiceFile.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 8, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (34, 25, '下发语音文件到指定设备', '', 'HTTP', 'POST', '//vss/voice/issueVoiceFile.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 9, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (35, 25, '下发语音播报指令', '', 'HTTP', 'POST', '/vss/voice/openVoice.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 10, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (36, 25, '根据ID更新语音包文件', '', 'HTTP', 'POST', '/vss/voice/updateVoiceFile.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 11, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (37, 25, '根据ID删除语音文件', '', 'HTTP', 'POST', '/vss/voice/deleteVoiceFile.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 12, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (38, 25, '获取登录统计时长数据接口', '', 'HTTP', 'POST', '/vss/user/getUserLoginInfo.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 13, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (39, 23, '锁定内部接口', '', 'HTTP', 'POST', '/vss/user/login.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 14, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (40, 23, '二次验证登录接口', '', 'HTTP', 'POST', '/vss/user/authBy2FA.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 15, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (41, 23, '获取用户二次认证信息', '', 'HTTP', 'POST', '/vss/user/getUser2FAInfo.action', '{\"Host\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 16, '2026-02-07 15:38:22', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (42, 28, '未命名接口', '', 'HTTP', 'GET', '/', '{\"Host\": {\"type\": \"string\", \"value\": \"47.115.83.226:9966\", \"enabled\": true, \"description\": \"\"}, \"token\": {\"type\": \"string\", \"value\": \"3118610f1b7944efa76104b0e30cd687\", \"enabled\": true, \"description\": \"\"}, \"Accept\": {\"type\": \"string\", \"value\": \"application/json, text/plain, */*\", \"enabled\": true, \"description\": \"\"}, \"Cookie\": {\"type\": \"string\", \"value\": \"194ECB40BE3701AF6634B8E578729C7D\", \"enabled\": true, \"description\": \"\"}, \"User-Agent\": {\"type\": \"string\", \"value\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\", \"enabled\": true, \"description\": \"\"}, \"Content-Type\": {\"type\": \"string\", \"value\": \"application/json\", \"enabled\": true, \"description\": \"\"}, \"Accept-Encoding\": {\"type\": \"string\", \"value\": \"gzip, deflate\", \"enabled\": true, \"description\": \"\"}, \"Accept-Language\": {\"type\": \"string\", \"value\": \"zh-CN,zh;q=0.9\", \"enabled\": true, \"description\": \"\"}}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:46:10', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (43, 29, '登录', '登录调试接口', 'HTTP', 'POST', ' {{base_url}}/api/v1/system/auth/login', '{}', '{}', '\"{\\n  \\\"username\\\": \\\"admin\\\",\\n  \\\"password\\\": \\\"123456\\\",\\n  \\\"captcha\\\": \\\"string\\\",\\n  \\\"captcha_key\\\": \\\"string\\\"\\n}\"', NULL, '{\"data\": {\"password\": \"123456\", \"username\": \"admin\"}, \"type\": \"basic\"}', '[]', '[]', '[{\"type\": \"body_contains\", \"expected\": \"200\", \"jsonpath\": \"$data.code\", \"operator\": \"contains\"}]', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (44, 30, '777', '', 'HTTP', 'GET', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (45, 30, '77', '', 'HTTP', 'PUT', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (46, 30, '77', '', 'HTTP', 'DELETE', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (47, 30, '77', '', 'HTTP', 'PATCH', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (48, 30, '77', '', 'HTTP', 'HEAD', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (49, 30, '77', '77', 'HTTP', 'OPTIONS', '77', 'null', 'null', 'null', NULL, 'null', '[]', '[]', 'null', 1, 1, 30000, 0, '2026-02-07 15:52:18', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (50, 31, '未命名接口', '', 'HTTP', 'GET', '/', '{\"Host\": \"47.115.83.226:9966\", \"token\": \"3118610f1b7944efa76104b0e30cd687\", \"Accept\": \"application/json, text/plain, */*\", \"Cookie\": \"194ECB40BE3701AF6634B8E578729C7D\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\", \"Content-Type\": \"application/json\", \"Accept-Encoding\": \"gzip, deflate\", \"Accept-Language\": \"zh-CN,zh;q=0.9\"}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:52:57', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (51, 32, '登录VSS接口', '', 'HTTP', 'POST', '///vss/user/login.action', '{\"Host\": \"47.115.83.226:9966\", \"token\": \"3118610f1b7944efa76104b0e30cd687\", \"Accept\": \"application/json, text/plain, */*\", \"Cookie\": \"194ECB40BE3701AF6634B8E578729C7D\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\", \"Content-Type\": \"application/json\", \"Accept-Encoding\": \"gzip, deflate\", \"Accept-Language\": \"zh-CN,zh;q=0.9\"}', '{}', 'null', NULL, 'null', '[]', '[]', '[]', 1, 1, 30000, 0, '2026-02-07 15:59:35', NULL, '2026-02-07 17:30:48', NULL, 1, NULL);
INSERT INTO `api_requests` VALUES (52, 33, '登录VSS接口', '', 'HTTP', 'POST', '///vss/user/login.action', '{\"Host\": \"47.115.83.226:9966\", \"token\": \"3118610f1b7944efa76104b0e30cd687\", \"Accept\": \"application/json, text/plain, */*\", \"Cookie\": \"194ECB40BE3701AF6634B8E578729C7D\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\", \"Content-Type\": \"application/json\", \"Accept-Encoding\": \"gzip, deflate\", \"Accept-Language\": \"zh-CN,zh;q=0.9\"}', '{}', 'null', NULL, 'null', '\"\"', '\"\"', '[]', 1, 1, 30000, 0, '2026-02-07 17:45:35', NULL, '2026-02-07 17:45:35', NULL, 1, NULL);

-- ----------------------------
-- Table structure for api_ssl_certificate
-- ----------------------------
DROP TABLE IF EXISTS `api_ssl_certificate`;
CREATE TABLE `api_ssl_certificate`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` int NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证书名称',
  `cert_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证书类型: CA/CLIENT',
  `domain` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用域名（支持通配符）',
  `ca_cert` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'CA证书内容（PEM格式）',
  `client_cert` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '客户端证书内容（CRT/PEM格式）',
  `client_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '客户端私钥内容（KEY/PEM格式）',
  `passphrase` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '私钥密码（加密存储）',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '描述',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_domain`(`domain`(255) ASC) USING BTREE,
  INDEX `idx_cert_type`(`cert_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SSL证书管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_ssl_certificate
-- ----------------------------

-- ----------------------------
-- Table structure for api_test_executions
-- ----------------------------
DROP TABLE IF EXISTS `api_test_executions`;
CREATE TABLE `api_test_executions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_suite_id` bigint NOT NULL COMMENT '测试套件ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING' COMMENT '执行状态: PENDING/RUNNING/SUCCESS/FAILED',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `total_requests` int NULL DEFAULT 0 COMMENT '总请求数',
  `passed_requests` int NULL DEFAULT 0 COMMENT '通过请求数',
  `failed_requests` int NULL DEFAULT 0 COMMENT '失败请求数',
  `results` json NULL COMMENT '执行结果',
  `executed_by` bigint NOT NULL COMMENT '执行者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_suite`(`test_suite_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API测试执行表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_test_executions
-- ----------------------------
INSERT INTO `api_test_executions` VALUES (1, 3, 'FAILED', '2026-02-07 09:23:44', '2026-02-07 09:23:45', 1, 0, 1, '[{\"result\": {\"history_id\": 2, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 271.6479301452637, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 4}]', 1, '2026-02-07 09:23:44', NULL, '2026-02-07 09:23:44', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (2, 4, 'FAILED', '2026-02-07 09:26:14', '2026-02-07 09:26:14', 1, 0, 1, '[{\"result\": {\"history_id\": 4, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 251.11770629882812, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 5}]', 1, '2026-02-07 09:26:13', NULL, '2026-02-07 09:26:14', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (3, 5, 'FAILED', '2026-02-07 09:28:30', '2026-02-07 09:28:30', 1, 0, 1, '[{\"result\": {\"history_id\": 6, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 253.11708450317383, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 6}]', 1, '2026-02-07 09:28:30', NULL, '2026-02-07 09:28:30', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (4, 6, 'FAILED', '2026-02-07 09:29:44', '2026-02-07 09:29:45', 1, 0, 1, '[{\"result\": {\"history_id\": 8, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 253.7741661071777, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 7}]', 1, '2026-02-07 09:29:44', NULL, '2026-02-07 09:29:44', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (5, 7, 'FAILED', '2026-02-07 09:32:17', '2026-02-07 09:32:17', 1, 0, 1, '[{\"result\": {\"history_id\": 10, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 376.72948837280273, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 8}]', 1, '2026-02-07 09:32:16', NULL, '2026-02-07 09:32:17', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (6, 8, 'FAILED', '2026-02-07 09:34:10', '2026-02-07 09:34:11', 1, 0, 1, '[{\"result\": {\"history_id\": 12, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 271.56901359558105, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 9}]', 1, '2026-02-07 09:34:10', NULL, '2026-02-07 09:34:10', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (7, 9, 'FAILED', '2026-02-07 09:35:18', '2026-02-07 09:35:18', 1, 0, 1, '[{\"result\": {\"history_id\": 14, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 250.12612342834473, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 10}]', 1, '2026-02-07 09:35:17', NULL, '2026-02-07 09:35:18', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (8, 10, 'FAILED', '2026-02-07 09:38:11', '2026-02-07 09:38:12', 1, 0, 1, '[{\"result\": {\"history_id\": 16, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 262.2687816619873, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 11}]', 1, '2026-02-07 09:38:11', NULL, '2026-02-07 09:38:11', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (9, 11, 'FAILED', '2026-02-07 09:39:49', '2026-02-07 09:39:49', 1, 0, 1, '[{\"result\": {\"history_id\": 18, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 250.4403591156006, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 12}]', 1, '2026-02-07 09:39:48', NULL, '2026-02-07 09:39:49', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (10, 12, 'FAILED', '2026-02-07 09:42:05', '2026-02-07 09:42:05', 1, 0, 1, '[{\"result\": {\"history_id\": 20, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 249.56178665161133, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 13}]', 1, '2026-02-07 09:42:04', NULL, '2026-02-07 09:42:05', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (11, 14, 'FAILED', '2026-02-07 13:57:54', '2026-02-07 13:57:55', 1, 0, 1, '[{\"result\": {\"history_id\": 45, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 257.0202350616455, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 15}]', 1, '2026-02-07 13:57:54', NULL, '2026-02-07 13:57:54', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (12, 14, 'FAILED', '2026-02-07 14:06:01', '2026-02-07 14:06:02', 1, 0, 1, '[{\"result\": {\"history_id\": 48, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 264.0042304992676, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 15}]', 1, '2026-02-07 14:06:01', NULL, '2026-02-07 14:06:01', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (13, 14, 'FAILED', '2026-02-07 14:35:00', '2026-02-07 14:35:00', 1, 0, 1, '[{\"result\": {\"history_id\": 64, \"status_code\": 0, \"updated_env\": null, \"error_message\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\", \"response_data\": {\"error\": \"Request URL is missing an \'http://\' or \'https://\' protocol.\"}, \"response_time\": 272.3374366760254, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 15}]', 1, '2026-02-07 14:34:59', NULL, '2026-02-07 14:34:59', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (14, 15, 'SUCCESS', '2026-02-07 14:35:50', '2026-02-07 14:35:50', 1, 1, 0, '[{\"result\": {\"history_id\": 65, \"status_code\": 200, \"updated_env\": null, \"error_message\": null, \"response_data\": {\"body\": {\"code\": 200, \"data\": {\"expires_in\": 86400, \"token_type\": \"Bearer\", \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIyOWQ5NmU0NGI0MGI0NzhjYjgwNzM4Y2I3NmRiODA1ZiIsImV4cCI6MTc3MDUzMjU1MH0.ftu3vZs3Y7nbgRdvcPLIkHe6fpgo8qHkWzPp5UeUodI\", \"refresh_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsInNlc3Npb25faWQiOiIyOWQ5NmU0NGI0MGI0NzhjYjgwNzM4Y2I3NmRiODA1ZiIsImV4cCI6MTc3MTA1MDk1MCwidHlwZSI6InJlZnJlc2gifQ.wqYvF0xWdYpYeXA0KkIHV3dFdrr5_I5E8HkSLP9KLMM\"}, \"message\": \"登录成功\"}, \"headers\": {\"date\": \"Sat, 07 Feb 2026 06:35:49 GMT\", \"server\": \"uvicorn\", \"content-type\": \"application/json\", \"x-request-id\": \"16308a9e49f745f5afad9fa34aaea9ff\", \"content-length\": \"563\"}, \"status_code\": 200, \"response_time\": 592.6196575164795}, \"response_time\": 592.6196575164795, \"assertions_passed\": true, \"assertions_results\": []}, \"order_num\": 1, \"request_id\": 15}]', 1, '2026-02-07 14:35:49', NULL, '2026-02-07 14:35:50', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (15, 15, 'SUCCESS', '2026-02-07 14:39:47', '2026-02-07 14:39:48', 1, 1, 0, '[{\"passed\": true, \"order_num\": 1, \"request_id\": 15, \"status_code\": 200, \"request_name\": \"登录\", \"error_message\": null, \"response_time\": 794.1465377807617, \"assertions_results\": []}]', 1, '2026-02-07 14:39:47', NULL, '2026-02-07 14:39:48', NULL, 1, NULL);
INSERT INTO `api_test_executions` VALUES (16, 15, 'SUCCESS', '2026-02-07 14:41:08', '2026-02-07 14:41:09', 1, 1, 0, '[{\"passed\": true, \"order_num\": 1, \"request_id\": 15, \"status_code\": 200, \"request_name\": \"登录\", \"error_message\": null, \"response_time\": 728.6155223846436, \"assertions_results\": []}]', 1, '2026-02-07 14:41:08', NULL, '2026-02-07 14:41:08', NULL, 1, NULL);

-- ----------------------------
-- Table structure for api_test_suite_requests
-- ----------------------------
DROP TABLE IF EXISTS `api_test_suite_requests`;
CREATE TABLE `api_test_suite_requests`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_suite_id` bigint NOT NULL COMMENT '测试套件ID',
  `request_id` bigint NOT NULL COMMENT 'API请求ID',
  `order_num` int NULL DEFAULT 0 COMMENT '执行顺序',
  `assertions` json NULL COMMENT '断言规则',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_suite_request`(`test_suite_id` ASC, `request_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '套件请求关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_test_suite_requests
-- ----------------------------
INSERT INTO `api_test_suite_requests` VALUES (1, 1, 2, 1, NULL, '2026-02-07 09:12:21', NULL, '2026-02-07 09:12:32', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (2, 2, 3, 1, NULL, '2026-02-07 09:19:43', NULL, '2026-02-07 09:20:00', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (3, 3, 4, 1, NULL, '2026-02-07 09:23:37', NULL, '2026-02-07 09:23:55', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (4, 4, 5, 1, NULL, '2026-02-07 09:26:07', NULL, '2026-02-07 09:26:24', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (5, 5, 6, 1, NULL, '2026-02-07 09:28:23', NULL, '2026-02-07 09:28:40', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (6, 6, 7, 1, NULL, '2026-02-07 09:29:38', NULL, '2026-02-07 09:29:55', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (7, 7, 8, 1, NULL, '2026-02-07 09:32:09', NULL, '2026-02-07 09:32:27', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (8, 8, 9, 1, NULL, '2026-02-07 09:34:04', NULL, '2026-02-07 09:34:20', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (9, 9, 10, 1, NULL, '2026-02-07 09:35:11', NULL, '2026-02-07 09:35:28', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (10, 10, 11, 1, NULL, '2026-02-07 09:38:05', NULL, '2026-02-07 09:38:22', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (11, 11, 12, 1, NULL, '2026-02-07 09:39:42', NULL, '2026-02-07 09:39:59', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (12, 12, 13, 1, NULL, '2026-02-07 09:41:58', NULL, '2026-02-07 09:42:15', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (13, 13, 15, 1, NULL, '2026-02-07 11:41:10', NULL, '2026-02-07 11:41:27', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (19, 14, 15, 1, NULL, '2026-02-07 13:57:21', NULL, '2026-02-07 14:35:10', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (20, 15, 15, 1, NULL, '2026-02-07 14:35:44', NULL, '2026-02-07 14:45:33', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (21, 16, 22, 1, NULL, '2026-02-07 14:40:13', NULL, '2026-02-07 14:40:18', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (22, 17, 15, 1, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (23, 17, 22, 2, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (24, 17, 16, 3, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (25, 17, 17, 4, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (26, 17, 18, 5, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (27, 17, 19, 6, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (28, 17, 20, 7, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);
INSERT INTO `api_test_suite_requests` VALUES (29, 17, 21, 8, NULL, '2026-02-07 14:47:55', NULL, '2026-02-07 14:48:04', 1, 0, NULL);

-- ----------------------------
-- Table structure for api_test_suites
-- ----------------------------
DROP TABLE IF EXISTS `api_test_suites`;
CREATE TABLE `api_test_suites`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `api_project_id` bigint NOT NULL COMMENT 'API项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套件名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '套件描述',
  `environment_id` bigint NULL DEFAULT NULL COMMENT '执行环境ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_api_project`(`api_project_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'API测试套件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of api_test_suites
-- ----------------------------
INSERT INTO `api_test_suites` VALUES (15, 1, '执行测试套件9', '执行测试套件', 16, '2026-02-07 14:35:44', NULL, '2026-02-08 18:43:26', NULL, 1, NULL);

-- ----------------------------
-- Table structure for app_airtest_images
-- ----------------------------
DROP TABLE IF EXISTS `app_airtest_images`;
CREATE TABLE `app_airtest_images`  (
  `file_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '图片名称',
  `file_path` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '图片地址',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `menu_id` bigint NULL DEFAULT NULL COMMENT '所属菜单',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_app_airtest_images_id`(`id` ASC) USING BTREE,
  INDEX `idx_app_airtest_images_menu`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `app_airtest_images_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `app_menus` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'APP自动化 Airtest 图像库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_airtest_images
-- ----------------------------
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260319/26d345c584c24b83ba577cf50d055ca9.png', '2026-03-19 19:54:38', NULL, 7, '2026-03-19 19:54:38', NULL, '2026-03-19 19:54:38', NULL, 1, NULL);
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260319/08128e2a150a482ebf52c5f95fb07066.png', '2026-03-19 19:56:59', NULL, 8, '2026-03-19 19:56:59', NULL, '2026-03-19 19:56:59', NULL, 1, NULL);
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260320/41bf1fd12ea840d6b284dc7157b17f23.png', '2026-03-20 09:26:03', NULL, 9, '2026-03-20 09:26:03', NULL, '2026-03-20 09:26:03', NULL, 1, NULL);
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260320/1ccc366c70584e11b3b605a33e491285.png', '2026-03-20 09:26:39', NULL, 10, '2026-03-20 09:26:39', NULL, '2026-03-20 09:26:39', NULL, 1, NULL);
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260320/ccabdcfee40a49e9a5a3cead1a521e5a.png', '2026-03-20 09:27:07', NULL, 11, '2026-03-20 09:27:07', NULL, '2026-03-20 09:27:07', NULL, 1, NULL);
INSERT INTO `app_airtest_images` VALUES ('nova_11.png', 'http://127.0.0.1:8100/static/upload/20260320/29f3e8d7dae14f6290616a6a7e2d54c9.png', '2026-03-20 09:51:05', NULL, 12, '2026-03-20 09:51:05', NULL, '2026-03-20 09:51:05', NULL, 1, NULL);

-- ----------------------------
-- Table structure for app_device_installs
-- ----------------------------
DROP TABLE IF EXISTS `app_device_installs`;
CREATE TABLE `app_device_installs`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `apk_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'APK名称',
  `apk_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'APK路径',
  `device_id` int NOT NULL COMMENT '设备ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '安装时间',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_app_device_installs_id`(`id` ASC) USING BTREE,
  INDEX `ix_app_device_installs_device_id`(`device_id` ASC) USING BTREE,
  INDEX `ix_app_device_installs_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备APP安装历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of app_device_installs
-- ----------------------------
INSERT INTO `app_device_installs` VALUES (1, '新建 文本文档.txt', 'http://127.0.0.1:8100/api/v1/system/file/content/a45e923185124cf88e694d28fe10f19a.txt', 36, 1, '2026-03-20 18:19:01', '2026-03-20 18:19:01', NULL, '2026-03-20 18:19:01', NULL, 1, NULL, '2026-03-20 18:19:01', '2026-03-20 18:19:01');

-- ----------------------------
-- Table structure for app_device_log_lists
-- ----------------------------
DROP TABLE IF EXISTS `app_device_log_lists`;
CREATE TABLE `app_device_log_lists`  (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `together_id` int NOT NULL COMMENT '关联ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of app_device_log_lists
-- ----------------------------

-- ----------------------------
-- Table structure for app_device_logs
-- ----------------------------
DROP TABLE IF EXISTS `app_device_logs`;
CREATE TABLE `app_device_logs`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `device_id` int NOT NULL COMMENT '设备ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始使用时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束使用时间',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_app_device_logs_id`(`id` ASC) USING BTREE,
  INDEX `ix_app_device_logs_device_id`(`device_id` ASC) USING BTREE,
  INDEX `ix_app_device_logs_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备使用日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of app_device_logs
-- ----------------------------
INSERT INTO `app_device_logs` VALUES (1, 36, 1, '2026-03-19 16:59:57', '2026-03-19 17:00:36', '2026-03-19 16:59:56', NULL, '2026-03-19 17:00:36', NULL, 1, NULL, '2026-03-19 16:59:57', '2026-03-19 17:00:36');
INSERT INTO `app_device_logs` VALUES (3, 36, 1, '2026-03-19 17:37:31', '2026-03-19 17:45:52', '2026-03-19 17:37:31', NULL, '2026-03-19 17:45:52', NULL, 1, NULL, '2026-03-19 17:37:31', '2026-03-19 17:45:52');
INSERT INTO `app_device_logs` VALUES (4, 36, 1, '2026-03-20 18:16:05', '2026-03-20 18:21:53', '2026-03-20 18:16:05', NULL, '2026-03-20 18:21:52', NULL, 1, NULL, '2026-03-20 18:16:06', '2026-03-20 18:21:53');
INSERT INTO `app_device_logs` VALUES (5, 36, 1, '2026-03-20 18:31:59', '2026-03-20 18:32:06', '2026-03-20 18:31:59', NULL, '2026-03-20 18:32:06', NULL, 1, NULL, '2026-03-20 18:31:59', '2026-03-20 18:32:06');
INSERT INTO `app_device_logs` VALUES (6, 36, 1, '2026-03-20 18:32:25', '2026-03-20 18:32:57', '2026-03-20 18:32:24', NULL, '2026-03-20 18:32:56', NULL, 1, NULL, '2026-03-20 18:32:25', '2026-03-20 18:32:57');
INSERT INTO `app_device_logs` VALUES (7, 36, 1, '2026-03-20 18:33:01', '2026-03-20 18:33:05', '2026-03-20 18:33:00', NULL, '2026-03-20 18:33:04', NULL, 1, NULL, '2026-03-20 18:33:01', '2026-03-20 18:33:05');
INSERT INTO `app_device_logs` VALUES (8, 36, 1, '2026-03-20 18:56:18', '2026-03-20 18:57:39', '2026-03-20 18:56:18', NULL, '2026-03-20 18:57:38', NULL, 1, NULL, '2026-03-20 18:56:18', '2026-03-20 18:57:39');

-- ----------------------------
-- Table structure for app_devices
-- ----------------------------
DROP TABLE IF EXISTS `app_devices`;
CREATE TABLE `app_devices`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `device_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备名称',
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备ID',
  `device_status` int NOT NULL DEFAULT 1 COMMENT '设备状态: 1-空闲, 2-使用中, 3-离线',
  `device_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备类型',
  `device_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备版本',
  `device_info` json NULL COMMENT '设备详细信息',
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备图片路径',
  `device_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '设备描述',
  `user_id` int NOT NULL COMMENT '用户ID',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_app_devices_id`(`id` ASC) USING BTREE,
  INDEX `ix_app_devices_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '云真机设备表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of app_devices
-- ----------------------------
INSERT INTO `app_devices` VALUES (10, '华为 nova 11', '9TM9K23404015786', 3, 'HUAWEI', '4.0.0', '{\"cpu\": \"高通骁龙™ 778G\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"4500毫安\", \"display\": \"2412*1084\", \"version\": \"4.0.0\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/nova_11.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (11, 'OPPO K9', '6faf7764', 3, 'OPPO', '12', '{\"cpu\": \"高通骁龙™ 768G\", \"memory\": \"256GB\", \"screen\": \"6.43英寸\", \"battery\": \"4300毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/oppo_k9.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (12, 'HONOR 60', 'AXYFVB1C03005594', 3, 'HONOR', '12', '{\"cpu\": \"高通骁龙™ 768G\", \"memory\": \"256GB\", \"screen\": \"6.43英寸\", \"battery\": \"4800毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/honor_60.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (13, 'XiaoMi K40 Pro', 'f87c1a21', 3, 'XIAOMI', '11', '{\"cpu\": \"A16芯片\", \"memory\": \"128GB\", \"screen\": \"6.7英寸\", \"battery\": \"4323毫安\", \"display\": \"2796*1290\", \"running_memory\": \"6GB\"}', 'http://110.41.67.102:8895/media/device/Redmi_K40_Pro1.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (14, '华为 nova 5 Pro', '6HJDU19723002103', 3, 'HUAWEI', '3.0.0', '{\"cpu\": \"海思麒麟980\", \"memory\": \"128GB\", \"screen\": \"6.39英寸\", \"battery\": \"3500毫安\", \"display\": \"2340*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/nova_5_pro.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (15, '三星 Galaxy A54 5G', 'R5CW32RABBR', 3, 'samsung', '13', '{\"cpu\": \"三星Exynos 1380\", \"memory\": \"128GB\", \"screen\": \"6.39英寸\", \"battery\": \"5100毫安\", \"display\": \"2412*1084\", \"running_memory\": \"6GB\"}', 'http://110.41.67.102:8895/media/device/Galaxy_A54_5G.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (16, '华为 nova 8 SE', 'BRNUT21B15053171', 3, 'HUAWEI', '3.0.0', '{\"cpu\": \"海思麒麟710A\", \"memory\": \"128GB\", \"screen\": \"6.53英寸\", \"battery\": \"3800毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/nova_8_SE.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (17, '一加 One Plus 8T', '1530c577', 3, 'OnePlus', '13', '{\"cpu\": \"高通骁龙™ 865\", \"memory\": \"128GB\", \"screen\": \"6.55英寸\", \"battery\": \"4500毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/one_plus_8T.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (18, '一加 One Plus9', '9e4c6fd0', 3, 'OnePlus', '13', '{\"cpu\": \"高通骁龙™ 888\", \"memory\": \"128GB\", \"screen\": \"6.55英寸\", \"battery\": \"4500毫安\", \"display\": \"2400*1080\", \"version\": \"4\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/one_plus_9.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (19, 'XiaoMi K40', '694f3ed', 3, 'XIAOMI', '12', '{\"cpu\": \"高通骁龙™ 870\", \"memory\": \"128GB\", \"screen\": \"6.67英寸\", \"battery\": \"4520毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/Redmi_K40.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (20, 'Google Pixel 6', '1A121FDF6002BF', 3, 'google', '13', '{\"cpu\": \"Google Tensor\", \"memory\": \"128GB\", \"screen\": \"6.4英寸\", \"battery\": \"4614毫安\", \"display\": \"2340*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/Google_Pixel_6.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (21, 'OPPO Reno4 SE', 'UWYTLFOVLRD65LHI', 3, 'OPPO', '12', '{\"cpu\": \"天玑720\", \"memory\": \"128GB\", \"screen\": \"6.43英寸\", \"battery\": \"4500毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/oppo_reno4_se.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (22, '三星 Galaxy Tab S9', 'R52W803F7MF', 3, 'samsung', '13', '{\"cpu\": \"高通骁龙™ 8 Gen 2\", \"memory\": \"128GB\", \"screen\": \"14.6英寸\", \"battery\": \"8400毫安\", \"display\": \"2960*1848\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/Galaxy_Tab_S9.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (23, 'Google Pixel 7', '27281FDH2004YA', 3, 'google', '13', '{\"cpu\": \"Google Tensor\", \"memory\": \"128GB\", \"screen\": \"6.4英寸\", \"battery\": \"4614毫安\", \"display\": \"2340*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/Pixel_7.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (24, 'OPPO Reno9 5G', '7fb1efb', 3, 'OPPO', '13', '{\"cpu\": \"高通骁龙™ 778G\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"4500毫安\", \"display\": \"2412*1080\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/OPPO_Reno9_5G.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (25, '夏普 sense7 plus', '358690499901359', 3, 'SHARP', '12', '{\"cpu\": \"高通骁龙™ 695 5G\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"4500毫安\", \"display\": \"2340*1080\", \"version\": \"4\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/AQUOS_sense7_plus.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (26, '华为 Mate 50 Pro', '3KX0222A24000500', 3, 'HUAWEI', '3.0.0', '{\"cpu\": \"高通骁龙™ 695 5G\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"4500毫安\", \"display\": \"2412*1084\", \"version\": \"4\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/Mate_50_Pro.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (27, '一加 neo5', '341523544400B38', 3, 'OnePlus', '12', '{\"cpu\": \"高通骁龙™ 870\", \"memory\": \"256GB\", \"screen\": \"6.62英寸\", \"battery\": \"4400毫安\", \"display\": \"2400*1080\", \"version\": \"4\", \"running_memory\": \"8+4GB\"}', 'http://110.41.67.102:8895/media/device/vivo_neo5.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (28, 'ViVo S19', '10CE6R0NP7001KX', 3, 'vivo', '14', '{\"cpu\": \"第三代骁龙7\", \"memory\": \"256GB\", \"screen\": \"6.78英寸\", \"battery\": \"6000毫安\", \"display\": \"2800*1260\", \"running_memory\": \"8+8GB\"}', 'http://110.41.67.102:8895/media/device/vivo_s19.jpg', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (29, 'XiaoMi note 12 pro', 'vokfmnfa8p45ib9t', 3, 'XIAOMI', '12', '{\"cpu\": \"天玑 1080\", \"memory\": \"256GB\", \"screen\": \"6.67英寸\", \"battery\": \"5000毫安\", \"display\": \"2400*1080\", \"running_memory\": \"8+4GB\"}', 'http://110.41.67.102:8895/media/device/xiaomi_note_12.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (30, '华为 Mate 70', 'xxx', 3, 'HUAWEI', '5.0.0', '{\"cpu\": \"海思麒麟 9100\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"4500毫安\", \"display\": \"2688*1216\", \"version\": \"4\", \"running_memory\": \"12GB\"}', 'http://110.41.67.102:8895/media/device/mate_70.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (31, 'OPPO Reno 12', 'DQMVDMINRSJVDE5H', 3, 'OPPO', '14', '{\"cpu\": \"天玑 8250\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"5000毫安\", \"display\": \"2412*1080\", \"running_memory\": \"16GB\"}', 'http://110.41.67.102:8895/media/device/opop_reno_12.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (32, '华为 Pura 70', 'xxqw', 3, 'HUAWEI', '4.0.0', '{\"cpu\": \"海思麒麟 9100\", \"memory\": \"256GB\", \"screen\": \"6.6英寸\", \"battery\": \"4900毫安\", \"display\": \"2760*1256\", \"running_memory\": \"12GB\"}', 'http://110.41.67.102:8895/media/device/pura_70.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (33, '华为 p30 pro', '22X0219924002278', 3, 'HUAWEI', '2.0.0', '{\"cpu\": \"海思麒麟980\", \"memory\": \"128GB\", \"screen\": \"6.47英寸\", \"battery\": \"4200毫安\", \"display\": \"2340*1080\", \"version\": \"4\", \"running_memory\": \"8GB\"}', 'http://110.41.67.102:8895/media/device/huawei_p30_pro.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (34, 'XiaoMi K70', '86477ae', 3, 'XIAOMI', '15', '{\"cpu\": \"第二代骁龙8\", \"memory\": \"256GB\", \"screen\": \"6.67英寸\", \"battery\": \"5000毫安\", \"display\": \"2712*1220\", \"running_memory\": \"32GB\"}', 'http://110.41.67.102:8895/media/device/redmi_k70.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (35, '荣耀 200', 'ACMMVB4904002940', 3, 'HONOR', '15', '{\"cpu\": \"第三代骁龙7\", \"memory\": \"256GB\", \"screen\": \"6.7英寸\", \"battery\": \"5200毫安\", \"display\": \"2664*1200\", \"running_memory\": \"8+8GB\"}', 'http://110.41.67.102:8895/media/device/honor_200.png', '', 1, '2026-03-19 11:38:44', NULL, '2026-03-19 11:38:44', NULL, 1, NULL, '2026-03-19 11:38:44', '2026-03-19 11:38:44');
INSERT INTO `app_devices` VALUES (36, 'OPPO Find', '69900dc9', 3, 'Android', '13', '{\"cpu\": \"\", \"phone\": \"\", \"memory\": \"\", \"screen\": \"\", \"battery\": \"\", \"display\": \"\", \"running_memory\": \"\"}', 'http://110.41.67.102:8895/media/device/OPPO_Reno9_5G.png', '', 1, '2026-03-19 16:58:11', NULL, '2026-03-20 18:59:15', NULL, 1, NULL, '2026-03-19 16:58:11', '2026-03-20 18:59:15');

-- ----------------------------
-- Table structure for app_menus
-- ----------------------------
DROP TABLE IF EXISTS `app_menus`;
CREATE TABLE `app_menus`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '名称',
  `pid` bigint NOT NULL COMMENT '父id',
  `type` int NOT NULL COMMENT '类型',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `ix_app_menus_id`(`id` ASC) USING BTREE,
  CONSTRAINT `app_menus_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'APP自动化菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_menus
-- ----------------------------
INSERT INTO `app_menus` VALUES ('根目录', 0, 0, 1, 47, '2026-03-30 16:04:45', NULL, '2026-03-30 16:04:45', NULL, 1, NULL);

-- ----------------------------
-- Table structure for app_mitmproxy_api
-- ----------------------------
DROP TABLE IF EXISTS `app_mitmproxy_api`;
CREATE TABLE `app_mitmproxy_api`  (
  `result_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '结果ID',
  `device_id` int NOT NULL COMMENT '设备ID（app_devices.id）',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '接口请求地址',
  `method` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '请求方法',
  `request_body` json NULL COMMENT '请求体',
  `request_headers` json NULL COMMENT '请求头',
  `response_headers` json NULL COMMENT '响应头',
  `response_body` json NULL COMMENT '响应体',
  `status` int NOT NULL COMMENT '状态(0失败/1成功)',
  `res_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '响应时间(ms)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `device_id`(`device_id` ASC) USING BTREE,
  INDEX `ix_app_mitmproxy_api_id`(`id` ASC) USING BTREE,
  INDEX `idx_app_mitmproxy_api_user_device`(`user_id` ASC, `device_id` ASC) USING BTREE,
  INDEX `idx_app_mitmproxy_api_result`(`result_id` ASC) USING BTREE,
  CONSTRAINT `app_mitmproxy_api_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `app_devices` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app_mitmproxy_api_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'mitmproxy 抓包接口记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_mitmproxy_api
-- ----------------------------

-- ----------------------------
-- Table structure for app_result_lists
-- ----------------------------
DROP TABLE IF EXISTS `app_result_lists`;
CREATE TABLE `app_result_lists`  (
  `task_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务名称',
  `device_list` json NOT NULL COMMENT '设备列表',
  `result_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '结果id',
  `script_list` json NOT NULL COMMENT '脚本列表',
  `script_status` json NOT NULL COMMENT '脚本执行情况',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `result_id`(`result_id` ASC) USING BTREE,
  INDEX `ix_app_result_lists_id`(`id` ASC) USING BTREE,
  INDEX `idx_app_result_lists_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `app_result_lists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'APP自动化结果汇总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_result_lists
-- ----------------------------
INSERT INTO `app_result_lists` VALUES ('调试', '[]', '1773909796956', '[{\"id\": 2, \"name\": \"\"}]', '[]', '2026-03-19 16:43:16', NULL, 1, 1, '2026-03-19 16:43:16', NULL, '2026-03-19 16:43:16', NULL, 1, NULL);
INSERT INTO `app_result_lists` VALUES ('测试', '[{\"id\": 36, \"name\": \"OPPO Find\", \"path\": \"\", \"notify\": 0, \"os_type\": \"android\", \"package\": \"\", \"version\": \"未知操作系统版本\", \"wifi_ip\": \"172.16.30.248\", \"deviceid\": \"69900dc9\"}]', '1773913855665', '[{\"id\": 2, \"name\": \"\"}]', '[{\"pid\": 28268, \"fail\": 0, \"total\": 0, \"device\": \"69900dc9\", \"passed\": 0, \"status\": \"running\", \"un_run\": 0, \"percent\": 0}]', '2026-03-19 17:50:55', NULL, 1, 2, '2026-03-19 17:50:55', NULL, '2026-03-19 17:50:55', NULL, 1, NULL);
INSERT INTO `app_result_lists` VALUES ('75765757', '[{\"id\": 36, \"name\": \"OPPO Find\", \"path\": \"com.howentech.vss\", \"notify\": 0, \"os_type\": \"android\", \"package\": \"\", \"version\": \"未知操作系统版本\", \"wifi_ip\": \"172.16.30.248\", \"deviceid\": \"69900dc9\"}]', '1773915379565', '[{\"id\": 2, \"name\": \"\"}]', '[{\"pid\": 27256, \"fail\": 0, \"total\": 0, \"device\": \"69900dc9\", \"passed\": 0, \"status\": \"running\", \"un_run\": 0, \"percent\": 0}]', '2026-03-19 18:16:19', '2026-03-19 18:16:49', 1, 3, '2026-03-19 18:16:19', NULL, '2026-03-19 18:16:49', NULL, 1, NULL);
INSERT INTO `app_result_lists` VALUES ('测试', '[]', '1773918473376', '[{\"id\": 2, \"name\": \"\"}]', '[]', '2026-03-19 19:07:53', NULL, 1, 4, '2026-03-19 19:07:53', NULL, '2026-03-19 19:07:53', NULL, 1, NULL);
INSERT INTO `app_result_lists` VALUES ('开始测试', '[]', '1773986965093', '[{\"id\": 2, \"name\": \"\"}]', '[]', '2026-03-20 14:09:25', NULL, 1, 5, '2026-03-20 14:09:25', NULL, '2026-03-20 14:09:25', NULL, 1, NULL);
INSERT INTO `app_result_lists` VALUES ('测试拍一下', '[{\"id\": 36, \"name\": \"OPPO Find\", \"path\": \"\", \"notify\": 1, \"os_type\": \"android\", \"package\": \"\", \"version\": \"未知操作系统版本\", \"wifi_ip\": \"172.16.30.248\", \"deviceid\": \"69900dc9\", \"notice_time\": 1774860961.0902562}]', '1773992584691', '[{\"id\": 2, \"name\": \"\"}]', '[{\"pid\": 38236, \"fail\": 0, \"total\": 0, \"device\": \"69900dc9\", \"passed\": 0, \"status\": \"running\", \"un_run\": 0, \"percent\": 0}]', '2026-03-20 15:43:05', '2026-03-20 15:43:55', 1, 6, '2026-03-20 15:43:05', NULL, '2026-03-30 16:53:01', NULL, 1, NULL);

-- ----------------------------
-- Table structure for app_results
-- ----------------------------
DROP TABLE IF EXISTS `app_results`;
CREATE TABLE `app_results`  (
  `device` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '设备',
  `result_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '结果id',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '脚本名称',
  `status` int NOT NULL COMMENT '状态 0失败 1成功 2进行中(兼容旧)',
  `log` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '详情',
  `assert_value` json NULL COMMENT '断言详情',
  `before_img` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '执行前截图地址',
  `after_img` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '执行后截图地址',
  `video` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '视频地址',
  `performance` json NULL COMMENT '实时性能',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '执行时间',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `menu_id`(`menu_id` ASC) USING BTREE,
  INDEX `ix_app_results_id`(`id` ASC) USING BTREE,
  INDEX `idx_app_results_result`(`result_id` ASC) USING BTREE,
  INDEX `idx_app_results_user_device`(`user_id` ASC, `device` ASC) USING BTREE,
  CONSTRAINT `app_results_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `app_menus` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app_results_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'APP自动化执行结果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_results
-- ----------------------------
INSERT INTO `app_results` VALUES ('69900dc9', '1773915379565', '执行异常', 0, 'Appium连接失败: Message: An unknown server-side error occurred while processing the command. Original error: Could not find a driver for automationName \'UIAutomator2\' and platformName \'Android\'. Have you installed a driver that supports those capabilities? Run \'appium driver list --installed\' to see. (Lower-level error: Could not find installed driver to support given caps)\nStacktrace:\nUnknownError: An unknown server-side error occurred while processing the command. Original error: Could not find a driver for automationName \'UIAutomator2\' and platformName \'Android\'. Have you installed a driver that supports those capabilities? Run \'appium driver list --installed\' to see. (Lower-level error: Could not find installed driver to support given caps)\n    at getResponseForW3CError (C:\\Users\\Administrator\\AppData\\Roaming\\npm\\node_modules\\appium\\node_modules\\@appium\\base-driver\\lib\\protocol\\errors.js:1143:9)\n    at asyncHandler (C:\\Users\\Administrator\\AppData\\Roaming\\npm\\node_modules\\appium\\node_modules\\@appium\\base-driver\\lib\\protocol\\protocol.js:487:57)', '{}', '', '', '', '{\"cpu\": [0], \"time\": [\"16:48\"], \"memory\": [0], \"up_network\": [0], \"temperature\": [0], \"down_network\": [0]}', 2, '2026-03-19 18:16:48', 1, 1, '2026-03-19 18:16:48', NULL, '2026-03-19 18:16:48', NULL, 1, NULL);
INSERT INTO `app_results` VALUES ('69900dc9', '1773915379565', '执行结束', 0, '执行结束', '{}', '', '', '', '{\"cpu\": [0, 0], \"time\": [\"16:48\", \"16:49\"], \"memory\": [0, 0], \"up_network\": [0, 0], \"temperature\": [0, 0], \"down_network\": [0, 0]}', 2, '2026-03-19 18:16:49', 1, 2, '2026-03-19 18:16:49', NULL, '2026-03-19 18:16:49', NULL, 1, NULL);
INSERT INTO `app_results` VALUES ('69900dc9', '1773992584691', '执行异常', 0, 'Appium连接失败: HTTPConnectionPool(host=\'127.0.0.1\', port=4723): Max retries exceeded with url: /session (Caused by NewConnectionError(\"HTTPConnection(host=\'127.0.0.1\', port=4723): Failed to establish a new connection: [WinError 10061] 由于目标计算机积极拒绝，无法连接。\"))', '{}', '', '', '', '{\"cpu\": [0], \"time\": [\"43:52\"], \"memory\": [0], \"up_network\": [0], \"temperature\": [0], \"down_network\": [0]}', 2, '2026-03-20 15:43:54', 1, 3, '2026-03-20 15:43:54', NULL, '2026-03-20 15:43:54', NULL, 1, NULL);
INSERT INTO `app_results` VALUES ('69900dc9', '1773992584691', '执行结束', 0, '执行结束', '{}', '', '', '', '{\"cpu\": [0, 0], \"time\": [\"43:52\", \"43:54\"], \"memory\": [0, 0], \"up_network\": [0, 0], \"temperature\": [0, 0], \"down_network\": [0, 0]}', 2, '2026-03-20 15:43:54', 1, 4, '2026-03-20 15:43:54', NULL, '2026-03-20 15:43:54', NULL, 1, NULL);

-- ----------------------------
-- Table structure for app_scripts
-- ----------------------------
DROP TABLE IF EXISTS `app_scripts`;
CREATE TABLE `app_scripts`  (
  `script` json NOT NULL COMMENT '脚本',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `menu_id`(`menu_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `ix_app_scripts_id`(`id` ASC) USING BTREE,
  CONSTRAINT `app_scripts_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `app_menus` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app_scripts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'APP自动化脚本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_scripts
-- ----------------------------

-- ----------------------------
-- Table structure for apscheduler_jobs
-- ----------------------------
DROP TABLE IF EXISTS `apscheduler_jobs`;
CREATE TABLE `apscheduler_jobs`  (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `next_run_time` double NULL DEFAULT NULL,
  `job_state` blob NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_apscheduler_jobs_next_run_time`(`next_run_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of apscheduler_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for business_requirements
-- ----------------------------
DROP TABLE IF EXISTS `business_requirements`;
CREATE TABLE `business_requirements`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `analysis_id` bigint NOT NULL COMMENT '关联分析ID',
  `requirement_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求编号',
  `requirement_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求名称',
  `requirement_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求类型',
  `parent_requirement_id` bigint NULL DEFAULT NULL COMMENT '父级需求ID',
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属模块',
  `requirement_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求级别',
  `reviewer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'admin' COMMENT '评审人',
  `estimated_hours` int NULL DEFAULT 8 COMMENT '预计工时',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求描述',
  `acceptance_criteria` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '验收标准',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_analysis_req`(`analysis_id` ASC, `requirement_id` ASC) USING BTREE,
  INDEX `idx_analysis`(`analysis_id` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_requirement_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务需求表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of business_requirements
-- ----------------------------
INSERT INTO `business_requirements` VALUES (1, 2, 'REQ-001', '支持微信快捷登录', '功能需求', NULL, '用户认证', '高', 'admin', 8, '用户点击“快捷微信登录”按钮后，系统应调用微信授权接口，完成身份验证并成功登录系统，无需手动输入账号密码。', '当用户点击微信快捷登录按钮，系统跳转至微信授权页面，用户授权后能自动登录并进入系统主界面，且会话状态有效。', '2026-02-27 15:37:21', 1, '2026-02-27 15:37:21', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (2, 2, 'REQ-002', '支持Gitee快捷登录', '功能需求', NULL, '用户认证', '高', 'admin', 8, '用户点击“Gitee快捷登录”按钮后，系统应调用Gitee OAuth接口，完成身份验证并成功登录系统，无需手动输入账号密码。', '当用户点击Gitee快捷登录按钮，系统跳转至Gitee授权页面，用户授权后能自动登录并进入系统主界面，且会话状态有效。', '2026-02-27 15:37:21', 1, '2026-02-27 15:37:21', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (3, 3, 'REQ-01-01', 'Onboarding & Home Page - T&Cs / App Permissions', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现T&Cs / App Permissions的功能界面', '1. T&Cs / App Permissions界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (4, 3, 'REQ-01-02', 'Onboarding & Home Page - Connect to device', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Connect to device的功能界面', '1. Connect to device界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (5, 3, 'REQ-01-03', 'Onboarding & Home Page - Profile', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Profile的功能界面', '1. Profile界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (6, 3, 'REQ-01-04', 'Onboarding & Home Page - Dashboard (Home)', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Dashboard (Home)的功能界面', '1. Dashboard (Home)界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (7, 3, 'REQ-01-05', 'Onboarding & Home Page - Dashboard (Home) - No incidents reported', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Dashboard (Home) - No incidents reported的功能界面', '1. Dashboard (Home) - No incidents reported界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (8, 3, 'REQ-01-06', 'Onboarding & Home Page - Dashboard (Incident Onboarding)', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Dashboard (Incident Onboarding)的功能界面', '1. Dashboard (Incident Onboarding)界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (9, 3, 'REQ-01-07', 'Onboarding & Home Page - Report Incident 1', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 1的功能界面', '1. Report Incident 1界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (10, 3, 'REQ-01-08', 'Onboarding & Home Page - Report Incident 2', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 2的功能界面', '1. Report Incident 2界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (11, 3, 'REQ-01-09', 'Onboarding & Home Page - Report Incident 3', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 3的功能界面', '1. Report Incident 3界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (12, 3, 'REQ-01-10', 'Onboarding & Home Page - Report Incident 4', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 4的功能界面', '1. Report Incident 4界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (13, 3, 'REQ-01-11', 'Onboarding & Home Page - Report Incident 5', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 5的功能界面', '1. Report Incident 5界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (14, 3, 'REQ-01-12', 'Onboarding & Home Page - Report Incident 6', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident 6的功能界面', '1. Report Incident 6界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (15, 3, 'REQ-01-13', 'Onboarding & Home Page - Report Incident v2 1', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 1的功能界面', '1. Report Incident v2 1界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (16, 3, 'REQ-01-14', 'Onboarding & Home Page - Report Incident v2 2', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 2的功能界面', '1. Report Incident v2 2界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (17, 3, 'REQ-01-15', 'Onboarding & Home Page - Report Incident v2 3', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 3的功能界面', '1. Report Incident v2 3界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (18, 3, 'REQ-01-16', 'Onboarding & Home Page - Report Incident v2 5', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 5的功能界面', '1. Report Incident v2 5界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (19, 3, 'REQ-01-17', 'Onboarding & Home Page - Report Incident v2 6', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 6的功能界面', '1. Report Incident v2 6界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (20, 3, 'REQ-01-18', 'Onboarding & Home Page - Report Incident v2 4', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 4的功能界面', '1. Report Incident v2 4界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (21, 3, 'REQ-01-19', 'Onboarding & Home Page - Report Incident v2 7', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 7的功能界面', '1. Report Incident v2 7界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (22, 3, 'REQ-01-20', 'Onboarding & Home Page - Report Incident v2 Complete A', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 Complete A的功能界面', '1. Report Incident v2 Complete A界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (23, 3, 'REQ-01-21', 'Onboarding & Home Page - Report Incident v2 Complete B', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Report Incident v2 Complete B的功能界面', '1. Report Incident v2 Complete B界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (24, 3, 'REQ-01-22', 'Onboarding & Home Page - Welcome Splash', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Welcome Splash的功能界面', '1. Welcome Splash界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (25, 3, 'REQ-01-23', 'Onboarding & Home Page - Footage Browser', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Footage Browser的功能界面', '1. Footage Browser界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (26, 3, 'REQ-01-24', 'Onboarding & Home Page - Download Device Footage 4', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Download Device Footage 4的功能界面', '1. Download Device Footage 4界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (27, 3, 'REQ-01-25', 'Onboarding & Home Page - App Permissions Modal', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现App Permissions Modal的功能界面', '1. App Permissions Modal界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (28, 3, 'REQ-01-26', 'Onboarding & Home Page - Terms & Conditions Modal', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Terms & Conditions Modal的功能界面', '1. Terms & Conditions Modal界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (29, 3, 'REQ-01-27', 'Onboarding & Home Page - Dashboard (Device Updates)', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Dashboard (Device Updates)的功能界面', '1. Dashboard (Device Updates)界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (30, 3, 'REQ-01-28', 'Onboarding & Home Page - Dashboard (Device Updates)', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Dashboard (Device Updates)的功能界面', '1. Dashboard (Device Updates)界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (31, 3, 'REQ-01-29', 'Onboarding & Home Page - Download Device Footage 1', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Download Device Footage 1的功能界面', '1. Download Device Footage 1界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (32, 3, 'REQ-01-30', 'Onboarding & Home Page - Download Device Footage 2', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Download Device Footage 2的功能界面', '1. Download Device Footage 2界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (33, 3, 'REQ-01-31', 'Onboarding & Home Page - Download Device Footage 5', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Download Device Footage 5的功能界面', '1. Download Device Footage 5界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (34, 3, 'REQ-01-32', 'Onboarding & Home Page - Download Device Footage 3', '功能需求', NULL, 'Onboarding & Home Page', '中', 'admin', 8, '实现Download Device Footage 3的功能界面', '1. Download Device Footage 3界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (35, 3, 'REQ-02-01', '_Archive - Incidents Browser', '功能需求', NULL, '_Archive', '中', 'admin', 8, '实现Incidents Browser的功能界面', '1. Incidents Browser界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (36, 3, 'REQ-02-02', '_Archive - Report Incident 3', '功能需求', NULL, '_Archive', '中', 'admin', 8, '实现Report Incident 3的功能界面', '1. Report Incident 3界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (37, 3, 'REQ-02-03', '_Archive - Permissions', '功能需求', NULL, '_Archive', '中', 'admin', 8, '实现Permissions的功能界面', '1. Permissions界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (38, 3, 'REQ-03-01', '📦 Components - Frame 1', '功能需求', NULL, '📦 Components', '中', 'admin', 8, '实现Frame 1的功能界面', '1. Frame 1界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (39, 3, 'REQ-03-02', '📦 Components - Icons', '功能需求', NULL, '📦 Components', '中', 'admin', 8, '实现Icons的功能界面', '1. Icons界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (40, 3, 'REQ-03-03', '📦 Components - Categories', '功能需求', NULL, '📦 Components', '中', 'admin', 8, '实现Categories的功能界面', '1. Categories界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (41, 3, 'REQ-03-04', '📦 Components - Frame 5', '功能需求', NULL, '📦 Components', '中', 'admin', 8, '实现Frame 5的功能界面', '1. Frame 5界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (42, 3, 'REQ-03-05', '📦 Components - Fadeout', '功能需求', NULL, '📦 Components', '中', 'admin', 8, '实现Fadeout的功能界面', '1. Fadeout界面正常显示\n2. 界面元素布局正确', '2026-02-27 18:30:16', 1, '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (43, 5, 'REQ-01-01', 'Figma Basics - Thumbnail', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Thumbnail的功能界面', '1. Thumbnail界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (44, 5, 'REQ-01-02', 'Figma Basics - About this file', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现About this file的功能界面', '1. About this file界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (45, 5, 'REQ-01-03', 'Figma Basics - What\'s in this?', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现What\'s in this?的功能界面', '1. What\'s in this?界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (46, 5, 'REQ-01-04', 'Figma Basics - Practice designs', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Practice designs的功能界面', '1. Practice designs界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (47, 5, 'REQ-01-05', 'Figma Basics - Homepage', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Homepage的功能界面', '1. Homepage界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (48, 5, 'REQ-01-06', 'Figma Basics - Shopping cart', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Shopping cart的功能界面', '1. Shopping cart界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (49, 5, 'REQ-01-07', 'Figma Basics - Product page', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Product page的功能界面', '1. Product page界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:42:51', 1, '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (50, 6, 'REQ-01-01', 'Figma Basics - Thumbnail', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Thumbnail的功能界面', '1. Thumbnail界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (51, 6, 'REQ-01-02', 'Figma Basics - About this file', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现About this file的功能界面', '1. About this file界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (52, 6, 'REQ-01-03', 'Figma Basics - What\'s in this?', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现What\'s in this?的功能界面', '1. What\'s in this?界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (53, 6, 'REQ-01-04', 'Figma Basics - Practice designs', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Practice designs的功能界面', '1. Practice designs界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (54, 6, 'REQ-01-05', 'Figma Basics - Homepage', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Homepage的功能界面', '1. Homepage界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (55, 6, 'REQ-01-06', 'Figma Basics - Shopping cart', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Shopping cart的功能界面', '1. Shopping cart界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `business_requirements` VALUES (56, 6, 'REQ-01-07', 'Figma Basics - Product page', '功能需求', NULL, 'Figma Basics', '中', 'admin', 8, '实现Product page的功能界面', '1. Product page界面正常显示\n2. 界面元素布局正确', '2026-02-28 09:55:03', 1, '2026-02-28 09:55:03', 1, NULL, NULL);

-- ----------------------------
-- Table structure for celery_crontab_schedule
-- ----------------------------
DROP TABLE IF EXISTS `celery_crontab_schedule`;
CREATE TABLE `celery_crontab_schedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `minute` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '分钟',
  `hour` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '小时',
  `day_of_week` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '日期',
  `day_of_month` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '月份',
  `month_of_year` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '年',
  `timezone` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '时区',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of celery_crontab_schedule
-- ----------------------------

-- ----------------------------
-- Table structure for celery_interval_schedule
-- ----------------------------
DROP TABLE IF EXISTS `celery_interval_schedule`;
CREATE TABLE `celery_interval_schedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `every` int NULL DEFAULT NULL COMMENT '区间数',
  `period` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '间隔单位',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of celery_interval_schedule
-- ----------------------------

-- ----------------------------
-- Table structure for celery_periodic_task
-- ----------------------------
DROP TABLE IF EXISTS `celery_periodic_task`;
CREATE TABLE `celery_periodic_task`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '定时任务名',
  `task` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '任务路径',
  `args` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '参数',
  `kwargs` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '关键字参数',
  `queue` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '队列',
  `exchange` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '交换',
  `routing_key` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '路由密钥',
  `expires` datetime NULL DEFAULT NULL COMMENT '到期时间',
  `one_off` tinyint(1) NULL DEFAULT NULL COMMENT '执行一次',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `enabled` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '是否启用, 1启动，0停用',
  `last_run_at` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '上次运行时间',
  `total_run_count` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '运行总次数',
  `date_changed` datetime NULL DEFAULT NULL COMMENT '更改日期',
  `description` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注',
  `crontab_id` int NULL DEFAULT NULL COMMENT '定时器id',
  `crontab` int NULL DEFAULT NULL COMMENT 'crontab 表达式',
  `interval_id` int NULL DEFAULT NULL COMMENT '间隔id',
  `interval_every` int NULL DEFAULT NULL COMMENT '间隔时间',
  `interval_period` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '间隔类型',
  `task_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'crontab interval',
  `project_id` int NULL DEFAULT NULL COMMENT '项目id',
  `module_id` int NOT NULL COMMENT '模块id',
  `suite_id` int NOT NULL COMMENT '套件id',
  `case_env_id` int NOT NULL COMMENT 'case_env_id 用例环境',
  `case_ids` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用例集合',
  `ui_env_id` int NOT NULL COMMENT 'case_env_id 用例环境',
  `ui_ids` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ui用例集合',
  `script_ids` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '脚本id',
  `task_tags` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务标签',
  `remarks` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务描述',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of celery_periodic_task
-- ----------------------------

-- ----------------------------
-- Table structure for celery_periodic_task_changed
-- ----------------------------
DROP TABLE IF EXISTS `celery_periodic_task_changed`;
CREATE TABLE `celery_periodic_task_changed`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `last_update` datetime NULL DEFAULT NULL COMMENT '到期时间',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of celery_periodic_task_changed
-- ----------------------------

-- ----------------------------
-- Table structure for data_factory_records
-- ----------------------------
DROP TABLE IF EXISTS `data_factory_records`;
CREATE TABLE `data_factory_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tool_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '工具名称',
  `tool_category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '工具分类: test_data/json/string/encoding/random/encryption/crontab',
  `tool_scenario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用场景',
  `input_data` json NULL COMMENT '输入数据',
  `output_data` json NOT NULL COMMENT '输出数据',
  `is_saved` tinyint(1) NULL DEFAULT 1 COMMENT '是否保存',
  `tags` json NULL COMMENT '标签列表',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_created`(`user_id` ASC, `creation_date` ASC) USING BTREE,
  INDEX `idx_tool_name`(`tool_name` ASC) USING BTREE,
  INDEX `idx_tool_category`(`tool_category` ASC) USING BTREE,
  INDEX `idx_tool_scenario`(`tool_scenario` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE,
  INDEX `idx_enabled_flag`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据工厂使用记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of data_factory_records
-- ----------------------------
INSERT INTO `data_factory_records` VALUES (1, 1, 'random_password', 'random', 'random', '{}', '{\"count\": 1, \"length\": 12, \"result\": \"3#(hfQ1e_1cD\", \"success\": true, \"strength\": \"强\", \"char_types\": [\"uppercase\", \"lowercase\", \"digits\", \"special\"], \"charset_size\": 88}', 1, '[]', '2026-03-03 16:58:41', 1, '2026-03-03 16:58:41', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (2, 1, 'generate_chinese_phone', 'test_data', 'test_data', '{}', '{\"result\": \"15968358269\"}', 1, '[]', '2026-03-03 17:05:24', 1, '2026-03-03 17:05:24', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (3, 1, 'generate_company_name', 'test_data', 'test_data', '{}', '{\"result\": \"上海上汽科技有限公司\"}', 1, '[]', '2026-03-03 17:05:42', 1, '2026-03-03 17:05:42', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (4, 1, 'generate_bank_card', 'test_data', 'test_data', '{}', '{\"result\": \"6216423425753541482\"}', 1, '[]', '2026-03-03 17:21:18', 1, '2026-03-03 17:21:18', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (5, 1, 'generate_chinese_address', 'test_data', 'test_data', '{}', '{\"result\": \"山西省深圳市中区和平路500号20单元723室\"}', 1, '[]', '2026-03-03 17:21:40', 1, '2026-03-03 17:21:40', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (6, 1, 'aes_decrypt', 'encryption', 'encryption', '{}', '{\"note\": \"这是简化实现，生产环境请使用专业加密库\", \"success\": true, \"algorithm\": \"AES-CBC\", \"decrypted\": \"\", \"encrypted\": \"\", \"key_length\": 256}', 1, '[]', '2026-03-03 17:21:47', 1, '2026-03-03 17:21:47', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (7, 1, 'generate_barcode', 'encoding', 'encoding', '{\"text\": \"4665546546544\", \"barcode_type\": \"code128\", \"save_to_static\": true}', '{\"url\": \"/static/image/barcode_1772529743_e2d91398_code128.png\", \"data\": \"4665546546544\", \"success\": true, \"filename\": \"barcode_1772529743_e2d91398_code128.png\", \"filepath\": \"E:\\\\Fastapi\\\\vue-fastapi-admin\\\\backend\\\\app\\\\static\\\\image\\\\barcode_1772529743_e2d91398_code128\", \"barcode_type\": \"code128\"}', 1, '[]', '2026-03-03 17:22:23', 1, '2026-03-03 17:22:23', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (8, 1, 'generate_qrcode', 'encoding', 'encoding', '{\"text\": \"4665546546544\", \"barcode_type\": \"code128\", \"save_to_static\": true}', '{\"url\": \"/static/image/qrcode_1772529748_35ded344_300px.png\", \"data\": \"4665546546544\", \"success\": true, \"filename\": \"qrcode_1772529748_35ded344_300px.png\", \"filepath\": \"E:\\\\Fastapi\\\\vue-fastapi-admin\\\\backend\\\\app\\\\static\\\\image\\\\qrcode_1772529748_35ded344_300px.png\", \"image_size\": 300}', 1, '[]', '2026-03-03 17:22:28', 1, '2026-03-03 17:22:28', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (9, 1, 'escape_string', 'string', 'string', '{\"text\": \"465464\", \"escape_type\": \"json\"}', '{\"result\": \"\\\"465464\\\"\"}', 1, '[]', '2026-03-03 17:22:52', 1, '2026-03-03 17:22:52', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (10, 1, 'validate_json', 'json', 'json', '{\"json_str\": \"456464\"}', '{\"size\": 6, \"valid\": true, \"message\": \"JSON格式正确\", \"success\": true, \"data_type\": \"int\", \"structure\": {\"type\": \"int\", \"depth\": 0, \"value\": \"456464\"}}', 1, '[]', '2026-03-03 17:23:14', 1, '2026-03-03 17:23:14', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (11, 1, 'generate_expression', 'crontab', 'crontab', '{}', '{\"fields\": {\"day\": \"*\", \"hour\": \"*\", \"month\": \"*\", \"minute\": \"*\", \"weekday\": \"*\"}, \"success\": true, \"next_runs\": [{\"weekday\": \"Tuesday\", \"datetime\": \"2026-03-03 17:24:00\", \"relative\": \"即将执行\", \"timestamp\": 1772529840}, {\"weekday\": \"Tuesday\", \"datetime\": \"2026-03-03 17:25:00\", \"relative\": \"1分钟后\", \"timestamp\": 1772529900}, {\"weekday\": \"Tuesday\", \"datetime\": \"2026-03-03 17:26:00\", \"relative\": \"2分钟后\", \"timestamp\": 1772529960}, {\"weekday\": \"Tuesday\", \"datetime\": \"2026-03-03 17:27:00\", \"relative\": \"3分钟后\", \"timestamp\": 1772530020}, {\"weekday\": \"Tuesday\", \"datetime\": \"2026-03-03 17:28:00\", \"relative\": \"4分钟后\", \"timestamp\": 1772530080}], \"expression\": \"* * * * *\", \"description\": \"每分钟执行\"}', 1, '[]', '2026-03-03 17:23:31', 1, '2026-03-03 17:23:31', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (12, 1, 'validate_json', 'json', 'json', '{\"json_str\": \"9879879\"}', '{\"size\": 7, \"valid\": true, \"message\": \"JSON格式正确\", \"success\": true, \"data_type\": \"int\", \"structure\": {\"type\": \"int\", \"depth\": 0, \"value\": \"9879879\"}}', 1, '[]', '2026-03-03 17:25:24', 1, '2026-03-03 17:25:24', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (13, 1, 'validate_json', 'json', 'json', '{\"json_str\": \"9879879\"}', '{\"size\": 7, \"valid\": true, \"message\": \"JSON格式正确\", \"success\": true, \"data_type\": \"int\", \"structure\": {\"type\": \"int\", \"depth\": 0, \"value\": \"9879879\"}}', 1, '[]', '2026-03-03 17:25:42', 1, '2026-03-03 17:36:11', 1, 0, NULL);
INSERT INTO `data_factory_records` VALUES (14, 1, 'word_count', 'string', 'string', '{}', '{\"count\": 4, \"results\": [{\"lines\": 1, \"numbers\": 0, \"paragraphs\": 0, \"punctuation\": 0, \"total_length\": 0, \"chinese_chars\": 0, \"english_words\": 0}, {\"lines\": 1, \"numbers\": 0, \"paragraphs\": 0, \"punctuation\": 0, \"total_length\": 0, \"chinese_chars\": 0, \"english_words\": 0}, {\"lines\": 1, \"numbers\": 0, \"paragraphs\": 0, \"punctuation\": 0, \"total_length\": 0, \"chinese_chars\": 0, \"english_words\": 0}, {\"lines\": 1, \"numbers\": 0, \"paragraphs\": 0, \"punctuation\": 0, \"total_length\": 0, \"chinese_chars\": 0, \"english_words\": 0}]}', 1, 'null', '2026-03-03 17:38:08', 1, '2026-03-03 17:38:08', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (20, 1, 'generate_company_name', 'test_data', 'test_data', '{}', '{\"result\": \"美的有限公司\"}', 1, '[]', '2026-03-04 09:21:58', 1, '2026-03-04 09:21:58', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (21, 1, 'generate_company_name', 'test_data', 'test_data', '{}', '{\"result\": \"南京海尔股份有限公司\"}', 1, '[]', '2026-03-04 09:22:04', 1, '2026-03-04 09:22:04', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (22, 1, 'generate_company_name', 'test_data', 'test_data', '{\"count\": 1, \"company_type\": \"tech\"}', '{\"result\": \"去哪儿tech\"}', 1, '[\"nihao \"]', '2026-03-04 09:22:30', 1, '2026-03-04 09:22:30', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (23, 1, 'replace_string', 'string', 'string', '{}', '{\"result\": \"\", \"replacements\": 1}', 1, 'null', '2026-03-04 09:50:07', 1, '2026-03-04 09:50:07', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (24, 1, 'md5_hash', 'encryption', 'encryption', '{\"text\": \"123\", \"encoding\": \"hex\", \"output_format\": \"hex\"}', '{\"hash\": \"202cb962ac59075b964b07152d234b70\", \"length\": 32, \"success\": true, \"encoding\": \"utf-8\", \"original\": \"123\", \"algorithm\": \"MD5\", \"hash_upper\": \"202CB962AC59075B964B07152D234B70\"}', 1, 'null', '2026-03-04 09:50:56', 1, '2026-03-04 09:50:56', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (25, 1, 'generate_chinese_name', 'test_data', 'test_data', '{}', '{\"result\": \"张蕊\"}', 1, 'null', '2026-03-08 13:48:21', 1, '2026-03-08 13:48:21', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (26, 1, 'generate_chinese_email', 'test_data', 'test_data', '{}', '{\"result\": \"5l5njrocy5@hotmail.com\"}', 1, 'null', '2026-03-08 13:49:56', 1, '2026-03-08 13:49:56', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (27, 1, 'generate_chinese_name', 'test_data', 'test_data', '{}', '{\"result\": \"高萍敏\"}', 1, 'null', '2026-03-08 13:56:40', 1, '2026-03-08 13:56:40', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (28, 1, 'generate_bank_card', 'test_data', 'test_data', '{}', '{\"result\": \"6222385908013642264\"}', 1, 'null', '2026-03-08 13:57:21', 1, '2026-03-08 13:57:21', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (29, 1, 'generate_hk_id_card', 'test_data', 'test_data', '{}', '{\"result\": \"R722487(6)\"}', 1, 'null', '2026-03-08 13:57:35', 1, '2026-03-08 13:57:35', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (30, 1, 'generate_user_profile', 'test_data', 'test_data', '{}', '{\"result\": {\"age\": 29, \"job\": \"销售经理\", \"name\": \"魏雨\", \"email\": \"ei5mu6iyqa@139.com\", \"phone\": \"18043759027\", \"gender\": \"女\", \"address\": \"上海市上海市中区中山路757号16单元1882室\", \"company\": \"深圳携程股份有限公司\", \"id_card\": \"440306199809200670\", \"birthday\": \"1997-10-11\"}}', 1, 'null', '2026-03-08 13:57:43', 1, '2026-03-08 13:57:43', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (31, 1, 'word_count', 'string', 'string', '{\"text\": \"546546465\"}', '{\"lines\": 1, \"numbers\": 1, \"paragraphs\": 1, \"punctuation\": 0, \"total_length\": 9, \"chinese_chars\": 0, \"english_words\": 0}', 1, 'null', '2026-03-08 13:58:40', 1, '2026-03-08 13:58:40', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (32, 1, 'random_uuid', 'random', 'random', '{}', '{\"count\": 1, \"format\": \"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\", \"result\": \"52820e8e-2b0f-4d17-8dc5-6be672414a32\", \"success\": true, \"version\": 4}', 1, 'null', '2026-03-08 14:06:05', 1, '2026-03-08 14:06:05', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (33, 1, 'generate_business_license', 'test_data', 'test_data', '{}', '{\"result\": \"91500000WKH4K78KL\"}', 1, 'null', '2026-03-08 14:06:33', 1, '2026-03-08 14:06:33', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (34, 1, 'generate_id_card', 'test_data', 'test_data', '{}', '{\"result\": \"310109195907273786\"}', 1, 'null', '2026-03-08 14:06:47', 1, '2026-03-08 14:06:47', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (35, 1, 'generate_id_card', 'test_data', 'test_data', '{}', '{\"result\": \"110102197910045511\"}', 1, 'null', '2026-03-08 14:07:18', 1, '2026-03-08 14:07:18', 1, 1, NULL);
INSERT INTO `data_factory_records` VALUES (36, 1, 'generate_chinese_name', 'test_data', 'test_data', '{\"count\": 5, \"gender\": \"all\"}', '{\"count\": 5, \"result\": [\"苏玲\", \"吴兰\", \"傅娟\", \"赵学\", \"徐倩\"]}', 1, 'null', '2026-03-08 14:07:36', 1, '2026-03-08 14:07:36', 1, 1, NULL);

-- ----------------------------
-- Table structure for figma_api_call_logs
-- ----------------------------
DROP TABLE IF EXISTS `figma_api_call_logs`;
CREATE TABLE `figma_api_call_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_id` int NOT NULL COMMENT 'Figma配置ID',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'API端点',
  `call_time` datetime NOT NULL COMMENT '调用时间',
  `status_code` int NULL DEFAULT NULL COMMENT 'HTTP状态码',
  `response_time` int NULL DEFAULT NULL COMMENT '响应时间(ms)',
  `is_rate_limited` tinyint NULL DEFAULT 0 COMMENT '是否触发限制',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_config_time`(`config_id` ASC, `call_time` ASC) USING BTREE,
  INDEX `idx_call_time`(`call_time` ASC) USING BTREE,
  INDEX `idx_status_code`(`status_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Figma API调用日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of figma_api_call_logs
-- ----------------------------
INSERT INTO `figma_api_call_logs` VALUES (1, 3, '/files/QhPUNibpjsR5IPthH0rUd4', '2026-02-28 09:55:03', 200, 2927, 0, 1, '2026-02-28 09:55:03', '2026-02-28 09:55:03', 1, NULL, NULL);
INSERT INTO `figma_api_call_logs` VALUES (2, 3, '/files/QhPUNibpjsR5IPthH0rUd4', '2026-02-28 10:06:36', 429, 1429, 1, 1, '2026-02-28 10:06:36', '2026-02-28 10:06:36', 1, NULL, NULL);

-- ----------------------------
-- Table structure for figma_configs
-- ----------------------------
DROP TABLE IF EXISTS `figma_configs`;
CREATE TABLE `figma_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `access_token` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Figma Access Token（公开文件可选）',
  `file_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Figma文件ID',
  `file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名称',
  `file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'Figma文件URL',
  `last_sync_time` datetime NULL DEFAULT NULL COMMENT '最后同步时间',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  `has_updates` tinyint NULL DEFAULT 0 COMMENT '是否有更新',
  `last_modified_time` datetime NULL DEFAULT NULL COMMENT 'Figma文件最后修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_file_key`(`file_key` ASC) USING BTREE,
  INDEX `idx_enabled_flag`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Figma配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of figma_configs
-- ----------------------------
INSERT INTO `figma_configs` VALUES (2, 14, 'figd_AY8DXdVZqUMNC_hkO7acHBpyL6x2tz-LwAAaGLJJ', '7GwOMtipf9FTsq8XW5lClx', '000', 'https://www.figma.com/proto/7GwOMtipf9FTsq8XW5lClx/Truevisia?node-id=4-10474&t=R0F60A200gEkcEGg-1&show-proto-sidebar=1&starting-point-node-id=4%3A10474', '2026-02-27 18:30:17', '2026-02-27 17:44:57', 1, '2026-02-28 10:04:07', NULL, 0, NULL, 1, NULL);
INSERT INTO `figma_configs` VALUES (3, 16, 'figd_AY8DXdVZqUMNC_hkO7acHBpyL6x2tz-LwAAaGLJJ', 'QhPUNibpjsR5IPthH0rUd4', NULL, 'https://www.figma.com/design/QhPUNibpjsR5IPthH0rUd4/Figma-basics?node-id=1669-162202&p=f&t=oq2gl8rgOFaxQQwx-0', '2026-02-28 09:55:04', '2026-02-28 09:40:51', 1, '2026-03-30 18:31:18', NULL, 0, NULL, 1, NULL);

-- ----------------------------
-- Table structure for figma_extraction_tasks
-- ----------------------------
DROP TABLE IF EXISTS `figma_extraction_tasks`;
CREATE TABLE `figma_extraction_tasks`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务ID（UUID）',
  `config_id` bigint NOT NULL COMMENT '关联Figma配置ID',
  `extraction_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'simple' COMMENT '提取模式: simple/complete',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '状态: pending/processing/completed/failed',
  `progress` int NULL DEFAULT 0 COMMENT '进度百分比(0-100)',
  `current_step` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前步骤描述',
  `total_frames` int NULL DEFAULT 0 COMMENT '总Frame数',
  `processed_frames` int NULL DEFAULT 0 COMMENT '已处理Frame数',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `result_document_id` bigint NULL DEFAULT NULL COMMENT '结果文档ID',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_config_id`(`config_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled_flag`(`enabled_flag` ASC) USING BTREE,
  CONSTRAINT `figma_extraction_tasks_ibfk_1` FOREIGN KEY (`config_id`) REFERENCES `figma_configs` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Figma提取任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of figma_extraction_tasks
-- ----------------------------
INSERT INTO `figma_extraction_tasks` VALUES (1, 'd9ab315d-a48c-4ed4-a67a-a3f03d39cf34', 2, 'simple', 'failed', 20, '获取文件数据...', 0, 0, 'Figma API调用频率超限，请稍后再试。\n\n原因：短时间内调用次数过多\n解决：等待1-2分钟后重试\n\n提示：如果刚刚已经提取成功，可以直接在\'需求文档管理\'中查看结果，无需重复提取', NULL, '2026-02-27 20:13:38', '2026-02-27 20:13:40', '2026-02-27 20:13:37', 1, '2026-02-27 20:13:40', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (2, '81ae8781-bfcc-4e31-9292-ab92dc6f1c40', 2, 'simple', 'failed', 20, '获取文件数据...', 0, 0, 'Figma API调用频率超限，请稍后再试。\n\n原因：短时间内调用次数过多\n解决：等待1-2分钟后重试\n\n💡 建议：\n1. 使用\'离线查看\'功能查看缓存数据\n2. 使用\'快速提取\'模式（只调用1次API）\n3. 避免频繁提取同一文件', NULL, '2026-02-28 09:26:34', '2026-02-28 09:26:37', '2026-02-28 09:26:34', 1, '2026-02-28 09:26:37', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (3, '577f1e22-ca8f-4f8a-bdf0-4b57a95d3601', 2, 'simple', 'failed', 20, '获取文件数据...', 0, 0, 'Figma API调用频率超限，请稍后再试。\n\n原因：短时间内调用次数过多\n解决：等待1-2分钟后重试\n\n💡 建议：\n1. 使用\'离线查看\'功能查看缓存数据\n2. 使用\'快速提取\'模式（只调用1次API）\n3. 避免频繁提取同一文件', NULL, '2026-02-28 09:33:35', '2026-02-28 09:33:39', '2026-02-28 09:33:35', 1, '2026-02-28 09:33:38', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (4, '47f2562f-3ab9-47f2-8d57-6044cbcf52c7', 3, 'simple', 'failed', 20, '获取文件数据...', 0, 0, '该Figma文件需要Access Token才能访问。\n\n原型链接（/proto/）虽然可以在浏览器中查看，但API访问需要Token。\n\n获取Token步骤：\n1. 访问 https://www.figma.com/settings\n2. 找到 \'Personal access tokens\'\n3. 点击 \'Generate new token\'\n4. 复制生成的Token\n5. 在配置中填写Token后重试\n\n注：免费Figma账号即可生成Token，无需付费', NULL, '2026-02-28 09:40:57', '2026-02-28 09:40:59', '2026-02-28 09:40:56', 1, '2026-02-28 09:40:58', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (5, '6779f9fa-9c8d-4fc2-a9be-5a1e9f391d92', 3, 'simple', 'completed', 100, '提取完成', 7, 0, NULL, 10, '2026-02-28 09:42:49', '2026-02-28 09:42:52', '2026-02-28 09:42:48', 1, '2026-02-28 09:42:51', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (6, 'b31150a4-6d5a-4b3d-865c-17d63d36d985', 3, 'simple', 'completed', 100, '提取完成', 7, 0, NULL, 11, '2026-02-28 09:55:00', '2026-02-28 09:55:04', '2026-02-28 09:54:59', 1, '2026-02-28 09:55:03', NULL, 1, NULL);
INSERT INTO `figma_extraction_tasks` VALUES (7, '151f37b8-cdad-4825-accc-4d110bb19d40', 3, 'simple', 'failed', 20, '获取文件数据...', 0, 0, 'Figma API调用频率超限，请稍后再试。\n\n原因：短时间内调用次数过多\n解决：等待1-2分钟后重试\n\n💡 建议：\n1. 使用\'离线查看\'功能查看缓存数据\n2. 使用\'快速提取\'模式（只调用1次API）\n3. 避免频繁提取同一文件', NULL, '2026-02-28 10:06:34', '2026-02-28 10:06:36', '2026-02-28 10:06:34', 1, '2026-02-28 10:06:36', NULL, 1, NULL);

-- ----------------------------
-- Table structure for figma_file_cache
-- ----------------------------
DROP TABLE IF EXISTS `figma_file_cache`;
CREATE TABLE `figma_file_cache`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_id` int NOT NULL COMMENT 'Figma配置ID',
  `file_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件ID',
  `file_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件数据(JSON)',
  `file_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件版本',
  `last_modified` datetime NULL DEFAULT NULL COMMENT 'Figma文件最后修改时间',
  `cache_time` datetime NOT NULL COMMENT '缓存时间',
  `cache_size` int NULL DEFAULT NULL COMMENT '缓存大小(bytes)',
  `hit_count` int NULL DEFAULT 0 COMMENT '命中次数',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_file_key`(`file_key` ASC) USING BTREE,
  INDEX `idx_config_id`(`config_id` ASC) USING BTREE,
  INDEX `idx_cache_time`(`cache_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Figma文件缓存' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of figma_file_cache
-- ----------------------------

-- ----------------------------
-- Table structure for file_info
-- ----------------------------
DROP TABLE IF EXISTS `file_info`;
CREATE TABLE `file_info`  (
  `id` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '存储的文件名',
  `file_path` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `extend_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '扩展名称',
  `original_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '原名称',
  `content_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  `file_size` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '文件大小',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_file_info_extend_name`(`extend_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_info
-- ----------------------------
INSERT INTO `file_info` VALUES ('304c88de1d264f1ea7465647bf8322f6', 'F829780D700F4BF0AA5B0DCFA034A3C2.jpg', 'E:\\Fastapi\\vue-fastapi-admin\\files\\F829780D700F4BF0AA5B0DCFA034A3C2.jpg', 'jpg', '-6-DCMQ5wwoxwOqF6lMIUb6iQNrxTmwA-FZVAcW30-c92faX8g0k5ubYfWaN-I9A.jpg', 'image/jpeg', '186.34', '2026-01-30 16:35:33', NULL, '2026-01-30 16:35:36', 1, 0, NULL);

-- ----------------------------
-- Table structure for generated_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `generated_test_cases`;
CREATE TABLE `generated_test_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requirement_id` bigint NOT NULL COMMENT '关联需求ID',
  `case_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例编号',
  `title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例标题',
  `priority` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优先级: P0/P1/P2/P3',
  `precondition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '前置条件',
  `test_steps` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '测试步骤',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '预期结果',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'generated' COMMENT '状态',
  `generated_by_ai` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'AI-A' COMMENT '生成AI模型',
  `reviewed_by_ai` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评审AI模型',
  `review_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评审意见',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_req_case`(`requirement_id` ASC, `case_id` ASC) USING BTREE,
  INDEX `idx_requirement`(`requirement_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI生成测试用例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of generated_test_cases
-- ----------------------------

-- ----------------------------
-- Table structure for generation_configs
-- ----------------------------
DROP TABLE IF EXISTS `generation_configs`;
CREATE TABLE `generation_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '默认生成配置' COMMENT '配置名称',
  `default_output_mode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'stream' COMMENT '默认输出模式',
  `enable_auto_review` tinyint(1) NULL DEFAULT 1 COMMENT '启用AI评审和改进',
  `review_timeout` int NULL DEFAULT 120 COMMENT '评审和改进超时时间（秒）',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '生成行为配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of generation_configs
-- ----------------------------

-- ----------------------------
-- Table structure for legacy_module_info
-- ----------------------------
DROP TABLE IF EXISTS `legacy_module_info`;
CREATE TABLE `legacy_module_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '模块名称',
  `project_id` int NOT NULL COMMENT '所属项目ID',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '模块描述',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of legacy_module_info
-- ----------------------------

-- ----------------------------
-- Table structure for legacy_msg_notices
-- ----------------------------
DROP TABLE IF EXISTS `legacy_msg_notices`;
CREATE TABLE `legacy_msg_notices`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知名称',
  `type` int NOT NULL COMMENT '通知类型: 1-邮件, 2-钉钉, 3-企业微信, 4-飞书',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知地址/Webhook',
  `status` int NOT NULL COMMENT '通知状态: 0-停用, 1-启用',
  `script` json NULL COMMENT '通知脚本配置',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知描述',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msg_notices_type`(`type` ASC) USING BTREE,
  INDEX `idx_msg_notices_status`(`status` ASC) USING BTREE,
  INDEX `idx_msg_notices_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '旧定时任务-消息通知配置表（legacy_msg_notices）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of legacy_msg_notices
-- ----------------------------

-- ----------------------------
-- Table structure for legacy_scheduler_tasks
-- ----------------------------
DROP TABLE IF EXISTS `legacy_scheduler_tasks`;
CREATE TABLE `legacy_scheduler_tasks`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `type` int NOT NULL COMMENT '任务类型: 1-APP自动化, 2-Web UI自动化, 3-接口自动化',
  `status` int NOT NULL COMMENT '任务状态: 0-停用, 1-启用',
  `script` json NULL COMMENT '任务脚本配置',
  `time` json NULL COMMENT '时间配置',
  `notice` json NULL COMMENT '通知配置',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务描述',
  `scheduler_job_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '调度器任务ID',
  `last_run_at` datetime NULL DEFAULT NULL COMMENT '上次运行时间',
  `next_run_at` datetime NULL DEFAULT NULL COMMENT '下次运行时间',
  `total_run_count` int NOT NULL DEFAULT 0 COMMENT '总运行次数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scheduler_tasks_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_scheduler_tasks_status`(`status` ASC) USING BTREE,
  INDEX `idx_scheduler_tasks_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务表（兼容旧架构 legacy_scheduler_tasks）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of legacy_scheduler_tasks
-- ----------------------------
INSERT INTO `legacy_scheduler_tasks` VALUES (1, '2026-03-13 11:50:51', 1, '2026-03-13 11:50:51', 1, 1, NULL, '999', 3, 1, '{\"width\": 1920, \"device\": [], \"env_id\": null, \"height\": 1080, \"browser\": [], \"params_id\": null, \"api_script_list\": [1], \"app_script_list\": [], \"web_script_list\": []}', '{\"type\": 1, \"interval\": 1, \"run_time\": \"yyyy-03-Fr 11:50:49\", \"week_date\": [], \"week_run_time\": \"\"}', '{\"status\": 0, \"notice_id\": null}', '99', NULL, NULL, NULL, 0);
INSERT INTO `legacy_scheduler_tasks` VALUES (2, '2026-03-13 11:51:14', 1, '2026-03-13 11:51:14', 1, 1, NULL, '999', 3, 1, '{\"width\": 1920, \"device\": [], \"env_id\": null, \"height\": 1080, \"browser\": [], \"params_id\": null, \"api_script_list\": [1], \"app_script_list\": [], \"web_script_list\": []}', '{\"type\": 1, \"interval\": 1, \"run_time\": \"yyyy-03-Fr 11:50:49\", \"week_date\": [], \"week_run_time\": \"\"}', '{\"status\": 1, \"notice_id\": null}', '99', NULL, NULL, NULL, 0);
INSERT INTO `legacy_scheduler_tasks` VALUES (3, '2026-03-13 11:51:23', 1, '2026-03-13 11:51:23', 1, 1, NULL, '999', 3, 1, '{\"width\": 1920, \"device\": [], \"env_id\": null, \"height\": 1080, \"browser\": [], \"params_id\": null, \"api_script_list\": [1], \"app_script_list\": [], \"web_script_list\": []}', '{\"type\": 1, \"interval\": 1, \"run_time\": \"yyyy-03-Fr 11:50:49\", \"week_date\": [], \"week_run_time\": \"\"}', '{\"status\": 1, \"notice_id\": null}', '99', NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for legacy_task_execution_histories
-- ----------------------------
DROP TABLE IF EXISTS `legacy_task_execution_histories`;
CREATE TABLE `legacy_task_execution_histories`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `execution_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行状态: success/failed/running/timeout',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长(秒)',
  `result` json NULL COMMENT '执行结果',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `trigger_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '触发类型: scheduled/manual',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_histories_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_task_histories_status`(`status` ASC) USING BTREE,
  INDEX `idx_task_histories_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务执行历史表（legacy_task_execution_histories）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of legacy_task_execution_histories
-- ----------------------------

-- ----------------------------
-- Table structure for legacy_task_notification_logs
-- ----------------------------
DROP TABLE IF EXISTS `legacy_task_notification_logs`;
CREATE TABLE `legacy_task_notification_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `execution_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行ID',
  `notice_id` bigint NOT NULL COMMENT '通知配置ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知状态: success/failed',
  `send_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `response` json NULL COMMENT '通知响应',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_notify_logs_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_task_notify_logs_notice`(`notice_id` ASC) USING BTREE,
  INDEX `idx_task_notify_logs_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务通知日志表（legacy_task_notification_logs）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of legacy_task_notification_logs
-- ----------------------------

-- ----------------------------
-- Table structure for menu_view_history
-- ----------------------------
DROP TABLE IF EXISTS `menu_view_history`;
CREATE TABLE `menu_view_history`  (
  `menu_id` int NULL DEFAULT NULL COMMENT '菜单id',
  `remote_addr` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '访问ip',
  `user_id` int NULL DEFAULT NULL COMMENT '访问人',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_menu_view_history_remote_addr`(`remote_addr` ASC) USING BTREE,
  INDEX `ix_menu_view_history_user_id`(`user_id` ASC) USING BTREE,
  INDEX `ix_menu_view_history_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menu_view_history
-- ----------------------------

-- ----------------------------
-- Table structure for module_info
-- ----------------------------
DROP TABLE IF EXISTS `module_info`;
CREATE TABLE `module_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '模块名称',
  `project_id` int NOT NULL COMMENT '所属项目ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父模块ID',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '模块描述',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序顺序',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_module_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of module_info
-- ----------------------------
INSERT INTO `module_info` VALUES (1, '默认模块', 1, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 1, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (2, '默认模块', 2, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 2, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (3, '默认模块', 3, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 3, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (4, '默认模块', 4, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 4, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (5, '默认模块', 5, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 5, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (6, '默认模块', 6, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 6, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (7, '默认模块', 7, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 7, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (8, '默认模块', 13, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 8, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (9, '默认模块', 14, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 9, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (10, '默认模块', 15, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 10, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (11, '默认模块', 16, NULL, '系统自动创建的默认模块，用于存放未分类的测试用例', 11, '2026-02-26 13:50:58', 1, NULL, NULL, 1, NULL);
INSERT INTO `module_info` VALUES (12, '??????', 1, NULL, '??????', 12, '2026-02-26 14:15:13', 1, '2026-02-26 17:47:19', 1, 0, NULL);
INSERT INTO `module_info` VALUES (13, 'Test Delete Module', 1, NULL, 'To be deleted', 13, '2026-02-26 14:16:17', 1, '2026-02-26 14:16:17', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (14, '999', 15, NULL, '', 14, '2026-02-26 14:33:25', 1, '2026-02-26 16:40:58', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (15, '00', 16, NULL, '', 15, '2026-02-26 14:41:07', 1, '2026-02-26 14:58:33', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (16, '00000', 16, NULL, '', 16, '2026-02-26 14:41:11', 1, '2026-02-26 16:51:20', 1, 0, NULL);
INSERT INTO `module_info` VALUES (17, '00009999', 16, NULL, '', 17, '2026-02-26 14:41:20', 1, '2026-02-26 16:45:26', 1, 0, NULL);
INSERT INTO `module_info` VALUES (18, '99', 16, 16, '', 0, '2026-02-26 16:45:09', 1, '2026-02-26 16:51:17', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (19, '99999757657', 16, 18, '', 0, '2026-02-26 16:45:53', 1, '2026-02-26 16:51:15', 1, 0, NULL);
INSERT INTO `module_info` VALUES (20, '00你好', 16, 19, '', 0, '2026-02-26 16:48:44', 1, '2026-02-26 16:51:12', 1, 0, NULL);
INSERT INTO `module_info` VALUES (21, '0', 16, 20, '', 0, '2026-02-26 16:48:57', 1, '2026-02-26 16:51:09', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (22, '00', 16, NULL, '', 0, '2026-02-26 16:50:37', 1, '2026-02-26 16:51:23', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (23, '00你好', 16, NULL, '', 0, '2026-02-26 17:02:13', 1, '2026-02-26 17:21:04', 1, 0, NULL);
INSERT INTO `module_info` VALUES (24, '你好是不是', 16, NULL, '', 0, '2026-02-26 17:04:27', 1, '2026-02-26 17:21:09', 1, 0, NULL);
INSERT INTO `module_info` VALUES (25, '登录模块', 16, NULL, '', 0, '2026-02-26 17:05:25', 1, '2026-02-26 17:21:00', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (26, '登录子模块', 16, 25, '', 0, '2026-02-26 17:05:33', 1, '2026-02-26 17:20:57', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (27, '耳机', 16, 26, '', 0, '2026-02-26 17:06:05', 1, '2026-02-26 17:20:54', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (28, '66', 16, 27, '', 0, '2026-02-26 17:06:12', 1, '2026-02-26 17:20:52', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (29, '666', 16, 28, '', 0, '2026-02-26 17:06:16', 1, '2026-02-26 17:20:49', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (30, '6666666', 16, 24, '', 0, '2026-02-26 17:06:33', 1, '2026-02-26 17:21:07', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (31, '00', 16, 11, '', 0, '2026-02-26 17:21:39', 1, '2026-02-26 17:25:30', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (32, '000', 16, 31, '', 0, '2026-02-26 17:21:45', 1, '2026-02-26 17:25:27', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (33, '000000', 16, NULL, '', 0, '2026-02-26 17:21:50', 1, '2026-02-26 17:22:09', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (34, '测试', 16, NULL, '', 0, '2026-02-26 17:22:16', 1, '2026-02-26 17:25:22', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (35, '测试1', 16, 34, '', 0, '2026-02-26 17:22:27', 1, '2026-02-26 17:25:18', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (36, '00', 16, NULL, '', 0, '2026-02-26 17:25:35', 1, '2026-02-26 17:25:55', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (37, '000', 16, 36, '', 0, '2026-02-26 17:25:39', 1, '2026-02-26 17:25:52', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (38, '00', 16, NULL, '', 0, '2026-02-26 17:25:59', 1, '2026-02-26 17:27:38', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (39, '000', 16, 38, '', 0, '2026-02-26 17:26:06', 1, '2026-02-26 17:27:36', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (40, '99', 16, NULL, '', 0, '2026-02-26 17:27:42', 1, '2026-02-26 17:28:13', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (41, '00', 16, 40, '', 0, '2026-02-26 17:27:47', 1, '2026-02-26 17:28:11', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (42, '88', 16, NULL, '', 0, '2026-02-26 17:28:20', 1, '2026-02-26 17:30:08', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (43, '99', 16, 42, '', 0, '2026-02-26 17:28:24', 1, '2026-02-26 17:30:06', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (44, '00', 16, NULL, '', 0, '2026-02-26 17:30:30', 1, '2026-02-26 17:32:27', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (45, '88', 16, 44, '', 0, '2026-02-26 17:30:36', 1, '2026-02-26 17:32:24', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (46, '00', 16, NULL, '', 0, '2026-02-26 17:32:32', 1, '2026-02-26 17:34:19', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (47, '9900', 16, 46, '', 0, '2026-02-26 17:32:38', 1, '2026-02-26 17:34:17', 1, 0, NULL);
INSERT INTO `module_info` VALUES (48, '99', 16, NULL, '', 0, '2026-02-26 17:34:24', 1, '2026-02-26 17:37:40', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (49, '999', 16, 48, '', 0, '2026-02-26 17:34:28', 1, '2026-02-26 17:37:36', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (50, '9999', 16, 48, '', 0, '2026-02-26 17:34:39', 1, '2026-02-26 17:37:38', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (51, '00', 16, NULL, '', 0, '2026-02-26 17:37:44', 1, '2026-03-23 09:09:17', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (52, '88', 16, 51, '', 0, '2026-02-26 17:37:48', 1, '2026-03-23 09:09:15', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (53, '000', 16, 52, '', 0, '2026-02-26 17:37:53', 1, '2026-03-23 09:09:12', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (54, '0000000000000000099888', 16, 53, '', 0, '2026-02-26 17:37:58', 1, '2026-03-23 09:09:10', 1, 0, NULL);
INSERT INTO `module_info` VALUES (55, '99', 15, NULL, '', 0, '2026-02-26 17:38:52', 1, '2026-02-26 17:39:08', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (56, '99', 15, NULL, '', 0, '2026-02-26 17:39:12', 1, '2026-02-26 17:39:12', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (57, '999', 15, 56, '', 0, '2026-02-26 17:39:17', 1, '2026-02-26 17:39:17', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (58, '9999', 15, 57, '', 0, '2026-02-26 17:39:21', 1, '2026-02-26 17:39:21', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (59, '9999', 7, NULL, '', 0, '2026-02-26 17:39:27', 1, '2026-02-26 17:39:27', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (60, '000', 14, NULL, '', 0, '2026-02-26 17:43:06', 1, '2026-02-26 17:50:32', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (61, '0000', 14, 60, '', 0, '2026-02-26 17:43:11', 1, '2026-02-26 17:50:30', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (62, '000000', 14, 61, '', 0, '2026-02-26 17:43:16', 1, '2026-02-26 17:50:27', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (63, '00000000000000000000', 14, 62, '', 0, '2026-02-26 17:43:21', 1, '2026-02-26 17:50:24', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (64, '0', 7, NULL, '', 0, '2026-02-26 17:43:40', 1, '2026-02-26 17:43:40', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (65, '00', 7, 64, '', 0, '2026-02-26 17:43:45', 1, '2026-02-26 17:43:45', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (66, '00000', 7, 65, '', 0, '2026-02-26 17:43:53', 1, '2026-02-26 17:43:53', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (67, '000', 4, NULL, '', 0, '2026-02-26 17:44:08', 1, '2026-02-26 17:45:42', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (68, '00000', 4, 67, '', 0, '2026-02-26 17:44:12', 1, '2026-02-26 17:45:39', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (69, '00000000000000000', 4, 68, '', 0, '2026-02-26 17:44:16', 1, '2026-02-26 17:45:37', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (70, '测试', 4, NULL, '', 0, '2026-02-26 17:45:47', 1, '2026-02-26 17:45:47', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (71, '测试1', 4, 70, '', 0, '2026-02-26 17:45:53', 1, '2026-02-26 17:45:53', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (72, '测试2', 4, 71, '', 0, '2026-02-26 17:45:58', 1, '2026-02-26 17:45:58', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (73, '8888', 1, NULL, '', 0, '2026-02-26 17:47:24', 1, '2026-03-23 09:09:41', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (74, '8888888888888888888', 1, 73, '', 0, '2026-02-26 17:47:29', 1, '2026-03-23 09:09:38', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (75, '888', 1, 74, '', 0, '2026-02-26 17:47:34', 1, '2026-03-23 09:09:36', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (76, '很好', 1, 75, '', 0, '2026-02-26 17:47:59', 1, '2026-03-23 09:09:33', 1, 0, NULL);
INSERT INTO `module_info` VALUES (77, '发大水发生', 1, 75, '', 1, '2026-02-26 17:48:15', 1, '2026-03-23 09:09:31', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (78, '登录', 6, NULL, '', 0, '2026-03-01 13:54:59', 1, '2026-03-01 13:54:59', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (79, '注册', 6, 78, '', 0, '2026-03-01 13:55:15', 1, '2026-03-01 13:55:15', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (80, '搜索', 6, 79, '', 0, '2026-03-01 13:55:25', 1, '2026-03-01 13:55:25', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (81, '9', 5, NULL, '', 0, '2026-03-02 15:46:41', 1, '2026-03-02 15:46:41', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (82, '99', 5, NULL, '', 0, '2026-03-02 15:46:47', 1, '2026-03-02 15:46:47', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (83, '8', 5, NULL, '', 0, '2026-03-02 15:46:50', 1, '2026-03-02 15:46:50', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (84, '88', 5, NULL, '', 0, '2026-03-02 15:46:54', 1, '2026-03-02 15:46:54', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (85, '77', 5, NULL, '', 0, '2026-03-02 15:46:58', 1, '2026-03-02 15:46:58', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (86, '7', 5, NULL, '', 0, '2026-03-02 15:47:02', 1, '2026-03-02 15:47:02', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (87, '66', 5, NULL, '', 0, '2026-03-02 15:47:06', 1, '2026-03-02 15:47:06', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (88, '6', 5, NULL, '', 0, '2026-03-02 15:47:09', 1, '2026-03-02 15:47:09', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (89, '55', 5, NULL, '', 0, '2026-03-02 15:47:14', 1, '2026-03-02 15:47:14', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (90, '44', 5, NULL, '', 0, '2026-03-02 15:47:17', 1, '2026-03-02 15:47:17', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (91, '33', 5, NULL, '', 0, '2026-03-02 15:47:22', 1, '2026-03-02 15:47:22', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (92, '4535', 5, NULL, '', 0, '2026-03-02 15:47:26', 1, '2026-03-02 15:47:26', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (93, '6646', 5, NULL, '', 0, '2026-03-02 15:47:29', 1, '2026-03-02 15:47:29', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (94, '3535', 5, NULL, '', 0, '2026-03-02 15:47:33', 1, '2026-03-02 15:47:33', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (95, '546546', 5, NULL, '', 0, '2026-03-02 15:47:36', 1, '2026-03-02 15:47:36', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (96, '232543', 5, NULL, '', 0, '2026-03-02 15:47:39', 1, '2026-03-02 15:47:39', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (97, '354353', 5, NULL, '', 0, '2026-03-02 15:47:43', 1, '2026-03-02 15:47:43', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (98, '756765', 5, NULL, '', 0, '2026-03-02 15:47:47', 1, '2026-03-02 15:47:47', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (99, '657', 5, NULL, '', 0, '2026-03-02 15:47:50', 1, '2026-03-02 15:47:50', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (100, '646', 5, NULL, '', 0, '2026-03-02 15:47:53', 1, '2026-03-02 15:47:53', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (101, '656765', 5, NULL, '', 0, '2026-03-02 15:47:56', 1, '2026-03-02 15:47:56', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (102, '453543', 5, NULL, '', 0, '2026-03-02 15:48:00', 1, '2026-03-02 15:48:00', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (103, '44', 4, NULL, '', 0, '2026-03-04 12:17:10', 1, '2026-03-04 12:17:10', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (104, '44444', 4, NULL, '', 0, '2026-03-04 12:17:14', 1, '2026-03-04 12:17:14', NULL, 1, NULL);
INSERT INTO `module_info` VALUES (105, '999', 16, NULL, '', 0, '2026-03-04 13:32:47', 1, '2026-03-23 09:09:22', NULL, 0, NULL);
INSERT INTO `module_info` VALUES (106, '9999', 16, 105, '', 0, '2026-03-04 13:32:55', 1, '2026-03-23 09:09:20', NULL, 0, NULL);

-- ----------------------------
-- Table structure for notification_histories
-- ----------------------------
DROP TABLE IF EXISTS `notification_histories`;
CREATE TABLE `notification_histories`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_id` bigint NOT NULL COMMENT '通知配置ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '通知内容',
  `recipient` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接收者',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '发送状态: pending/success/failed',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `sent_at` int NULL DEFAULT NULL COMMENT '发送时间戳',
  `response_data` json NULL COMMENT '响应数据',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_config_id`(`config_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_sent_at`(`sent_at` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知历史记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification_histories
-- ----------------------------
INSERT INTO `notification_histories` VALUES (7, 11, 'N-Tester测试通知', '这是一条N-Tester测试通知消息，用于验证通知配置是否正常工作。', '测试', 'success', NULL, 1772762749, '{\"errmsg\": \"ok\", \"errcode\": 0}', '2026-03-06 10:05:49', '2026-03-06 10:05:51', 1, '2026-03-06 10:05:49', 1, '2026-03-06 10:05:51', NULL, NULL);
INSERT INTO `notification_histories` VALUES (8, 17, 'N-Tester测试通知', '这是一条N-Tester测试通知消息，用于验证通知配置是否正常工作。', '测试', 'success', NULL, 1772762855, '{\"to\": [\"rebort.chen@howentech.com\"], \"from\": \"rebort.chen@howentech.com\", \"sent_at\": 1772762857, \"subject\": \"N-Tester测试通知\"}', '2026-03-06 10:07:35', '2026-03-06 10:07:37', 1, '2026-03-06 10:07:35', 1, '2026-03-06 10:07:37', NULL, NULL);

-- ----------------------------
-- Table structure for notify
-- ----------------------------
DROP TABLE IF EXISTS `notify`;
CREATE TABLE `notify`  (
  `user_id` int NULL DEFAULT NULL COMMENT '用户id',
  `group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '组',
  `message` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '消息',
  `send_status` int NULL DEFAULT NULL COMMENT '发送状态，10成功 20 失败',
  `read_status` int NULL DEFAULT NULL COMMENT '消息状态，10未读 20 已读',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_notify_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notify
-- ----------------------------

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `permission_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '权限编码',
  `permission_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '权限名称',
  `permission_type` smallint NOT NULL COMMENT '1菜单权限 2按钮权限 3数据权限 4API权限',
  `resource_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '资源类型',
  `resource_id` bigint NULL DEFAULT NULL COMMENT '关联资源ID',
  `status` smallint NULL DEFAULT NULL COMMENT '1启用 0禁用',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `description` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_permission_permission_code`(`permission_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES ('user:query', '查询用户', 2, 'user', NULL, 1, 1, NULL, 48, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('user:add', '新增用户', 2, 'user', NULL, 1, 2, NULL, 49, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('user:edit', '编辑用户', 2, 'user', NULL, 1, 3, NULL, 50, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('user:disable', '禁用用户', 2, 'user', NULL, 1, 4, NULL, 51, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('user:resetpwd', '重置密码', 2, 'user', NULL, 1, 5, NULL, 52, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('user:delete', '删除用户', 2, 'user', NULL, 1, 6, NULL, 53, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('role:query', '查询角色', 2, 'role', NULL, 1, 1, NULL, 54, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('role:add', '新增角色', 2, 'role', NULL, 1, 2, NULL, 55, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('role:edit', '编辑角色', 2, 'role', NULL, 1, 3, NULL, 56, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('role:delete', '删除角色', 2, 'role', NULL, 1, 4, NULL, 57, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dept:add', '新增部门', 2, 'dept', NULL, 1, 1, NULL, 58, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dept:edit', '编辑部门', 2, 'dept', NULL, 1, 2, NULL, 59, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dept:disable', '禁用部门', 2, 'dept', NULL, 1, 3, NULL, 60, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dept:delete', '删除部门', 2, 'dept', NULL, 1, 4, NULL, 61, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('project:query', '查询项目', 2, 'project', NULL, 1, 1, NULL, 62, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('project:add', '新增项目', 2, 'project', NULL, 1, 2, NULL, 63, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('project:edit', '编辑项目', 2, 'project', NULL, 1, 3, NULL, 64, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('project:delete', '删除项目', 2, 'project', NULL, 1, 4, NULL, 65, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('loginRecord:query', '查询记录', 2, 'loginRecord', NULL, 1, 1, NULL, 66, '2026-01-30 16:28:24', NULL, '2026-01-30 16:28:24', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dept:query', '查询部门', 2, 'dept', NULL, 1, 0, NULL, 79, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('menu:query', '查询菜单', 2, 'menu', NULL, 1, 0, NULL, 80, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('dict:query', '查询字典', 2, 'dict', NULL, 1, 0, NULL, 81, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('file:query', '查询文件', 2, 'file', NULL, 1, 0, NULL, 82, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('depy:query', '查询部门', 2, 'depy', NULL, 1, 0, NULL, 83, '2026-01-31 08:55:08', 1, '2026-01-31 08:55:08', 1, 1, NULL);
INSERT INTO `permission` VALUES ('dict:add', '新增字典', 2, 'dict', NULL, 1, 0, NULL, 84, '2026-01-31 08:58:14', 1, '2026-01-31 08:58:14', 1, 1, NULL);
INSERT INTO `permission` VALUES ('dict:edit', '编辑字典', 2, 'dict', NULL, 1, 0, NULL, 85, '2026-01-31 08:58:59', 1, '2026-01-31 08:58:59', 1, 1, NULL);
INSERT INTO `permission` VALUES ('dict:delete', '删除字典', 2, 'dict', NULL, 1, 0, NULL, 86, '2026-01-31 08:59:50', 1, '2026-01-31 08:59:50', 1, 1, NULL);
INSERT INTO `permission` VALUES ('menu:add', '新增菜单', 2, 'menu', NULL, 1, 0, NULL, 87, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('menu:edit', '编辑菜单', 2, 'menu', NULL, 1, 0, NULL, 88, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('menu:delete', '删除菜单', 2, 'menu', NULL, 1, 0, NULL, 89, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:server:list', '服务器监控查看', 1, 'menu', NULL, 1, 1, '查看服务器监控信息', 90, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:server:info', '获取服务器信息', 4, 'api', NULL, 1, 2, '获取服务器监控详细信息', 91, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:online:list', '在线用户查看', 1, 'menu', NULL, 1, 3, '查看在线用户列表', 92, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:online:stats', '在线用户统计', 4, 'api', NULL, 1, 4, '获取在线用户统计信息', 93, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:online:force-offline', '强制用户下线', 2, 'button', NULL, 1, 5, '强制指定用户下线', 94, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('monitor:online:cleanup', '清理过期用户', 2, 'button', NULL, 1, 6, '清理过期的在线用户', 95, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:list', '用户列表API', 4, 'api', NULL, 1, 0, '获取用户列表的API权限', 96, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:detail', '用户详情API', 4, 'api', NULL, 1, 0, '获取用户详情的API权限', 97, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:create', '创建用户API', 4, 'api', NULL, 1, 0, '创建用户的API权限', 98, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:update', '更新用户API', 4, 'api', NULL, 1, 0, '更新用户的API权限', 99, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:delete', '删除用户API', 4, 'api', NULL, 1, 0, '删除用户的API权限', 100, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:user:reset-password', '重置密码API', 4, 'api', NULL, 1, 0, '重置用户密码的API权限', 101, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:role:list', '角色列表API', 4, 'api', NULL, 1, 0, '获取角色列表的API权限', 102, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:role:detail', '角色详情API', 4, 'api', NULL, 1, 0, '获取角色详情的API权限', 103, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:role:create', '创建角色API', 4, 'api', NULL, 1, 0, '创建角色的API权限', 104, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:role:update', '更新角色API', 4, 'api', NULL, 1, 0, '更新角色的API权限', 105, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:role:delete', '删除角色API', 4, 'api', NULL, 1, 0, '删除角色的API权限', 106, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:dept:list', '部门列表API', 4, 'api', NULL, 1, 0, '获取部门列表的API权限', 107, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:dept:detail', '部门详情API', 4, 'api', NULL, 1, 0, '获取部门详情的API权限', 108, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:dept:create', '创建部门API', 4, 'api', NULL, 1, 0, '创建部门的API权限', 109, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:dept:update', '更新部门API', 4, 'api', NULL, 1, 0, '更新部门的API权限', 110, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('api:dept:delete', '删除部门API', 4, 'api', NULL, 1, 0, '删除部门的API权限', 111, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('business:user:list', '业务用户列表', 4, 'api', NULL, 1, 0, '业务模块用户列表权限', 112, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('business:user:detail', '业务用户详情', 4, 'api', NULL, 1, 0, '业务模块用户详情权限', 113, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('business:user:reset-password', '业务重置密码', 4, 'api', NULL, 1, 0, '业务模块重置密码权限', 114, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('business:admin:reset-password', '管理员重置密码', 4, 'api', NULL, 1, 0, '管理员重置任意用户密码权限', 115, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('business:stats:view', '查看统计信息', 4, 'api', NULL, 1, 0, '查看业务统计信息权限', 116, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('data:user:all', '用户全部数据', 3, 'data', NULL, 1, 0, '可以查看所有用户数据', 117, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('data:user:dept', '用户部门数据', 3, 'data', NULL, 1, 0, '可以查看本部门用户数据', 118, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('data:user:dept-child', '用户部门及下级数据', 3, 'data', NULL, 1, 0, '可以查看本部门及下级部门用户数据', 119, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('data:user:self', '用户个人数据', 3, 'data', NULL, 1, 0, '只能查看自己创建的用户数据', 120, '2026-02-03 11:40:53', 1, '2026-02-03 11:40:53', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:login:list', '查看登录日志', 4, 'log', NULL, 1, 1, '查看登录日志列表', 121, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:login:query', '查询登录日志', 2, 'log', NULL, 1, 2, '查询登录日志', 122, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:login:detail', '查看登录日志详情', 2, 'log', NULL, 1, 3, '查看登录日志详情信息', 123, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:login:delete', '删除登录日志', 2, 'log', NULL, 1, 4, '删除登录日志记录', 124, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:login:clean', '清理登录日志', 2, 'log', NULL, 1, 5, '清理旧的登录日志记录', 125, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:operation:list', '查看操作日志', 4, 'log', NULL, 1, 6, '查看操作日志列表', 126, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:operation:query', '查询操作日志', 2, 'log', NULL, 1, 7, '查询操作日志', 127, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:operation:detail', '查看操作日志详情', 2, 'log', NULL, 1, 8, '查看操作日志详情信息', 128, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:operation:delete', '删除操作日志', 2, 'log', NULL, 1, 9, '删除操作日志记录', 129, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);
INSERT INTO `permission` VALUES ('system:log:operation:clean', '清理操作日志', 2, 'log', NULL, 1, 10, '清理旧的操作日志记录', 130, '2026-02-03 15:32:00', NULL, '2026-02-03 15:32:00', NULL, 1, NULL);

-- ----------------------------
-- Table structure for project_environments
-- ----------------------------
DROP TABLE IF EXISTS `project_environments`;
CREATE TABLE `project_environments`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '环境ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '环境名称',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '基础URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '环境描述',
  `variables` json NULL COMMENT '环境变量',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pe_project`(`project_id` ASC) USING BTREE,
  CONSTRAINT `project_environments_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目环境表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_environments
-- ----------------------------

-- ----------------------------
-- Table structure for project_info
-- ----------------------------
DROP TABLE IF EXISTS `project_info`;
CREATE TABLE `project_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '项目名称',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '项目描述',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_info
-- ----------------------------
INSERT INTO `project_info` VALUES (1, '99', '99', '2026-01-30 16:56:10', 1, '2026-01-30 16:56:15', 1, 0, NULL);
INSERT INTO `project_info` VALUES (2, '9988', '99', '2026-01-30 17:56:11', 5, '2026-01-30 18:03:34', 7, 1, NULL);
INSERT INTO `project_info` VALUES (3, '77777', '7777', '2026-01-30 18:05:24', 7, '2026-01-30 18:05:35', 7, 1, NULL);

-- ----------------------------
-- Table structure for project_members
-- ----------------------------
DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '成员ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'tester' COMMENT '角色: owner/admin/developer/tester/viewer',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_pm_project_user`(`project_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_pm_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `project_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目成员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_members
-- ----------------------------

-- ----------------------------
-- Table structure for project_versions
-- ----------------------------
DROP TABLE IF EXISTS `project_versions`;
CREATE TABLE `project_versions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `version_id` bigint NOT NULL COMMENT '版本ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_version`(`project_id` ASC, `version_id` ASC) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_version`(`version_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  CONSTRAINT `project_versions_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `project_versions_ibfk_2` FOREIGN KEY (`version_id`) REFERENCES `versions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目版本关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_versions
-- ----------------------------

-- ----------------------------
-- Table structure for projects
-- ----------------------------
DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '项目描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'active' COMMENT '状态: active/paused/completed/archived',
  `owner_id` bigint NOT NULL COMMENT '负责人ID',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_owner`(`owner_id` ASC) USING BTREE,
  INDEX `idx_project_status`(`status` ASC) USING BTREE,
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of projects
-- ----------------------------

-- ----------------------------
-- Table structure for prompt_configs
-- ----------------------------
DROP TABLE IF EXISTS `prompt_configs`;
CREATE TABLE `prompt_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名称',
  `prompt_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提示词类型: writer/reviewer',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提示词内容',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `created_by` bigint NOT NULL COMMENT '创建者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_prompt_type`(`prompt_type` ASC) USING BTREE,
  INDEX `idx_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提示词配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of prompt_configs
-- ----------------------------
INSERT INTO `prompt_configs` VALUES (6, '默认编写提示词', 'writer', '你是一位拥有20年经验的资深测试用例编写专家，能够根据需求精确生成高质量的测试用例。\n# 核心目标\n生成高覆盖率、颗粒度细致的测试用例，确保不遗漏任何功能逻辑、异常场景和边界条件。\n# 角色设定\n1. 身份：精通全栈测试（Web/App/API）的高级QA专家\n2. 测试风格：破坏性测试思维，善于发现潜在Bug\n3. 输出原则：详细、独立、可执行\n# 用例设计规范\n1. **独立性**：每条用例只验证一个具体的测试点，严禁合并多个场景。\n2. **完整性**：\n- 包含用例ID（[模块]_[序号]）\n- 清晰的测试目标\n- 准确的前置条件\n- 步骤化操作描述\n- 具体的预期结果\n3. **覆盖维度**：\n- ✅ 功能正向流程（Happy Path）\n- ⚠️ 异常流程（输入错误、权限不足、网络异常）\n- 🔄 边界值（最大/最小值、空值、特殊字符）\n- 🔒 业务约束（状态机流转、数据依赖）\n# 输出格式\n请严格按照以下Markdown表格格式输出，不要包含任何开场白或结束语：\n## ⚠️ 重要：输出顺序要求\n1. **必须按用例编号从小到大的顺序输出**（如：001, 002, 003...）\n2. **绝对不能跳号、重复或乱序输出**\n3. 编号必须连续，中间不能有遗漏\n4. 所有用例必须一次性完整输出，不能中断\n```markdown\n| 用例ID | 测试标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 测试类型 | 关联需求 |\n|--------|--------|--------|--------|--------|--------|--------|--------|\n| LOGIN_001 | 验证手机号格式校验 | 在登录页 | 1. 输入10位手机号<br>2. 点击获取验证码 | 提示\"手机号格式不正确\"，发送按钮不可点 | P1 | 功能验证 | 登录模块 |\n```', 1, 1, '2026-02-25 16:53:28', '2026-03-03 10:46:11', 1, NULL, NULL);
INSERT INTO `prompt_configs` VALUES (7, '默认评审提示词', 'reviewer', '你是一名资深测试专家（Test Architect），拥有极高的质量标准。你的任务是对生成的测试用例进行严格的评审。\n# 核心职责\n不只是简单通过，而是要作为\"质量守门员\"，敏锐地发现遗漏的场景、逻辑漏洞和描述不清的问题。\n# 评审维度\n1. **覆盖率检查**：\n- 是否遗漏了需求文档中的关键功能点？\n- 是否包含了必要的异常场景（如断网、服务超时、数据错误）？\n- 是否覆盖了边界条件（如最大长度、空值、特殊字符）？\n2. **逻辑性检查**：\n- 前置条件是否充分？（例如测试\"支付功能\"前是否检查了\"余额充足\"）\n- 预期结果是否具体？（拒绝模糊的\"显示正确\"，必须说明具体提示文案或状态变化）\n3. **规范性检查**：\n- 用例标题是否清晰表达了测试意图？\n- 步骤是否可执行？\n# 输出要求\n请输出一份结构化的评审报告：\n1. **总体评价**：给出一个质量评分（0-100分）和总体结论（通过/需修改）。\n2. **发现的问题**：列出具体的问题点，精确到具体的用例ID。\n3. **补充建议**：直接给出建议补充的测试场景或用例。\n4. **修正后的用例**（可选）：如果发现严重问题，请直接提供修正后的用例版本。', 1, 1, '2026-02-25 16:53:28', '2026-02-25 16:53:28', 1, NULL, NULL);

-- ----------------------------
-- Table structure for request_history
-- ----------------------------
DROP TABLE IF EXISTS `request_history`;
CREATE TABLE `request_history`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `remote_addr` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户名称',
  `real_ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户名称',
  `request` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户名称',
  `method` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `args` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `form` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `json` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '操作',
  `response` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '操作',
  `endpoint` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '操作',
  `elapsed` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '操作',
  `request_time` datetime NULL DEFAULT NULL COMMENT '操作',
  `env` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `employee_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `toekn` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of request_history
-- ----------------------------

-- ----------------------------
-- Table structure for requirement_analyses
-- ----------------------------
DROP TABLE IF EXISTS `requirement_analyses`;
CREATE TABLE `requirement_analyses`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `document_id` bigint NOT NULL COMMENT '关联文档ID',
  `analysis_report` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '分析报告',
  `requirements_count` int NULL DEFAULT 0 COMMENT '需求数量',
  `analysis_time` float NULL DEFAULT NULL COMMENT '分析耗时(秒)',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_document`(`document_id` ASC) USING BTREE,
  INDEX `idx_document`(`document_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '需求分析表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of requirement_analyses
-- ----------------------------
INSERT INTO `requirement_analyses` VALUES (1, 5, '该需求文档描述了用户通过两种第三方快捷登录方式（微信和Gitee）成功登录系统的基本功能，属于用户认证模块的核心功能需求。', 2, 12.8318, 1, '2026-02-27 15:27:51', '2026-02-27 15:27:51', 1, NULL, NULL);
INSERT INTO `requirement_analyses` VALUES (2, 6, '该需求文档描述了用户通过两种第三方快捷登录方式（微信和Gitee）成功登录系统的基本功能，属于用户认证模块的核心功能需求。', 2, 12.5491, 1, '2026-02-27 15:37:21', '2026-02-27 15:37:21', 1, NULL, NULL);
INSERT INTO `requirement_analyses` VALUES (3, 8, '从Figma设计稿《Truevisia》提取了40个需求，涵盖3个页面', 40, 0, 1, '2026-02-27 18:30:16', '2026-02-27 18:30:16', 1, NULL, NULL);
INSERT INTO `requirement_analyses` VALUES (4, 9, '从Figma设计稿《Truevisia》提取了0个需求，涵盖3个页面', 0, 0, 1, '2026-02-27 18:34:14', '2026-02-27 18:34:14', 1, NULL, NULL);
INSERT INTO `requirement_analyses` VALUES (5, 10, '从Figma设计稿《Figma basics》提取了7个需求，涵盖1个页面（简化模式）', 7, 0, 1, '2026-02-28 09:42:51', '2026-02-28 09:42:51', 1, NULL, NULL);
INSERT INTO `requirement_analyses` VALUES (6, 11, '从Figma设计稿《Figma basics》提取了7个需求，涵盖1个页面（简化模式）', 7, 0, 1, '2026-02-28 09:55:03', '2026-02-28 09:55:03', 1, NULL, NULL);

-- ----------------------------
-- Table structure for requirement_documents
-- ----------------------------
DROP TABLE IF EXISTS `requirement_documents`;
CREATE TABLE `requirement_documents`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文档标题',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文档文件路径',
  `document_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文档类型: pdf/docx/txt/md',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'uploaded' COMMENT '状态: uploaded/analyzing/analyzed/failed',
  `file_size` int NULL DEFAULT NULL COMMENT '文件大小(bytes)',
  `extracted_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '提取的文本内容',
  `uploaded_by` bigint NOT NULL COMMENT '上传者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_uploaded_by`(`uploaded_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '需求文档表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of requirement_documents
-- ----------------------------
INSERT INTO `requirement_documents` VALUES (1, 15, '99', 'static/upload/requirement_docs/20260225/Xshell7_en.pdf', 'pdf', 'uploaded', 349855, NULL, 1, '2026-02-25 15:25:00', '2026-02-25 15:47:13', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (2, 1, '测试需求文档', 'static/upload/requirement_docs/20260225/test_requirement.txt', 'txt', 'uploaded', 100, NULL, 1, '2026-02-25 15:29:29', '2026-02-25 15:40:32', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (3, 15, '000', 'static/upload/requirement_docs/20260225/Xshell7_en.pdf', 'pdf', 'uploaded', 349855, NULL, 1, '2026-02-25 15:47:30', '2026-02-25 16:21:44', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (4, 14, '9', 'static/upload/requirement_docs/20260225/Xshell7_en.pdf', 'pdf', 'uploaded', 349855, 'Manual - Xshell\nVersion 7 Help\nExported on  10/23/2020\n\nVersion 7 Help  –  Manual - Xshell\n –  2Table of Contents\n1 Xshell Manual ....................................................................................................... 7\n2 Content ................................................................................................................. 8\n2.1 About Xshell ............................................................................................................................... 8\n2.2 Start ........................................................................................................................................... 8\n2.3 Session Management ................................................................................................................ 8\n2.4 Connection ................................................................................................................................ 9\n2.5 Security ...................................................................................................................................... 9\n2.6 Tab Management ...................................................................................................................... 9\n2.7 Tunneling Service ...................................................................................................................... 9\n2.8 Terminal Window Operations .................................................................................................. 9\n2.9 Options Setting ....................................................................................................................... 10\n2.10 File Transfer ............................................................................................................................. 10\n2.11 Session Logging and Tracing .................................................................................................. 10\n2.12 Printing .................................................................................................................................... 10\n2.13 Using Xagent ............................................................................................................................ 10\n2.14 Using Scripts ............................................................................................................................ 10\n2.15 References ............................................................................................................................... 11\n3 About Xshell ........................................................................................................ 12\n3.1 Key Functions .......................................................................................................................... 12\n3.2 Minimum System Requirements ............................................................................................ 14\n3.3 Install and Uninstall ................................................................................................................ 14\n4 Start .................................................................................................................... 15\n4.1 Create Session ......................................................................................................................... 15\n4.2 Connect to Remote Host ......................................................................................................... 16\n4.3 Exit Xshell ................................................................................................................................ 17\n5 Session Management ......................................................................................... 18\n5.1 Session Management .............................................................................................................. 18\n5.2 Session Properties .................................................................................................................. 19\n\nVersion 7 Help  –  Manual - Xshell\n –  35.2.1 Connection ............................................................................................................................................................ 19\n5.2.2 Connection _ Authentication ............................................................................................................................... 20\n5.2.3 Connection _ Authentication _ Login Prompts ................................................................................................... 20\n5.2.4 Connection _ Login Scripts ................................................................................................................................... 21\n5.2.5 Connection _ SSH .................................................................................................................................................. 21\n5.2.6 Connection _ SSH _ Security ................................................................................................................................ 22\n5.2.7 Connection _ SSH _ Tunneling ............................................................................................................................. 22\n5.2.8 Connection _ SSH _ SFTP ..................................................................................................................................... 22\n5.2.9 Connection _ TELNET ........................................................................................................................................... 22\n5.2.10 Connection _ RLOGIN ........................................................................................................................................... 22\n5.2.11 Connection _ SERIAL ............................................................................................................................................. 23\n5.2.12 Connection _ PROXY ............................................................................................................................................. 23\n5.2.13 Connection _ Keep Alive ....................................................................................................................................... 23\n5.2.14 Terminal ................................................................................................................................................................ 23\n5.2.15 Terminal _ Keyboard ............................................................................................................................................. 24\n5.2.16 Terminal _ VT Mode .............................................................................................................................................. 24\n5.2.17 Terminal _ Advanced ............................................................................................................................................ 25\n5.2.18 Appearance ........................................................................................................................................................... 26\n5.2.19 Appearance _ Window .......................................................................................................................................... 26\n5.2.20 Appearance _ Highlight ........................................................................................................................................ 27\n5.2.21 Advanced ............................................................................................................................................................... 27\n5.2.22 Advanced _ Trace .................................................................................................................................................. 27\n5.2.23 Advanced _ Bell ..................................................................................................................................................... 28\n5.2.24 Advanced _ Logging .............................................................................................................................................. 28\n5.2.25 File Transfer ........................................................................................................................................................... 29\n5.2.26 File Transfer _ X_YMODEM .................................................................................................................................... 29\n5.2.27 File Transfer _ ZMODEM ........................................................................................................................................ 29\n5.3 Export ...................................................................................................................................... 30\n5.4 Import ...................................................................................................................................... 30\n6 Connection ......................................................................................................... 31\n6.1 Connections without Session Files ........................................................................................ 31\n6.2 Connections with Session Files .............................................................................................. 31\n6.3 Sessions to Run on Xshell Startup .......................................................................................... 32\n6.4 SERIAL Connection .................................................................................................................. 32\n\nVersion 7 Help  –  Manual - Xshell\n –  46.5 Connection with Kerberos ...................................................................................................... 32\n6.6 Connection with PKCS _11 ..................................................................................................... 33\n6.7 Proxy Setting ........................................................................................................................... 33\n6.8 Jump host ................................................................................................................................ 33\n7 Security ............................................................................................................... 35\n7.1 Public Key User Authentication0 ............................................................................................ 35\n7.1.1 User Keys Dialog Box ............................................................................................................................................. 36\n7.2 Host Key Management ............................................................................................................ 36\n7.2.1 SSH Security Warning Dialog Box ......................................................................................................................... 36\n7.2.2 Host Keys Dialog Box ............................................................................................................................................ 37\n7.3 Master Password ..................................................................................................................... 37\n8 Tab Management ............................................................................................... 39\n8.1 Tab ........................................................................................................................................... 39\n8.2 Tab Group ................................................................................................................................ 39\n8.3 Split and Merge Tabs .............................................................................................................. 40\n8.4 Arrange Tabs ........................................................................................................................... 40\n9 Tunneling Service ............................................................................................... 41\n9.1 TCP_IP Port Forwarding ......................................................................................................... 41\n9.2 X11 Forwarding ....................................................................................................................... 41\n9.3 SOCKS4_5 Dynamic Port Forwarding .................................................................................... 42\n9.4 Instant Tunneling .................................................................................................................... 42\n10 Terminal Window Operations ........................................................................... 44\n10.1 Copy and Paste ........................................................................................................................ 44\n10.2 Find String ............................................................................................................................... 45\n10.3 Font Change ............................................................................................................................ 45\n10.4 Font Color and Background Color Setting ............................................................................. 45\n10.5 Cursor Change ......................................................................................................................... 46\n10.6 Window Handling .................................................................................................................... 47\n10.7 Multi-session Handling ........................................................................................................... 48\n10.8 Quick Command Sets Setting ................................................................................................. 48\n10.9 Terminal Output Encoding Change ........................................................................................ 50\n\nVersion 7 Help  –  Manual - Xshell\n –  510.10 Advanced Terminal Options Setting ...................................................................................... 50\n10.11 Layout Management ............................................................................................................... 51\n10.12 Highlight Sets Settings ............................................................................................................ 51\n11 Options Setting .................................................................................................. 53\n11.1 Session Folder and Startup Session ....................................................................................... 53\n11.2 History Clearing and Connection Log .................................................................................... 53\n11.3 Key Mapping Setting ............................................................................................................... 53\n11.4 Mouse Setting .......................................................................................................................... 54\n11.5 Transparency Setting .............................................................................................................. 54\n11.6 Master Password Settings ...................................................................................................... 54\n11.7 Screen Lock Settings ............................................................................................................... 54\n11.7.1 Auto Lock ............................................................................................................................................................... 55\n11.8 Live Update Settings ............................................................................................................... 55\n11.9 Advanced Settings .................................................................................................................. 56\n12 File Transfer ........................................................................................................ 58\n12.1 File Transfer Using SFTP ......................................................................................................... 58\n12.2 File Transfer Using FTP ........................................................................................................... 58\n12.3 File Transfer Using X_Y_ZMODEM .......................................................................................... 58\n12.4 File Transfer Using Xftp ........................................................................................................... 60\n13 Session Logging and Tracing ............................................................................. 61\n13.1 Session Logging ...................................................................................................................... 61\n13.2 Session Tracing ....................................................................................................................... 61\n14 Printing ............................................................................................................... 62\n15 Using Xagent ....................................................................................................... 63\n15.1 Connecting to a Server Through Xagent ................................................................................ 63\n15.2 Using the Xagent User Key on a Remote Host ....................................................................... 63\n16 Using Scripts ....................................................................................................... 65\n16.1 Script Starting and Ending ..................................................................................................... 65\n16.2 Script API ................................................................................................................................. 65\n16.2.1 xsh.Session ............................................................................................................................................................ 65\n16.2.2 xsh.Screen ............................................................................................................................................................. 66\n\nVersion 7 Help  –  Manual - Xshell\n –  616.2.3 xsh.Dialog .............................................................................................................................................................. 68\n16.2.4 Script Example ...................................................................................................................................................... 68\n16.3 Script Recording ...................................................................................................................... 70\n16.4 Multi-Session Script ................................................................................................................ 70\n17 References .......................................................................................................... 71\n17.1 Standard Buttons .................................................................................................................... 71\n17.2 Address Bar .............................................................................................................................. 73\n17.3 Xshell Local Command ........................................................................................................... 74\n17.4 Xshell Command Line Option ................................................................................................. 78\n17.5 SFTP Command ....................................................................................................................... 80\n17.6 Regular Expression .................................................................................................................. 81\n17.6.1 Pattern Match ........................................................................................................................................................ 81\n17.6.2 The shorthand of character classes ..................................................................................................................... 82\n17.6.3 POSIX character classes ........................................................................................................................................ 83\n17.6.4 Example ................................................................................................................................................................. 84\n17.7 Pre-defined Shortcut Key ....................................................................................................... 84\n\nVersion 7 Help  –  Manual - Xshell\nXshell Manual   –  71 Xshell Manual\nThe manual describe how to use the program\'s interface and will guide you through the basics.\n\nVersion 7 Help  –  Manual - Xshell\nContent   –  8•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•2 Content\n2.1 About Xshell\nKey Functions (see page 12)\nMinimum System Requirements (see page 14)\nInstall and Uninstall (see page 14)\n2.2 Start\nCreate Session (see page 15)\nConnect to Remote Host (see page 16)\nExit Xshell (see page 17)\n2.3 Session Management\nSession Management (see page 18)\nSession Properties (see page 19)\nConnection (see page 19)\nConnection _ Authentication (see page 20)\nConnection _ Authentication _ Login Prompts (see page 20)\nConnection _ Login Scripts (see page 21)\nConnection _ SSH (see page 21)\nConnection _ SSH _ Security (see page 22)\nConnection _ SSH _ Tunneling (see page 22)\nConnection _ SSH _ SFTP (see page 22)\nConnection _ TELNET (see page 22)\nConnection _ RLOGIN (see page 22)\nConnection _ SERIAL (see page 23)\nConnection _ PROXY (see page 23)\nConnection _ Keep Alive (see page 23)\nTerminal (see page 23)\nTerminal _ Keyboard (see page 24)\nTerminal _ VT Mode (see page 24)\nTerminal _ Advanced (see page 25)\nAppearance (see page 26)\nAppearance _ Window (see page 26)\nAppearance _ Highlight (see page 27)\nAdvanced (see page 27)\nAdvanced _ Trace (see page 27)\nAdvanced _ Bell (see page 28)\nAdvanced _ Logging (see page 28)\nFile Transfer (see page 29)\nFile Transfer _ X_YMODEM (see page 29)\nFile Transfer _ ZMODEM (see page 29)\nExport (see page 30)\nImport (see page 30)\n\nVersion 7 Help  –  Manual - Xshell\nContent   –  9•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•2.4 Connection\nConnections without Session Files (see page 31)\nConnections with Session Files (see page 31)\nSessions to Run on Xshell Startup (see page 32)\nSERIAL Connection (see page 32)\nConnection with Kerberos (see page 32)\nConnection with PKCS _11 (see page 33)\nProxy Setting (see page 33)\nJump host (see page 33)\n2.5 Security\nPublic Key User Authentication0 (see page 35)\nUser Keys Dialog Box (see page 36)\nHost Key Management (see page 36)\nSSH Security Warning Dialog Box (see page 36)\nHost Keys Dialog Box (see page 37)\nMaster Password (see page 37)\n2.6 Tab Management\nTab (see page 39)\nTab Group (see page 39)\nSplit and Merge Tabs (see page 40)\nArrange Tabs (see page 40)\n2.7 Tunneling Service\nTCP_IP Port Forwarding (see page 41)\nX11 Forwarding (see page 41)\nSOCKS4_5 Dynamic Port Forwarding (see page 42)\nInstant Tunneling (see page 42)\n2.8 Terminal Window Operations\nCopy and Paste (see page 44)\nFind String (see page 45)\nFont Change (see page 45)\nFont Color and Background Color Setting (see page 45)\nCursor Change (see page 46)\nWindow Handling (see page 47)\nMulti-session Handling (see page 48)\nQuick Command Sets Setting (see page 48)\nTerminal Output Encoding Change (see page 50)\nAdvanced Terminal Options Setting (see page 50)\nLayout Management (see page 51)\n\nVersion 7 Help  –  Manual - Xshell\nContent   –  10•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•Highlight Sets Settings (see page 51)\n2.9 Options Setting\nSession Folder and Startup Session (see page 53)\nHistory Clearing and Connection Log (see page 53)\nKey Mapping Setting (see page 53)\nMouse Setting (see page 54)\nTransparency Setting (see page 54)\nMaster Password Settings (see page 54)\nScreen Lock Settings (see page 54)\nAuto Lock (see page 55)\nLive Update Settings (see page 55)\nAdvanced Settings (see page 56)\n2.10 File Transfer\nFile Transfer Using SFTP (see page 58)\nFile Transfer Using FTP (see page 58)\nFile Transfer Using X_Y_ZMODEM (see page 58)\nFile Transfer Using Xftp (see page 60)\n2.11 Session Logging and Tracing\nSession Logging (see page 61)\nSession Tracing (see page 61)\n2.12 Printing\n2.13 Using Xagent\nConnecting to a Server Through Xagent (see page 63)\nUsing the Xagent User Key on a Remote Host (see page 63)\n2.14 Using Scripts\nScript Starting and Ending (see page 65)\nScript API (see page 65)\nxsh.Session (see page 65)\nxsh.Screen (see page 66)\nxsh.Dialog (see page 68)\nScript Example (see page 68)\nScript Recording (see page 70)\nMulti-Session Script (see page 70)\n\nVersion 7 Help  –  Manual - Xshell\nContent   –  11•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•2.15 References\nStandard Buttons (see page 71)\nAddress Bar (see page 73)\nXshell Local Command (see page 74)\nXshell Command Line Option (see page 78)\nSFTP Command (see page 80)\nRegular Expression (see page 81)\nPattern Match (see page 81)\nThe shorthand of character classes (see page 82)\nPOSIX character classes (see page 83)\nExample (see page 84)\nPre-defined Shortcut Key (see page 84)\n\n1 http://ssh.comVersion 7 Help  –  Manual - Xshell\nAbout Xshell   –  12•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•3 About Xshell\nXshell  is a powerful SSH, TELNET and RLOGIN terminal emulator software operating on the Windows platform. \nWindows users can conveniently and securely access UNIX/Linux hosts using Xshell . SSH (secure shell) protocols \nsupport encryption and user authentication for secure connections on the Internet and can replace legacy \nprotocols, such as TELNET and RLOGIN.\n3.1 Key Functions\nThis section provides descriptions on key functions of Xshell .\nGeneral\nSupports SSH1, SSH2, SFTP, TELNET, RLOGIN and SERIAL protocols\nSupports Windows 7/8/10, Server 2008/2012/2016\nSupports OpenSSH and ssh.com1 servers\nSupports having multi tabs in a single window\nSupports displaying multiple tab groups in a single window\nMulti-user setting\nKeep alive option\nSOCKS4/5, HTTP proxy connection\nCustom key mapping\nVB, Perl, Jscript scripting\nIPv6 support\nKerberos(MIT Keberos, Microsoft SSPI) authentication support\nSSH/Telnet 추적\nSession Management\nThe Session Manager provides a convenient way to manage and run multiple sessions\nCreate and manage session files for both local and remote hosts\nSupports Sessions dialog box, address bar, local prompt, shortcut to session, and links bar to open sessions\nProvides a default session for quick connection\nSimultaneous connection with multiple sessions\nAddress bar supports URL commands and allows connection to a remote host with or without a saved \nsession\nSupports automatic login and login scripts\nSupports folder and tree view in the Sessions dialog box\nBatch update sessions\nImport and export sessions\nSecurity\n\nVersion 7 Help  –  Manual - Xshell\nAbout Xshell   –  13•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•RSA/DSA/ECDSA/ED25519 Public key, Password and Keyboard interactive user authentication\nRSA/DSA/ECDSA/ED25519 New Key Wizard and import/export key\nSSH PKCS#11 Support\nUser authentication using Xagent (SSH user authentication agent)\nAES128/192/256, 3DES, BLOWFISH, CAST128, ARCFOUR and RIJNDAEL encryption algorithms\nSHA1, SHA1-96, MD5, MD5-96 and RIPEMD160 MAC algorithms\nzlib compression\nHost Keys dialog box\nUser Keys dialog box\nSupports using master password to encrypt password\nTerminal\nUnicode-based terminal buffer\nVT100, VT220, VT320, XTERM, LINUX, SCOANSI and ANSI terminals\nFixed terminal size option for standardized output\nHorizontal scroll bar while in fixed terminal size\nMulti-language output encoding (UTF-8)\nCompose Bar for sending strings to multiple sessions\nCompose Pane for sending multiple lines of strings to multiple sessions\nScroll buffer enabling up to 2,147,483,647 lines to be saved\nCharacter string search using regular expressions\nColumn unit text selection\nSupports multi-byte character strings at copy & paste\nDesignates delimiters of double-click word selection in the terminal window\nTriple click selects one line\nBold font and ANSI color code\nXterm terminal mouse\nXterm 256-color mode\nLinux Meta key emulation\nPrints terminal screen\nSet line spacing and margins in the terminal window\nSearch a user specified web browser for selected text\nVarious bell options\nTunneling\nTCP/IP and X11 forwarding\nDynamic port forwarding using SOCKS4/5\nTunneling pane for observing and managing active forwarding channels\nInstand tunneling to add/remove or modify tunneling to the current connected session\nAppearance\nDockable UI for the main window\nTheme selection feature\nConvenient and powerful user interface\nSupports custom layout\nColor schemes edit/import/export feature\nChange cursor color and blinking\nEasily changeable fonts via the Font button\nApply separate fonts for ASCII and non ASCII characters\nDesignate frequently used character strings as quick commands: Quick Commands Bar, Quick Commands \nPane\nCustomizable Standard Buttons on toolbar\nSecurity–lock, session selection, and network up/down traffic information display in the status bar\n\nVersion 7 Help  –  Manual - Xshell\nAbout Xshell   –  14•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•Full screen view (Alt+Enter)\nTransparency options\nLocal Command\nLocal shell prompt for advanced users\nLocal commands, including open, ssh, telnet, rlogin, sftp, and ftp\nLocal Windows commands, such as ping, ipconfig, netstat, and nslookup\nEscape to the local prompt during connection\nInteroperability\nInteroperable with Xmanager program for X11 forwarding\nInteroperable with Xagent program for agent authentication and forwarding\nInteroperable with Xftp program for file transfers\nEdits scroll buffer in notepad\nSequentially selects Xshell window via the menu command\nString Transfer and File Management\nSend and receives files via FTP/SFTP\nSend and receives files via X/Y/Z MODEM\nSend ASCII files\nSend Delay for preventing data loss\nAuto save and support for various logging formats during session logging\nPage setting and print preview\n3.2 Minimum System Requirements\nProcessor : Intel® compatible\nOperating System :Microsoft Windows® 7 or higher\nStorage Space : 50MB of available space\nMemory:  512 MB\nNetwork : TCP/IP network\n3.3 Install and Uninstall\nThe Xshell  installation program was created using InstallShield®. A variety of installation options can be changed \nduring installation. However, it is often sufficient to simply click [Next].\nTo uninstall Xshell , use the standard Windows add/remove functions. Run [Add/Remove Program] in the control \npanel and select to uninstall Xshell  from the list. Even when the program is uninstalled, the registry information, log \nfiles and data files created by the user are not removed. The information and files are available for reuse when the \nprogram is reinstalled. If you want to remove all the files and registry information completely, remove the following \nexplicitly:\nRegistry Information:\n\\HKEY_CURRENT_USER\\Software\\NetSarang\\Xshell\nFile and Folder:\n\"User\'s Docuements Folder\"\\Netsarang Computer\\7\\Xshell\n\nVersion 7 Help  –  Manual - Xshell\nStart   –  151.\n2.\n3.\n4.\n5.\n6.4 Start\nThis section provides descriptions of the methods to create a TELNET/RLOGIN or SSH session and to connect to \nUNIX/Linux hosts. TELNET sessions are very simple. However, an SSH session occasionally requires a user key \nregistration in the server prior to connection. If you need user key registration for SSH sessions, see \'Public Key \nUser Authentication\' .\n4.1 Create Session\nSelect [New] from the [File] menu. New Session Properties  dialog box is displayed.\nFig. 1: New Session Properties dialog box\nEnter a session name in [Name].\nSelect an appropriate protocol from the [Protocol] list.\nEnter server host name or IP address in [Host].\nEnter port number used by the remote server in [Port Number].\nClick [OK].\n\n\nVersion 7 Help  –  Manual - Xshell\nStart   –  161.\n2.\n3.\n4.\n5.4.2 Connect to Remote Host\nThe following is the process for connecting to a remote host via an SSH session. If a session is not available, see \n\'Create Session\'.\nSelect [Open] from the [File] menu. Sessions  dialog box is displayed.\nSelect session for connection from the sessions list and click [Connect]. SSH User Name  dialog box is \ndisplayed.\nFig. 2: SSH User Name dialog box\nEnter user name and click [OK]. SSH User Authentication  dialog box is displayed.\nFig. 3: SSH User Authentication dialog box\nTo attempt Password  authentication, enter password in [Password] and click [OK].\nTo attempt Public Key  authentication, first select a user key from the list. Enter [Passphrase] of the selected \nuser key and click [OK].\n\n\nVersion 7 Help  –  Manual - Xshell\nStart   –  17\n6.\nNote\nIf a user key is not available, see \'Public Key User Authentication\'.\nTo attempt Keyboard Interactive  authentication, click [OK] and answer the questions given during \nconnection process.\n4.3 Exit Xshell\nTo disconnect with a session, enter \'exit\' in the terminal screen prompt or select [Disconnect] from the [File] menu.\nNote \nIf a session is disconnected with the [Revert to local shell when connection is closed]  option selected, the \nsession tab remains open and reverts back to local shell. Under local shell status, the current session file\'s \npath prompt is displayed in the terminal screen and local commands, such as open, telnet, ssh, and ping can \nbe executed.  \nTo end Xshell , select [Exit] from the [File] menu. \n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  181.\n2.\n3.\n•\n•\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n4.5 Session Management\nSession is a file containing information about remote host connection setup. By creating a session, users can set \ndifferent options for different remote hosts. The Sessions  dialog box shows all sessions created and enables to \ncreate and edit sessions. \nUsers can connect to a remote computer without creating a session. For this purpose, Xshell  provides a default \nsession which is ready to use after installation.\n5.1 Session Management\nTo Create a New Session:\nOpen the New Session Properties  dialog box by selecting [New] in the [File] menu.\nEnter connection information.\nClick [OK].\nTo Open the Sessions Dialog Box:\nSelect [Open] in the [File] menu.\nClick the standard [Open] button.\nTo Edit a Session:\nOpen the Sessions  dialog box.\nSelect a session to edit.\nClick the standard [Properties] button.\nClick [OK] after completing session editing.\nNote \nYou can edit multiple sessions simultaneously simply by selecting all the sessions you want to edit and \nclicking [Properties].\nTo Rename a Session:\nOpen the Sessions  dialog box.\nRight-click on the session to rename.\nSelect [Rename] in menu.\nNote \nSession name must be a valid file name.\nTo Copy a Session Under Different Name:\nOpen the Sessions  dialog box.\nSelect a session to copy under a different name.\nClick the standard [Save As] button.\nTo Delete a Session:\nOpen the Sessions  dialog box.\nSelect the session to delete.\nClick the standard [Delete] button.\nTo Create a Shortcut to Session:\nOpen the Sessions  dialog box.\nSelect a session for which to create shortcut.\nClick the standard [Create Shortcut] button.\nSelect a folder to save shortcut.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  195.\n•\n•\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n5.\n•\n•\n•Click [OK].\nTo Change Default Session Properties:\nTo open the default Session Properties  dialog box, select one of the following:\nSelect [Properties] from the [File] menu in local shell.\nClick the arrow next to the standard [Properties] button in the main toolbar and select [Default Session] \nfrom the list.\nNote\nDefault session is used when connecting with SSH, TELNET, RLOGIN and SFTP using a local prompt or the \nAddress Bar.\nTo use a connection command in the local prompt, see \'Xshell Local Command\' . For connections using the \naddress bar, see \'Address Bar\' .\nTo Create a New Session Folder:\nOpen the Sessions  dialog box.\nClick an arrow next to the standard [New] button and select [Folder] from the list.\nEnter folder name.\nTo Copy a Session file to Another Computer:\nSelect [Export] from the [File] Menu.\nIf you would like to use the session file\'s password on another device, set the Master Password.\nCopy a session file (*.xsh) or email it to another computer.\nOn the device to use the session file, set the exact same Master Password.\nSelect [Import] from the [File] Menu.\n5.2 Session Properties\nOpen the Session Properties  dialog box to create a new session or to edit a session. \nTo Open the Session Properties Dialog Box:\nSelect [New] from the [File] menu.\nSelect [Properties] from the [File] menu.\nClick the standard [Properties] button.\n5.2.1 Connection\nIn the connection settings, information about session connections may be set. In most cases, users can connect to a \nremote host with the connection settings only. \nName\nEnter an intrinsic name for the session. The name becomes the session file name, and must be comprised of a valid \ncharacters for a file name.\nProtocol\nSelect a connection protocol to use when connecting to a remote computer. The protocols supported are SSH, \nSFTP, TELNET, RLOGIN, SERIAL, and LOCAL. \nHost\nEnter host name or IP address of the remote computer. \nPort Number\nEnter the port number of the protocol selected above. When a protocol is selected from the protocols list, the \ndefault protocol port number is automatically entered. If a remote computer is using another port number, the port \nnumber must be directly entered. Default port numbers for each protocol are 22 for SSH/SFTP, 23 for TELNET, and \n513 for RLOGIN. SERIAL and LOCAL sessions do not require a port number.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  20\nDescription  \nAdd a short description about the session. This information will be displayed on the session tab after running the \nsession.\nReconnect  \nThis setting is used to restart the session if the connection is lost. Set the number of seconds desired between \nreconnection attempts. If a connection is not established during the user specified duration of minutes, the \nconnection will cease. If the specified time is set to 0, a connection will be attempted.\nUse Nagle\'s algorithm\nIf this option is selected, transfer efficiency may be slightly higher at the expense of a slower key response rate.\n5.2.2 Connection _ Authentication\nIn the user authentication settings, the authentication method, user name, password, user key, etc. may be \ndesignated \nMethod\nSelect an authentication method among Password, Public Key,  Keyboard Interactive , GSSAPI and PKCS11. If the \nselected authentication method is not supported by the SSH server, a dialog box asking about the user \nauthentication method is displayed during connection.\nNote\nIf the PC running Xshell is utilizing an Xshell supported Kerberos module, Xshell can only automatically \nauthenticate to the SSH server if GSSAPI authentication is selected.\nUser Name\nEnter a user name for login. User name is the remote computer login account. If this field is left blank, a dialog box \nasking for the user name is displayed during connection. \nPassword  \nEnter a remote user account password. This value is valid when Password  authentication is selected. If this field is \nleft blank, a dialog box asking for the user authentication is displayed during connection. The password is encoded \nand saved in the user\'s PC. For greater security, leave this field blank.\nUser Key\nSelect a user key to use when Public Key authentication is selected. If this field is left blank, a dialog box asking \nabout the user authentication is displayed during connection. If a user key is not in the list, a key must be created \nand registered in the remote SSH server. \nPassphrase\nEnter the passphrase for the selected user key. The entered key passphrase is encoded and saved in the user\'s PC. \nFor greater security, leave this field blank.\n5.2.3 Connection _ Authentication _ Login Prompts\nIt is necessary for Xshell  to recognize the server user name/password prompt in order to automate the login \nprocess for the TELNET or RLOGIN protocol. In general, the default value is used.\nTELNET\nEnter the user name and password prompt to automate TELNET login process. Note that blanks are recognized as \nvalid characters.\nRLOGIN\nEnter the password prompt for RLOGIN protocol. A password may not be needed depending on the RLOGIN server \nsettings. Note that blanks are recognized as valid characters.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  215.2.4 Connection _ Login Scripts\nFor the login script settings, commands to be automatically entered in the terminal may be defined. After a \nsuccessful login to a remote server, commands are sequentially executed in the order displayed in the list. This \nfeature is very useful when you login to another server after the first login to a remote server.\nExecute the Following Expect and Send Rule\nSelect this option to use expect and send rule.\nAdd\nOpen the Expect and Send Rule  dialog box. When rules editing is complete, the rule is added to the list.\nEdit\nOpen the Expect and Send Rule  dialog box and edit the selected rule.\nRemove\nDelete the Expect and Send Rule .\nMove up\nMove the Expect and Send Rule  up.\nMove Down\nMove the Expect and Send Rule  down\nExecute script when session starts.\nSet a script file to execute after a session connection.\n5.2.5 Connection _ SSH\nSet general SSH protocol options.\nRemote Command\nSpecify the remote command to run after connection.*\nProtocol Version Priority\nSelect which SSH version to prioritize. SSH2 is safer than SSH1 and offers more capabilities.\nUse Xagent (SSH Agent) for authentication\nPrivate keys for the public key authentication are provided by Xagent .* Using Xagent , entering a passphrase is not \nrequired during the public key user authentication process.\nAllow agent forwarding\nXagent allow the remote servers which are already connected with the SSH protocol to use its private keys. It can be \nused when connecting to another remote server or using a remote service through public key authentication from a \nremote server.*\nUse ZLIB Compression\nA compression algorithm is used to compress all SSH connection data. In an environment where network speed is \nslow, use this option to improve the speed.\nDo Not Allocate a Terminal\nSelect this option when not using terminal. If this option is turned on, a terminal(tty) for input/output is not \nassigned and thus input/output on the screen is not possible. Use this option if you want to use tunneling only \nwithout terminal access.\nAccept and save host key automatically upon first connection\nIf the option is turned on when connecting to a server where the host key is not registered, the host key is \nautomatically saved without going through the authentication process.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  225.2.6 Connection _ SSH _ Security\nEncryption\nEncryption algorithms are used to encrypt and decrypt network traffics. Users may select a preferred encryption \nalgorithm from the list. If <Cipher List>  is selected from the list, multiple algorithms may be attempted in the order \nappearing in the list. To edit the list of <Cipher List> , click [Edit].\nMAC (Message Authentication Code)\nMAC is added in SSH2 for greater security and to ensure data integrity. If <MAC List>  is selected from the list, \nmultiple algorithms are tried in the order appearing in the list. To edit the list of <MAC List> , click [Edit].\nKey exchange\nUsers can select the intial Key Exchange for the SSH connection. The desired algorithm can be selected from the list. \nIf the server does not support the selected algorithm, the connection will fail.\n5.2.7 Connection _ SSH _ Tunneling\nIn the tunneling setting, TCP/IP, Dynamic and X11 forwarding rules may be set. These settings are valid only when \nthe SSH protocol is selected in Connection setting. \nFor details on tunneling setting, see \'Tunneling Service\'.\n5.2.8 Connection _ SSH _ SFTP\nSet SFTP protocol related options.\nStartup Folder\nSet a local and remote folder with which to start after a successful login via SFTP protocol.\n5.2.9 Connection _ TELNET\nSet TELNET protocol related options.\nUse XDISPLOC Telnet Option\nUses XDISPLOC Telnet option to pass display (PC X server) information to server. If you are using a PC X server such \nas Xmanager , use this option to execute remote X11 applications from a local PC.\nDisplay\nEnter the DISPLAY value to pass upon login. $PCADDR value is translated automatically to IP address of a local PC \nright before it is passed to server. The DISPLAY number must match the DISPLAY number of the X server currently \nrunning on the PC.\nOption Negotiation\nThis option determines who initiates the attempt to negotiate additional TELNET options. When set to Active, after \na connection has started, Xshell intiates the negotation. Passive waits for the server to intiate the negotiation. The \nvalues may have to be different depending on the server or firewall settings. If both the server and Xshell are set to \nPassive, the negotiation will not proceed. Conversely, if Active is selected and the firewall is enabled on the server, \nthe negotiation may fail.\n5.2.10 Connection _ RLOGIN\nSet RLOGIN protocol related options.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  23Terminal Speed\nDesignate terminal speed to be passed to rlogin server.\n5.2.11 Connection _ SERIAL\nIn serial setting, serial connection options may be set. Instead of using the traditional terminal environment, \nRS232C SERAL connection lets you use your PC to connect to UNIX machines that has no graphic card support or \nwhere direct access to console is not available. To use Serial connection through Xshell , serial interface must be \ninstalled in the host system. \nFor details on serial setting, see \'Serial Connection\' .\n5.2.12 Connection _ PROXY\nProxy Server\nSelect a proxy server to use in this session. \nFor details on proxy setting, see \'Proxy Setting\' .\n5.2.13 Connection _ Keep Alive\nSend keep alive messages while this session is connected\nSend keep alive messages every user defined interval (seconds) to a remote computer. This is useful when a \nconnection is unexpectedly closed while the connection is idle. In some network environments, the gateway or \nfirewall system forces a disconnection if data transfer is not made for a defined period of time.\nSend string when network is idle\nCertain systems, if there is not user key input, the sessions is automatically determined to be idle and the sesion is \nended. Typically, the NF value, /n, is used.\nSend TCP keep alive packets when network is idle\nUsers cannot designate the interval or cycles in which keep alive packets are sent at the OS level.\n5.2.14 Terminal\nIn the terminal setting, terminal types and other related options may be set.\nTerminal Type\nSelect a terminal type to use. Xshell  supports VT100, VT102, VT220, VT320, ANSI, SCOANSI, LINUX and XTERM \nterminals. The terminal type may change after a connection is made depending on the remote user\'s settings. Users \ncan check the current terminal type using the echo $TERM command.\nTerminal Size : Columns\nEnter the number of columns in the terminal. The value is applied when the column size is fixed or if the terminal is \nreset after the connection is made.\nTerminal Size :  Rows\nEnter the number of lines in the terminal. The value is applied once the terminal is reset after the connection is \nmade.\nFixed column size\nWith this option selected and a connection established, even if the user changes the window size, the column size, \nspecified by the user, will not change. If the window size is smaller than the column size, a horizontal scroll bar will \nbe shown.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  24Reset terminal size when connected\nWhen a session is run, Xshell\'s window will be resized to the user defined terminal size.\nScroll Buffer  \nDesignate the row unit scroll buffer size.\nPush Erased Screen into Scroll Buffer  \nWith this option enabled, clearing the screen or resetting the terminal will push the contents into the Scroll Buffer. \nThe erased contents can be viewed again using the mouse scroll.\nEncoding\nSelect terminal output encoding. This value must be a language the remote server uses. If Default Language  is \nselected, Xshell  uses the Windows encoding.\nTreat Ambiguously  sized characters as wide\nCharacters without size information will be treated as 2-byte characters.\n5.2.15 Terminal _ Keyboard\nIn the keyboard settings, users may set the character strings sent by their PC\'s keyboard to the server.\nFunction Key Emulation\nSet function keys appropriate for your terminal type. If < Default > is selected, the function key is automatically \nassigned according to the terminal type designated in the \'Terminal\'  setting.\nSpecify an Alternate Key Mapping File\nUsing a custom key mapping file, users can manually assign a string to each function key (F1~F20) and it will be sent \nto the server when pressed.\nDelete Key Sequence, Backspace Key Sequence\nSelect a character string to be sent when the user presses the Delete or Backspace key.\nMeta Key Emulation\nTreat the Alt key as the Meta key for application programs which use meta keys, such as Emacs.\nUse Left ALT Key as Meta key\nTreat the Left Alt key as the Meta key.\nCtrl+Alt works as Alt Gr\nIf Ctrl + Alt are pressed simultaneously, it will be recognized as the Alt Gr key.\nUse Right ALT key as Meta key\nTreat the Right Alt key as the Meta key.\n5.2.16 Terminal _ VT Mode\nSet the initial values for each terminal mode.\nAuto Wrap Mode (DECAWM)\nActivate auto wrap mode at startup.\nOrigin Mode (DECOM)\nActivate origin mode. When this option is activated, the cursor moves based on the location designated by the \nserver.\nReverse Video Mode (DECSCNM)\nEnables Reverse Video Mode when the session starts. When this option is activated, the screen foreground and \nbackground colors are reversed.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  25New Line Mode (NLM)\nEnables New Line Mode when the session starts. When this option is activated, both CR and LF are sent when Enter \nkey is pressed. If this option is not selected, Enter key sends CR only.\nInsert Mode (IRM)\nEnables Insert Mode. When this option is selected, characters received from the remote server are inserted into \nwhere the cursor is located and the existing characters are not erased.\nEcho Mode (SRM)\nWhen this option is activated, a character string to send to server is displayed on screen and then transferred to \nserver.\nInitial Cursor Key Mode (DECCKM)\nSet initial cursor key mode value.\nInitial Numeric Keypad Mode (DECNKM)\nSet default setting for Keypad mode.\n5.2.17 Terminal _ Advanced\nSet advanced terminal options.\nRestrict Mouse Use at Terminal with Shift Key\nSome applications such as \'vi\' and \'mc\' can use mouse click and drag to make a selection or change the directory. \nWhen this option is selected, press the Shift key while using the mouse and Xshell  uses the mouse input to perform \nactions such as making selection on the screen.\nErase Screen Using Background Color\nUse the current terminal background color rather than the background color set in the color scheme when erasing \nscreen.\nReceive LF as CR+LF\nDisplay both CR and LF in the terminal screen when LF is received from the server.\nScroll to the Bottom when Pressing the Key\nScroll to the bottom of the terminal screen when a user enters a key.\nScroll to the Bottom at Terminal Input/Output\nScroll to the bottom of the screen when text is displayed on the terminal screen.\nEnable Destructive Backspace\nErase a letter to the left of the cursor, when the Backspace key is pressed, and move the cursor to the erased \ncharacter\'s position.\nDisable Blinking Text\nBlinking texts do not blink and are displayed with solid color.\nDisable Terminal Title Change\nDo not change the Xshell  title bar. In most cases, the title bar displays the folder and host name according to a \nrequest from a remote computer.\nDisable Terminal Printing Feature\nDisplay the terminal on screen without printing it when a request for terminal printing is received from server.\nDisable Switching to Alternate Terminal Screen\nDo not use an alternate screen for certain application programs, such as vi. When an alternate screen is used, and \nthe application is terminated, the terminal area goes back to the screen before the application is started.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  26Disable Terminal Size Change upon Request\nIgnore a terminal size change signal from the server.\nAnswerback to ^E\nFor output ^E (ENQ, Enquiry), most terminal emulators will answerback with its name. Xshell defaults to the same \nbehavior, but the user may define which characters to answerback with.\nUse the built-in font to draw line characters\nWhen outputting lines or boxes with line characters ( ─,│,┌┘,├, etc.) use Xshell\'s default font instead of the user \ndefined font.\nUse the built-in font to support Powerline\nEnable this option for a cleaner ouput when using Powerline.\n5.2.18 Appearance\nIn the appearance setting, the terminal window\'s colors and fonts may be set.\nColor Scheme\nSelect a color scheme. Xshell  provides several default color schemes. Add a new color scheme or edit an existing \ncolor scheme in the Select Color Scheme  dialog box.\nFont\nSelect a font to be used for Roman characters and ASCII numbers. Only fixed width fonts are listed. A font may also \nbe selected by pressing the standard [Fonts] button.\nAsian Font\nSelect the font to be used for non ASCII characters such as Chinese. If you change the font via the Standard Button \ntoolbar, this value will be replaced by the font selected for ASCII characters.\nFont Size\nSelect the desired font size. If the desired font size is not displayed, it can be manually entered.\nFont Quality\nSelect the quality of the characters displayed in the terminal.\nBold\nSelect a method to express bold characters.\nCursor Color\nSelect the cursor\'s color.\nText Color\nSelect the color for text within the cursor.\nUse blinking cursor\nEnable this option to have the cursor blink.\nSpeed\nSelect the speed at which to blink the cursor.\nAppearance\nSelect the type of cursor.\n5.2.19 Appearance _ Window\nIn the window settings, set the margins, spacing, tab color, and background of Xshell\'s  terminal window.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  27Margin\nSet terminal window margins.\nSpacing\nSet spacing between lines and characters outputted in the terminal window.\nTab Color\nSelect or choose the color of the session tab.\nBackground Image\nSelect a BMP image file to set as the terminal\'s background image.\nBackground Image\nSelect a BMP image file to set as the terminal\'s background image.\n5.2.20 Appearance _ Highlight\nHighlighting will highlight user defined keywords with color or font conversions. Set the Highlight Set to be used to \nmanage keywords to emphasize. For more information on settings keywords and managing highlight sets, see \n\"Highlight Set Settings .\"\n5.2.21 Advanced\nIn the advanced settings, set quick command sets, tracing, bell options, and log options.\nQuick Command Set\nSelect the default quick command set to be used in a session. The selected quick command set is displayed in the \nquick command bar when the session is started. For more information on quick commands and settings, see \n\"Quick Command Bar Settings.\"\nDisable Shortcut Key to Quick Command  \nCtrl+F1 and Ctrl+F2 keys are not used as shortcut keys to quick commands. The corresponding key values are sent \nto the server.\nXftp Option\nXftp can be called from Xshell using the current connection\'s information. When the Telnet and Rlogin protocols are \nbeing used, Xftp will utilize the FTP protocol. A port number other than 21 can be set here.\nSend Delay  \nPasting a large number of strings into a terminal may cause some of the data to be lost depending on the network \nor server environment. In this case, it is recommended to use Send Delay to manually delay the transmission.\nSend Delay : Character Delay\nSet the string paste delay between the characters in milliseconds.\nSend Delay :  Line Delay\nSet the string paste delay between lines in milliseconds.\nSend Delay : Prompt\nWhen pasting multiple lines in sequence, paste the following line only when this user defined string appears. Set a \n\"Max Wait\" time to withold pasting the following line if the specified string does not appear.\n5.2.22 Advanced _ Trace\nIn the tracing settings, set protocol tracing options. This feature is helpful when you want to trace detailed protocol \nmessages to solve a specific problem. A tracing message is displayed in the terminal screen.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  28•\n•\n•\n•SSH Version, Algorithm Exchange and User Authentication\nDisplay information about version exchange, encoding algorithm, compression method, and server and user \nauthentication.\nSSH TCP/IP and X11 Tunneling\nDisplay port forwarding information on screen.\nSSH Packet\nDisplay SSH Packet message ID information.\nTELNET Option Negotiation\nDisplay the TELNET option exchange process between Xshell  and the telnet server on the screen.\n5.2.23 Advanced _ Bell\nXshell incorporates several options to utilize the typical sytems\' bell sounds using the ASCII character number 7(Bell \ncharacter, ^G).\nBell Settings\nSelect how to acknowledge the bell character.\nNone (Ignore bell request)  : Do not respond to the server\'s bell character output\nDefault system alert sound  : Play Window\'s default alert sound\nPC Speaker  : Play the bell sound via the PC\'s speakers\nPlay the following sound  : Play a user defined .wav format file\nFlash window and taskbar if window is not focused\nIf the bell enabled window is behind another window or if the user is working on another program, the icon on the \nWindows taskbar and the window itself will flash to notifify the user that there was a bell ouput on the remote \nsystem.\nIgnore Bell\nNon system alerts and etc. may cause unintendedl bell rings due to incorrect output strings in the terminal. Time \nintervals can be set to avoid unintended bell rings.\nTemporarily disable the bell if the bell request is received more than once during the following time duration.\nAny bell requests made more than once during the time duration set here (seconds) will be ignored.\nRe-enable it after the following period of time.\nAfter a bell request has been ignored, bell requests will once again be accepted after no bell requests are made in \nthe time duration set here (seconds).\n5.2.24 Advanced _ Logging\nIn the logging settings, set the options related to log creation.\nFile Path\nSpecifies the path of the log file. The string conversion formats available at file creation are %n: session name, %Y: \ncurrent 4 digit year, %m: current 2 digit month, %d: current 2 digit day, %t: current time (%H-%M-%s), %h: current 2 \ndigit hour, %M: current 2 digit minutes, %s: current 2 digit seconds.\nOverwrite if the file exists\nIf a file with the same name exists in the destination folder, specify whether or not to overwrite the file. If this option \nis not selected, a sequence number is appended to the file name.\nStart Logging upon connection\nLogging is automatically started when a session is connected to a remote host.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  29•\n•Prompt me to choose a file path when logging starts\nA prompt will be displayed when logging starts which allows the user to specify where to save the log file rather \nthan the default path.\nInclude terminal code\nChoose one of the following logging methods.\nRecord only printable text\nRecord terminal code as well as printable text\nIf you include terminal code, all contents (color, string output status, etc.) will be recorded.\nTimestamp: Log file records\nLog file records will show the time the log was output.\nTimestamp : Format\nThis is how the the date and time are formatted: %n: session name, %Y: current 4 digit year, %m: current 2 digit \nmonth, %d: current 2 digit day, %t: current time(%H-%M-%s), %h: current 2 digit hour, %M: current 2 digit minutes, \n%s: current 2 digit seconds, %a: other OS expression for date and time, %I: line number.\nTimestamp: Preview\nDisplays the formatted timestamp based on current date and time.\n5.2.25 File Transfer\nThis sections deals with X/Y/Z modem protocol file transfers during a terminal connection.\nFolder\nWhen transferring a file from remote servers, users can specify whether to save to a predetermined path or to have \na prompt displayed so the user can specifiy each transfer.\nDuplicate file handling\nWhen a file with the same name exists, users can specify whether to automatically rename the file or to overwrite it.\nUpload protocol\nUser can upload local files by simply dragging and dropping the file into Xshell. Specify which protocol to use during \nthese uploads.\n5.2.26 File Transfer _ X_YMODEM\nSet various options for file transers using X/Y modem.\nOption\nSelect the packet size to be sent to the remote server. If 1024 bytes is selected, the transfer speed will be faster, but \nit must be supported by the server.\nUpload Command\nWhen using the XMODEM or YMODEM commands in the File Menu or when dragging and dropping, the selected file \nis automatically transferred. Set the commands the server will use to prepare to receive the files at this time. For X/Y \nmodem related commands, please refer to the related server manual.\n5.2.27 File Transfer _ ZMODEM\nIn the ZMODEM settings, set various options relating to ZMODEM file transfers.\n\nVersion 7 Help  –  Manual - Xshell\nSession Management   –  301.\n2.\n3.\n1.\n2.\n3.\n4.\n5.Activate ZMODEM Automatically\nAutomatically start file send when remote ZMODEM program starts send. If this option is not set, the file must be \nreceived by selecting [Send with ZMODEM] in the [File] > [Transfer] menu. X/YMODEM cannot automatically be \nreceived and so [Receive with X/YMODEM] must be selected\" from the [File] > [Transfer] menu.\n5.3 Export\nSessions exported by Xshell  are collected into a single convenient file. When this file is imported from another \ncomputer where Xshell  is installed, the imported sessions may be used without additional setup. However, the \npassword of the exported session file will not be available unless a Master Password has been set on the PC from \nwhich the session file was exported and the same exact Master Password has been set on the PC into which the \nsession file is imported.\nTo Export Session:\nSelect [Export] from the [File] menu. The Import/Export Sessions  wizard is displayed.\nSelect the position where the exported file is to be saved and click [Next]. Session export results will be \ndisplayed.\nNote\nIf \'Clear Password\'  is selected , the exported session file will not include the session password during \nthe export. Also, even if \'Clear Password\' is not selected, the password will only be evailable if \nimported into the same computer under the same user. To use the session with the session password \non another device you must first set a Master Password on the computer from which the session file \nis being exported and the same exact Master Password must be set on the computer into which the \nsession file is to be imported.\nClick [Finish] to complete sessions export.\n5.4 Import\nXshell  can import sessions exported by other computers.\nTo Import Session:\nSelect [Import] from the [File] menu. The Import/Export Sessions  wizard is displayed.\nDirectly enter the file path exported from other computer or click the […] button to select the exported file \nand click [Next]. Sessions are imported and the result is displayed.\nSelect how to handle sessions with the same file names.\nClick [Next] to select the types of sessions to import.\nClick [Finish] to complete session import.                                                                                                                                            \n                                                          \n\nVersion 7 Help  –  Manual - Xshell\nConnection   –  311.\n•\n•\n•\n1.\n•\n•\n•\n2.\n1.\n2.\n1.\n2.\n3.\n1.\n1.\n6 Connection\nXshell  provides various connection methods, such as the Sessions  dialog box, local prompt, address bar, links bar, \nand shortcuts to session.\n6.1 Connections without Session Files\nConnection from the  Local Prompt:\nEnter one of the following commands in the local prompt:\n[C:~]$ telnet hostname\n[C:~]$ ssh hostname\n[C:~]$ rlogin hostname \nNote\nA port number must be designated if a remote host does not use the default port number. For information \non commands, see \'Xshell Local Command\'.\nConnection from the Address Bar:\nEnter one of the following commands in the address bar:\ntelnet://hostname\nssh://hostname\nrlogin://hostname\nPress Enter or click [Connect].\nNote\nA user name and port number may be entered in the address bar. For details, see \'Address Bar\'.\nConnection from the Recent Sessions :\nSelect [Recent Sessions] in the [File] menu.\nUser authentication of the selected session is performed.\nNote\nIf user authentication is registered in the registration information of the selected session, step 2 is skipped.\n6.2 Connections with Session Files\nConnection from  the Sessions Dialog Box:\nOpen the Sessions  dialog box.\nSelect a session for connection.\nClick [Connect].\nNote\nIf a remote host connection already exists, a new tab is opened or a new Xshell  is started.\nConnection from  the Local Prompt:\nEnter the following command in Xshell  local prompt. [C:~]$ open session file name\nConnection from  a Shortcut:\nDouble-click the shortcut icon of a session.\nNote\nTo obtain information about shortcut to session, see \'Session Management\'.\n\nVersion 7 Help  –  Manual - Xshell\nConnection   –  321.\n2.\n1.\n2.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.\n11.\n12.\n13.\n1.\n2.\n3.\n4.\n5.\n6.\n7.Connection from the Session Manager:\nMake sure the \"Session Manager\" is enabled in the [View] menu.\nSelect the session you want to connect to and double-click or press the Enter key.\n6.3 Sessions to Run on Xshell Startup\nSelect \'Options\' from the [Tools] menu.\nIn the \'General\' tab, click \'Add\' and select session files to automatically connect upon Xshell startup.\n6.4 SERIAL Connection\nRS232C SERIAL connections lets you use your PC as a terminal when there is no video card in the UNIX system or if \nthe console is not directly accessible. To use SERIAL connections via Xshell , the SERIAL interface must be installed \nin the host system.\nTo Make Serial Connections:\nSelect [New] from the [File] menu . New Session Properties  dialog box is displayed.\nEnter a session name in [Session].\nSelect SERIAL from [Protocols] list.\nEnter a host name in [Host]\nSelect [SERIAL] from [Category].\nSelect the RS232C serial port number connected with the PC where Xshell  is installed from [Port]. If the port \nnumber is not in the list or if the name is the same as the named pipe, enter it manually.\nSelect communication speed in [Baud Rate]. The value must match the server value. In general, 9600 is used.\nSelect the transferred data unit bit count in [Data Bits]. It must match the server value.\nSelect number of bits to indicate the end of data unit in [Stop Bits]. Make a selection according to server \nsettings.\n[Parity] is to verify errors in transferred data. Select one from none, odd, even, mark and space according to \nserver settings.\n[Flow Control] is for controlling data communications. Supported flow control methods are XON/XOFF and \nRTS/CTS. If a flow control is not set(None), data may be lost if data is sent faster than the serial line.\nCreate a new session by clicking [OK].\nMake a connection as described in \'Connection with Sessions Files\'  with the created session.\n6.5 Connection with Kerberos\nXshell 6 supports MIT GSSAPI Kerberos and Microsoft\'s SSPI Kerberos authentication. This article assumes that you \nhave a working Kerberos server and client. \nTo create a new Kerberos session,\nSelect [New] from the [File] menu.\nEnter a session name in [Name].\nSelect SSH from the [Protocols] list.\nEnter a host name in [Host]\nSelect [Authentication] from under [Category].\nSelect GSSAPI  from the [Method] list.\nNote \nIf the PC running Xshell is utilizing an Xshell supported Kerberos module, Xshell can only \nautomatically authenticate to the SSH server if GSSAPI authentication is selected.\nTo change the GSSAPI settings, click the [Setup] button.\n\nVersion 7 Help  –  Manual - Xshell\nConnection   –  33\n8.\n9.\n10.\n11.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.\n11.\n12.\n1.\n2.\n3.\n4.Note \nTo connect to another server using Kerberos authentication from a server using Kerberos \nauthentication, select the \'Allow GSSAPI credential delegation\' option.\nClick [OK] to save the GSSAPI settings.\nEnter the user name.\nClick [OK] to save the session file.\nClick [Connect] to connect immediately or select the session file from the Sessions Dialog Box to connect.\nYou have finished creating a session that will use the Kerberos module. When this session opens, it will try to use the \nKerberos credential for the specified user. It has to be the same user you defined in the Network Identity Manager.\n6.6 Connection with PKCS _11\nPKCS #11 is one of the public key cryptography standards. Xshell 6 can connect to a remote SSH server using a PKCS \n#11 encrypted hardware security token (HSM) or a smart card\'s RSA key. \nTo create a new PKCS #11 session:\nSelect [New] from the [File] menu.\nEnter a session name in [Name].\nSelect SSH from the [Protocols] list.\nEnter a host name in [Host]\nSelect [Authentication] from under [Category].\nSelect PKCS11  from the [Method] list.\nClick the [Setup] button.\nEnter the path of the middleware program that can connect to the hardware token that contains the user \nkey. Or click […] to browse for it.\nIf the pin number is set in the hardware token, enter the pin number.\nEnter the user name.\nClick [OK] to save the session file .\nClick [Connect] to connect immediately or select the session file from the Sessions Dialog Box to connect.\n6.7 Proxy Setting\nProxy server mediates between a network to which a user belongs and an external network to be connected with. \nAdd, edit and delete a proxy server in Proxy List  dialog box.\nTo Add Proxy Server:\nIn [Connection > Proxy] category of Session Properties  dialog box, click [Browse] in [Proxy Server].\nClick [Add] in Proxy List  dialog box. Proxy Settings  dialog box is displayed.\nEnter proxy server name, proxy server type, host information and user information.\nPress [OK] to add proxy server.\n6.8 Jump host\nThe Jump Host feature is a proxy feature that allows you to utilize an intermediate SSH server in order to reach the \nfinal destination server. As it uses Open-SSH’s TCP Tunneling, this feature can be used to connect to servers that \ncannot directly connect to the firewall or network configuration.\nTo Connect Using the -J Parameter from the Local Shell:\n\nVersion 7 Help  –  Manual - Xshell\nConnection   –  341.\n1.\n2.\n3.\n4.\n5.\n6.In the local shell, type ssh -J user1: passwd1 @ jump_host1, user2: passwd2 @ jump_host2 \ndestination_host.\nTo Connect Through a Proxy:\nSelect [New…] from the [File] meun.\nEnter the host of the destination server in [Host].\nSelect [Browse] in [Proxy Server].\nSelect [Add] to open the proxy creation window.\nIn [Proxy Settings], change [Type] to JUMPHOST and enter the remaining required information.\nFig 1: Proxy Settings Screen\nSet the created proxy as the default in [Proxy Server].\n\n\n2 http://ssh.comVersion 7 Help  –  Manual - Xshell\nSecurity   –  351.\n2.\n•\n•\n•\n1.\n2.\n3.\n4.\n5.\n6.\n1.\n2.7 Security\nXshell  provides public key user authentication. Host keys and user key databases created in Xshell  may be used in \nXmanager  and Xftp  programs. Once a public key is created, it may be used in other programs without any \nadditional configuration.\n7.1 Public Key User Authentication0\nFor public key user authentication, a pair of user keys must be created comprised of a public key and a private key. \nWhile public key authentication is carried out, the private key is used by Xshell  to create a user signature and the \npublic key is used by the SSH server to check the signature. \nA user key may be created from the SSH server or Xshell . If the user key is created from the server, the private key \nmust be registered in the Xshell  private key repository using Xshell  import. If the user key is created from Xshell , \nthe public key must be registered in the server. \nTo Create a User Key:\nSelect [New User Key Wizard] from the [Tools] menu.\nCreate a user key according to instructions given by the New User Key Wizard .\nNote \nRegister a public key on a server at the last stage of key creation. Registration methods vary depending on \nserver types. \nSSH1 : Copy the public key text and save it to $HOME/.SSH/authorized_keys file. Execute the following \ncommand to turn off the write permission of the files and directories.  \n$ cd\n$ chmod go-w . .SSH .SSH/authorized_keys\nSSH2-OpenSSH : OpenSSH servers use this format. Copy the public key text and save it to \n$HOME/.SSH/authorized_keys2 file. Execute the following command to turn off the write permission \nof the files and directories.  \n$ cd\n$ chmod go-w . .SSH .SSH/authorized_keys2\nSSH2-IETF SECSH : Certain commercial SSH servers, such as ssh.com2 server, use this format. Save a \npublic key under an intrinsic name, such as mypublickey.pub and copy it to $HOME/.ssh2 directory. \nAdd the following line to  $HOME/.ssh2/authorization file:  \nKey mypublickey.pub  \nExecute the following command to turn off the write permission of the files and directories. \n$ cd  \n$ chmod go-w . .ssh2$ chmod go-w .ssh2/authorization .ssh2/mypublickey.pub\nTo Register a Public Key in a Server:\nOpen the User Keys  dialog box by selecting [User Key Manager] from the [Tools] menu.\nSelect a user key to register.\nClick [Properties]. The User Key Properties  dialog box is displayed.\nClick the [Public Key] tab.\nSelect an appropriate type from the [Public Key Format] list.\nClick [Save as a file] to save or copy the key content and register the key to the server according to the public \nkey registration method above.\nTo Change the User KeyPassphrase:\nOpen the User Keys  dialog box.\nSelect a user key for which to change the passphrase.\n\n3 http://SSH.comVersion 7 Help  –  Manual - Xshell\nSecurity   –  363.\n4.\n5.\nClick [Properties]. The User Key Properties  dialog box is displayed.\nClick the [General] tab.\nClick [Change Passphrase].\nNote\nImport, export, rename, delete, and create a user key in the \'User Keys Dialog Box \'.\n7.1.1 User Keys Dialog Box\nThe User Keys  dialog box enables the creation and management of user keys. Open this dialog box by selecting \n[User Key Manager] from the [Tools] menu.\nImport\nSelect a user key file and import it by opening the Open  dialog box. Currently, Xshell  can read the SSH1 protocol \nRSA key, the OpenSSH SSH2 protocol RSA/DSA key, the SSH.com3 key and the NetSarang Computer user key \nformats(*.pri).\nExport\nSave a selected user key file by opening the Save  dialog box. Exported file types are NetSarang user keys or the \nOpenSSH SSH2 format. NetSarang Computer user key format files(*.pri) can be used in programs developed by \nNetSarang Computer, Inc.\nDelete\nDelete a selected user key from database.\nRename\nRename a selected user key. Key name must be valid as a file name.\nProperties\nShow user key attributes. Type, length, fingerprint, and public key may be viewed, and the key passphrase may be \nchanged.\nGenerate\nOpen the New User Key Wizard .\n7.2 Host Key Management\nA host key is a remote host public key, and users can verify the host via its fingerprint. When a connection is made, \nthe remote host sends its public key to Xshell . When the host key is valid and you trust it, you can save the host key \nto the database in Xshell . If a host key is not saved in the database, the SSH Security Warning  dialog box will \nappear when you try to connect to the host.\n7.2.1 SSH Security Warning Dialog Box\nThe SSH Security Warning  dialog box is displayed when a remote host key is not saved in the host key database or \nthe fingerprints of the remote host key and the saved host key are different.\nAccept Once\nAccept host key for this connection only. The host key is not saved and the same dialog box opens at the next \nconnection. This is useful when a server host key changes often or the user rarely connects to the server.\n\nVersion 7 Help  –  Manual - Xshell\nSecurity   –  37\n1.\n2.\n3.\n4.\n5.\n6.\n1.Accept and Save\nSave host key and process the connection. This dialog box does not open on the next connection. This is useful \nwhen the fingerprint is correct and the user connects to the host frequently.\nCancel\nHost key is not accepted and connection is cancelled.\n7.2.2 Host Keys Dialog Box\nThe Host Keys  dialog box permits users to manage host keys of remote hosts to which connection is allowed.\nImport\nImport a host key by opening the Open  dialog box. The imported host key is saved in the host key database. Files \nsaved in the SECSH public key format can be imported.\nExport\nExport a selected host key by opening the Save  dialog box. The exported keys are saved in the SECSH public key \nformat and can be used in other programs.\nRemove\nRemove a selected host key from the database.\nView\nOpen a selected host key with notepad.\n7.3 Master Password\nMaster password can be used to save passwords more securely using the user defined master password . Xshell\nsaves all password information in an encrypted format. However, since passwords are encrypted using a fixed key, \nit has a risk of being exploited by hackers. When the master password is enabled and set, it is mixed in during \npassword encryption adding an additional layer of security. \nMaster password uses a user defined keyword to encrypt the password section of the session data. When the master \npassword is enabled, Xshell asks for the master password every time a new Xshell instance is started and a session \nis open. If the correct master password in not inputted, the session\'s password is not able to be utilized and must be \nentered again manually preventing unauthorized access.\nNote\nBe sure to remember your master password. If you lose your master password, there is no way to retrieve \nthe password information stored in the session files. Maser Password settings are applied simultaneously to \nXmanager, Xshell, and Xftp sessions.\nTo Enable Master Password:\nClick on the Tools  menu and then select Options .\nSelect the Security  tab.\nClick Set Master Password  to open the Master Password dialog box.\nIn the Master Password  dialog box, enter a new master password in the New Password  field.\nIn the Confirm Password  field, enter the new password again.\nClick OK to save the changes.\nOnce master password is enabled, all sessions saved in the default location are re-encrypted using the new master \npassword. \nTo Change Master Password:\nClick on the Tools  menu and then select Options .\n\nVersion 7 Help  –  Manual - Xshell\nSecurity   –  382.\n3.\n4.\n5.\n6.\n7.\n8.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n5.\nSelect the Security  tab.\nClick Set Master Password  to open the Master Password dialog box.\nIn the Change area click Change  to open the Master Password Change dialog box..\nEnter the current master password in the Current Password  field.\nEnter the new master password in the New Password  field.\nEnter the new password one more time in the Confirm Password  field.\nClick OK to save the changes.\nTo Disable Master Password:\nClick on the Tools  menu and then select Options .\nSelect the Security  tab.\nClick Set Master Password  to open the Master Password dialog box.\nClick the Remove  button to open the Remove Master Password dialog box.\nIn the Remove Master Password dialog box, enter the master password and click OK.\nTo Reset the Master Password:\nClick on the Tools  menu and then select Options .\nSelect the Security  tab.\nClick Set Master Password  to open the Master Password dialog box.\nClick the Reset  button to open the Reset Master Password dialog box.\nIn the Reset Master Password dialog box, click Reset Master Password  and click OK.\nNote\nReset of the master password can be used if your forgot your master password or if you would like to clear \nall the passwords stored in your sessions.\n\nVersion 7 Help  –  Manual - Xshell\nTab Management   –  39•\n•\n•\n•\n•\n1.\n2.\n1.\n2.\n1.\n2.\n3.8 Tab Management\nXshell  has a powerful tab management feature. You can connect to multiple hosts and compare them side by side \nfrom a single window. The intuitive tab management feature is a unique Xshell feature that cannot be found in \nother terminal emulators. \nEach tab is associated to a single terminal and it belongs to a tab group. A tab group is a collection tabs. A single \nXshell window can have multiple tab groups and can be organized as desired. \n8.1 Tab\nThere are several ways you can create a new tab. You can use any of the following methods:\nClick the [Tab] menu and select [New Tab]\nDouble click on the tab bar in the background.\nUse the keyboard shortcut, Shift + Alt + N.\nTo close a Tab:\nClick the x button on the tab.\nWhen focus is on the tab, press Ctrl+Shift+F4.\nTo close a tab from Terminal:\nWhile connected to the remote host, enter \'exit\'.\nIn Xshell\'s local shell, type \'exit\' again.\nNote\nTo close a tab from Terminal, you must not have selected the \'Revert to local shell when connection is \nclosed\' option in the [Options] dialog box. Also, if the \'Exit Xshell when the last tab is closed\' option is not \nselected, you must select \'Exit\' from the \'File\' menu to exit Xshell.\n8.2 Tab Group\nA tab group is collection of multiple tabs. Use tab groups to neatly organize sessions. Only one tab from the tab \ngroup is visible at any given moment. To view and compare multiple tabs simultaneously, you must separate the \ntabs into different groups.\nTo Create a New Tab Group:\nRight click on the tab background.\nPoint to [New Tab Group] and select a location you want to create a new tab group.\nNote\nIf you want to create a new tab group with an existing tab, you can drag a tab to edge of the terminal until \nyou see the blue marker and drop it.  \nTo Move a Tab to a Different Tab Group:\nSelect a tab you want to move to a new tab group.\nWhile holding down the left mouse button, drag the tab to a different tab group.\nDrop the tab to a new tab group.\nTo Delete a Tab Group:\n\nVersion 7 Help  –  Manual - Xshell\nTab Management   –  401.\n2.\n3.\n1.\n2.\n1.\n2.\n1.\n2.\n1.\n2.\n1.\n2.Select a tab group you want to close.\nRight click on the tab group in the background.\nSelect the [Close This Tab Group] option.\nTo Combine All Tab Groups into one Tab Group\nSelect the Xshell window you would like to combine tab groups.\nIn the [Tab] menu, select \'Merge All Tab Groups\' under \'Arrange.\'\n8.3 Split and Merge Tabs\nTabs can be separated to create new windows and you can combine tabs from different windows into one window. \nTo use this feature, you must turn off the \'Use single-process mode for better performance\' in [Options > \nAdvanced].  \nTo Detach a Tab and Create a New Window:\nSelect the tab you want to detach with the mouse.\nDrag the tab and drop it outside of the Xshell Window.\nTo Detach and Tab and Add it to an Existing Window:\nSelect the tab from an Xshell Window.\nDrag the tab and drop it into a tab group of an existing Xshell Window.\n8.4 Arrange Tabs\nMultiple tabs can be automatically arranged into horizontal, vertical, or tiled tab groups. This is useful for \nconcurrent operations on multiple servers.\nTo Arrange Tabs Horizontally, Vertically, or Tiled:\nSelect the Xshell window to be arranged.\nIn the [Tab] menu, under \'Arrange,\' select the desired arrangement method.\nTo Combine an Auto-Arranged Group of Tabs into One Tab Group:\nSelect the Xshell window to be arranged.\nIn the [Tab] menu, under \'Arrange,\' select \'Merge All Tab Groups.\n\nVersion 7 Help  –  Manual - Xshell\nTunneling Service   –  41\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.\n11.\n12.\n1.\n2.\n3.\n4.\n5.\n6.\n1.\n2.\n3.\n4.\n5.\n6.9 Tunneling Service\nXshell  provides TCP/IP and X11 forwarding functions, which creates a secure tunnel between a user\'s PC and \nanother computer connected across an unreliable network enviornment providing a way to safely transmit data.\n9.1 TCP_IP Port Forwarding\nTo use port forwarding service via a secure tunnel, define port forwarding rules for each application program.\nNote\nFor local forwarding, connection to a local PC\'s  listening port  is forwarded to a specific destination host port.\nFor remote  forwarding, connection to the remote host listening port is forwarded to a specific destination \nhost port.\nDynamic forwarding works the same as local forwarding. It automatically determines the host of delivery \ndestination and port according to the SOCKS protocol. The default port number of SOCKS protocol is 1080.\nTo Add a New Port Forwarding Rule to a Session:\nOpen the Sessions  dialog box.\nSelect a session for which to edit port forwarding rule.\nClick the standard [Properties] button.\nSelect [Connection > SSH > Tunneling] from [Category].\nClick [Add] to open the Forwarding Rule  dialog box.\nSelect connection type from the [Type] list.\nEnter the localhost or IP address in [Source Host].\nEnter the port number in [Listening Port] or select a service name.\nEnter the name of the host or IP address where the server program operates in [Destination Host].\nEnter the port number where server program is waiting in [Destination Port].\nEnter a description of the forwarding rule in [Description].\nClick [OK].\nTo Change Forwarding Rule:\nOpen the Sessions  dialog box.\nSelect session for which to edit port forwarding rule.\nClick the standard [Properties] button.\nSelect [Connection > SSH > Tunneling] from [Category].\nSelect a forwarding rule to change.\nClick [Edit].\nTo Remove Port Forwarding Rule:\nOpen the Sessions  dialog box.\nSelect session for which to edit port forwarding rule.\nClick the standard [Properties] button.\nSelect [Connection > SSH > Tunneling] from [Category].\nSelect a forwarding rule to remove.\nClick [Remove].\n9.2 X11 Forwarding\nX11 forwarding is a special TCP/IP port forwarding case. The X11 protocol is used by a PC X server software, such as \nXmanager, and the connection is established to a user PC from a remote host. It is thus the reverse situation from \nother client programs, such as email or telnet. Using X11 forwarding, remote X11 application programs can be used \n\nVersion 7 Help  –  Manual - Xshell\nTunneling Service   –  421.\n2.\n3.\n4.\n5.\n6.\n7.\n1.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\nin a user\'s PC via a secure encoding tunnel without complicated port forwarding settings.                                                    \nTo use the X11 forwarding service, you should configure both Xshell  and the SSH server.\nTo Activate X11 Forwarding in Xshell:\nOpen the Sessions  dialog box.\nSelect a session for which to activate X11 forwarding.\nClick the standard [Properties] button.\nSelect [Connection > SSH > Tunneling] from [Category].\nSelect [Forward X11 Connections to].\nIf Xmanager® is installed in the user\'s PC, select [Xmanager]. If another PC X server is used, select [X DISPLAY] \nand enter an appropriate DISPLAY.\nClick [OK].\nNote\nIn Xmanager, Xshell automatically finds the X DISPLAY option. In other PC X server programs, the option \nmust be set  manually. If PC X server uses TCP 6000 port, DISPLAY is set as \'localhost:0.0\'.\nTo Activate X11 Forwarding in an  OpenSSH  Server:\nOpen the /etc/ssh/sshd_config file.\nSet X11Forwarding option value as follows: X11Forwarding yes\nRestart SSH server.\nTo Activate X11 Forwarding in an ssh.com Server:\nOpen the /etc/ssh2/sshd2_config file.\nSet AllowX11Forwarding option value as follows: AllowX11Forwarding yes\nRestart SSH server.\n9.3 SOCKS4_5 Dynamic Port Forwarding\nDynamic port forwarding is a method to forward a local network connection to an SSH server, where the \ndestination host and port are automatically determined by the SOCKS protocol. Using dynamic port forwarding, \nXshell  can operate as a SOCKS proxy server.\nTo Add New Dynamic Port Forwarding Rule to a Session:\nOpen the Sessions  dialog box.\nSelect a session for which to edit port forwarding rule.\nClick the standard [Properties] button.\nSelect [Connection > SSH > Tunneling] from [Category].\nOpen the Forwarding Rule  dialog box by clicking [Add].\nSelect Dynamic (SOCKS4/5)  from [Type] list.\nEnter port number in [Listening Port] or select a service name. The SOCKS proxy server default port is 1080.\nClick [OK].\nNote\nFor dynamic port forwarding, the destination host and port do not need to be entered.\n9.4 Instant Tunneling\nInstant tunneling enables users to add, remove, suspend, and resume a forwarding rule while a session is \nconnected. The current session tunneling status can be checked in the tunneling pane. To view the tunneling pane, \nselect [Tunneling Pane] from the [View] menu.\n\nVersion 7 Help  –  Manual - Xshell\nTunneling Service   –  431.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\nTo Add Port Forwarding Rule in the Tunneling pane:\nClick the [Forwarding Rules] tab in the tunneling pane.\nRight-click on the list.\nSelect [Add] from menu. Forwarding Rule  dialog box is displayed.\nNote\nNewly added rules are applied to the current connection. Unless you save the rules,  they are deleted when \nthe connection is closed.\nTo Remove Port Forwarding Rules from the Tunneling pane:\nClick the [Forwarding Rules] tab in the tunneling pane.\nRight-click on a rule to remove from the [Forwarding Rules] list.\nSelect [Remove] from menu.\nTo Suspend Port Forwarding Rules:\nClick the [Forwarding Rules] tab in the tunneling pane.\nRight-click on a rule to suspend from the [Forwarding Rules] list.\nSelect [Suspend] from menu.\nTo Retry Port Forwarding Rules:\nClick the [Forwarding Rules] tab in the tunneling pane.\nRight-click on a rule to resume in the [Forwarding Rules] list.\nSelect [Resume] from menu.\nNote\nResume can only be executed for a previously suspended rule.\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  441.\n•\n•\n•\n•\n1.\n2.\n1.\n2.\n•\n•\n•\n•\n•\n1.\n2.\n•\n•\n1.\n•\n•\n•\n•10 Terminal Window Operations\nXshell  provides a succinct and powerful terminal window enabling users to simultaneously use the remote terminal \nand local prompt command interface. Terminal window provides a range of convenient functions, such as copy & \npaste, find character string, change font and font color, and advanced terminal options.\n10.1 Copy and Paste\nTo Select a Character String:\nDo one of the following:\nPress the left mouse button at the starting point of an area to select. While pressing the button, move \nthe mouse to the end of the area to be selected and release the button. The selected character string \nis displayed in an inverted color.\nClick the left mouse button at the starting point of an area to select. Move mouse to the end of the \narea. While pressing Shift key, press the left button once again.\nDouble-click a word to select. The double-clicked word is selected.\nTriple-click a row to select. The entire row is selected.\nTo Select Character Strings in a Column Unit:\nPress Alt key.\nPress the left mouse button at the starting point of an area to select. While pressing the button, move to the \nend of the area to select and release the button.\nTo Copy Selected Character Strings to the Windows Clipboard:\nSelect a character string to copy.\nDo one of the following:\nClick the [Smart Selection] button and select [Copy].\nSelect [Copy] from the [Edit] menu.\nClick the standard [Copy] button.\nPress Ctrl+Insert key.\nIf [Copy Selected Texts to the Clipboard Automatically] is set in options, the selected text is \nautomatically copied.\nTo Copy Selected Character String to Notepad:\nSelect a character string to copy.\nDo one of the following:\nClick the [Smart Selection] button and select [To Text Editor].\nPoint to [To Text Editor] in the [Edit] menu and select [Selected Area].\nNote\nThe  scroll buffer and current screen  may be copied as well as the selected character strings. A notepad \nwindow is automatically displayed with the copied text. This does not copy character strings to the \nclipboard.\nTo Paste Clipboard Contents to the Terminal Screen:\nDo one of the following:\nSelect [Paste] from the [Edit] menu.\nClick the standard [Paste] button.\nPress Shift+Insert key.\nIf Paste the clipboard contents  is selected for middle or right mouse button operation, click the \ncorresponding mouse button.\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  451.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n1.\n•\n•\n1.\n2.\n3.\nTo Set Xterm  Style Copy and Paste:\nOpen the Options  dialog box.\nClick the [Keyboard and Mouse] tab.\nSelect [Mouse] – [Middle Button] operation as Paste the clipboard contents .\nSelect [Selection] - [Copy Selected Texts to the Clipboard Automatically].\nClick [OK].\nNote\nWhen a character string is selected, the  xterm  program copies it to clipboard. When the middle mouse \nbutton is pressed, it is pasted to the terminal screen.\n10.2 Find String\nSearch scroll buffer using a specific keyword or a regular expression.\nTo Find with Keyword:\nSelect [Find] from the [Edit] menu.\nEnter a keyword in Find  dialog box.\nClick [Find Next].\nTo Find with Regular Expression:\nSelect [Find] from the [Edit] menu.\nEnter a keyword in Find  dialog box.\nSelect [Regular Expression].\nClick [Find Next].\nNote\nFor detailed information on regular expression, see \'Regular Expression\'.\n10.3 Font Change\nIn the terminal screen, characters must be displayed in rows and columns. In Xshell , only fixed width fonts may be \nselected.                                                                                                                                                                               \nTo Change Terminal Font and the Font Size:\nDo one of the following:\nClick the standard [Fonts] button and select a font and the font size.\nSelect [Appearance] in Session Properties  dialog box and select a font and the font size.\nTo Change Bold Text:\nOpen the Session Properties  dialog box.\nSelect [Appearance] from [Category].\nSelect an option from [Bold] field.\nNote\nAs for Bold, either colors or bold font or both may be used.\n10.4 Font Color and Background Color Setting\nIn a color scheme, font colors, background colors and ANSI 16 colors are saved. Xshell  enables users to select/\nchange color schemes anytime while using Xshell. The selected color scheme is applied immediately.\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  461.\n•\n•\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n5.\n6.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n5.To Change Terminal Color:\nDo one of the following:\nClick the standard [Color Schemes] button to display the Select Color Scheme  dialog box. Select a \ncolor scheme in the dialog box and click [OK].\nSelect [Appearance] from [Category] in Session Properties  dialog box, select a color scheme from \nthe [Color Scheme] and click [OK].\nNote\nXshell  provides several default color schemes. Users may edit the existing color schemes or create new color \nschemes.\nTo Create New Color Scheme:\nOpen the Select Color Scheme  dialog box.\nClick [New]. A new color scheme is added to the list.\nSelect the new color scheme created.\nClick [Edit]. Edit Color Scheme  dialog box is displayed.\nTo Edit Color Scheme:\nOpen the Select Color Scheme  dialog box.\nSelect a color scheme to edit.\nClick [Edit]. Edit Color Scheme  dialog box is displayed.\nSelect colors for normal text in [Normal Text].\nSelect colors for bold text in [Bold Text]. In general, colors lighter than the normal text are used for bold text.\n[ANSI Colors] is used to express ANSI color code in terminal. The colors on top are for normal text, such as \nblack , red, green , yellow , blue , magenta , cyan  and white , and the colors on the bottom are for bold text.\nTo Export Color Scheme:\nOpen the Select Color Scheme  dialog box.\nSelect a color scheme to export.\nClick [Export]. Save  dialog box is displayed.\nSelect a folder and enter the file name to save.\nClick [Save].\nNote\nExported file is in \'.xcs\'  format and may be used in Xshell only. A number of color schemes may be saved in a \nsingle file. The color scheme names  are also saved in the file.\nTo Import Color Scheme:\nOpen the Select Color Scheme  dialog box.\nClick [Import]. Open  dialog box is displayed.\nSelect a color scheme file (.xcs) to import.\nClick [Open].\n10.5 Cursor Change\nTo Change Cursor Color:\nOpen the Session Properties  dialog box.\nSelect [Appearance] from [Category].\nSelect [Cursor Color] value.\nSelect [Text Color] value.\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  471.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n1.\n1.\n1.To Change Cursor Blinking:\nOpen the Session Properties  dialog box.\nSelect [Appearance] from [Category].\nSelect or deselect [Use blinking cursor].\nClick [OK].\nTo Change Cursor Blinking Speed:\nOpen the Session Properties  dialog box.\nSelect [Appearance] from [Category].\nCheck [Use blinking cursor].\nEnter cursor blinking speed by millisecond in [Speed].\nClick [OK].\n10.6 Window Handling\nTo Minimize to Notification Area:\nOpen the Options  dialog box.\nClick the [Advanced] tab.\nCheck [Send to the notification area when minimized] in [Window] options.\nSave changes by clicking [OK].\nTo Minimize to Notification Area at Startup:\nOpen the Options  dialog box.\nClick the [Advanced] tab.\nCheck [Minimize to the notification area at Xshell startup] in [Window] options.\nSave changes by clicking [OK].\nTo Exit Xshell when All Connections  are Closed:\nOpen the Options  dialog box.\nClick the [Advanced] tab.\nCheck [Exit Xshell when all connections are closed] in [Session] options.\nClick [OK].\nTo Exit to Local Shell when Connections are Closed:\nOpen the Options  dialog box.\nClick the [Advanced] tab.\nCheck [Revert to local shell when connection is closed] in [Session] options.\nClick [OK].\nTo Create New Xshell Window:\nSelect [New Window] from the [Window] menu.\nTo Move to Another Xshell Window:\nSelect [Next] or [Previous] from the [Window] menu.\nNote\nThe same function may be executed using Alt+Right and  Alt+Left keys.\nTo Close All Xshell Windows Simultaneously:\nSelect [Close All] from the [Window] menu.\nTo Close All Xshell Windows Except the Current Window:\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  481.\n1.\n2.\n3.\n4.\n1.\n2.\n1.\n2.\n1.\n2.\n1.\n•\n•\n•\n•\n1.Select [Close All but This] from the [Window] menu.\n10.7 Multi-session Handling\n\'Multi-session\' enables users to work and move between sessions using the sessions tab  or sessions bar  while \nmaintaining multiple connections in a single Xshell  window. \nTo Open the Multiple Sessions in Single Xshell Window:\nOpen the Options  dialog box.\nClick the [Advanced] tab.\nCheck [Open multiple sessions in a single Xshell window] in [Session] options.\nSave changes by clicking [OK].\nTo Create a New Connection in Sessions Tab:\nClick the [+(Add Tab)] button at the far left of the sessions tab .\nSelect one from sessions list. The selected session is opened in a new tab.\nTo Create New Connection in Sessions Bar:\nClick an icon at the far left of the sessions bar .\nSelect one from the sessions list. The selected session is opened in a new tab.\nNote\nTo create a new connection, use a session as described in \'Session Management\' or try a connection without \na session.\nTo Connect with a Remote Computer by Entering a Command in Local Shell:\nTo open a local shell, click the [+(Add Tab)]  button of the sessions tab  and select [Local Shell] or double-\nclick a blank in the sessions tab .\nIn the local command prompt, connect to a remote computer using commands, such as ssh, telnet and sftp. \nFor details on using command, enter \'?\'.\nNote\nFor detailed information on local commands, see \'Xshell Local Command\'.\nTo Move Between Sessions at Multi-session Connection:\nDo one of the following:\nClick a sessions tab.\nClick a session button from the sessions bar.\nUse Ctrl+Tab, Shift+Tab or Ctrl+Shift+Tab.\nMove between sessions using Alt+\'session number\'.\nTo Connect with Session in New Xshell Window:\nSelect [New Terminal] from the [Window] menu or click the standard [New Terminal] button. A new Xshell\nwindow opens and connection is attempted with the same session information as the currently connected \nsession.\n10.8 Quick Command Sets Setting\nBy designating frequently used character strings as quick commands, Users can avoid repeated keyboard inputs \nand use simple mouse clicks to execute the commands. To display quick commands bar, check [Quick Commands] \nin the [View] menu.\nTo Add Quick Command Set:\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  491.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n1.\n1.\n2.\n3.\n4.\n5.Select [Quick Command Sets] in the [Tools] menu. Quick Command Sets  dialog box is displayed.\nClick [New].\nEnter the new quick command set name.\nNote\nTo open the Quick Command Sets  dialog box, click the [Quick Command Set] button(an icon at the far left) \nin the quick commands bar and select [Browse] from the list.  \nTo Add Quick Command on Quick Commands Bar:\nClick an undefined Quick Command button in the quick commands bar or press a shortcut key (Ctrl+F1, \netc.). Edit Quick Command  dialog box is displayed.\nEnter the quick command name in [Label] and a frequently used command or character string in [Action] \narea.\nClick [OK].\nNote\nTo edit the quick command set displayed in the quick commands bar, click the [Quick Command Set] \nbutton(an icon at the far left) on the bar and select [Edit] from the list. Edit Quick Command Set  dialog box \nis displayed.  \nThe order of quick commands listed in the quick command bar  can be changed by dragging button.  \nTo Add Quick Command to Quick Command Set:\nSelect [Quick Command Sets] from the [Tools] menu. Quick Command Sets  dialog box is displayed.\nSelect a quick command set to which a quick command is to be added.\nClick [Edit]. Edit Quick Command Set  dialog box is displayed.\nSelect a quick command and click [Edit]. Edit Quick Command  dialog box is displayed.\nEnter the quick command name in [Label] and a frequently used command or character string in [Action] \narea.\nNote\nYou can use the %HOSTNAME variable to pass the host name of your PC. For example, if the host name for \nyour PC is \'COMPUTER_A\', then if you use \'echo %HOSTNAME\', \'echo COMPUTER_A\' will be sent.\nClick [OK].\nTo add more quick commands, repeat the process from 4 to 6.\nClick [OK] in Edit Quick Command Set  dialog box.\nNote\nIn Edit Quick Command Set  dialog box, add, delete, and edit quick commands. The order of  quick \ncommands listed in the quick command bar  may be changed.\nTo Display Another Quick Command Set in Quick Commands Bar:\nClick the [Quick Command Set] button(an icon at the far left) in quick commands bar and select a quick \ncommand set from the list. The buttons from the selected quick command set are listed.\nTo Select Quick Command Set Displayed when Session is Started:\nOpen the session\'s Session Properties  dialog box.\nSelect [Advanced] from [Category].\nSelect a quick command set to be used in session.\nPress [Browse] and select the quick command set or create a new quick command set in Quick Command \nSets  dialog box.\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  501.\n•\n•\n2.\n•\n1.\n2.\n3.\n4.\n•\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n5.\n6.\n1.\n2.\n3.\n4.10.9 Terminal Output Encoding Change\nXshell  uses the default user language in Windows system. Users can select and use various encodings which differ \nfrom the Windows system according to remote host encoding.\nTo Change Session Encoding:\nDo one of the following:\nClick the standard [Encoding] button and select an encoding to use.\nOpen the Session Properties  dialog box and select [Terminal] from [Category] and select an \nencoding from the [Encoding] list.\nDisplay UTF-8 Encoding:\nIf a remote computer is set to support unicode (UTF-8) and to use UTF-8, use \' Unicode  (UTF-8) \' as \nencoding. UTF-8 encoding enables simultaneous output of character sets in various languages.\nNote\nTo correctly display the selected encoding, the selected encoding language pack must be installed in the \nWindows system concerned.  \nEncoding option does not change keyboard input values. If necessary, install the appropriate IME (Input \nMethod Editor) provided by Windows.\n10.10 Advanced Terminal Options Setting\nTo Change Scroll Buffer Size:\nOpen the Session Properties  dialog box.\nSelect [Terminal] from [Category].\nEnter number of rows to use in [Scroll Buffer].\nClick [OK].\nNote \nScroll buffer size is a value between 0 and 2,147,483,647. 0 means that scroll buffer is not used.\nTo Change Terminal Type:\nOpen the Session Properties  dialog box.\nSelect [Terminal] from [Category].\nSelect a terminal type from [Terminal Type].\nClick [OK].\nTo Change Size at Terminal Startup:\nOpen the Session Properties  dialog box.\nSelect [Terminal] from [Category].\nCheck [Use the following terminal size when connected] from the [Emulation] area.\nEnter column size in [Columns].\nEnter row size in [Rows].\nClick [OK].\nTo Change Keypad Mode:\nOpen the Session Properties  dialog box.\nSelect [Terminal > VT Modes] from [Category].\nSelect [Normal] or [Application] from [Initial Numeric Keypad Mode].\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  511.\n2.\n3.\n•\n•\n1.\n2.\n1.\n2.\n3.\n1.\n2.\n1.\n2.\n1.\n2.\n3.\n4.\n5.10.11 Layout Management\nLayout management enables users to save Xshell  window layout according to their preference. In Manage Layout\ndialog box, change names or delete the saved layouts.\nTo Save Layout of the Current Xshell Window:\nSelect [Layout] from the [View] menu and select [Save As].\nEnter [New name] in Save As  dialog box.\nClick [OK].\nTo Change Xshell Window to  Another Layout:\nSelect [Layout] from the [View] menu and select one from the layouts list.\nPress Alt+L to select one from the layouts list.\nTo Manage Registered Layouts List:\nSelect [Layout] from the [View] menu and select [Manage].\nDelete the layout or rename it in Manage Layout  dialog box.\n10.12 Highlight Sets Settings\nStrings you\'d like to emphasize can be highlighted via color or font changes using Xshell\'s Highlight Sets. \nTo Add a Highlight Set:\nFrom the [Tools] menu, select [Terminal Highlight Sets] to open the Highlight Sets dialog box.\nClick [New] to create a new Highligt Set.\nEnter the name for the new Highlight Set.\nNote\nYou can also open the Highlight Sets dialog box using the Terminal Highlight Sets button on the standard \ntoolbar.\nTo Delete a Highlight Set:\nFrom the [Tools] menu, select [Terminal Highlight Sets] to open the Highlight Sets dialog box.\nSelect the Highlight Set to delete and click [Delete].\nTo Apply a Highlight Set to a Session:\nFrom the Highlight Sets Dialog box, select the desired Highlight Set.\nClick [Set to Current].\nNote\nHighlight Sets can also be applied to sessions from a session\'s properties.\nTo Add Keywords to a Highlight Set:\nFrom the Highlight Sets Dialog box, select the desired Highlight Set.\nClick [Add] to open the Keyword dialog box.\nEnter the keyword to highlight. To distinguish between upper/lower case, select the \'Case Sensitive\' option. \nTo highlight strings based on regular expressions, select the \'Regular Expression\' option.\nSelect the style of the highlight in the \'View\' area. To change the color of the text without changing the \nbackground color, select the \'Term Color\' option.\nClick [OK].\nTo Delete Keywords from a Highlight Set:\n\nVersion 7 Help  –  Manual - Xshell\nTerminal Window Operations   –  521.\n2.\n3.\n1.\n2.\n3.\n4.From the Highlight Sets Dialog box, select the Highlight Set which contains the keyword.\nSelect the keyword to delete.\nClick [Delete]\nTo Modify Keywords in a Highlight Set:\nFrom the Highlight Sets Dialog box, select the Highlight Set which contains the keyword.\nSelect the keyword to modify.\nClick [Edit] to open the keyword dialog box.\nAfter completing your modification, click [OK].\n\nVersion 7 Help  –  Manual - Xshell\nOptions Setting   –  531.\n2.\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n5.\n6.\n7.11 Options Setting\nIn the Options  dialog box, set global options applied to all sessions. The dialog box may be opened by selecting \n[Options] in the [Tools] menu.\n11.1 Session Folder and Startup Session\nThe Xshell  session folder path can be changed. In the Sessions  dialog box, all sessions of the changed path are \ndisplayed. Select a network folder to share sessions with other users. \nTo Change Session Folder:\nOpen the Options  dialog box.\nEnter [Session Folder Path] in the [General] tab.\nTo Register Sessions to Open at Startup:\nOpen the Options  dialog box.\nClick [Add] under the [Sessions to open at startup] list in the [General] tab.\nSelect a session file from Open  dialog box.\n11.2 History Clearing and Connection Log\nIn Clear History  dialog box, clear history of address bar, compose bar, search keyword, local shell and connection \nlog. In History Settings  dialog box, designate a file to save connection log settings.\nTo Clear History:\nOpen the Options  dialog box.\nClick [Clear] in the [Security] tab.\nSelect contents to clear from Clear History  dialog box.\nClick [Clear].\nTo Save Connection Log:\nOpen the Options  dialog box.\nClick the [Log] tab.\nSelect [Log connection information on the following file.] from Connection Log area.\nEnter a file to save information about connection server, connection protocol, connection time, exit time \nand connection time.\n11.3 Key Mapping Setting\nIn Custom Key Mapping  dialog box, currently set shortcut key combinations are listed. The user can add, delete, \nand edit key combinations.\nTo Change Key Mapping:\nOpen the Options  dialog box.\nClick the [Keyboard and Mouse] tab.\nClick [Edit] in [Key Mapping]. Custom Key Mapping  dialog box is displayed.\nSelect a key combination to change from [Current Key Setting] and click [Edit].\nSelect one from Menu , Send String , Run Script  or Launch Application  in [Type].\nEnter the selected menu or character string in [Action].\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nOptions Setting   –  541.\n2.\n•\n•\n•\n•\n3.\n1.\n2.\n1.\n2.\n3.\n4.\n5.\n6.11.4 Mouse Setting\nThe middle and right mouse button actions can be individually selected. The delimiters to be used when selecting a \nword by double-clicking can be designated.\nTo Change Mouse Button Operation:\nOpen the Options  dialog box.\nSelect one of the middle mouse button actions from the [Keyboard and Mouse] tab.\nDo nothing.\nOpen the popup menu.\nPaste the clipboard contents (default value).\nOpen Properties dialog.\nSelect one of the right button actions. The default action is [Open the popup menu].\nTo Change Delimiter for Selection by Double-clicking:\nOpen the Options  dialog box.\nEnter a delimiter to use when selecting a word in the [Keyboard and Mouse] tab [Selection] field.\n11.5 Transparency Setting\nXshell  offers a transparency setting.\nTo Set Window to Appear Transparent:\nSelect [Transparent] from the [View] menu.\nOpen the Options  dialog box.\nSet transparency in the [View] tab.\nSet [Opacity]. The smaller the opacity is, the more transparent the Xshell  window becomes.\nIf [Make window opaque on mouse over] option is selected, Xshell  window is displayed opaque while mouse \nis over the window even when it is set to display Xshell  window transparent.\nIf [Always on Top when it is transparent] option is selected, Xshell  window is displayed at the top of all \nwindows.\n11.6 Master Password Settings\nMaster password can be used to save passwords more securely using the user defined master password . \nMaster password uses a user defined keyword to encrypt the password section of the session data. When the master \npassword is enabled, Xshell asks for the master password every time a new Xshell instance is started and a session \nis open. If the correct master password in not inputted, the session\'s password is not able to be utilized and must be \nentered again manually preventing unauthorized access.\nFor details on Master Password setting, see \' Master Password\' .\n11.7 Screen Lock Settings\nYou can lock the terminal screen while you are away from the PC to protect your session from unwanted use. When \nthe terminal is locked, the terminal screen changes to a grey and users cannot interact with terminal until the \ncorrect password is received. Once the screen is locked, you cannot pass any data to the terminal. Xshell cannot be \nclosed until the correct password is received. However, connections will stay open and data will be still updated in \n\nVersion 7 Help  –  Manual - Xshell\nOptions Setting   –  551.\n2.\n3.\n4.\n5.\n1.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n5.\nthe terminal. \nSet a Screen Lock Password\nFrom the Tools  menu, select Options .\nSelect the Security  tab.\nFrom the Lock Screen  section, click Set Password  to open the Lock Screen Password dialog box.\nEnter the desired password into the \'Enter Password\' and \'Confirm Password\' fields.\nClick OK to save.\nNote\nIf a Lock Screen is attempted from the View  menu when a password is not set, the user will be prompted to \nfirst set a password.  \nTo Lock Screen\nClick on the View  menu and select Lock Screen .\nNote\nIf a Lock Screen is attempted from the View  menu when a password is not set, the user will be prompted to \nfirst set a password.\n11.7.1 Auto Lock\nAuto Lock  can be used to lock the terminal screen automtacially after a duration of no interaction with the \nterminal. This feature is especially useful if you are using your computer in an open area.\nTo Enable Auto Unlock\nClick on the Tools  menu and then select Options .\nClick on the Security  tab.\nIn the Screen Lock section, select the Automatically lock screen  option.\nEnter the number of minutes Xshell should wait for terminal input/ouput before the screen is locked \nautomatically.\nClick OK to save.\nNote\nIf a Lock Screen is attempted from the View  menu when a password is not set, the user will be prompted to \nfirst set a password.\n11.8 Live Update Settings\nLive update allows Xshell to check for software update at an interval defined by the user. By default, it checks for a \nnew update every 2 weeks. When the [Check for updates automatically] option is enabled, Xshell checks for the \nupdates with NetSarang\'s server upon startup.\nTo Enable Live Update\nClick on the Tools  menu and then select Options .\nClick on the Update  tab.\nSelect the Check for updates automatically option.\nEnter the number of days you want to wait until Xshell checks for updates again.\nClick OK to save the changes.\nNote\nYou can always check for updates manually by selecting the Check for Updates in the Help menu.\n\nVersion 7 Help  –  Manual - Xshell\nOptions Setting   –  5611.9 Advanced Settings\nAdvanced options can be set in the Options  dialog box [Advanced] tab.\nSwitch to English input when ESC key is pressed  \nWhen ESC key is pressed to move to command mode while entering Korean in certain applications, such as vi and \nvim, the status is automatically changed to English input mode.\nUse the Smart select button for easy copy and file download  \nShow or hide the [Smart Selection] button when selecting a terminal area with a mouse.\nDisable on-the-fly highlight refreshing\nDisable highlight refresh on a running tab.\nUse true color\nSet to support true color terminal.\nSend to the notification area when minimized\nWhen Xshell  is minimized, it is minimized to the notification area.\nShow session tab in full screen mode\nShow the sessions tab in full screen mode.\nHide  scroll bar in full screen mode\nHide the scroll bar in full screen mode.\nUse the title bar in full screen mode\nThis hides the control window which normally appears in full screen mode. To exit full screen mode, the shortcut \nkey or terminal context menu must be used.\nArrange cascade windows in current window size\nUses the current window size to cascade Xshell windows. When this option is not selected, Xshell windows are \ncascaded in default size.\nRun Xshell at Windows startup\nXshell  is automatically started when Windows is started.\nMinimize to the notification area at Xshell  startup\nMinimize to the notification area when Xshell  is started.\nOpen the Sessions dialog box at Xshell  startup\nOpen the Sessions  dialog box when Xshell  is started.\nUse Alt key to access menu\nOpen the menu by pressing Alt key.\nOpen multiple sessions in a single Xshell window\nOpens multiple sessions in a single Xshell  window. Move between sessions using the session tab or session bar. If \nthis option is not enabled, each session will open in a separate window when opening multiple sessions \nsimultaneously.\nConfirm to disconnect when Xshell is terminated  \nAsk whether or not to terminate connected sessions when a program is terminated.\nConfirm to disconnect when session is terminated\nAsk whether to disconnect at session termination.\nRevert to local shell when connection is  closed  \nThe session tab is maintained in local shell status when a connection is closed. In a local shell session, the Xshell\n\nVersion 7 Help  –  Manual - Xshell\nOptions Setting   –  57prompt is displayed in terminal screen and local commands, such as open , telnet , ssh and ping  can be executed. To \nview a list of commands, execute help or ? in the Xshell  prompt.\nClear scrollback buffer when connection is closed\nWhen a connection is closed, the scrollback buffer will be cleared.\nRestore the last used tab group layout at Xshell startup\nIf Xshell is closed normally or abnormally, upon next startup Xshell will revert back to session connection status as \nwell as the tab arrangement state of Xshell before it was closed.\nAuto-save session changes to current session file\nWhen changes are made to the session properties by the user, the changed are automatically saved in the session \nfile. In the case of the default session, the changes are saved to the default session file.\nUse single-process mode for better performance\nXshell\'s tabs can each have their own process (multi-process mode) or multiple tabs can run on the same process \n(single process mode). Single-process mode consumes less system resources and can improve performance, but \ntabs cannot be split to new windows and cannot be combined into one window.\n[New File Transfer] opens an SFTP session in Xshell, not executing Xftp\nSelecting [New File Transfer] from the [Window] menu opens an SFTP session in Xshell instead of opening Xftp even \nif Xftp is installed on the computer. If the Xftp program is not installed, the SFTP session ignores this option.\nExit Xshell when all tabs are closed simultaneously\nIf this option is not enabled, Xshell will not exit even if all tabs are closed simultaneously. Instead, a local session \nwill begin to run.\nExit Xshell when the last tab is closed\nIf this option is not enabled, Xshell will not exit even if the last tab is closed. Instead, a local session will begin to run.\n\nVersion 7 Help  –  Manual - Xshell\nFile Transfer   –  581.\n2.\n1.\n2.\n1.\n2.\n1.\n2.\n12 File Transfer\nXshell  allows sending or receiving files using FTP/SFTP and the X/Y/ZMODEM protocols.\n12.1 File Transfer Using SFTP\nSFTP is an SSH-based file transfer protocol. Compared to FTP, X/Y/ZMODEM, it supports a safer and faster file \ntransfer.\nTo Receive Files with SFTP:\nConnect with a host from which to receive a file using the sftp  command in the local prompt. [C:~]$ sftp \nhostname\nReceive a file using get command in the sftp prompt. sftp:/home/user21> get filename\nNote\nFor a detailed description of the sftp command supported by Xshell, run the help command at the sftp \ncommand prompt.\nTo Send Files with SFTP:\nConnect with a host to which to send a file using the sftp  command in the local prompt. [C:~]$ sftp \nhostname\nSend a file using put  command in the sftp prompt. sftp:/home/user21> put filename\nNote\nFor a detailed explanation of the sftp command supported by Xshell, run the help command at the sftp \ncommand prompt.\n12.2 File Transfer Using FTP\nXshell supports the FTP file transfer protocol on a terminal basis.\nTo Receive Files with FTP:\nConnect with a host from which to receive a file using the ftp command in the local prompt. [C:~]$ sftp \nhostname\nReceive a file using get command in the ftp prompt. ftp:/home/user21> get filename\nNote\nFor a detailed explanation of the ftp command supported in Xshell, run the help command at the ftp \ncommand prompt.\nTo Send Files with Ftp:\nConnect with a host to which to send a file using the ftp command in the local prompt. [C:~]$ ftp hostname\nSend a file using put  command in the ftp prompt. ftp:/home/user21> put filename\nNote\nFor a detailed explanation of the ftp command supported in Xshell, run the help command at the ftp \ncommand prompt.\n12.3 File Transfer Using X_Y_ZMODEM\nFiles transferred via X/Y/ZMODEM are saved in a folder designated by a user. Users may designate different folders \neach time files are received. The method for file transfers using XMODEM and YMODEM is similar to ZMODEM. The \n\nVersion 7 Help  –  Manual - Xshell\nFile Transfer   –  591.\n2.\n3.\n1.\n2.\n3.\n1.\n2.\n3.\n4.\n5.\n6.\n1.\n2.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.commands you use to send and received files fore X,Y, and ZMODEM are sx, sb, sb for receiving and rx, rb, rz for \nsending respectively. The commands may differ between systems and it is recommend that users consult the \nremote OS\'s manual. Below is a description of the average ZMODEM fil transfer.\nTo Receive File with ZMODEM:\nExecute the following command in a remote host prompt:\n$ sz file1 file2 …\nNote\nIf [Activate ZMODEM automatically] is set in the Session Properties, the file receive process will be \nstarted automatically, and the following process in No. 2 and 3 can be omitted.\nPoint to [Transfer] in the [File] menu.\nSelect [Receive with ZMODEM].\nNote\nIf the sz command does not exist in a remote host, users must install it directly. In most cases, similar \ncommands exist.\nTo Receive File with ZMODEM in Xshell Terminal:\nSelect the name of a file to download in the Xshell  terminal window. The [Smart Selection] button is \ndisplayed around the selected file name.\nClick the [Smart Selection] button.\nSelect [Download with ZMODEM].\nTo Send File with ZMODEM:\nExecute the following command in remote prompt: \n$ rz\nNote\nIf [Activate ZMODEM automatically] is set in the Session Properties, the file send process will be \nstarted automatically, and the following process in No. 2 and 3 can be omitted.\nPoint to [Transfer] in the [File] menu.\nSelect [Send with ZMODEM].\nSelect a file to send from the Open File dialog box.\nTo send a file as ASCII, select [Send File as ASCII].\nClick [Open].\nTo Send File with ZMODEM Using Drag & Drop:\nSelect a file to upload from the Windows file explorer.\nDrag the file and drop it in Xshell  terminal window. File transfer is carried out automatically. \nTo Change Default Folder to Save File:\nOpen the Session  Properties  dialog box.\nSelect [File Transfer] from [Category].\nSelect [Use the following download path] from [Receive folder].\nOpen the Browse For Folder  dialog box by clicking […] button of the [Download Path] and select a folder \nwhere the received files are to be saved.\nClick [OK].\nTo View Files Received in the Default Path:\nOpen the Session Properties  dialog box.\nSelect [File Transfer] from [Category].\nClick [Open] in the [Download Path] field.\n\nVersion 7 Help  –  Manual - Xshell\nFile Transfer   –  601.\n2.\n12.4 File Transfer Using Xftp\nXshell  is interoperable with Xftp , a NetSarang Computer Inc. file transfer program. This allows for fast and \nconvenient FTP/SFTP connections with a host currently connected with Xshell .\nTo Create a  Xftp Connection with a Host Currently Connected via  Xshell:\nConnect with the host of a file to be transferred using Xshell .\nSelect [New File Transfer] from the [Window] menu. Or, click the standard [New File Transfer] button.\nNote\nIf a protocol Xshell  uses is SSH, Xftp  attempts an  SFTP connection. If the protocol used by Xshell  is TELNET \nor RLOGIN, Xftp  attempts an FTP connection.  \n\nVersion 7 Help  –  Manual - Xshell\nSession Logging and Tracing   –  611.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.\n5.\n1.\n2.\n3.\n4.13 Session Logging and Tracing\nXshell allows users to log the entire transcript of a session to a file. Trace may be used for debugging.\n13.1 Session Logging\nTo Log Character Strings Only:\nPoint to [Log] in the [File] menu.\nSelect [Start]. Save As  dialog box is displayed.\nEnter the file name where log data is to be saved.\nClear [Record terminal code as well as normal text].\nClick [Save].\nNote\nLogging continues until a session ends. To stop logging without ending a session, select [Stop] from the \n[File] – [Log] menu. Files with different names in the Save As dialog box are file formats which were specified \nthe the logging options of a session\'s properties.\nTo Log Character Strings with Terminal Codes:\nPoint to [Log] in the [File] menu.\nSelect [Start]. Save As  dialog box is displayed.\nEnter the file name where log data is to be saved.\nCheck [Record terminal code as well as normal text].\nClick [Save].\nTo Start Logging at Session Connection:\nOpen the Session Properties  dialog box.\nSelect [Advanced > Logging] from [Category].\nSelect [Start logging upon connection].\nDesignate the folder or file name where the log is to be saved.\nClick [OK].\n13.2 Session Tracing\nUsing the trace option, trace protocol control data is exchanged with a remote host. \nFor SSH protocols, user authentication and algorithm exchange details may be displayed on the terminal screen. \nFor TELNET protocols, the exchange of various options can be traced. This is useful when problems occur in \nconnection with a remote host.\nTo Turn on or Turn off Trace Function:\nOpen the Session Properties  dialog box.\nSelect [Advanced > Trace] from the [Category].\nSelect options appropriately.\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nPrinting   –  621.\n2.\n3.\n4.\n1.\n2.\n3.14 Printing\nXshell  provides the ability to print text in a terminal window via a local printer. Xshell  uses fonts and colors used in \na terminal window for printing. The printing paper margins can be set in the Page Setup  dialog box.\nTo Set Paper Size and Direction:\nSelect [Page Setup] from the [File] menu.\nSelect an appropriate paper size and direction.\nEnter margins.\nClick [OK] to save changes.\nTo Print:\nSelect [Print] from the [File] menu.\nSelect printer from the [Name] list.\nClick [OK].\n\nVersion 7 Help  –  Manual - Xshell\nUsing Xagent   –  63\n1.\n2.\n3.\n4.\n1.\n2.\n3.\n4.\n1.\n2.15 Using Xagent\nXagent  is an SSH authentication agent. Xagent  holds a user key for public key user authentication and provides it \nto Xshell  when a user key is required by Xshell . \nXagent  retains all user key lists and requests a passphrase input when necessary. When a user enters a passphrase, \nXagent  decodes the user key and saves it in memory. Via Xagent , users may use the same key several times by \nentering the passphrase once. \nXagent  also works as an SSH authentication server for the SSH agent forwarding feature. You must use the SSH \nagent forwarding feature when connecting to a different remote host from the first remote host. Typically, your \nprivate key is only held in your local PC and an SSH client program on the first server cannot connect to a second \nmachine. However, using the SSH agent forwarding feature, the SSH client program on the first server requests a \nprivate key from Xagent  to enter into the second server.\nNote\nWhen Xagent  is executed,  the Xagent  icon is created in the notification area. Even when the Xagent  dialog \nbox is closed, Xagent  is not closed and keeps running.  To close Xagent  or open the Xagent  dialog box, use \nthe icon menus in the notification area.\n15.1 Connecting to a Server Through Xagent\nTo Set Xshell to Use  Xagent:\nOpen the Session Properties  dialog box.\nSelect [Connection > SSH] from [Category].\nSelect [Use Xagent (SSH agent) for handling passphrase].\nClick [OK].\nTo Connect with SSH Server Through Xagent:\nSet Xshell  to use Xagent .\nExecute Xagent  if Xagent  is not running.\nConnect to SSH server. In this case, the SSH server must support public key user authentication and the \npublic key section of the user key must be registered on the server.\nPassphrase  dialog box is displayed. Enter passphrase of the selected user key.\nNote\nWhen selecting [Launch Xagent  automatically] in [Connection > SSH] setting, the process in No. 2 above may \nbe omitted. Passphrase  dialog box is displayed only when the selected key status is Close . You can check \nuser key status in Xagent  user keys list.\nNote\nXshell will attempt to authenticate into the server by cycling through the keys managed by Xagent. Because \nmultiple attempts may need to be made before a key match is found, authetentication may fail if the \nnumber of attempts exceeds the server\'s defined limit. In this case, the number of allowable authentication \nattempts can be increased on the server or the number of keys must be adjusted in Xagent.\n15.2 Using the Xagent User Key on a Remote Host\nUsing Xagent , the SSH client on a remote host can use a user key used by Xshell , which is a user key held by \nXagent . To use an Xagent  user key on a remote host, both Xshell  and the remote host SSH server must support \nagent-forwarding.\nTo Activate Agent-Forwarding on the  ssh.com Server:\nOpen the /etc/ssh2/sshd2_config file.\nSet value for AllowAgentForwarding option as follows: AllowAgentForwardingyes \n\nVersion 7 Help  –  Manual - Xshell\nUsing Xagent   –  643.\n1.\n2.\n3.\n4.\n5.\nRestart SSH server.\nNote\nOpenSSH servers automatically enable the agent forwarding feature unless user specifies the no-agent-\nforwarding  option.\nTo Use Xagent Key on the  Remote Host:\nSet Xshell  to use Xagent .\nExecute Xagent  if Xagent  is not running.\nConnect to SSH server and login.\nNote\nIf the SSH server supports the agent forwarding feature, the environment variable for agent \nforwarding (SSH_AUTH_SOCK or SSH2_AUTH_SOCK) is set to a proper value.\nConnect to another server, which supports public key authentication, from the remote server.\nWhen Passphrase  dialog box is displayed, enter passphrase to the selected user key.\nNote\nPassphrase  dialog box is displayed only when the selected key status is Close . You can check user key status \nin Xagent  user keys list.  \n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  651.\n2.\n3.\n1.16 Using Scripts\nScript is a file that contains a set of commands to be executed at once. Repetitive tasks are conveniently collected \nin a file and commands may be executed without needing to type them in one by one. Xshell supports Visual Basic \nScript, JavaScript, and Python Script.\n16.1 Script Starting and Ending\nTo Start a Script File:\nPoint to [Script] in the [Tools] menu and select [Run]. Open  dialog box is displayed.\nSelect a script file.\nClick [OK].\nTo Stop Script File Execution:\nPoint to [Script] in the [Tools] menu and select [Cancel].\n16.2 Script API\nXshell  provides the following script APIs. Use the APIs to automate repetitive tasks.\n16.2.1 xsh.Session\nThe following functions and variables can be used in Xshell  sessions. To use these functions and variables, execute \nthem together with xsh.Session. For example, to use \'Sleep()\' function, use \'xsh.Session.Sleep(1000)\'. \nFunctio\nns     \nReturn \nValueFunction Parameter Description\nVoid Open (LPCTSTR\nlpszSession) lpszSession  \nA character string of an Xshell \nsession path or URL format of \nXshell.Open a new session or URL. \nTo open a session, place /s option in front \nof a character string. \nEx.) To open the A.xsh session, use \'/s \n$PATH/A.xsh\'.\nVoid Close ()   Close the currently connected session.\nVoid Sleep (long\ntimeout)Timeout  \nMilisecond unit time value.Make Xshell wait for the designated time.\n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  66Void LogFilePath (\nLPCTSTR\nlpszNewFilePath)lpszNewFilePath  \nFile name including pathDesignate log file.\nvoid StartLog ()   Start logging for a session. Log is \ndesignated with a path specified in \nLogFilePath(). If a log file path is not \ndesignated, the default path is used.\nvoid StopLog ()   Stop logging.\nVariable    \nName Type Description\nConnected BOOL Check whether current session is connected.\nLocalAddress BSTR Retrieve the local address.\nPath BSTR Retrieve the current session file path.\nRemoteAddress BSTR Retrieve the remote address.\nRemotePort long Retrieve the remote port.\nLogging BOOL Check whether current session is recording log file.\nLogFilePath BSTR Save as a log file.\n16.2.2 xsh.Screen\nThe following functions and variables can be used when handling of the Xshell  terminal screen. To use these \nfunctions and variables, execute them together with the xsh.Screen. For example, to use \'Clear()\' function, use \n\'xsh.Session.Clear()\'. \nFunctions      \n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  67Return \nValueFunction Parameter Description\nvoid Clear ()   Clear terminal screen.\nvoid Send (LPCTSTR\nlpszStrToSend)lpszStrToSend  \nCharacter string to \nsendSend message to terminal.\nBSTR Get (long  nBegRow, long\nnBegCol, long  nEndRow, long\nnEndCol)nBegRow  \nTerminal row starting \nposition \nnBegCol  \nTerminal column \nstarting position \nnEndRow  \nTerminal row ending \nposition \nnEndCol  \nTerminal column \nending positionRead the character string in the \nspecified terminal section and return \nthe value.\nvoid WaitForString (LPCTSTR\nlpszString)lpszString  \nCharacter string to be \ndisplayed on the \nterminal.Wait for message.\nLong WaitForStrings (VARIANT  FAR* \nstrArray, long  nTimeout)strArray  \nCharacter string to be \ndisplayed on the \nterminal \nnTimeout  \nWait time millisecond \nvalue \nReturn Value  \nThe number of found \nstrings.Wait for message until timeout.\nVariable    \nName Type Description\n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  68CurrentColumn long Return the current column.\nCurrentRow long Return the current row.\nColumns long Retrieve the total columns same as terminal width.\nRows long Retrieves the total row same as terminal lines\nSynchronous BOOL Set screen synchronization (True means synchronize and false means do not  \nsynchronize)\n16.2.3 xsh.Dialog\nYou can use this to manipulate the Xshell terminal  screen. To use the following function and variable, execute it \nwith xsh.Dialog. For example, if you want to use the MsgBox() function, append xsh.Dialog.MsgBox() in the front like \nthis: xsh.Dialog.MsgBox(). \nFunctions      \nReturn Value Function Parameter Description\nLong MsgBox (LPCTSTR  lpszMsg) LpszMsg  \nString you want to \nsend.Open a message \nbox.\nstring Prompt (LPCTSTR  lpszMessage, LPCTSTR \nlpszTitle, LPCTSTR lpszDefault, BOOL \nbHidden) \n16.2.4 Script Example\nScript file\nSub Main \n\' *** Connect the session ***  \nxsh.Session.Open \"ssh://192.168.1.17\" \n\' \"/s C:\\Users\\Administor\\AppData\\Roaming\\NetSarang\\Xshell\\Sessions\\example.xsh\"  \nxsh.Screen.Synchronous = true \n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  69xsh.Screen.WaitForString \"login: \" \nxsh.Screen.Send \"username\" \nxsh.Screen.Send VbCr \nxsh.Session.Sleep 100 \nxsh.Screen.WaitForString \"Password: \" \nxsh.Screen.Send \"password\" \nxsh.Screen.Send VbCr \nxsh.Session.Sleep 100 \n\' *** Wait for Prompt Message ***  \nxsh.Screen.WaitForString \"username@password\" \n\' *** Set File Format ***  \nDim app, wb, ws \nSet app= CreateObject(\"Excel.Application\") \nSet wb = app.Workbooks.Add \nset ws = wb.Worksheets(1) \nxsh.Session.LogFilePath = \"c:\\example.log\" \nxsh.Session.StartLog \nDim waitStrs \nwaitStrs = Array(Chr(10), \"username@password\") \' make wait message as array  \nDim row, screenrow, readline, itmes \nrow = 1 \n\' *** Send Command *** \nxsh.Screen.Send \"cat /etc/passwd\" \nxsh.Screen.Send VbCr \nxsh.Session.Sleep 100 \nDim result \n\' *** Read Data and Save it as an EXCEL File ***  \nDo \nWhile true \nresult = xsh.Screen.WaitForStrings(waitStrs, 1000) \nIf result = 2 Then \nExit Do \nEnd If \nscreenrow = xsh.Screen.CurrentRow - 1 \nreadline = xsh.Screen.Get(screenrow, 1, screenrow, 40) \nitems= Split(readline, \":\", -1) \nws.Cells(row,1).Value = items(0) \nws.Cells(row,2).Value = items(2) \nrow = row + 1 \n\nVersion 7 Help  –  Manual - Xshell\nUsing Scripts   –  701.\n2.\n3.\n4.\n1.\n2.\n3.Wend \nLoop \nwb.SaveAs(\"C:\\chart.xls\") \' save file path \nwb.Close \napp.Quit \nSet ws = nothing \nSet wb = nothing \nSet app = nothing \nxsh.Screen.Synchronous = false \nxsh.Session.StopLog \nEnd Sub\n16.3 Script Recording\nAutomatically generate script based on input (send) and output (expect). Use the generated script as a foundation \nto create more complex and versatile script.\nTo Run a Script Recording:\nSelect [Script]-[Start Recording] from [Tools] menu.\nProceed with the action you want to record.\nSelect [Script]-[Stop Recording] from [Tools] menu.\nSelect and save the script file in the format you want to save.\n16.4 Multi-Session Script\nTarget multiple tabs on which to apply your script. (This feature is only supported in single process mode).\nTo use the Multi-Session Script:\nSelect [Options…] from [Tools] menu.\nSelect [Use single-process mode for better performance] from [Advanced] tab and [OK] Click.\nSpecify the name of the tab you want to use the tab selection script for and run the script.\nSub Main\n    Dim bSelect\n    bSelect = xsh.Session.SelectTabName( \"Session Name\" )\n \n    if (bSelect) Then\n        xsh.Screen.Send( \"pwd\" & VbCr)\n    End if\nEnd Sub\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  7117 References\nThis section provides referential information about using Xshell .\n17.1 Standard Buttons\nXshell  provides standard buttons for the frequently used tasks and commands. \nThe following are descriptions of the standard buttons.\nButton Name Description\nNew Create a new session by opening New Session \nProperties  dialog box.\nOpen Open the Sessions  dialog box.\nDisconnect Close connection with the current session.\nReconnect Reconnect with the current tab session.\nProperties Show current session properties. If the \nsession is not opened, default session properties is \ndisplayed.\nCopy Copy the selected field to clipboard.\nPaste Paste clipboard contents.\nFind Open the Find  dialog box.\nPrint Open the Print  dialog box.\nColor Schemes Select color scheme.\nEncoding List encodings available with the output language.\n\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  72Button Name Description\nFonts List available font names and sizes. Fonts for the \ncurrently Open the session can be changed. To change \nthe font for each session, select a session font from the \nSession Properties  dialog box.\nNew Terminal Open the a new Xshell  window. Click this button while a \nconnection is being made to attempt connection using \nthe corresponding session\'s connection information.\nNew File Transfer Execute Xftp  if Xftp™ is installed. Click this button while a \nconnection is being made to start a New File Transfer \nsession with the corresponding session\'s connection \ninformation. If Xftp  is not installed, the Xshell  File \nTransfer session itself is started.\nFull Screen Convert to full screen mode. Screen changes to general \nwindow mode when Alt+Enter is pressed.\nLock Convert to screen lock mode. User input is not received \nuntil password is entered.\nKey Mapping Open the Custom Key Mapping  dialog box.\nHighlight Sets Open the Highlight Sets  dialog box.\nScript Start Xshell  script file.\nStart Recording Start script recording\nPause Recording Pause script recording\nStop Recording Stop script recording\nStart Logging Start logging.\n\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  73•\n•\n•\n•\n•Button Name Description\nStop Logging Stop logging.\nNew Tab Group Opens a new local shell tab in a new tab group. Can be \nopened to the right, bottom, top, or left.\nSort Tabs Arrange the currently opened tabs horizontally, \nvertically, or tiled. Or merge already arranged tabs.\nOptions Open the Options  dialog box.\nUser Key Manager Open the User Keys  dialog box.\nHost Key Manager Open the Host Keys  dialog box.\nXagent Execute Xagent  program.\nHelp Open the Xshell  help.\n17.2 Address Bar\nThe address bar grammar is as follows: \n[protocol://][user[:password]@]hostname[:port][/]\nThe available protocols are ssh, sftp , telnet, rlogin,  and serial . The default protocol is a protocol selected in the \ndefault session. Default port numbers by protocol are defined as follows:\nssh: 22\nsftp: 22\ntelnet: 23\nrlogin: 513\nftp: 21\nA number of examples are given below.\nExample Description\nfoobar.com Connect to foobar.com using the protocol and port number \ndesignated in the default session.\n\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  74Example Description\nssh://kay:passwd@foobar.com/ Connect to foobar.com using the SSH protocol. User account is \n\'kay\' and password is \'passwd\'. The default port number is used.\nssh://kay@foobar.com:12345/ Connect to foobar.com port 12345 using the SSH protocol. User \naccount is kay.\ntelnet://foobar.com/ Connect to foobar.com via telnet protocol. User account is not \ndesignated and connection is made with port 23, the default \nport.\nrlogin://kay@foobar.com/ Connect to foobar.com using the rlogin protocol. The user \naccount is \'kay\' and connection is made with port \n513, the default port.\nsftp://kay@foobar.com/ Connect to foobar.com using the SFTP protocol. User account is \n\'kay\' and the default port number is used.\nftp://foobar.com/test.zip Connect to foobar.com using the ftp protocol and download \ntest.zip file.\n17.3 Xshell Local Command\nXshell  provides local commands for advanced users familiar with the terminal environment. \nBasically, Xshell  prompt is displayed on the terminal screen when a remote host is not connected. When a session \nis connected, press \'Ctrl+Alt+]\' to exit to local prompt. To return to the remote host mode, enter \'exit\' or press \n\'Ctrl+D\'.\nThe following commands can be used.\nCommand Description\nhelp \n?Display commands list on the terminal window.\nnew Open the New Session Properties  dialog box.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  75Command Description\nopen the \n[session ]Connect with the corresponding session when \'session\' is designated. If a session is not \ndesignated, the Sessions  dialog box is opened.\nedit \n[session ]Open the Session Properties  dialog box for the corresponding session if \'session\' is designated. \nOpen the Session Properties  dialog box for the default session if \'session\' is not designated.\nlist Display a list of directories and information about sessions in the current directory.\ncd Change the current task directory.\npwd Show the current path of the local PC. The default is the path to the session files.\nclear Clear local shell command prompt screen, address bar history, and command history. The \navailable options are:\nscreen  Clear the screen. This is the default value.\naddress  Clear the history of the address bar.\nhistory  Clear the history of local shell commands.\nexit \nquitClose Xshell  session or return to remote host.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  76Command Description\nset Configure the Xshell environment. Certain settings can be defined in the session properties or \noptions. To view the current configuration, type the set command without any command line \noptions. The available options are:\nStartFolder  This is the default path when the local shell starts. The default is \'User Data \nFolder\\Xshell\\Sessions\', which is the root of the session folder. User data folder can be set \nin the program.\nLogFolderPath  This is the default folder to store logs for sessions. The default is \'User \nData Folder\\Xshell\\Logs\'. The location where the session log is saved can be determined \nseparately for the session.\nScriptFolderPath  This is the default folder that is opened when specified in a session file \nor when calling a script from a menu. The default is \'User Data Folder\\Xshell\\Scripts\'.\nAutoSaveHostKey  In case of SSH connection, fingerprint information on the host key is \nautomatically saved. If this is the first host to access or if the host key has been changed by \nthe administrator\'s setting, Xshell asks whether to save the host key. Default value is 0 \n(user confirmation)\nInputCRLF  You can send the value of the Enter key to CRLF. The default value is 0 (only LF \nis sent).\nExitAllTabClose  Closes the Xshell window when all sessions are closed at the same time \nwhile the Send command to all sessions light is on. The default is 0.\nStopScrollOnLButtonDown  Screen output is stopped while the mouse button is held \ndown. The default value is 1 (use).\nOpenXftpNewWin  Opens a new window when calling Xftp using the currently connected \nsession information. The default is 0 to open an existing window in a new tab.\nComposeBarHistoryCount  The number of command history saved in the compose bar. \nThe default value is 50 (pcs).\nComposePaneHistoryCount  The number of command history saved in the compose \nwindow. The default value is 50 (pcs).\nSaveAppLog  Saves the program\'s own log to the [User Data Folder]\\Applog folder. The \ndefault value is 0 (do not store).\nImportFileOnDrop  You can import user keys by dragging and dropping them into the \nlocal shell. The default value is 0 (not used).\nJumpHostListenPort  This is the default port of the proxy server used as a jump host \nwhen using the SSH jump host function. The default number is 10000.\nPrintToEditor  When the is set to 1, the output is not sent to the printer when the terminal \nprint code is received, but to the editor specified by the user. The default is 0.\nhelp Show help for each command. For explanation of the ssh command, use the\'help ssh\' command. \nIf\'help\' is entered without command, this help is displayed.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  77Command Description\nssh [\nuser:pass\n@]host\n[port ]Connect using the SSH protocol.\n-pa Use Password authentication. Ignore other auth parameters(-A -i).\n-a Doe not use Xagent for user authentication.\n-A Use Xagent for user authentication.\n-i user_key  A user key authentication.\n-J jump_host  Use jump host proxy.*\nuser  Indicate the user\'s login name.\npass  If pass is defined, use password authentication.\nhost  Indicates the name, alias, or Internet address of the remote host.\nport  Indicates a port number (address of an application). If the port is not specified, the \ndefault ssh port (22) is used.\nsftp \n[user:pass\n@]host\n[port ]Connect using the SFTP protocol.\ntelnet \n[user:pass\n@]host\n[port ]Connect using the telnet protocol.\nrlogin \n[user @]\nhost  [port ]Connect using the rlogin protocol.\nftp \n[user:pass\n@]host\n[port ]Connect using the ftp protocol.\nipconfig Execute Windows ipconfig command.\nping host Execute Windows ping command.\ntracert host Show packet path to host.\nnetstat Execute Windows netstat command.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  78Command Description\nnslookup Execute Windows nslookup command.\nrealcmd Execute Windows cmd command.\nscp  src ... \n[user:pass\n@]host:destUse the scp protocol to send or get the file to another server.\n-pa Use Password authentication. Ignore other auth parameters(-A -i).\n-a Doe not use Xagent for user authentication.\n-A Use Xagent for user authentication.\n-i user_key  A user key authentication.\n-J jump_host  Use jump host proxy.*\n-r Copy directory recursively.\n-p Preserve modification and access time.\n-P Indicates a port number (address of an application). If the port is not specified, the \ndefault ssh port (22) is used.\nuser  Indicate the user\'s login name.\npass  If pass is defined, use password authentication.\nhost  Indicates the name, alias, or Internet address of the remote host.\nsrc ...  Indicates the path of source files or directories. You can list files separated by a \nspace character.\ndest  Indicates the path of a destination file  or folder.\n17.4 Xshell Command Line Option\nThe following are the command line parameter options recognized by Xshell . These parameters can be used when \nexecuting Xshell  from the Windows console program or other applications.\nOption, Parameter Description\n\'session file\' Execute the session. \'Session file\' can include a path.\n-folder \'session folder\' Execute all folder sessions.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  79•\n•\n•\n•\n•\n•Option, Parameter Description\n-url [ protocol:// ]\n[user [:password ]@]host[ :port ]Connect by directly entering URL, rather than using designated \nsession file. Usable protocols are SSH, SFTP, TELNET, RLOGIN and \nFTP. \nWhen protocol is omitted, use the default protocol designated in \nthe Options  dialog box [General] tab. \nWhen user and password are ommited, a window for the \nauthentication is displayed. \nWhen a connection port is not designated, the connection \nprotocol default port of is used.\n-open Open the Sessions  dialog box.\n-register Open the a dialog box for product registration.\n-about Open the Xshell  Information dialog box where product version \nand license information is available.\n-prop \'session file\' Open the Session Properties  dialog box. \'Session file\' can include \na path.\n-create \'session file\' Create a new session.\n-newwin Open the a new Xshell  window.\n-newtab \'tab name\' Create a new tab with \'Tab Name\'.\nExample\nExecute xdev.xsh session file.\nXshell \'c:\\users\\user\\Documents\\ NetSarang Computer\\6\\Xshell\\Sessions\\xdev.xsh\'\nConnect to foobar.com with the default protocol.\nXshell -url foobar.com\nConnect to foobar.com with ssh.\nXshell -url ssh://foobar.com\nConnect to foobar.com with ssh. User name and password are \'username\' and \'deomopassword\' \nrespectively. \nXshell –url ssh://username:demopassword@foobar.com\nConnect to foobar.com port 2300 using telnet protocol.\nXshell –url telnet://foobar.com:2300\nConnect to foobar.com by executing a new Xshell  window.\nXshell -newwin -url foobar.com\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  80\nNote\nIf the [Open multiple sessions in a single Xshell window] option  is set in the [Advanced] tab of Options  dialog \nbox,  All parameters  with the exception of the \'-newwin\'  are executed in the last Xshell window or a new tab.  \nThe \'-newwin\' option can be used with other options. A new Xshell window is started with the options.\n17.5 SFTP Command\nXshell  provides commands similar to UNIX/Linux FTP for advanced users who are familiar with terminal \nenvironments. Descriptions of each command are as follows. For details, enter \'help\' command in the SFTP prompt.\nCommand Description\nget file1  [file2 ] [file3 ] … Download files from the remote host.\nput file1  [file2 ] [file3 ] … Upload files to the remote host.\nmv path 1 path2  \nrename path1  path2Move/rename a file or directory on the remote host.\nmkdir directory Create a designated directory on the remote host.\nrmdir directory Delete a designated directory from the remote host.\nrm file Delete a designated file from the remote host.\npwd Display the working directory of the remote host.\nlpwd Display the working directory of the local host..\ncd directory Change remote host working directory.\nlcd directory Change local host working directory.\nls [directory ] Display remote host files list.\nlls [directory ] Display local host files list.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  81Command Description\nexplore [ directory ] View the current (or designated) directory via Windows Explorer.\nhelp [ command ] Show instructions for using SFTP commands list or designated \ncommands.\nbye \nexit \nquitEnd SFTP connection.\n17.6 Regular Expression\nThis section provides descriptions of the regular expressions used in the Find  dialog box.\n17.6.1 Pattern Match\nPattern Description\n. Any one character except newline character\n[abs] One character of a, b or c\n[a-z] One character from a to z\n[^ac] One character excluding a and c\n(x) x, x can be a regular expression.\nx* x is repeated 0 time or more. x can be a regular expression.\nx+ x is repeated 1 time or more. x can be a regular expression.\nx{n,m} x is repeated n times or more and m times or less. x can be a regular \nexpression.\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  82Pattern Description\nx{n} x is repeated n times exactly. X can be a regular expression.\nx{n,} x is repeated n times or more. X can be a regular expression.\nx|y x or y, x and y can be regular expressions.\nxy xy, x and y can be regular expressions.\n^ Start of a line\n\\A Start of a line\n$ End of a line\n\\z End of a line\n\\Z End of a line\n\\< Start of a word\n\\b Start of a word\n\\> End of a word\n\\B End of a word\n17.6.2 The shorthand of character classes\nClass Description\n\\w Characters comprising a word, as in [a-zA-Z0-9_]\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  83Class Description\n\\W Characters not consisting a word, as in [^a-zA-Z0-9_]\n\\s Spaces\n\\S Characters excluding spaces\n\\d Numbers, as in [0-9]\n\\D Characters excluding numbers, as in [^0-9]\n17.6.3 POSIX character classes\nClass Description\n[:alnum:] Letters and numbers, as in [a-zA-Z0-9]\n[:alpha:] Letters, as in [a-zA-Z]\n[:blank:] Blanks\n[:cntrl:] Controls\n[:digit:] Numbers, as in [0-9]\n[:graph:] Printable characters (blanks excluded)\n[:lower:] Small letters, as in [a-z]\n[:print:] Characters which are not controls\n[:punct:] Punctuations\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  84Class Description\n[:space:] Spaces\n[:upper:] Capital letters, as in [A-Z]\n[:xdigit:] Characters used to express a hexadecimal number, as in [0-9a-fA-F]\n17.6.4 Example\nExpression Description\n[0-9]+ Pattern where a number is repeated more than once\n(foo)|(bar) \'foo\' or \'bar\'\n\\.html$ Character string ending with \'.html\'\n^\\. Character string starting with \'.\'\n17.7 Pre-defined Shortcut Key\nThe list below shows descriptions of shortcut keys defined in Xshell .\nShortcut Key Description\nAlt + 1~9 Move session tab\nAlt + A [View] Always on Top\nAlt + C Same as Disconnect in the File menu\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  85Shortcut Key Description\nAlt + D Move keyboard focus to address bar\nAlt + Enter Convert to full screen mode\nAlt + I [Edit] Move to Compose Bar\nAlt + Insert [Edit] Paste Selection\nAlt + J [Edit] Move to Compose Pane\nAlt + L Change layout\nAlt + Left Same as Previous in the Window menu\nAlt + M [Edit] Move to Session Manager\nAlt + N Same as New in the File menu\nAlt + O Same as Open the in the File menu\nAlt + P [File] Session Properties\nAlt + R [View] Transparent\nAlt + Right Same as Next in the Window menu\nAlt + S [View] Simple Layout Mode\nCtrl + Alt + ] Exit to local prompt during connection\nCtrl + Alt + F Same as New File Transfer in the Window menu\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  86Shortcut Key Description\nCtrl + Alt + N [Window] New Window\nCtrl + Alt + T Same as New Terminal in the Window menu\nCtrl + F1~F12 [Quick Command] Command #01~#12\nCtrl + Insert [Edit] Copy\nCtrl + Pause [Edit] Send Break\nCtrl + Shift + A [Edit] Clear Screen and Scrollback Buffer\nCtrl + Shift + Alt + [ [View] Decrease Font Size\nCtrl + Shift + Alt + ] [View] Increase Font Size\nCtrl + Shift + B [Edit] Clear Scrollback Buffer\nCtrl + Shift + F4 [Tab] Close\nCtrl + Shift + L [Edit] Clear Screen\nCtrl + Shift + R [Connection] Reconnect\nCtrl + Shift + T [View] Session Tab\nCtrl + Shift + Tab [Tab] Move to previous session\nCtrl + Tab Move to the next session tab in a single Xshell  window\nPause [Edit] Send Break\n\nVersion 7 Help  –  Manual - Xshell\nReferences   –  87\nShortcut Key Description\nShift + Alt + Enter [View] Multipane Full Screen\nShift + Alt + L [View] Choose Layout (Up)\nShift + Alt + N [Tab] Open New Tab\nShift + Alt + T [Connection] Duplicate Current Session\nShift + Down Arrow Downward scroll\nShift + End To end\nShift + Home To top\nShift + Insert [Edit] Paste\nShift + PgDn Page down\nShift + PgUp Page up\nShift + Tab Move to the recently used session tab in a single Xshell\nwindow\nShift + Up Arrow Upward scroll\nNote\nUse the standard [Key Mapping] button to change shortcut keys. In the Custom Key Mapping dialog box, \nchange shortcut key combinations and allocate key operations such as menu, send character string, execute \nscript, and execute program.', 1, '2026-02-25 16:21:59', '2026-03-12 17:38:32', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (5, 16, '0000', 'static/upload/requirement_docs/20260226/登录需求.txt', 'txt', 'analyzing', 105, '1、用户点击快捷微信方式，登录成功\n2、用户点击gitee快捷登录方式，登录成功', 1, '2026-02-26 18:22:18', '2026-02-27 15:36:37', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (6, 16, '等陆续', 'static/upload/requirement_docs/20260227/登录需求.txt', 'txt', 'analyzing', 105, '1、用户点击快捷微信方式，登录成功\n2、用户点击gitee快捷登录方式，登录成功', 1, '2026-02-27 15:36:53', '2026-03-12 17:38:35', NULL, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (8, 14, 'Figma需求-Truevisia', 'https://www.figma.com/proto/7GwOMtipf9FTsq8XW5lClx/Truevisia?node-id=4-10474&t=R0F60A200gEkcEGg-1&show-proto-sidebar=1&starting-point-node-id=4%3A10474', 'figma', 'analyzed', NULL, NULL, 1, '2026-02-27 18:30:16', '2026-02-27 18:33:22', 1, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (9, 14, 'Figma需求-7GwOMtipf9FTsq8XW5lClx', 'https://www.figma.com/proto/7GwOMtipf9FTsq8XW5lClx/Truevisia?node-id=4-10474&t=R0F60A200gEkcEGg-1&show-proto-sidebar=1&starting-point-node-id=4%3A10474', 'figma', 'analyzed', NULL, NULL, 1, '2026-02-27 18:34:13', '2026-02-27 18:34:59', 1, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (10, 16, 'Figma需求-Figma basics', 'https://www.figma.com/design/QhPUNibpjsR5IPthH0rUd4/Figma-basics?node-id=1669-162202&p=f&t=oq2gl8rgOFaxQQwx-0', 'figma', 'analyzed', NULL, NULL, 1, '2026-02-28 09:42:51', '2026-02-28 10:06:15', 1, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (11, 16, 'Figma需求-Figma basics', 'https://www.figma.com/design/QhPUNibpjsR5IPthH0rUd4/Figma-basics?node-id=1669-162202&p=f&t=oq2gl8rgOFaxQQwx-0', 'figma', 'analyzed', NULL, NULL, 1, '2026-02-28 09:55:03', '2026-02-28 10:06:12', 1, NULL, 0, NULL);
INSERT INTO `requirement_documents` VALUES (12, 16, '00', 'static/upload/requirement_docs/20260312/fastapi.txt', 'txt', 'uploaded', 0, '', 1, '2026-03-12 17:43:29', '2026-03-12 17:44:03', NULL, NULL, 0, NULL);

-- ----------------------------
-- Table structure for review_assignments
-- ----------------------------
DROP TABLE IF EXISTS `review_assignments`;
CREATE TABLE `review_assignments`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `review_id` bigint NOT NULL COMMENT '评审ID',
  `reviewer_id` bigint NOT NULL COMMENT '评审人ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '评审状态: pending/in_progress/completed/rejected/human_review',
  `ai_pre_reviewed` tinyint(1) NULL DEFAULT 0 COMMENT '是否已进行AI预评审',
  `ai_pre_review_at` datetime NULL DEFAULT NULL COMMENT 'AI预评审时间',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评审意见',
  `checklist_results` json NULL COMMENT '检查清单结果',
  `reviewed_at` datetime NULL DEFAULT NULL COMMENT '评审时间',
  `assigned_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  `started_at` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_review_reviewer`(`review_id` ASC, `reviewer_id` ASC) USING BTREE,
  INDEX `idx_review`(`review_id` ASC) USING BTREE,
  INDEX `idx_reviewer`(`reviewer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评审分配表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review_assignments
-- ----------------------------

-- ----------------------------
-- Table structure for review_comments
-- ----------------------------
DROP TABLE IF EXISTS `review_comments`;
CREATE TABLE `review_comments`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `review_id` bigint NOT NULL COMMENT '评审ID',
  `test_case_id` bigint NULL DEFAULT NULL COMMENT '相关用例ID',
  `author_id` bigint NOT NULL COMMENT '评论者ID',
  `comment_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'general' COMMENT '意见类型: general/suggestion/issue/question',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '意见内容',
  `step_number` int NULL DEFAULT NULL COMMENT '步骤序号',
  `is_resolved` tinyint(1) NULL DEFAULT 0 COMMENT '是否已解决',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_review`(`review_id` ASC) USING BTREE,
  INDEX `idx_test_case`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_author`(`author_id` ASC) USING BTREE,
  INDEX `idx_resolved`(`is_resolved` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评审意见表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review_comments
-- ----------------------------

-- ----------------------------
-- Table structure for review_results
-- ----------------------------
DROP TABLE IF EXISTS `review_results`;
CREATE TABLE `review_results`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `review_id` bigint NOT NULL COMMENT '评审ID',
  `test_case_id` bigint NOT NULL COMMENT '测试用例ID',
  `reviewer_id` bigint NOT NULL COMMENT '评审人ID',
  `result` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评审结果: pass/fail/modify',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '评审意见',
  `reviewed_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评审时间',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_review_case_reviewer`(`review_id` ASC, `test_case_id` ASC, `reviewer_id` ASC) USING BTREE,
  INDEX `idx_review`(`review_id` ASC) USING BTREE,
  INDEX `idx_test_case`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_reviewer`(`reviewer_id` ASC) USING BTREE,
  INDEX `idx_result`(`result` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评审结果表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review_results
-- ----------------------------
INSERT INTO `review_results` VALUES (3, 10, 299, 1, 'fail', 'API测试需要修改', '2026-03-04 17:45:38', '2026-03-04 17:45:38', 1, '2026-03-04 17:45:38', 1, 1, NULL);
INSERT INTO `review_results` VALUES (7, 11, 1, 1, 'fail', '8888', '2026-03-04 17:50:07', '2026-03-04 17:50:07', 1, '2026-03-04 17:50:07', 1, 1, NULL);
INSERT INTO `review_results` VALUES (34, 12, 275, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (35, 12, 273, 1, 'fail', '继续编写', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (36, 12, 279, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (37, 12, 280, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (38, 12, 281, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (39, 12, 282, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (40, 12, 283, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (41, 12, 284, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (42, 12, 285, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (43, 12, 286, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (44, 12, 287, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (45, 12, 288, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (46, 12, 289, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (47, 12, 290, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (48, 12, 291, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (49, 12, 292, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (50, 12, 293, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (51, 12, 294, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (52, 12, 295, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (53, 12, 296, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (54, 12, 297, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (55, 12, 298, 1, 'pass', '', '2026-03-04 18:26:41', '2026-03-04 18:26:41', 1, '2026-03-04 18:26:41', 1, 1, NULL);
INSERT INTO `review_results` VALUES (56, 12, 276, 1, 'modify', '从写', '2026-03-04 18:26:43', '2026-03-04 18:26:43', 1, '2026-03-04 18:26:43', 1, 1, NULL);
INSERT INTO `review_results` VALUES (57, 12, 277, 1, 'pass', '', '2026-03-04 18:26:43', '2026-03-04 18:26:43', 1, '2026-03-04 18:26:43', 1, 1, NULL);
INSERT INTO `review_results` VALUES (58, 12, 274, 1, 'fail', '你好啊', '2026-03-04 18:26:43', '2026-03-04 18:26:43', 1, '2026-03-04 18:26:43', 1, 1, NULL);
INSERT INTO `review_results` VALUES (59, 12, 278, 1, 'pass', '', '2026-03-04 18:26:43', '2026-03-04 18:26:43', 1, '2026-03-04 18:26:43', 1, 1, NULL);
INSERT INTO `review_results` VALUES (60, 13, 273, 1, 'fail', '', '2026-03-04 21:52:17', '2026-03-04 21:52:17', 1, '2026-03-04 21:52:17', 1, 1, NULL);
INSERT INTO `review_results` VALUES (61, 13, 274, 1, 'modify', '用例考虑场景不够，重新考虑这个测试场景', '2026-03-05 09:48:09', '2026-03-05 09:48:09', 1, '2026-03-05 09:48:09', 1, 1, NULL);
INSERT INTO `review_results` VALUES (63, 16, 299, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 正常登录流程**\n2. 用户名错误/不存在**\n3. 密码错误**\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一标识符\n2. 优先级未定义**：无法判断测试重要性', '2026-03-05 11:39:22', '2026-03-05 11:39:22', 1, '2026-03-05 11:39:22', 1, 1, NULL);
INSERT INTO `review_results` VALUES (64, 17, 273, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 异常访问场景**：\n2. 设备未连接时访问固件升级页面\n3. 用户无权限时的访问控制\n\n【发现问题】:\n1. 用例ID缺失**：缺少唯一标识符，不利于用例管理和追踪\n2. 测试环境信息不足**：未明确操作系统、浏览器版本、设备型号等关键信息', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (65, 17, 274, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 不同网络环境下的加载时间测试**\n2. 异常网络情况下的页面行为**\n3. 页面元素加载失败的容错性**\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符\n2. 测试环境信息不足**：未说明设备型号、固件版本、浏览器类型等', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (66, 17, 275, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 异常场景**：设备连接失败时的版本显示\n2. 边界条件**：版本号为空、超长、特殊字符的处理\n3. 兼容性测试**：不同设备型号的版本显示差异\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符\n2. 优先级未定义**：无法判断测试重要程度', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (67, 17, 276, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 固件版本为null值的显示场景\n2. 固件版本为空字符串的显示场景\n3. 网络异常时的显示场景\n\n【发现问题】:\n1. ID缺失**：测试用例缺少唯一标识符\n2. 环境信息缺失**：未说明测试环境、设备型号、软件版本等', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (68, 17, 277, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 设备未连接时的按钮状态**\n2. 固件已是最新版本时的按钮状态**\n3. 网络异常情况下的按钮显示**\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符\n2. 测试环境信息缺失**：未说明设备型号、固件版本、操作系统等', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (69, 17, 278, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 固件文件验证场景**\n2. 网络异常处理场景**\n3. 权限验证场景**\n\n【发现问题】:\n1. 测试环境信息缺失**：未说明设备状态、网络环境、固件版本等关键信息\n2. 优先级未定义**：无法判断测试执行优先级', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (70, 17, 279, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 文件格式验证**：测试支持和不支持的文件格式\n2. 文件大小边界**：测试最大允许大小、超大文件处理\n3. 文件完整性**：测试损坏文件、不完整文件的处理\n\n【发现问题】:\n1. 用例ID缺失**：未提供唯一标识符，无法进行用例管理\n2. 测试数据缺失**：未指定具体的固件文件类型、大小、格式要求', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (71, 17, 280, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 其他非法格式测试**：.doc、.pdf、.jpg等\n2. 合法格式测试**：.bin、.hex、.fw等\n3. 文件大小边界测试**：超大文件、空文件\n\n【发现问题】:\n1. ID缺失**：测试用例缺少唯一标识符\n2. 优先级缺失**：未标注测试用例优先级', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (72, 17, 281, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 正常大小文件上传**（正向场景）\n2. 刚好等于限制大小的文件**（边界值）\n3. 略小于限制大小的文件**（边界值）\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符\n2. 文件大小限制值缺失**：未明确说明限制的具体数值（如100MB）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (73, 17, 282, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 文件格式验证**：上传非固件格式文件\n2. 文件大小边界**：超大文件、超小文件\n3. 文件损坏场景**：损坏的固件文件\n\n【发现问题】:\n1. ID**: TC-001 - 缺少用例ID、优先级、模块归属等基本信息\n2. ID**: TC-001 - 前置条件过于简单，未明确页面状态（如是否有其他文件已选择）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (74, 17, 283, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 网络异常场景**: 网络中断时进度显示\n2. 设备异常场景**: 设备突然断电的进度处理\n3. 进度异常场景**: 进度卡死、回退、超100%等\n\n【发现问题】:\n1. ID**: TC-001 - 前置条件\"固件升级正在进行中\"与测试步骤\"开始固件升级\"逻辑矛盾\n2. ID**: TC-001 - 缺少设备型号、固件版本等关键测试环境信息', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (75, 17, 284, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 网络恢复后的自动重连处理**\n2. 多次网络中断的累积影响**\n3. 升级开始阶段的网络中断**\n\n【发现问题】:\n1. 用例ID缺失**：缺少唯一标识符，不利于用例管理和追踪\n2. 测试环境描述不足**：未明确网络中断的具体方式（WiFi断开、网线拔掉、防火墙阻断等）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (76, 17, 285, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级前设备断开**：验证是否允许在设备未连接时启动升级\n2. 升级完成后的设备断开**：验证升级成功后设备断开的处理\n3. 网络延迟导致的假断开**：验证短暂网络波动的处理机制\n\n【发现问题】:\n1. 用例ID**: 该用例（固件升级过程中的设备断开处理）\n2. 用例ID**: 该用例', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (77, 17, 286, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级失败状态显示**\n2. 升级过程中断网处理**\n3. 升级超时状态处理**\n\n【发现问题】:\n1. ID-001**: 前置条件\"固件升级成功完成\"与测试步骤\"完成固件升级\"逻辑重复，存在循环依赖\n2. ID-002**: 测试步骤过于笼统，\"观察页面状态\"无法准确执行', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (78, 17, 287, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 网络中断导致的升级失败**\n2. 固件包损坏导致的升级失败**\n3. 设备存储空间不足导致的升级失败**\n\n【发现问题】:\n1. ID: TC-001** - 缺少用例ID、优先级、模块归属等基本信息\n2. ID: TC-001** - 前置条件过于简单，未说明设备当前状态、网络连接状态等', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (79, 17, 288, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级进度5%时刷新页面\n2. 升级进度50%时刷新页面\n3. 升级进度90%时刷新页面\n\n【发现问题】:\n1. ID**: TC-001 - 缺少测试用例ID编号\n2. ID**: TC-001 - 缺少测试环境要求（浏览器类型、设备型号等）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (80, 17, 289, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级开始后立即关闭页面** - 验证初始化阶段中断处理\n2. 升级进度50%时关闭页面** - 验证中间阶段中断处理\n3. 升级完成前关闭页面** - 验证完成阶段中断处理\n\n【发现问题】:\n1. ID**: TC-001-完整性 - 缺少用例ID、优先级、模块归属等基础信息\n2. ID**: TC-001-前置条件 - \"固件升级进行中\"过于模糊，未说明如何进入升级状态', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (81, 17, 290, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级前状态验证**：按钮是否可点击\n2. 升级完成后状态**：按钮是否恢复正常状态\n3. 升级失败后状态**：按钮是否可重新点击\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符，无法进行追踪管理\n2. 测试环境描述不足**：缺少设备状态、网络环境等关键信息', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (82, 17, 291, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 高进度取消场景**：升级进度80%以上时的取消行为\n2. 异常网络场景**：网络不稳定时的取消操作\n3. 资源竞争场景**：系统资源紧张时的取消处理\n\n【发现问题】:\n1. ID**: TC-001-001 - 前置条件中\"升级进度小于80%\"缺乏具体验证方法\n2. ID**: TC-001-002 - 缺少测试数据准备（如固件文件、设备型号等）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (83, 17, 292, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 文件选择验证**：不同格式文件的处理\n2. 异常场景**：网络中断、存储空间不足、权限不足\n3. 边界条件**：超大文件、文件名长度限制、特殊字符\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符，无法进行追踪管理\n2. 重要信息缺失**：缺少优先级、测试类型、所属模块等基本信息', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (84, 17, 293, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 网络异常场景**: 断网状态下取消升级操作\n2. 系统资源不足**: 存储空间不足时的取消操作\n3. 多设备场景**: 同时连接多设备时的取消操作\n\n【发现问题】:\n1. TC001**: 前置条件过于简单，未说明\"升级确认弹窗\"的具体状态（如固件版本信息、升级文件是否有效等）\n2. TC002**: 缺少环境准备步骤（设备连接状态、网络状态等）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (85, 17, 294, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 取消操作验证**\n2. 固件包损坏场景**\n3. 存储空间不足场景**\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一的用例标识符\n2. 优先级未定义**：无法判断测试的重要程度', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (86, 17, 295, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 正向兼容测试**：验证兼容固件版本的升级流程\n2. 边界版本测试**：临界版本号的兼容性验证\n3. 网络异常测试**：检查过程中网络中断的处理\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一标识符，无法追踪和管理\n2. 版本信息缺失**：没有测试用例版本号和创建时间', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (87, 17, 296, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 正常固件文件上传测试**\n2. 不同损坏程度的文件测试**（部分损坏、头部损坏、尾部损坏）\n3. 文件格式验证测试**（非固件格式文件）\n\n【发现问题】:\n1. 用例ID缺失**：没有唯一标识符，无法追踪和管理\n2. 测试环境描述不足**：缺少设备状态、系统版本等关键信息', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (88, 17, 297, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 升级过程中网络中断恢复测试**\n2. 升级过程中断电重启测试**\n3. 固件包校验失败测试**\n\n【发现问题】:\n1. ID001**: 前置条件过于模糊，\"固件升级进行中\"没有具体的状态定义\n2. ID002**: 缺少必要的环境准备信息（设备型号、当前固件版本、目标固件版本）', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);
INSERT INTO `review_results` VALUES (89, 17, 298, 1, 'fail', 'AI预评审:\n\n【AI建议】:\n1. 正常业务流程测试\n2. 输入验证测试\n3. 异常处理测试\n\n【发现问题】:\n1. ID-001**: 标题为\"未命名用例\"，完全无法表达测试意图\n2. 缺少业务场景描述，无法理解测试目标', '2026-03-05 11:53:59', '2026-03-05 11:53:59', 1, '2026-03-05 11:53:59', 1, 1, NULL);

-- ----------------------------
-- Table structure for review_templates
-- ----------------------------
DROP TABLE IF EXISTS `review_templates`;
CREATE TABLE `review_templates`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '模板描述',
  `checklist` json NULL COMMENT '检查清单',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creator_id` bigint NOT NULL COMMENT '创建人ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_creator`(`creator_id` ASC) USING BTREE,
  INDEX `idx_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评审模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review_templates
-- ----------------------------

-- ----------------------------
-- Table structure for review_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `review_test_cases`;
CREATE TABLE `review_test_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `review_id` bigint NOT NULL COMMENT '评审ID',
  `test_case_id` bigint NOT NULL COMMENT '测试用例ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_review_case`(`review_id` ASC, `test_case_id` ASC) USING BTREE,
  INDEX `idx_review`(`review_id` ASC) USING BTREE,
  INDEX `idx_test_case`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 136 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评审用例关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review_test_cases
-- ----------------------------

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_role_menu_role_id`(`role_id` ASC) USING BTREE,
  INDEX `ix_role_menu_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 322 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_menu
-- ----------------------------
INSERT INTO `role_menu` VALUES (2, 93, 191, '2026-01-30 17:11:31', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_menu` VALUES (2, 94, 192, '2026-01-30 17:11:31', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_menu` VALUES (2, 1, 193, '2026-01-30 17:11:31', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 1, 197, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 28, 198, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 29, 199, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 30, 200, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 31, 201, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 51, 202, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 61, 203, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 63, 204, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 64, 205, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 65, 206, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 66, 207, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 67, 208, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 76, 209, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 77, 210, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 78, 211, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 79, 212, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 80, 213, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 81, 214, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 82, 215, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 83, 216, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 84, 217, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 85, 218, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 86, 219, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 87, 220, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 88, 221, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 89, 222, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 90, 223, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 91, 224, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 92, 225, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 93, 226, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 94, 227, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 95, 228, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 96, 229, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (1, 97, 230, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (3, 1, 231, '2026-01-30 17:18:59', 1, '2026-01-30 17:18:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (3, 93, 232, '2026-01-30 17:18:59', 1, '2026-01-30 17:18:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (3, 94, 233, '2026-01-30 17:18:59', 1, '2026-01-30 17:18:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 1, 234, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 93, 235, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 94, 236, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 29, 237, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 85, 238, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 86, 239, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 87, 240, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 88, 241, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 89, 242, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 90, 243, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 91, 244, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 92, 245, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 79, 246, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 80, 247, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 81, 248, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 82, 249, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 83, 250, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 84, 251, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 51, 252, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 66, 253, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 61, 254, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (4, 67, 255, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 1, 291, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 93, 292, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 29, 293, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 85, 294, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 89, 295, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 79, 296, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 101, 297, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 66, 298, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 61, 299, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (8, 67, 300, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 1, 311, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 93, 312, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 105, 313, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 85, 314, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 100, 315, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 89, 316, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 79, 317, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 101, 318, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 66, 319, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 61, 320, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);
INSERT INTO `role_menu` VALUES (6, 67, 321, '2026-01-31 09:24:59', 1, '2026-01-31 09:24:59', 1, 1, NULL);

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_role_permission_permission_id`(`permission_id` ASC) USING BTREE,
  INDEX `ix_role_permission_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 243 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (1, 48, 126, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 49, 127, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 50, 128, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 51, 129, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 52, 130, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 53, 131, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 54, 132, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 55, 133, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 56, 134, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 57, 135, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 58, 136, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 59, 137, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 60, 138, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 61, 139, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 62, 140, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 63, 141, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 64, 142, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 65, 143, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 66, 144, '2026-01-30 17:18:09', 1, '2026-01-30 17:18:09', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (3, 62, 145, '2026-01-30 17:18:59', 1, '2026-01-30 17:18:59', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (3, 63, 146, '2026-01-30 17:18:59', 1, '2026-01-30 17:18:59', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 48, 147, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 49, 148, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 50, 149, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 51, 150, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 52, 151, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 53, 152, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 54, 153, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 55, 154, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 56, 155, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 57, 156, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 58, 157, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 59, 158, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 60, 159, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 61, 160, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 62, 161, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (4, 63, 162, '2026-01-30 17:20:48', 1, '2026-01-30 17:20:48', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 79, 184, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 80, 185, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 81, 186, '2026-01-30 18:28:17', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 82, 187, '2026-01-30 18:28:18', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (8, 48, 188, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (8, 54, 189, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (8, 58, 190, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (8, 62, 191, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (8, 81, 192, '2026-01-31 09:02:21', 1, '2026-01-31 09:02:21', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 84, 198, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 85, 199, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 86, 200, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 87, 201, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 88, 202, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 89, 203, '2026-01-31 09:08:52', 1, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 48, 204, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 54, 205, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 58, 206, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 62, 207, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 83, 208, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 81, 209, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (6, 80, 210, '2026-01-31 09:25:00', 1, '2026-01-31 09:25:00', 1, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 95, 211, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 94, 212, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 92, 213, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 93, 214, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 91, 215, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 90, 216, '2026-02-03 09:50:03', NULL, NULL, NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 83, 217, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 96, 218, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 97, 219, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 98, 220, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 99, 221, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 100, 222, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 101, 223, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 102, 224, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 103, 225, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 104, 226, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 105, 227, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 106, 228, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 107, 229, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 108, 230, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 109, 231, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 110, 232, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 111, 233, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 112, 234, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 113, 235, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 114, 236, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 115, 237, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 116, 238, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 117, 239, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 118, 240, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 119, 241, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);
INSERT INTO `role_permission` VALUES (1, 120, 242, '2026-02-03 11:40:54', 1, '2026-02-03 11:40:54', NULL, 1, NULL);

-- ----------------------------
-- Table structure for sys_code_sequence
-- ----------------------------
DROP TABLE IF EXISTS `sys_code_sequence`;
CREATE TABLE `sys_code_sequence`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `business_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '业务类型',
  `prefix` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '前缀',
  `date_key` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '日期键（用于按日期重置）',
  `current_seq` int NULL DEFAULT 0 COMMENT '当前序号',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_business_prefix_date`(`business_type` ASC, `prefix` ASC, `date_key` ASC) USING BTREE,
  INDEX `idx_business_type`(`business_type` ASC) USING BTREE,
  INDEX `idx_date_key`(`date_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '编码序号表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_code_sequence
-- ----------------------------
INSERT INTO `sys_code_sequence` VALUES (1, 'test_order_seq', 'ORDER', '20260205', 3, '2026-02-05 11:02:48', NULL, '2026-02-05 11:02:49', NULL, 1, NULL);
INSERT INTO `sys_code_sequence` VALUES (2, 'test_contract', 'CONTRACT', '202602', 1, '2026-02-05 11:02:50', NULL, '2026-02-05 11:02:50', NULL, 1, NULL);
INSERT INTO `sys_code_sequence` VALUES (3, 'test', 'ORDER', '20260205', 1, '2026-02-05 12:13:20', NULL, '2026-02-05 12:13:20', NULL, 1, NULL);

-- ----------------------------
-- Table structure for sys_conversation
-- ----------------------------
DROP TABLE IF EXISTS `sys_conversation`;
CREATE TABLE `sys_conversation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对话标题',
  `llm_config_id` bigint NULL DEFAULT NULL COMMENT 'LLM配置ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '是否活跃（1是 0否）',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NOT NULL COMMENT '创建人',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NOT NULL COMMENT '更新人',
  `enabled_flag` tinyint NOT NULL DEFAULT 1 COMMENT '启用标志（1启用 0禁用）',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_llm_config_id`(`llm_config_id` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE,
  CONSTRAINT `fk_conversation_llm_config` FOREIGN KEY (`llm_config_id`) REFERENCES `sys_llm_config` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI 对话表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_conversation
-- ----------------------------
INSERT INTO `sys_conversation` VALUES (1, 'b5bfb5d9-2b53-4b4c-b56d-fe555cb57bfc', '更新后的标题', NULL, 1, 1, '2026-02-05 14:48:58', 1, '2026-02-05 14:49:05', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (2, '3bfda608-85b8-4828-9353-00eb049e21e9', '更新后的标题', NULL, 1, 1, '2026-02-05 14:49:42', 1, '2026-02-05 14:49:47', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (3, '61104b18-c6a0-47a6-a7fe-f430bd703f83', '用python写个冒泡排序', NULL, 1, 1, '2026-02-05 15:13:01', 1, '2026-02-05 15:15:47', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (4, '7cb3e0c0-0e7c-4254-b588-225e176ed509', '你是谁9', NULL, 1, 1, '2026-02-05 15:18:27', 1, '2026-02-05 16:15:09', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (5, '54013f33-19ad-46d2-98f0-b45eaa092b29', '新对话', NULL, 1, 1, '2026-02-05 15:31:44', 1, '2026-02-05 16:37:53', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (6, '94fd0319-1cbc-4fb6-990f-c7a3c16088d4', '你是谁', NULL, 1, 1, '2026-02-05 15:42:17', 1, '2026-02-05 16:37:48', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (7, '98df2a1f-2300-4d70-bfc5-ac11b7e43304', '新对话', NULL, 1, 1, '2026-02-05 15:47:06', 1, '2026-02-05 16:37:51', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (8, '927e8b99-62a5-4ab3-bcfe-7c3376331d7a', '你是谁', NULL, 1, 1, '2026-02-05 15:57:32', 1, '2026-02-05 16:18:14', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (9, '3e93745d-4386-4cca-83bb-d24a72754f6a', '新对话', NULL, 1, 1, '2026-02-05 16:12:20', 1, '2026-02-05 16:37:46', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (10, '9541b11b-9e9e-404d-827f-fe6b3fe2a892', '新对话', NULL, 1, 1, '2026-02-05 16:27:00', 1, '2026-02-05 16:37:43', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (11, 'd76f35ae-4b17-48ec-a697-9ed7e028dbbc', '新对话', NULL, 1, 1, '2026-02-05 16:36:41', 1, '2026-02-05 16:37:41', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (12, '3a659b23-0d5c-4c02-823c-ccb24cadfd17', '新对话', NULL, 1, 1, '2026-02-05 16:37:30', 1, '2026-02-05 16:37:38', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (13, 'afbdfbd6-90dc-4840-809b-fe62d13daf50', '新对话', NULL, 1, 1, '2026-02-05 16:37:57', 1, '2026-02-05 17:16:48', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (14, '93e174e7-d01c-4ffd-90ad-73e156066787', '新对话', NULL, 1, 1, '2026-02-05 16:40:23', 1, '2026-02-05 18:21:44', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (15, 'f37be5a6-1ead-4f25-a88a-7c7d32482413', '新对话', NULL, 1, 1, '2026-02-05 17:21:45', 1, '2026-02-05 18:21:47', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (16, 'ddf71dce-c5d0-4270-b8f5-f028e968022f', '新对话', NULL, 1, 1, '2026-02-05 17:32:47', 1, '2026-02-05 18:21:50', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (17, 'ea70d41d-1a6e-4445-a85c-c18d0e6b140e', '测试对话', NULL, 1, 1, '2026-02-05 18:07:53', 1, '2026-02-05 18:22:02', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (18, '66763110-9fb7-409d-8a56-abbdb5fdc7ba', '新对话', NULL, 1, 1, '2026-02-05 18:22:03', 1, '2026-03-03 14:12:48', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (19, '2adcbccc-0545-48e7-8228-cd85b4e3b682', '新对话', NULL, 1, 1, '2026-02-05 18:36:08', 1, '2026-03-03 14:12:42', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (20, 'b1ac79fe-fe96-4971-b7d3-fc3005f274a3', '新对话', NULL, 1, 1, '2026-02-25 17:27:59', 1, '2026-02-27 08:54:45', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (21, '8d02c788-50f7-40e4-a8c9-f856c78281f9', '新对话', NULL, 1, 1, '2026-03-02 11:04:19', 1, '2026-03-03 14:12:40', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (22, 'd783dd8d-7141-4201-a3cf-71169b1f80ee', '新对话', NULL, 1, 1, '2026-03-03 14:12:30', 1, '2026-03-03 14:12:37', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (23, '752f9c41-7736-40d4-9153-133fcfbd7d31', '新对话henaho de ', NULL, 1, 1, '2026-03-03 14:12:50', 1, '2026-03-03 14:13:01', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (24, '6c01aad0-22c0-40ae-a29b-64027ba59e3b', '新对话', NULL, 1, 1, '2026-03-08 13:47:27', 1, '2026-03-09 11:49:50', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (25, '0714ffc2-d5ac-40dc-a161-80afda070b35', '新对话', NULL, 1, 1, '2026-03-09 11:49:28', 1, '2026-03-09 11:49:48', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (26, '139b0010-a868-4a3c-b802-30768c3b002e', '新对话', NULL, 1, 1, '2026-03-09 11:49:36', 1, '2026-03-09 11:49:45', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (27, '1eb9c4a8-51dc-482c-a5d0-ea86b82c08ea', '新对话', NULL, 1, 1, '2026-03-09 11:49:52', 1, '2026-03-09 11:58:03', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (28, '158115e9-73cc-4502-afac-7e7699c2254a', '新对话', NULL, 1, 1, '2026-03-09 11:54:41', 1, '2026-03-09 11:58:08', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (29, 'b44b128f-5d62-4416-a972-b647ff2dab84', '新对话', NULL, 1, 1, '2026-03-09 11:58:10', 1, '2026-03-09 11:58:15', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (30, '5c79fbb2-ac9c-44ee-bd6e-ce01bfe4271c', '新对话', NULL, 1, 1, '2026-03-09 11:58:16', 1, '2026-03-10 17:06:49', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (31, '6b767e2e-7b30-4405-8207-2406c12eff19', '新对话', NULL, 1, 1, '2026-03-09 12:05:59', 1, '2026-03-09 19:15:05', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (32, '0cdeb081-3035-45ae-8575-1ff5167d6a4a', '新对话', NULL, 1, 1, '2026-03-09 12:10:35', 1, '2026-03-09 19:14:59', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (33, '4fc29093-19b8-428d-9990-03f0b6052157', '新对话', NULL, 1, 1, '2026-03-09 12:12:34', 1, '2026-03-09 19:14:56', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (34, '5cfc3dbe-9396-4b9c-aac9-395980160df4', '新对话', NULL, 1, 1, '2026-03-09 19:14:12', 1, '2026-03-09 19:14:53', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (35, 'b4654df9-5af7-4d2f-ada9-644709f9e4c0', '新对话', NULL, 1, 1, '2026-03-10 17:06:50', 1, '2026-03-23 08:56:54', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (36, '9c3e5201-866c-4256-8d9e-849df63af796', '新对话', NULL, 1, 1, '2026-03-10 17:32:37', 1, '2026-03-30 14:41:22', 1, 0, NULL);
INSERT INTO `sys_conversation` VALUES (37, '6b898f47-fe02-4fd6-8b3c-824673919c45', '新对话', NULL, 1, 1, '2026-03-10 17:34:13', 1, '2026-03-30 14:41:19', 1, 0, NULL);

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dept_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部门名称',
  `dept_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门编码',
  `parent_id` int NULL DEFAULT 0 COMMENT '父部门ID（0表示顶级部门）',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '祖级列表（逗号分隔）',
  `leader_id` bigint NULL DEFAULT NULL COMMENT '负责人ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` int NULL DEFAULT 1 COMMENT '状态（0:禁用 1:启用）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门描述',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_sys_dept_dept_code`(`dept_code` ASC) USING BTREE,
  INDEX `fk_sys_dept_leader_id`(`leader_id` ASC) USING BTREE,
  CONSTRAINT `fk_sys_dept_leader_id` FOREIGN KEY (`leader_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (1, '总公司', 'ROOT', 0, NULL, NULL, NULL, NULL, 0, 1, '顶级部门', '2026-01-31 18:06:08', NULL, '2026-02-03 09:17:02', 1, 1, NULL, NULL, '2026-02-03 09:17:03');
INSERT INTO `sys_dept` VALUES (6, '测试部', NULL, 0, '0', NULL, NULL, NULL, 0, 1, '', '2026-02-02 14:13:48', 1, '2026-02-02 14:13:48', 1, 1, NULL, '2026-02-02 14:13:49', '2026-02-02 14:13:49');
INSERT INTO `sys_dept` VALUES (7, '研发部', NULL, 0, '0', NULL, NULL, NULL, 0, 1, '', '2026-02-02 14:13:56', 1, '2026-02-02 14:13:56', 1, 1, NULL, '2026-02-02 14:13:56', '2026-02-02 14:13:56');
INSERT INTO `sys_dept` VALUES (8, '研发部一部', NULL, 7, '0,7', NULL, NULL, NULL, 0, 1, '', '2026-02-02 14:14:33', 1, '2026-02-02 14:14:33', 1, 1, NULL, '2026-02-02 14:14:34', '2026-02-02 14:14:34');
INSERT INTO `sys_dept` VALUES (9, '研发二部', NULL, 8, '0,7,8', NULL, NULL, NULL, 0, 1, '', '2026-02-02 14:14:43', 1, '2026-02-02 14:14:43', 1, 1, NULL, '2026-02-02 14:14:44', '2026-02-02 14:14:44');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（CSS类名）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` int NULL DEFAULT 0 COMMENT '是否默认（0:否 1:是）',
  `status` int NULL DEFAULT 1 COMMENT '状态（0:禁用 1:启用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_sys_dict_data_dict_type`(`dict_type` ASC) USING BTREE,
  CONSTRAINT `sys_dict_data_ibfk_1` FOREIGN KEY (`dict_type`) REFERENCES `sys_dict_type` (`dict_type`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '1', 'sys_show_hide', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '0', 'sys_show_hide', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '1', 'sys_normal_disable', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '0', 'sys_normal_disable', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '1', 'sys_job_status', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '0', 'sys_job_status', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (10, 1, '是', '1', 'sys_yes_no', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (11, 2, '否', '0', 'sys_yes_no', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (12, 1, '通知', '1', 'sys_notice_type', NULL, 'warning', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (13, 2, '公告', '2', 'sys_notice_type', NULL, 'success', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (14, 1, '正常', '1', 'sys_notice_status', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (15, 2, '关闭', '0', 'sys_notice_status', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (16, 1, '其他', '0', 'sys_oper_type', NULL, 'info', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (17, 2, '新增', '1', 'sys_oper_type', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (18, 3, '修改', '2', 'sys_oper_type', NULL, 'success', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (19, 4, '删除', '3', 'sys_oper_type', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (20, 5, '授权', '4', 'sys_oper_type', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (21, 6, '导出', '5', 'sys_oper_type', NULL, 'warning', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (22, 7, '导入', '6', 'sys_oper_type', NULL, 'warning', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (23, 8, '强退', '7', 'sys_oper_type', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (24, 9, '清空', '8', 'sys_oper_type', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (25, 1, '成功', '1', 'sys_common_status', NULL, 'primary', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (26, 2, '失败', '0', 'sys_common_status', NULL, 'danger', 0, 1, NULL, '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典类型',
  `status` int NULL DEFAULT 1 COMMENT '状态（0:禁用 1:启用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_sys_dict_type_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', 1, '菜单状态列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', 1, '系统开关列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', 1, '任务状态列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (5, '系统是否', 'sys_yes_no', 1, '系统是否列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (6, '通知类型', 'sys_notice_type', 1, '通知类型列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (7, '通知状态', 'sys_notice_status', 1, '通知状态列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (8, '操作类型', 'sys_oper_type', 1, '操作类型列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (9, '系统状态', 'sys_common_status', 1, '登录状态列表', '2026-01-31 18:21:28', NULL, '2026-01-31 18:21:28', NULL, 1, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储的文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件访问URL',
  `file_size` int NOT NULL COMMENT '文件大小（字节）',
  `file_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件MIME类型',
  `file_ext` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件扩展名',
  `upload_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上传类型（local/oss/database）',
  `storage_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '存储路径',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文件描述',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件标签',
  `download_count` int NOT NULL DEFAULT 0 COMMENT '下载次数',
  `is_public` tinyint NOT NULL DEFAULT 1 COMMENT '是否公开（0:私有 1:公开）',
  `uploaded_by` int NOT NULL COMMENT '上传用户ID',
  `uploaded_at` datetime NOT NULL COMMENT '上传时间',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `file_content` longblob NULL COMMENT '文件二进制内容（用于数据库存储模式）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_file_name`(`file_name` ASC) USING BTREE,
  INDEX `idx_original_name`(`original_name` ASC) USING BTREE,
  INDEX `idx_file_ext`(`file_ext` ASC) USING BTREE,
  INDEX `idx_upload_type`(`upload_type` ASC) USING BTREE,
  INDEX `idx_uploaded_by`(`uploaded_by` ASC) USING BTREE,
  INDEX `idx_is_public`(`is_public` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file
-- ----------------------------

-- ----------------------------
-- Table structure for sys_llm_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_llm_config`;
CREATE TABLE `sys_llm_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户自定义的配置名称',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '模型名称',
  `provider` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'LLM 提供商',
  `model_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '模型名称（兼容字段）',
  `api_key` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'API 密钥（本地模型如 Ollama 可为空）',
  `base_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'API 基础URL',
  `system_prompt` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '系统级提示词',
  `temperature` float NULL DEFAULT 0.7 COMMENT '温度参数',
  `max_tokens` int NULL DEFAULT 2000 COMMENT '最大令牌数',
  `supports_vision` tinyint(1) NULL DEFAULT 0 COMMENT '是否支持多模态',
  `context_limit` int NULL DEFAULT 128000 COMMENT '最大上下文Token数',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否为默认配置',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_provider`(`provider` ASC) USING BTREE,
  INDEX `idx_is_default`(`is_default` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'LLM 配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_llm_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `login_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web' COMMENT '登录类型',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录IP',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录地点',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浏览器',
  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作系统',
  `status` int NOT NULL COMMENT '登录状态（0:失败 1:成功）',
  `message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录信息',
  `login_time` datetime NOT NULL COMMENT '登录时间',
  `logout_time` datetime NULL DEFAULT NULL COMMENT '退出时间',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_login_type`(`login_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_login_time`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 513 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '登录日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` int NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0:是 1:否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0:缓存 1:不缓存）',
  `menu_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单类型（M:目录 C:菜单 F:按钮）',
  `visible` int NULL DEFAULT 1 COMMENT '菜单状态（0:隐藏 1:显示）',
  `hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否在侧边栏隐藏（0显示 1隐藏）',
  `status` int NULL DEFAULT 1 COMMENT '菜单状态（0:停用 1:正常）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 8, '/system', '', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-BellFilled', '系统管理目录', '2026-01-31 18:24:44', NULL, '2026-03-06 13:35:29', 1, 1, NULL, NULL, '2026-03-06 13:35:29');
INSERT INTO `sys_menu` VALUES (2, '用户管理', 1, 1, '/system/user', 'system/user/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:user:list', 'ele-User', '用户管理菜单', '2026-01-31 18:24:44', NULL, '2026-02-03 14:50:18', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (3, '角色管理', 1, 2, '/system/role', 'system/role/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:role:list', 'ele-UserFilled', '角色管理菜单', '2026-01-31 18:24:44', NULL, '2026-02-03 14:50:18', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4, '菜单管理', 1, 3, '/system/menu', 'system/menu/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:menu:list', 'ele-Menu', '菜单管理菜单', '2026-01-31 18:24:44', NULL, '2026-02-03 14:39:47', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (5, '部门管理', 1, 4, '/system/dept', 'system/dept/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:dept:list', 'ele-CreditCard', '部门管理菜单', '2026-01-31 18:24:44', NULL, '2026-02-03 14:50:18', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (6, '字典管理', 1, 5, '/system/dic', 'system/dic/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:dict:list', 'ele-CreditCard', '字典管理菜单', '2026-01-31 18:24:44', NULL, '2026-02-03 14:50:18', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (7, '首页', 0, 0, '/home', 'home/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:menu', 'ele-HomeFilled', '首页', '2026-01-31 18:24:44', NULL, '2026-02-02 10:04:24', 1, 1, NULL, NULL, '2026-02-02 10:04:25');
INSERT INTO `sys_menu` VALUES (8, '用户查询', 2, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:list', NULL, '用户查询按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (9, '用户新增', 2, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:add', NULL, '用户新增按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (10, '用户编辑', 2, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:edit', NULL, '用户编辑按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (11, '用户删除', 2, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:delete', NULL, '用户删除按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (12, '用户状态', 2, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:status', NULL, '用户状态切换按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (13, '重置密码', 2, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:user:reset-password', NULL, '重置密码按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (14, '角色查询', 3, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:role:list', NULL, '角色查询按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (15, '角色新增', 3, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:role:add', NULL, '角色新增按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (16, '角色编辑', 3, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:role:edit', NULL, '角色编辑按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (17, '角色删除', 3, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:role:delete', NULL, '角色删除按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (18, '分配权限', 3, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:role:menu', NULL, '分配菜单权限按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (20, '部门新增', 5, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dept:add', NULL, '部门新增按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (21, '部门编辑', 5, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dept:edit', NULL, '部门编辑按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (22, '部门删除', 5, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dept:delete', NULL, '部门删除按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (23, '菜单查询', 4, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:menu:list', NULL, '菜单查询按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (24, '菜单新增', 4, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:menu:add', NULL, '菜单新增按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (25, '菜单编辑', 4, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:menu:edit', NULL, '菜单编辑按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (26, '菜单删除', 4, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:menu:delete', NULL, '菜单删除按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (27, '字典查询', 6, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:list', NULL, '字典查询按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (28, '字典新增', 6, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:add', NULL, '字典新增按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (29, '字典编辑', 6, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:edit', NULL, '字典编辑按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (30, '字典删除', 6, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:delete', NULL, '字典删除按钮', '2026-02-02 08:57:41', NULL, '2026-02-02 08:57:41', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (34, '接口管理', 0, 50, '/system/apiDoc', 'system/apiDoc/index', 'layout', 0, 1, 'C', 1, 0, 1, NULL, 'ele-CreditCard', '接口管理', '2026-02-02 10:10:58', 1, '2026-02-03 14:50:18', 1, 1, NULL, '2026-02-02 10:10:59', '2026-02-03 10:00:59');
INSERT INTO `sys_menu` VALUES (35, 'Swagger文档', 34, 1, '/system/apiDoc/swagger', 'system/apiDoc/swagger', NULL, 1, 1, 'C', 1, 0, 1, NULL, 'ele-ChatLineSquare', NULL, '2026-02-02 10:12:48', 1, '2026-02-03 14:50:18', 1, 1, NULL, '2026-02-02 10:12:48', '2026-02-02 15:32:05');
INSERT INTO `sys_menu` VALUES (36, 'Redoc文档', 34, 2, '/system/apiDoc/redoc', 'system/apiDoc/redoc', NULL, 1, 1, 'C', 1, 0, 1, NULL, 'ele-CopyDocument', NULL, '2026-02-02 10:57:27', 1, '2026-02-03 14:50:18', 1, 1, NULL, '2026-02-02 10:57:28', '2026-02-02 15:33:15');
INSERT INTO `sys_menu` VALUES (44, '部门查询', 5, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dept:query', NULL, NULL, '2026-02-02 13:51:59', 1, '2026-02-02 13:51:59', 1, 1, NULL, '2026-02-02 13:51:59', '2026-02-02 13:51:59');
INSERT INTO `sys_menu` VALUES (45, '启用禁用', 5, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dept:disable', NULL, NULL, '2026-02-02 13:51:59', 1, '2026-02-02 13:51:59', 1, 1, NULL, '2026-02-02 13:51:59', '2026-02-02 13:51:59');
INSERT INTO `sys_menu` VALUES (46, '字典类型查询', 6, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:type:query', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (47, '字典类型新增', 6, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:type:add', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (48, '字典类型编辑', 6, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:type:edit', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (49, '字典类型删除', 6, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:type:delete', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (50, '字典数据查询', 6, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:data:query', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (51, '字典数据新增', 6, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:data:add', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (52, '字典数据编辑', 6, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:data:edit', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (53, '字典数据删除', 6, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:dict:data:delete', NULL, NULL, '2026-02-02 14:24:20', 1, '2026-02-02 14:24:20', 1, 1, NULL, '2026-02-02 14:24:20', '2026-02-02 14:24:20');
INSERT INTO `sys_menu` VALUES (55, '个人中心', 1, 6, '/system/personal', 'system/personal/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Avatar', NULL, '2026-02-02 15:58:29', 1, '2026-02-03 14:50:18', 1, 1, NULL, '2026-02-02 15:58:29', '2026-02-02 15:58:51');
INSERT INTO `sys_menu` VALUES (58, '文件管理', 0, 10, '/system/file', 'system/file/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:file:list', 'ele-FolderOpened', '文件管理菜单', '2026-02-02 17:04:03', 1, '2026-03-16 14:08:20', 1, 1, NULL, '2026-02-02 17:04:03', '2026-03-16 14:08:20');
INSERT INTO `sys_menu` VALUES (59, '文件查询', 58, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:query', '', '文件查询按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (60, '文件上传', 58, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:upload', '', '文件上传按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (61, '文件下载', 58, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:download', '', '文件下载按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (62, '文件编辑', 58, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:edit', '', '文件编辑按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (63, '文件删除', 58, 5, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:delete', '', '文件删除按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (64, '批量删除', 58, 6, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:batch:delete', '', '批量删除按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (65, '文件详情', 58, 7, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:detail', '', '文件详情按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (66, '文件统计', 58, 8, '', '', '', 1, 0, 'F', 1, 0, 1, 'system:file:stats', '', '文件统计按钮', '2026-02-02 17:04:03', 1, '2026-02-02 17:04:03', 1, 1, NULL, '2026-02-02 17:04:03', '2026-02-02 17:04:03');
INSERT INTO `sys_menu` VALUES (67, '日志管理', 0, 10, 'log', '', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Coin', '日志管理目录', '2026-02-02 21:08:02', NULL, '2026-02-03 09:59:49', 1, 1, NULL, NULL, '2026-02-03 09:59:49');
INSERT INTO `sys_menu` VALUES (68, '登录日志', 67, 1, '/system/loginRecord', 'system/loginRecord/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:log:login:list', 'ele-Message', '登录日志菜单', '2026-02-02 21:08:03', NULL, '2026-02-03 14:50:18', 1, 1, NULL, NULL, '2026-02-02 21:33:38');
INSERT INTO `sys_menu` VALUES (69, '操作日志', 67, 2, '/system/operationLog', 'system/operationLog/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:log:operation:list', 'ele-LocationFilled', '操作日志菜单', '2026-02-02 21:08:03', NULL, '2026-02-03 14:50:18', 1, 1, NULL, NULL, '2026-02-02 21:34:25');
INSERT INTO `sys_menu` VALUES (70, '登录日志查询', 68, 1, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:login:query', '', '登录日志查询按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (71, '登录日志详情', 68, 2, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:login:detail', '', '登录日志详情按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (72, '登录日志删除', 68, 3, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:login:delete', '', '登录日志删除按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (73, '登录日志清理', 68, 4, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:login:clean', '', '登录日志清理按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (74, '操作日志查询', 69, 1, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:operation:query', '', '操作日志查询按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (75, '操作日志详情', 69, 2, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:operation:detail', '', '操作日志详情按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (76, '操作日志删除', 69, 3, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:operation:delete', '', '操作日志删除按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (77, '操作日志清理', 69, 4, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'system:log:operation:clean', '', '操作日志清理按钮', '2026-02-02 21:08:03', NULL, '2026-02-02 21:08:03', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (78, '系统监控', 0, 11, 'monitor', '', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Platform', '系统监控目录', '2026-02-03 09:50:03', NULL, '2026-02-03 10:00:10', 1, 1, NULL, NULL, '2026-02-03 10:00:11');
INSERT INTO `sys_menu` VALUES (79, '服务器监控', 78, 1, '/system/monitor/server', 'monitor/server/index', NULL, 1, 0, 'C', 1, 0, 1, 'monitor:server:list', 'ele-Histogram', '服务器监控菜单', '2026-02-03 09:50:03', NULL, '2026-02-03 14:50:18', 1, 1, NULL, NULL, '2026-02-03 10:05:24');
INSERT INTO `sys_menu` VALUES (80, '在线用户', 78, 2, '/system/monitor/online', 'monitor/online/index', NULL, 1, 0, 'C', 1, 0, 1, 'monitor:online:list', 'ele-User', '在线用户监控菜单', '2026-02-03 09:50:03', NULL, '2026-02-03 14:50:18', 1, 1, NULL, NULL, '2026-02-03 10:14:54');
INSERT INTO `sys_menu` VALUES (81, '权限管理', 1, 7, '/system/permission', 'system/permission/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:permission:list', 'ele-Key', NULL, '2026-02-03 11:57:13', 1, '2026-02-03 11:58:34', 1, 1, '6c0cda86-00b4-11f1-aceb-00ffed48fd0d', '2026-02-03 11:57:13', '2026-02-03 11:58:34');
INSERT INTO `sys_menu` VALUES (82, '新增权限', 81, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:permission:add', NULL, NULL, '2026-02-03 11:57:13', 1, '2026-02-03 11:57:13', 1, 1, '6c15fdcf-00b4-11f1-aceb-00ffed48fd0d', '2026-02-03 11:57:13', '2026-02-03 11:57:13');
INSERT INTO `sys_menu` VALUES (83, '编辑权限', 81, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:permission:edit', NULL, NULL, '2026-02-03 11:57:13', 1, '2026-02-03 11:57:13', 1, 1, '6c17ebf2-00b4-11f1-aceb-00ffed48fd0d', '2026-02-03 11:57:13', '2026-02-03 11:57:13');
INSERT INTO `sys_menu` VALUES (84, '删除权限', 81, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:permission:delete', NULL, NULL, '2026-02-03 11:57:13', 1, '2026-02-03 11:57:13', 1, 1, '6c1830bf-00b4-11f1-aceb-00ffed48fd0d', '2026-02-03 11:57:13', '2026-02-03 11:57:13');
INSERT INTO `sys_menu` VALUES (85, '查看权限', 81, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'system:permission:view', NULL, NULL, '2026-02-03 11:57:13', 1, '2026-02-03 11:57:13', 1, 1, '6c186d06-00b4-11f1-aceb-00ffed48fd0d', '2026-02-03 11:57:13', '2026-02-03 11:57:13');
INSERT INTO `sys_menu` VALUES (88, '编码生成器', 1, 8, '/system/code-generator', 'system/codeGenerator/index', NULL, 1, 0, 'C', 1, 0, 1, 'system:code:view', 'ele-ChatDotSquare', '编码生成器菜单', '2026-02-05 11:43:55', 1, '2026-02-05 11:53:55', 1, 1, NULL, NULL, '2026-02-05 11:46:35');
INSERT INTO `sys_menu` VALUES (89, '生成编码', 88, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'system:code:generate', '#', '生成编码按钮', '2026-02-05 11:43:55', 1, '2026-02-05 11:43:55', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (90, '查询生成方式', 88, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'system:code:modes', '#', '查询生成方式按钮', '2026-02-05 11:43:55', 1, '2026-02-05 11:43:55', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (92, 'AI 管理', 0, 0, '/ai', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Comment', 'AI 模块管理', '2026-02-05 14:09:33', 1, '2026-03-19 15:20:07', 1, 1, NULL, NULL, '2026-03-19 15:20:07');
INSERT INTO `sys_menu` VALUES (93, 'LLM 配置管理', 92, 2, '/ai/llm-config', 'ai/llmConfig/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai:llm:view', 'ele-Connection', 'LLM 配置管理菜单', '2026-02-05 14:09:33', 1, '2026-02-05 15:07:29', 1, 1, NULL, NULL, '2026-02-05 15:07:29');
INSERT INTO `sys_menu` VALUES (94, '查询配置', 93, 1, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:list', '#', '查询 LLM 配置列表', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (95, '新增配置', 93, 2, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:create', '#', '新增 LLM 配置', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (96, '编辑配置', 93, 3, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:update', '#', '编辑 LLM 配置', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (97, '删除配置', 93, 4, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:delete', '#', '删除 LLM 配置', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (98, '设置默认', 93, 5, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:setdefault', '#', '设置默认 LLM 配置', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (99, '测试配置', 93, 6, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:llm:test', '#', '测试 LLM 配置连接', '2026-02-05 14:09:33', 1, '2026-02-05 14:09:33', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (105, 'AI 聊天助手', 92, 1, '/ai/chat', 'ai/chat/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai:chat:view', 'ele-ChatDotRound', 'AI 聊天助手菜单', '2026-02-05 15:08:58', 1, '2026-02-05 15:08:58', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (106, '创建对话', 105, 1, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:chat:create', '#', '创建新对话', '2026-02-05 15:08:58', 1, '2026-02-05 15:08:58', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (107, '发送消息', 105, 2, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:chat:send', '#', '发送聊天消息', '2026-02-05 15:08:58', 1, '2026-02-05 15:08:58', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (108, '更新对话', 105, 3, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:chat:update', '#', '更新对话标题', '2026-02-05 15:08:58', 1, '2026-02-05 15:08:58', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (109, '删除对话', 105, 4, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ai:chat:delete', '#', '删除对话', '2026-02-05 15:08:58', 1, '2026-02-05 15:08:58', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (110, '项目管理', 0, 0, '/projects', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-FolderOpened', '项目管理目录', '2026-02-06 12:42:28', 1, '2026-03-16 14:05:39', 1, 1, NULL, NULL, '2026-03-16 14:05:39');
INSERT INTO `sys_menu` VALUES (111, '项目列表', 110, 1, '/projects/list', 'projects/list/index', NULL, 1, 0, 'C', 1, 0, 1, 'projects:list:view', 'ele-List', '项目列表页面', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (112, '查询项目', 111, 1, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:list:query', '#', '查询项目列表', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (113, '新增项目', 111, 2, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:list:add', '#', '创建新项目', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (114, '编辑项目', 111, 3, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:list:edit', '#', '编辑项目信息', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (115, '删除项目', 111, 4, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:list:delete', '#', '删除项目', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (116, '管理成员', 111, 5, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:member:manage', '#', '管理项目成员', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (117, '管理环境', 111, 6, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'projects:environment:manage', '#', '管理项目环境', '2026-02-06 12:42:28', 1, '2026-02-06 12:42:28', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (121, '测试管理', 0, 2, '/testing', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Document', '测试管理模块，包含测试用例和版本管理', '2026-02-06 16:57:33', 1, '2026-03-16 14:06:58', 1, 1, NULL, NULL, '2026-03-16 14:06:58');
INSERT INTO `sys_menu` VALUES (122, '测试用例', 121, 10, '/testing/testcases', 'testing/testcases/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Document', '测试用例管理页面，支持用例创建、编辑、查询和步骤管理', '2026-02-06 16:57:33', 1, '2026-02-06 17:13:51', 1, 1, NULL, NULL, '2026-02-06 17:13:52');
INSERT INTO `sys_menu` VALUES (123, '版本管理', 121, 20, '/testing/versions', 'testing/versions/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-FolderOpened', '版本管理页面，支持版本创建、编辑和用例关联', '2026-02-06 16:57:33', 1, '2026-02-06 17:14:05', 1, 1, NULL, NULL, '2026-02-06 17:14:06');
INSERT INTO `sys_menu` VALUES (124, '查询测试用例', 122, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testcase:query', '#', '查询测试用例按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (125, '新增测试用例', 122, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testcase:add', '#', '新增测试用例按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (126, '编辑测试用例', 122, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testcase:edit', '#', '编辑测试用例按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (127, '删除测试用例', 122, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testcase:delete', '#', '删除测试用例按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (128, '查看测试用例', 122, 5, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testcase:view', '#', '查看测试用例详情按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (129, '查询版本', 123, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'version:query', '#', '查询版本按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (130, '新增版本', 123, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'version:add', '#', '新增版本按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (131, '编辑版本', 123, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'version:edit', '#', '编辑版本按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (132, '删除版本', 123, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'version:delete', '#', '删除版本按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (133, '关联测试用例', 123, 5, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'version:associate', '#', '关联测试用例按钮权限', '2026-02-06 17:11:07', 1, '2026-02-06 17:11:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (134, 'API测试', 121, 30, '/testing/api-testing', 'testing/api-testing/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Connection', 'API测试管理页面，支持HTTP请求测试、环境管理、测试套件等功能', '2026-02-07 09:57:07', 1, '2026-02-07 10:01:01', 1, 1, NULL, NULL, '2026-02-07 10:01:02');
INSERT INTO `sys_menu` VALUES (135, '查询API项目', 134, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:query', '#', '查询API项目列表按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (136, '新增API项目', 134, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:add', '#', '新增API项目按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (137, '编辑API项目', 134, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:edit', '#', '编辑API项目按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (138, '删除API项目', 134, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:delete', '#', '删除API项目按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (139, '导出API项目', 134, 5, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:export', '#', '导出API项目按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (140, '导入API项目', 134, 6, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:project:import', '#', '导入API项目按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (141, '查询API集合', 134, 7, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:collection:query', '#', '查询API集合树按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (142, '新增API集合', 134, 8, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:collection:add', '#', '新增API集合按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (143, '编辑API集合', 134, 9, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:collection:edit', '#', '编辑API集合按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (144, '删除API集合', 134, 10, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:collection:delete', '#', '删除API集合按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (145, '查询API请求', 134, 11, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:query', '#', '查询API请求列表按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (146, '新增API请求', 134, 12, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:add', '#', '新增API请求按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (147, '编辑API请求', 134, 13, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:edit', '#', '编辑API请求按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (148, '删除API请求', 134, 14, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:delete', '#', '删除API请求按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (149, '执行API请求', 134, 15, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:execute', '#', '执行API请求按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (150, '查看请求历史', 134, 16, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:request:history', '#', '查看请求历史按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (151, '查询环境变量', 134, 17, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:environment:query', '#', '查询环境变量列表按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (152, '新增环境变量', 134, 18, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:environment:add', '#', '新增环境变量按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (153, '编辑环境变量', 134, 19, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:environment:edit', '#', '编辑环境变量按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (154, '删除环境变量', 134, 20, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:environment:delete', '#', '删除环境变量按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (155, '激活环境变量', 134, 21, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:environment:activate', '#', '激活环境变量按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (156, '查询测试套件', 134, 22, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:query', '#', '查询测试套件列表按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (157, '新增测试套件', 134, 23, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:add', '#', '新增测试套件按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (158, '编辑测试套件', 134, 24, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:edit', '#', '编辑测试套件按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (159, '删除测试套件', 134, 25, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:delete', '#', '删除测试套件按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (160, '执行测试套件', 134, 26, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:execute', '#', '执行测试套件按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (161, '查看执行历史', 134, 27, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'api_testing:suite:history', '#', '查看测试套件执行历史按钮权限', '2026-02-07 09:57:07', 1, '2026-02-07 09:57:07', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (162, 'UI项目列表', 199, 30, '/testing/ui-automation/index', 'testing/ui-automation/index', NULL, 1, 0, 'C', 1, 0, 1, 'ui_automation:view', 'ele-Monitor', NULL, '2026-02-08 13:36:05', 1, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-03-06 16:18:04');
INSERT INTO `sys_menu` VALUES (163, '新建UI项目', 162, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:project:create', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (164, '编辑UI项目', 162, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:project:edit', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (165, '删除UI项目', 162, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:project:delete', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (166, '生成项目代码', 162, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:project:generate_code', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (167, '新建元素分组', 162, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element_group:create', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (168, '编辑元素分组', 162, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element_group:edit', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (169, '删除元素分组', 162, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element_group:delete', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (170, '新建UI元素', 162, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element:create', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (171, '编辑UI元素', 162, 9, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element:edit', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (172, '删除UI元素', 162, 10, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element:delete', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:36:05', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (173, '验证元素定位器', 162, 11, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:element:validate', NULL, NULL, '2026-02-08 13:36:05', 1, '2026-02-08 13:38:20', 1, 1, NULL, NULL, '2026-02-08 13:38:21');
INSERT INTO `sys_menu` VALUES (174, '新建页面对象', 162, 12, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:create', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (175, '编辑页面对象', 162, 13, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:edit', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (176, '删除页面对象', 162, 14, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:delete', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (177, '管理页面对象元素', 162, 15, '', '', NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:manage_elements', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:38:09', 1, 1, NULL, NULL, '2026-02-08 13:38:10');
INSERT INTO `sys_menu` VALUES (178, '生成页面对象代码', 162, 16, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:generate_code', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (179, '预览页面对象代码', 162, 17, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:page_object:preview_code', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (180, '新建测试用例', 162, 18, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:create', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (181, '编辑测试用例', 162, 19, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:edit', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (182, '删除测试用例', 162, 20, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:delete', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (183, '编辑测试步骤', 162, 21, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:edit_steps', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (184, '执行测试用例', 162, 22, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:execute', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (185, '生成测试用例代码', 162, 23, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_case:generate_code', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (186, '新建测试套件', 162, 24, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_suite:create', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (187, '编辑测试套件', 162, 25, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_suite:edit', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (188, '删除测试套件', 162, 26, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_suite:delete', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (189, '管理套件用例', 162, 27, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_suite:manage_cases', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (190, '执行测试套件', 162, 28, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:test_suite:execute', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (191, '查看执行历史', 162, 29, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:view', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (192, '查看执行详情', 162, 30, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:detail', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (193, '查看执行日志', 162, 31, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:logs', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (194, '停止执行', 162, 32, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:stop', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (195, '删除执行记录', 162, 33, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:delete', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (196, '导出执行报告', 162, 34, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:export', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (197, '查看执行统计', 162, 35, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:execution:statistics', NULL, NULL, '2026-02-08 13:36:06', 1, '2026-02-08 13:36:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (198, 'UI自动化管理', 199, 31, '/testing/ui-automation/manage', 'testing/ui-automation/manage', NULL, 1, 0, 'C', 1, 1, 1, 'ui_automation:manage', 'ele-HelpFilled', NULL, '2026-02-08 13:55:19', 1, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-02-08 14:26:55');
INSERT INTO `sys_menu` VALUES (199, 'Selenium', 0, 1, '/testing/ui-automation', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-ChromeFilled', NULL, '2026-02-08 14:11:44', 1, '2026-03-16 14:06:30', 1, 1, NULL, '2026-02-08 14:11:44', '2026-03-16 14:06:31');
INSERT INTO `sys_menu` VALUES (200, '测试报告', 199, 32, '/testing/ui-automation/report', 'testing/ui-automation/report', NULL, 1, 0, 'C', 1, 0, 1, 'ui_automation:report:view', 'ele-Document', NULL, '2026-02-24 15:09:25', 1, '2026-02-24 15:09:25', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (201, '查看报告详情', 200, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:report:detail', NULL, NULL, '2026-02-24 15:09:25', 1, '2026-02-24 15:09:25', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (202, '查看报告日志', 200, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:report:logs', NULL, NULL, '2026-02-24 15:09:25', 1, '2026-02-24 15:09:25', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (203, '导出测试报告', 200, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:report:export', NULL, NULL, '2026-02-24 15:09:25', 1, '2026-02-24 15:09:25', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (204, '查看报告统计', 200, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ui_automation:report:statistics', NULL, NULL, '2026-02-24 15:09:25', 1, '2026-02-24 15:09:25', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (205, 'AI智能化', 0, 3, '/ai/intelligence', 'ParentView', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Cpu', 'AI智能化模块', '2026-02-25 15:05:24', 1, '2026-03-03 10:54:10', 1, 1, NULL, NULL, '2026-03-03 10:54:11');
INSERT INTO `sys_menu` VALUES (206, '需求文档管理', 205, 1, '/ai/intelligence/requirement-analysis', 'ai/intelligence/requirement-analysis/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:requirement:view', 'ele-Document', '需求文档管理', '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (207, 'AI模型配置', 205, 2, '/ai/intelligence/model-config', 'ai/intelligence/model-config/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:model:view', 'ele-Connection', 'AI模型配置管理', '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (208, '提示词配置', 205, 3, '/ai/intelligence/prompt-config', 'ai/intelligence/prompt-config/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:prompt:view', 'ele-ChatDotRound', '提示词配置管理', '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (209, '测试用例生成', 205, 4, '/ai/intelligence/case-generation', 'ai/intelligence/case-generation/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:generation:view', 'ele-MagicStick', '测试用例生成', '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (211, '上传需求文档', 206, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:requirement:upload', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (212, '查看需求文档', 206, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:requirement:detail', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (213, '更新需求文档', 206, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:requirement:update', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (214, '删除需求文档', 206, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:requirement:delete', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (215, '分析需求文档', 206, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:requirement:analyze', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (216, '新增模型配置', 207, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:model:create', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (217, '编辑模型配置', 207, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:model:update', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (218, '删除模型配置', 207, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:model:delete', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (219, '查看模型配置', 207, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:model:detail', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (220, '测试模型连接', 207, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:model:test', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (221, '新增提示词', 208, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:prompt:create', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (222, '编辑提示词', 208, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:prompt:update', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (223, '删除提示词', 208, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:prompt:delete', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (224, '查看提示词', 208, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:prompt:detail', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (225, '复制提示词', 208, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:prompt:copy', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (226, '创建生成任务', 209, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:create', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (227, '查看生成任务', 209, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:detail', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (228, '查看生成结果', 209, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:result', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (229, '保存到用例库', 209, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:save', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (230, '导出测试用例', 209, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:export', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (231, '重新生成', 209, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:generation:regenerate', NULL, NULL, '2026-02-25 15:05:24', 1, '2026-02-25 15:05:24', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (243, 'AI用例生成历史', 205, 6, '/ai/intelligence/generation-history', 'ai/intelligence/generation-history/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:history:view', 'ele-Clock', 'AI用例生成历史记录', '2026-02-25 19:58:35', 1, '2026-02-25 19:58:35', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (244, '查看历史记录', 243, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:history:view', NULL, NULL, '2026-02-25 19:58:35', 1, '2026-02-25 19:58:35', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (245, '查看用例详情', 243, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:history:detail', NULL, NULL, '2026-02-25 19:58:35', 1, '2026-02-25 19:58:35', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (246, '导出历史用例', 243, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:history:export', NULL, NULL, '2026-02-25 19:58:35', 1, '2026-02-25 19:58:35', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (247, '删除历史记录', 243, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:history:delete', NULL, NULL, '2026-02-25 19:58:35', 1, '2026-02-25 19:58:35', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (248, '模板管理', 205, 7, '/ai/intelligence/template-management', 'ai/intelligence/template-management/index', NULL, 1, 0, 'C', 1, 0, 1, 'ai_intelligence:template:view', 'ele-Document', '测试用例模板管理', '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (249, '查看模板', 248, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:view', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (250, '新建模板', 248, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:create', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (251, '编辑模板', 248, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:edit', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (252, '删除模板', 248, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:delete', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (253, '导出模板', 248, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:export', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (254, '导入模板', 248, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:import', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (255, '预览模板', 248, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_intelligence:template:preview', NULL, NULL, '2026-02-26 11:47:27', 1, '2026-02-26 11:47:27', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (256, '模块管理', 121, 15, '/testing/modules', 'testing/modules/index', NULL, 1, 0, 'C', 1, 0, 1, 'testing:module:list', 'ele-FolderOpened', '测试模块管理页面，支持模块创建、编辑、删除和用例归属管理', '2026-02-26 14:27:12', 1, '2026-02-26 14:29:54', 1, 1, NULL, NULL, '2026-02-26 14:29:55');
INSERT INTO `sys_menu` VALUES (257, '查看模块', 256, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testing:module:query', '', '查看模块列表和详情', '2026-02-26 14:27:12', 1, '2026-02-26 14:27:12', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (258, '新增模块', 256, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testing:module:add', '', '创建新的测试模块', '2026-02-26 14:27:12', 1, '2026-02-26 14:27:12', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (259, '编辑模块', 256, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testing:module:edit', '', '编辑模块信息', '2026-02-26 14:27:12', 1, '2026-02-26 14:27:12', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (260, '删除模块', 256, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'testing:module:delete', '', '删除测试模块（需要模块下无用例）', '2026-02-26 14:27:12', 1, '2026-02-26 14:27:12', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (262, 'Figma配置', 92, 4, '/ai/intelligence/figma-config', 'ai/intelligence/figma-config/index', NULL, 1, 1, 'C', 1, 0, 1, NULL, 'ele-Connection', NULL, '2026-02-27 17:02:08', NULL, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-02-27 17:05:58');
INSERT INTO `sys_menu` VALUES (264, 'AI用例管理', 263, 1, '/ai/intelligence/browser-use/cases', 'ai/intelligence/browser-use/cases/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:case:view', 'ele-Document', 'AI智能浏览器用例管理', '2026-02-28 11:06:30', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (265, '执行记录', 263, 2, '/ai/intelligence/browser-use/executions', 'ai/intelligence/browser-use/executions/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:execution:view', 'ele-List', 'AI智能浏览器执行记录', '2026-02-28 11:06:30', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (266, '执行统计', 263, 3, '/ai/intelligence/browser-use/statistics', 'ai/intelligence/browser-use/statistics/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:statistics:view', 'ele-DataAnalysis', 'AI智能浏览器执行统计', '2026-02-28 11:06:30', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (267, 'AI测试报告', 263, 4, '/ai/intelligence/browser-use/reports', 'ai/intelligence/browser-use/reports/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:report:view', 'ele-Document', 'AI智能浏览器测试报告', '2026-02-28 11:06:30', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (268, '查询用例', 264, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:query', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (269, '新增用例', 264, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:add', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (270, '编辑用例', 264, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:edit', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (271, '删除用例', 264, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:delete', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (272, '导入Excel', 264, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:import', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (273, '导出用例', 264, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:export', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (274, '执行用例', 264, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:execute', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (275, '批量执行', 264, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:batch_execute', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (276, '停止执行', 264, 9, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:stop', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (277, '查看详情', 264, 10, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:detail', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (278, '查询记录', 265, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:query', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (279, '查看详情', 265, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:detail', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (280, '查看日志', 265, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:log', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (281, '查看截图', 265, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:screenshot', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (282, '删除记录', 265, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:delete', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (283, '导出记录', 265, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:export', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (284, '查询统计', 266, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:query', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (285, '导出统计', 266, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:export', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (286, '刷新统计', 266, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:refresh', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (287, '查询报告', 267, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:query', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (288, '查看报告', 267, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:view', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (289, '导出报告', 267, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:export', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (290, '删除报告', 267, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:delete', NULL, NULL, '2026-02-28 11:06:30', 1, '2026-02-28 11:06:30', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (292, 'AI用例管理', 291, 1, '/ai/intelligence/browser-use/cases', 'ai/intelligence/browser-use/cases/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:case:view', 'ele-Document', 'AI智能浏览器用例管理', '2026-02-28 11:27:57', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (293, '执行记录', 291, 2, '/ai/intelligence/browser-use/executions', 'ai/intelligence/browser-use/executions/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:execution:view', 'ele-List', 'AI智能浏览器执行记录', '2026-02-28 11:27:57', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (294, '执行统计', 291, 3, '/ai/intelligence/browser-use/statistics', 'ai/intelligence/browser-use/statistics/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:statistics:view', 'ele-DataAnalysis', 'AI智能浏览器执行统计', '2026-02-28 11:27:57', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (295, 'AI测试报告', 291, 4, '/ai/intelligence/browser-use/reports', 'ai/intelligence/browser-use/reports/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:report:view', 'ele-Document', 'AI智能浏览器测试报告', '2026-02-28 11:27:57', 1, '2026-02-28 11:35:00', 1, 0, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (296, '查询用例', 292, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:query', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (297, '新增用例', 292, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:add', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (298, '编辑用例', 292, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:edit', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (299, '删除用例', 292, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:delete', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (300, '导入Excel', 292, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:import', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (301, '导出用例', 292, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:export', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (302, '执行用例', 292, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:execute', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (303, '批量执行', 292, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:batch_execute', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (304, '停止执行', 292, 9, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:stop', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (305, '查看详情', 292, 10, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:detail', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (306, '查询记录', 293, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:query', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (307, '查看详情', 293, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:detail', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (308, '查看日志', 293, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:log', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (309, '查看截图', 293, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:screenshot', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (310, '删除记录', 293, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:delete', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (311, '导出记录', 293, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:export', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (312, '查询统计', 294, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:query', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (313, '导出统计', 294, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:export', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (314, '刷新统计', 294, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:refresh', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (315, '查询报告', 295, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:query', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (316, '查看报告', 295, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:view', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (317, '导出报告', 295, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:export', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (318, '删除报告', 295, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:delete', NULL, NULL, '2026-02-28 11:27:57', 1, '2026-02-28 11:27:57', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (319, 'AI浏览器', 0, 3, '/ai/intelligence/browser-use', 'ParentView', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Monitor', 'AI智能浏览器模块', '2026-02-28 11:28:39', 1, '2026-03-19 15:21:45', 1, 1, NULL, NULL, '2026-03-19 15:21:46');
INSERT INTO `sys_menu` VALUES (320, 'AI用例管理', 319, 1, '/ai/intelligence/browser-use/cases', 'ai/intelligence/browser-use/cases/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:case:view', 'ele-Document', 'AI智能浏览器用例管理', '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (321, '执行记录', 319, 2, '/ai/intelligence/browser-use/executions', 'ai/intelligence/browser-use/executions/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:execution:view', 'ele-List', 'AI智能浏览器执行记录', '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (322, '执行统计', 319, 3, '/ai/intelligence/browser-use/statistics', 'ai/intelligence/browser-use/statistics/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:statistics:view', 'ele-DataAnalysis', 'AI智能浏览器执行统计', '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (323, 'AI测试报告', 319, 4, '/ai/intelligence/browser-use/reports', 'ai/intelligence/browser-use/reports/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_browser:report:view', 'ele-Document', 'AI智能浏览器测试报告', '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (324, '查询用例', 320, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:query', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (325, '新增用例', 320, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:add', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (326, '编辑用例', 320, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:edit', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (327, '删除用例', 320, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:delete', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (328, '导入Excel', 320, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:import', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (329, '导出用例', 320, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:export', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (330, '执行用例', 320, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:execute', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (331, '批量执行', 320, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:batch_execute', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (332, '停止执行', 320, 9, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:stop', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (333, '查看详情', 320, 10, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:case:detail', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (334, '查询记录', 321, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:query', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (335, '查看详情', 321, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:detail', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (336, '查看日志', 321, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:log', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (337, '查看截图', 321, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:screenshot', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (338, '删除记录', 321, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:delete', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (339, '导出记录', 321, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:execution:export', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (340, '查询统计', 322, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:query', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (341, '导出统计', 322, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:export', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (342, '刷新统计', 322, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:statistics:refresh', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (343, '查询报告', 323, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:query', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (344, '查看报告', 323, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:view', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (345, '导出报告', 323, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:export', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (346, '删除报告', 323, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_browser:report:delete', NULL, NULL, '2026-02-28 11:28:39', 1, '2026-02-28 11:28:39', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (357, 'AI测试套件', 319, 5, '/ai/intelligence/test-suites', 'ai/intelligence/test-suites/index', NULL, 1, 1, 'C', 1, 0, 1, 'ai_test_suite:view', 'ele-Collection', 'AI测试套件管理', '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (358, '查询套件', 357, 1, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:query', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (359, '新增套件', 357, 2, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:add', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (360, '编辑套件', 357, 3, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:edit', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (361, '删除套件', 357, 4, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:delete', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (362, '执行套件', 357, 5, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:execute', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (363, '查看详情', 357, 6, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:detail', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (364, '执行记录', 357, 7, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:execution_list', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (365, '执行监控', 357, 8, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:execution_monitor', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (366, '导出套件', 357, 9, NULL, NULL, NULL, 1, 0, 'F', 1, 0, 1, 'ai_test_suite:export', NULL, NULL, '2026-03-01 17:02:01', 1, '2026-03-01 17:02:01', 1, 1, '0', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2001, '数据工厂', 0, 5, '/data-factory', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-DataAnalysis', '数据工厂主菜单', '2026-03-03 16:43:23', 1, '2026-03-04 11:28:58', 1, 1, '09ee327f-16dd-11f1-a16b-00ffed48fd0d', NULL, '2026-03-04 11:28:58');
INSERT INTO `sys_menu` VALUES (2002, '工具箱', 2001, 1, '/data-factory/tools', 'testing/data-factory/tools/index', '', 1, 1, 'C', 1, 0, 1, 'data_factory:tools:view', 'ele-Tools', '数据工厂工具箱', '2026-03-03 16:43:23', 1, '2026-03-30 19:52:05', 1, 1, '09f31a00-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2003, '使用记录', 2001, 2, '/data-factory/records', 'testing/data-factory/records/index', '', 1, 1, 'C', 1, 0, 1, 'data_factory:records:view', 'ele-List', '数据工厂使用记录', '2026-03-03 16:43:23', 1, '2026-03-30 19:52:05', 1, 1, '09fdf021-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2004, '统计分析', 2001, 3, '/data-factory/statistics', 'testing/data-factory/statistics/index', '', 1, 1, 'C', 1, 0, 1, 'data_factory:statistics:view', 'ele-PieChart', '数据工厂统计分析', '2026-03-03 16:43:23', 1, '2026-03-30 19:52:05', 1, 1, '09fe08ae-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2005, '获取工具分类', 2002, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:tools:categories', '', '获取工具分类权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09fe19a8-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2006, '执行工具', 2002, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:tools:execute', '', '执行工具权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09fe1b6c-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2007, '批量生成', 2002, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:tools:batch', '', '批量生成权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09fe1c36-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2008, '查看记录', 2003, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:records:list', '', '查看记录权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09ff631f-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2009, '删除记录', 2003, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:records:delete', '', '删除记录权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09ff65ee-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2010, '导出记录', 2003, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:records:export', '', '导出记录权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09ff66aa-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2011, '查看统计', 2004, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:statistics:view', '', '查看统计权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09ff96f0-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (2012, '获取标签', 2004, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'data_factory:statistics:tags', '', '获取标签权限', '2026-03-03 16:43:23', 1, '2026-03-03 16:43:23', 1, 1, '09ff9c2c-16dd-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3001, '用例评审', 0, 2, '/reviews', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Document', '用例评审主菜单', '2026-03-04 11:26:29', 1, '2026-03-16 14:07:11', 1, 1, 'ef05daf7-1779-11f1-a16b-00ffed48fd0d', NULL, '2026-03-16 14:07:12');
INSERT INTO `sys_menu` VALUES (3002, '评审管理', 3001, 1, '/reviews/index', 'reviews/index', '', 1, 1, 'C', 1, 0, 1, 'reviews:manage:view', 'ele-List', '评审管理页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef1023d0-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3003, '评审模板', 3001, 2, '/reviews/templates', 'reviews/templates', '', 1, 1, 'C', 1, 0, 1, 'reviews:templates:view', 'ele-Setting', '评审模板管理页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef10dbbb-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3004, '评审统计', 3001, 3, '/reviews/statistics', 'reviews/statistics', '', 1, 1, 'C', 1, 0, 1, 'reviews:statistics:view', 'ele-DataAnalysis', '评审统计分析页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef111683-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3005, '查看评审', 3002, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:list', '', '查看评审列表权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef124763-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3006, '创建评审', 3002, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:create', '', '创建评审权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef124d92-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3007, '编辑评审', 3002, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:edit', '', '编辑评审权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef124f65-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3008, '删除评审', 3002, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:delete', '', '删除评审权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef125025-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3009, '分配评审人', 3002, 5, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:assign', '', '分配评审人权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef1250da-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3010, '提交评审', 3002, 6, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:manage:submit', '', '提交评审结果权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef1251ad-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3011, '查看意见', 3002, 7, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:comments:view', '', '查看评审意见权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef127c9e-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3012, '添加意见', 3002, 8, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:comments:add', '', '添加评审意见权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef128230-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3013, '解决意见', 3002, 9, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:comments:resolve', '', '解决评审意见权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef128354-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3014, '查看模板', 3003, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:templates:list', '', '查看模板列表权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef12ca31-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3015, '创建模板', 3003, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:templates:create', '', '创建模板权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef12d0bc-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3016, '编辑模板', 3003, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:templates:edit', '', '编辑模板权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef12d1bb-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3017, '删除模板', 3003, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:templates:delete', '', '删除模板权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef12d274-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3018, '启用/禁用模板', 3003, 5, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:templates:toggle', '', '启用/禁用模板权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef12d322-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3019, '查看统计', 3004, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:statistics:view', '', '查看评审统计权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef185aff-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3020, '导出报告', 3004, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:statistics:export', '', '导出统计报告权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef186231-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3021, '我的任务', 3001, 1, '/reviews/my-tasks', 'reviews/my-tasks', '', 1, 1, 'C', 1, 0, 1, 'reviews:tasks:view', 'ele-User', '我的评审任务页面', '2026-03-04 16:15:23', 1, '2026-03-30 19:52:05', 1, 1, '4b0f69fd-17a2-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3025, '评审执行', 3001, 5, '/reviews/execute', 'reviews/execute', '', 1, 1, 'C', 1, 1, 1, 'reviews:execute:view', 'ele-Edit', '评审执行页面(隐藏)', '2026-03-04 18:36:10', 1, '2026-03-30 19:52:05', 1, 1, 'f58b1486-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3026, '评审结果', 3001, 6, '/reviews/result', 'reviews/result', '', 1, 1, 'C', 1, 1, 1, 'reviews:result:view', 'ele-View', '评审结果页面(隐藏)', '2026-03-04 18:36:10', 1, '2026-03-30 19:52:05', 1, 1, 'f593d639-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3027, '执行评审', 3025, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:execute:perform', '', '执行评审权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f5941b0a-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3028, '保存评审结果', 3025, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:execute:save', '', '保存评审结果权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f59421f7-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3029, '提交评审', 3025, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:execute:submit', '', '提交评审权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f59424bd-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3030, '查看用例详情', 3025, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:execute:case-detail', '', '查看测试用例详情权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f59426f0-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3031, '查看结果', 3026, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:result:view', '', '查看评审结果权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f595864c-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (3032, '导出结果', 3026, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'reviews:result:export', '', '导出评审结果权限', '2026-03-04 18:36:10', 1, '2026-03-04 18:36:10', 1, 1, 'f5958c69-17b5-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4001, 'Dify助手', 0, 3, '/assistant', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-ChatDotRound', 'AI助手主菜单', '2026-03-04 11:26:29', 1, '2026-03-19 15:21:26', 1, 1, 'ef356126-1779-11f1-a16b-00ffed48fd0d', NULL, '2026-03-19 15:21:26');
INSERT INTO `sys_menu` VALUES (4002, '助手管理', 4001, 1, '/assistant/index', 'assistant/index', NULL, 1, 1, 'C', 1, 0, 1, 'assistant:manage:view', 'ele-Basketball', '助手管理页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef36e0a9-1779-11f1-a16b-00ffed48fd0d', NULL, '2026-03-04 13:37:15');
INSERT INTO `sys_menu` VALUES (4003, '配置管理', 4001, 2, '/assistant/configs', 'assistant/configs', '', 1, 1, 'C', 1, 0, 1, 'assistant:configs:view', 'ele-Setting', '助手配置管理页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef36f0d8-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4004, '对话管理', 4001, 3, '/assistant/conversations', 'assistant/conversations', '', 1, 1, 'C', 1, 0, 1, 'assistant:conversations:view', 'ele-ChatLineRound', '对话管理页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef36fdec-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4005, '助手统计', 4001, 4, '/assistant/statistics', 'assistant/statistics', '', 1, 1, 'C', 1, 0, 1, 'assistant:statistics:view', 'ele-DataAnalysis', '助手统计分析页面', '2026-03-04 11:26:29', 1, '2026-03-30 19:52:05', 1, 1, 'ef370d9d-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4006, '开始对话', 4002, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:manage:chat', '', '开始对话权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37390d-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4007, '查看助手', 4002, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:manage:list', '', '查看助手列表权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef3740d4-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4008, '查看配置', 4003, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:configs:list', '', '查看配置列表权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37b0c7-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4009, '创建配置', 4003, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:configs:create', '', '创建配置权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37b5e8-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4010, '编辑配置', 4003, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:configs:edit', '', '编辑配置权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37b6b8-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4011, '删除配置', 4003, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:configs:delete', '', '删除配置权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37b796-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4012, '启用/禁用配置', 4003, 5, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:configs:toggle', '', '启用/禁用配置权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37b833-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4013, '查看对话', 4004, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:conversations:list', '', '查看对话列表权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37d153-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4014, '创建对话', 4004, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:conversations:create', '', '创建对话权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37d39a-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4015, '编辑对话', 4004, 3, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:conversations:edit', '', '编辑对话权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37d464-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4016, '删除对话', 4004, 4, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:conversations:delete', '', '删除对话权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37d550-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4017, '继续对话', 4004, 5, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:conversations:continue', '', '继续对话权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37d5ec-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4018, '查看消息', 4004, 6, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:messages:view', '', '查看消息权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37eac6-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4019, '发送消息', 4004, 7, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:messages:send', '', '发送消息权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37ed48-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4020, 'Dify聊天', 4004, 8, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:chat:dify', '', 'Dify聊天权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef37ee0d-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4021, '查看统计', 4005, 1, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:statistics:view', '', '查看助手统计权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef380388-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4022, '导出报告', 4005, 2, '', '', '', 1, 0, 'F', 1, 0, 1, 'assistant:statistics:export', '', '导出统计报告权限', '2026-03-04 11:26:29', 1, '2026-03-04 11:26:29', 1, 1, 'ef380863-1779-11f1-a16b-00ffed48fd0d', NULL, NULL);
INSERT INTO `sys_menu` VALUES (4023, '通知管理', 0, 7, '/notifications', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Bell', '统一通知系统管理', '2026-03-05 17:38:36', 1, '2026-03-06 13:35:08', 1, 1, NULL, NULL, '2026-03-06 13:35:08');
INSERT INTO `sys_menu` VALUES (4024, '通知配置', 4023, 1, '/notifications/configs', 'notifications/configs/index', NULL, 1, 0, 'C', 1, 0, 1, 'notifications:config:list', 'ele-ChatLineSquare', '通知配置管理', '2026-03-05 17:38:38', 1, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-03-05 18:13:38');
INSERT INTO `sys_menu` VALUES (4025, '通知历史', 4023, 2, '/notifications/histories', 'notifications/histories/index', NULL, 1, 0, 'C', 1, 0, 1, 'notifications:history:list', 'ele-Coffee', '通知发送历史', '2026-03-05 17:38:38', 1, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-03-05 18:15:17');
INSERT INTO `sys_menu` VALUES (4026, '任务通知', 4023, 3, '/notifications/task-settings', 'notifications/task-settings/index', NULL, 1, 0, 'C', 1, 0, 1, 'notifications:task:list', 'ele-Collection', '任务通知设置', '2026-03-05 17:38:38', 1, '2026-03-30 19:52:05', 1, 1, NULL, NULL, '2026-03-05 18:15:53');
INSERT INTO `sys_menu` VALUES (4027, '通知配置查询', 4024, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:query', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4028, '通知配置新增', 4024, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:add', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4029, '通知配置修改', 4024, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:edit', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4030, '通知配置删除', 4024, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:remove', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4031, '通知配置测试', 4024, 5, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:test', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4032, '设置默认配置', 4024, 6, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:config:default', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4033, '通知历史查询', 4025, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:history:query', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4034, '通知历史详情', 4025, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:history:detail', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4035, '通知重发', 4025, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:history:resend', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4036, '任务通知查询', 4026, 1, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:task:query', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4037, '任务通知新增', 4026, 2, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:task:add', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4038, '任务通知修改', 4026, 3, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:task:edit', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4039, '任务通知删除', 4026, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:task:remove', '#', '', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4040, '发送通知', 4023, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:send', '#', '发送通知权限', '2026-03-05 17:38:38', 1, '2026-03-05 17:38:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4077, '通知历史删除', 4025, 4, '', '', NULL, 1, 0, 'F', 0, 0, 0, 'notifications:history:remove', '#', '', '2026-03-06 08:39:38', 1, '2026-03-06 08:39:38', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4078, '云真机管理', 0, 0, '/testing/cloud-device', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-UploadFilled', NULL, '2026-03-11 17:39:12', 1, '2026-03-17 12:30:04', 1, 1, NULL, '2026-03-11 17:39:13', '2026-03-17 12:30:04');
INSERT INTO `sys_menu` VALUES (4079, '云真机', 4078, 0, '/testing/cloud-device/index', 'testing/cloud-device/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Iphone', NULL, '2026-03-11 17:40:32', 1, '2026-03-30 19:52:05', 1, 1, NULL, '2026-03-11 17:40:32', '2026-03-12 09:04:30');
INSERT INTO `sys_menu` VALUES (4080, 'API 自动化', 0, 0, '/api-automation', 'layout/routerView/parent', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Connection', NULL, '2026-03-12 15:48:50', NULL, '2026-03-16 18:30:11', 1, 1, NULL, NULL, '2026-03-16 14:05:06');
INSERT INTO `sys_menu` VALUES (4081, '接口自动化', 4080, 1, '/api-automation/index', 'testing/api-automation/index', NULL, 1, 0, 'C', 0, 0, 1, NULL, 'ele-Connection', NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 16:16:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4082, '新增项目', 4081, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:project:add', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4083, '删除项目', 4081, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:project:delete', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4084, '新增服务', 4081, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:service:add', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4085, '删除服务', 4081, 4, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:service:delete', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4086, '新建菜单节点', 4081, 5, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:tree:add', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4087, '重命名菜单节点', 4081, 6, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:tree:edit', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4088, '删除菜单节点', 4081, 7, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'apiAutomation:tree:delete', NULL, NULL, '2026-03-12 15:48:50', NULL, '2026-03-12 15:48:50', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4089, '接口管理', 4080, 1, '/api-automation/project', 'testing/api-automation/api_project', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Connection', NULL, '2026-03-12 16:16:06', NULL, '2026-03-12 16:16:06', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4090, '场景管理', 4080, 2, '/api-automation/script', 'testing/api-automation/api_script', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Coin', NULL, '2026-03-12 16:16:06', NULL, '2026-03-17 12:26:51', 1, 1, NULL, NULL, '2026-03-17 12:26:51');
INSERT INTO `sys_menu` VALUES (4091, '结果列表', 4080, 3, '/api-automation/results', 'testing/api-automation/api_result_list', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Flag', NULL, '2026-03-12 16:16:06', NULL, '2026-03-17 12:27:46', 1, 1, NULL, NULL, '2026-03-17 12:27:46');
INSERT INTO `sys_menu` VALUES (4092, '任务管理', 0, 7, '/task', 'layout/routerView/parent', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Calendar', NULL, '2026-03-13 11:47:51', NULL, '2026-03-16 14:07:41', 1, 1, NULL, NULL, '2026-03-16 14:07:41');
INSERT INTO `sys_menu` VALUES (4093, '定时任务', 4092, 1, '/task/scheduler', 'testing/scheduler/index', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Timer', NULL, '2026-03-13 11:47:51', NULL, '2026-03-13 11:47:51', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4094, '新增任务', 4093, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'scheduler:task:add', NULL, NULL, '2026-03-13 11:47:51', NULL, '2026-03-13 11:47:51', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4095, '编辑任务', 4093, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'scheduler:task:edit', NULL, NULL, '2026-03-13 11:47:51', NULL, '2026-03-13 11:47:51', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4096, '删除任务', 4093, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'scheduler:task:delete', NULL, NULL, '2026-03-13 11:47:51', NULL, '2026-03-13 11:47:51', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4097, 'Playwright', 0, 0, '/web-management', 'layout/routerView/parent', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-ElemeFilled', NULL, '2026-03-13 15:57:19', NULL, '2026-03-17 18:04:36', 1, 1, NULL, NULL, '2026-03-17 18:04:36');
INSERT INTO `sys_menu` VALUES (4098, 'Web元素管理', 4097, 1, '/web/element', 'web_view/element_manager', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Grid', NULL, '2026-03-13 15:57:19', NULL, '2026-03-30 18:22:55', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4099, 'Web自动化脚本', 4097, 2, '/web/automation', 'web_view/web', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-ChromeFilled', NULL, '2026-03-13 15:57:19', NULL, '2026-03-30 18:22:45', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4100, 'Web场景管理', 4097, 3, '/web/group', 'web_view/web_group', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-LocationInformation', NULL, '2026-03-13 15:57:19', NULL, '2026-03-30 18:22:49', 1, 1, NULL, NULL, '2026-03-17 12:32:40');
INSERT INTO `sys_menu` VALUES (4101, 'Web测试结果', 4097, 4, '/web/result', 'web_view/web_result_list', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Platform', NULL, '2026-03-13 15:57:19', NULL, '2026-03-30 18:23:05', 1, 1, NULL, NULL, '2026-03-17 12:33:17');
INSERT INTO `sys_menu` VALUES (4102, '元素查询', 4098, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:element:list', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4103, '元素新增', 4098, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:element:add', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4104, '元素编辑', 4098, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:element:edit', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4105, '元素删除', 4098, 4, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:element:delete', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4106, '脚本查询', 4099, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:script:list', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4107, '脚本保存', 4099, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:script:save', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4108, '脚本执行', 4099, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:script:run', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4109, '场景查询', 4100, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:group:list', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4110, '场景新增', 4100, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:group:add', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4111, '场景编辑', 4100, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:group:edit', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4112, '场景删除', 4100, 4, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:group:delete', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4113, '场景执行', 4100, 5, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:group:run', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4114, '结果查询', 4101, 1, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:result:list', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4115, '结果详情', 4101, 2, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:result:detail', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4116, '结果报告', 4101, 3, NULL, NULL, NULL, 1, 0, 'F', 0, 0, 1, 'web:result:report', NULL, NULL, '2026-03-13 15:57:19', NULL, '2026-03-13 15:57:19', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4117, 'Web测试报告', 4097, 5, '/web/report', 'web_view/web_report', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Document', NULL, '2026-03-14 17:12:14', NULL, '2026-03-30 18:23:31', 1, 1, NULL, NULL, '2026-03-14 22:08:52');
INSERT INTO `sys_menu` VALUES (4118, '接口报告', 4080, 4, '/api-automation/report', 'testing/api-automation/api_report', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Memo', NULL, '2026-03-16 18:00:44', 1, '2026-03-17 12:28:25', 1, 1, NULL, '2026-03-16 18:00:45', '2026-03-17 12:28:26');
INSERT INTO `sys_menu` VALUES (4128, 'APP自动化', 0, 0, '/app_manage', 'Layout', NULL, 1, 0, 'M', 1, 0, 1, NULL, 'ele-Iphone', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:17:45', 1, 1, NULL, NULL, '2026-03-31 09:17:45');
INSERT INTO `sys_menu` VALUES (4129, 'APP包管理', 4128, 1, '/app_manage/package', 'testing/app-management/app_package', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-SetUp', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:30:36', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4130, 'APP自动化脚本', 4128, 2, '/app_manage/automation', 'testing/app-management/app_automation', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Iphone', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:30:37', NULL, 1, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4131, 'OCR图像识别', 4128, 3, '/testing/app_management/images', 'testing/app-management/app_images', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-PictureFilled', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:30:37', 1, 1, NULL, NULL, '2026-03-31 09:18:18');
INSERT INTO `sys_menu` VALUES (4132, 'APP测试结果', 4128, 4, '/testing/app_manage/results', 'testing/app-management/app_results', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Document', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:30:37', 1, 1, NULL, NULL, '2026-03-31 09:18:35');
INSERT INTO `sys_menu` VALUES (4133, 'APP测试报告', 4128, 4, '/testing/app_report', 'testing/app-management/app_report', NULL, 1, 0, 'C', 1, 0, 1, NULL, 'ele-Document', NULL, '2026-03-19 15:08:39', NULL, '2026-03-31 09:30:37', 1, 1, NULL, NULL, '2026-03-31 09:18:55');

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `conversation_id` bigint NOT NULL COMMENT '对话ID',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色（system/user/assistant）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容',
  `message_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'text' COMMENT '消息类型',
  `metadata` json NULL COMMENT '元数据',
  `tokens_used` int NULL DEFAULT NULL COMMENT '使用的令牌数',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NOT NULL COMMENT '创建人',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NOT NULL COMMENT '更新人',
  `enabled_flag` tinyint NOT NULL DEFAULT 1 COMMENT '启用标志（1启用 0禁用）',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_conversation_id`(`conversation_id` ASC) USING BTREE,
  INDEX `idx_creation_date`(`creation_date` ASC) USING BTREE,
  CONSTRAINT `fk_message_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `sys_conversation` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI 消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (1, 1, 'user', '你好，请用一句话介绍你自己。', 'text', 'null', NULL, '2026-02-05 14:49:00', 1, '2026-02-05 14:49:00', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (2, 1, 'assistant', '你好！我是一个由阿里云研发的超大规模语言模型，能够回答问题、创作文字、编程等，致力于为你提供准确、有用和友好的帮助。', 'text', 'null', 50, '2026-02-05 14:49:03', 1, '2026-02-05 14:49:03', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (3, 2, 'user', '你好，请用一句话介绍你自己。', 'text', 'null', NULL, '2026-02-05 14:49:43', 1, '2026-02-05 14:49:43', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (4, 2, 'assistant', '你好！我是通义千问，阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程等，致力于为你提供准确、有用和友好的帮助。', 'text', 'null', 52, '2026-02-05 14:49:45', 1, '2026-02-05 14:49:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (5, 3, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 15:13:11', 1, '2026-02-05 15:13:11', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (6, 3, 'assistant', '我是通义千问，阿里巴巴集团旗下的超大规模语言模型。我能够回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。如果你有任何问题或需要帮助，欢迎随时告诉我！', 'text', 'null', 70, '2026-02-05 15:13:13', 1, '2026-02-05 15:13:13', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (7, 3, 'user', '用python写个冒泡排序', 'text', 'null', NULL, '2026-02-05 15:14:18', 1, '2026-02-05 15:14:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (8, 3, 'assistant', '当然可以！下面是一个用 Python 实现的冒泡排序（Bubble Sort）函数：\n\n```python\ndef bubble_sort(arr):\n    \"\"\"\n    对列表 arr 进行冒泡排序（升序）\n    \"\"\"\n    n = len(arr)\n    # 遍历所有数组元素\n    for i in range(n):\n        # 标志位：如果某一轮没有发生交换，说明已经有序，可以提前结束\n        swapped = False\n        # 最后 i 个元素已经排好序了，不需要再比较\n        for j in range(0, n - i - 1):\n            if arr[j] > arr[j + 1]:\n                # 交换元素\n                arr[j], arr[j + 1] = arr[j + 1], arr[j]\n                swapped = True\n        # 如果没有发生交换，说明数组已经有序\n        if not swapped:\n            break\n    return arr\n\n# 示例使用\nif __name__ == \"__main__\":\n    data = [64, 34, 25, 12, 22, 11, 90]\n    print(\"原始数组:\", data)\n    sorted_data = bubble_sort(data.copy())  # 使用 copy() 避免修改原列表\n    print(\"排序后数组:\", sorted_data)\n```\n\n### 输出：\n```\n原始数组: [64, 34, 25, 12, 22, 11, 90]\n排序后数组: [11, 12, 22, 25, 34, 64, 90]\n```\n\n### 说明：\n- 冒泡排序通过重复遍历列表，比较相邻元素并交换顺序错误的元素。\n- 时间复杂度：最坏和平均为 O(n²)，最好情况（已排序）为 O(n)（因为加了 `swapped` 优化）。\n- 空间复杂度：O(1)，是原地排序。\n\n如果你需要降序排序，只需把 `>` 改成 `<` 即可。需要我帮你改成降序版本吗？', 'text', 'null', 543, '2026-02-05 15:14:29', 1, '2026-02-05 15:14:29', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (9, 4, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 15:24:47', 1, '2026-02-05 15:24:47', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (10, 4, 'assistant', '我是通义千问，阿里巴巴集团旗下的超大规模语言模型。我能够回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。如果你有任何问题或需要帮助，欢迎随时告诉我！', 'text', 'null', 70, '2026-02-05 15:24:50', 1, '2026-02-05 15:24:50', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (11, 6, 'user', '你哈', 'text', 'null', NULL, '2026-02-05 15:56:59', 1, '2026-02-05 15:56:59', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (12, 6, 'assistant', '', 'text', 'null', 0, '2026-02-05 15:57:02', 1, '2026-02-05 15:57:02', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (13, 6, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 15:57:17', 1, '2026-02-05 15:57:17', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (14, 6, 'assistant', '', 'text', 'null', 0, '2026-02-05 15:57:20', 1, '2026-02-05 15:57:20', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (15, 8, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 15:57:40', 1, '2026-02-05 15:57:40', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (16, 8, 'assistant', '', 'text', 'null', 0, '2026-02-05 15:57:43', 1, '2026-02-05 15:57:43', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (17, 7, 'user', '你好，请介绍一下你自己', 'text', 'null', NULL, '2026-02-05 16:01:48', 1, '2026-02-05 16:01:48', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (18, 7, 'assistant', '', 'text', 'null', 0, '2026-02-05 16:01:52', 1, '2026-02-05 16:01:52', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (19, 6, 'user', '你哈', 'text', 'null', NULL, '2026-02-05 16:08:20', 1, '2026-02-05 16:08:20', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (20, 6, 'assistant', '你好！看起来你可能是想跟我打招呼 😊  \n如果你有任何问题、需要帮助，或者只是想聊聊，尽管说！我在这儿呢～', 'text', 'null', 53, '2026-02-05 16:08:23', 1, '2026-02-05 16:08:23', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (21, 6, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 16:10:03', 1, '2026-02-05 16:10:03', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (22, 6, 'assistant', '你好！我是 **通义千问**（Qwen），是由阿里巴巴集团旗下的通义实验室自主研发的超大规模语言模型。我可以回答问题、创作文字（比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等），还能表达观点，玩游戏等。\n\n简单来说，我是一个能跟你聊天、帮你做事的AI助手！  \n有什么我可以帮你的吗？😊', 'text', 'null', 147, '2026-02-05 16:10:07', 1, '2026-02-05 16:10:07', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (23, 6, 'user', 'python好学吗', 'text', 'null', NULL, '2026-02-05 16:10:28', 1, '2026-02-05 16:10:28', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (24, 6, 'assistant', 'Python 是**公认比较好学的编程语言之一**，尤其适合编程初学者。以下是几个原因：\n\n### ✅ 为什么 Python 好学？\n1. **语法简洁清晰**  \n   Python 的代码看起来很像英语，缩进代替大括号，结构直观。  \n   比如打印“Hello, World!”只需一行：\n   ```python\n   print(\"Hello, World!\")\n   ```\n\n2. **上手快，成就感强**  \n   很快就能写出实用的小程序，比如自动整理文件、爬取网页数据、做简单数据分析等。\n\n3. **丰富的学习资源**  \n   网上有大量免费教程、视频、书籍（比如《Python Crash Course》《Automate the Boring Stuff with Python》），中文资料也非常多。\n\n4. **强大的社区支持**  \n   遇到问题很容易在网上找到答案（比如 Stack Overflow、知乎、B站等）。\n\n5. **应用广泛**  \n   Python 在**数据分析、人工智能、Web开发、自动化脚本、科学计算**等领域都很流行，学了有用武之地。\n\n---\n\n### ⚠️ 但也要注意：\n- “好学”不等于“不用努力”——任何编程语言都需要动手练习。\n- 初期可能对**变量、循环、函数、缩进规则**等概念感到陌生，但坚持几天就会适应。\n- 后期深入（比如面向对象、异步编程、性能优化）也有挑战，但可以循序渐进。\n\n---\n\n### 🎯 给初学者的建议：\n- **边学边写代码**：不要只看不练！\n- **从兴趣出发**：想做游戏？试试 PyGame；想分析数据？学 pandas；想建网站？试试 Flask/Django。\n- **善用工具**：安装 VS Code 或 PyCharm，配合 Jupyter Notebook 学习更高效。\n\n> 💡 一句话总结：**Python 是入门友好的“第一门编程语言”，坚持一周，你就能写出自己的小工具！**\n\n如果你刚开始学，我可以帮你制定学习计划、解释概念，或者一起写代码 😊  \n想试试吗？', 'text', 'null', 899, '2026-02-05 16:10:45', 1, '2026-02-05 16:10:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (25, 9, 'user', '今天星期几', 'text', 'null', NULL, '2026-02-05 16:12:29', 1, '2026-02-05 16:12:29', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (26, 9, 'assistant', '我无法获取你设备的当前日期和时间，因此无法直接告诉你今天是星期几。不过，你可以通过以下方式快速查看：\n\n- **手机/电脑**：查看屏幕右上角或右下角的时间，通常点击后会显示详细日期和星期。\n- **语音助手**：对 Siri、小爱同学、小度等说“今天星期几”。\n- **手动计算**：如果你知道某个已知日期是星期几（比如 2024 年 6 月 10 日是星期一），可以推算出今天的星期。\n\n如果你告诉我今天的具体日期（例如“2024年6月15日”），我可以帮你算出是星期几！', 'text', 'null', 238, '2026-02-05 16:12:34', 1, '2026-02-05 16:12:34', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (27, 9, 'user', '你好', 'text', 'null', NULL, '2026-02-05 16:13:14', 1, '2026-02-05 16:13:14', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (28, 9, 'assistant', '你好！有什么可以帮你的吗？😊', 'text', 'null', 14, '2026-02-05 16:13:15', 1, '2026-02-05 16:13:15', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (29, 9, 'user', '如何学习vue', 'text', 'null', NULL, '2026-02-05 16:13:49', 1, '2026-02-05 16:13:49', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (30, 9, 'assistant', '学习 Vue.js 是一个非常明智的选择，它是一个渐进式、易上手又功能强大的前端框架。以下是系统学习 Vue 的建议路径，适合初学者到进阶者：\n\n---\n\n### 🌱 一、前置知识（建议掌握）\n在学习 Vue 之前，确保你已经掌握以下基础：\n- **HTML / CSS**：网页结构与样式\n- **JavaScript（ES6+）**：变量、函数、数组方法、箭头函数、解构、模块化等\n- **基本命令行操作**（如使用 npm）\n\n> ✅ 不需要会 React 或 Angular，Vue 可以独立入门。\n\n---\n\n### 📚 二、官方文档是最佳起点\nVue 官方文档写得非常清晰、友好，且有中文版：\n- 官网：[https://vuejs.org](https://vuejs.org)\n- 中文文档（Vue 3）：[https://cn.vuejs.org](https://cn.vuejs.org)\n\n> 🔥 强烈建议从 **Vue 3** 开始学（当前主流版本），不要学 Vue 2（已进入维护阶段）。\n\n---\n\n### 🧩 三、学习路线建议\n\n#### 第 1 阶段：基础核心概念（1–2 周）\n- 创建 Vue 应用（`createApp`）\n- 模板语法（插值 `{{}}`、指令 `v-if`、`v-for`、`v-bind`、`v-on`）\n- 响应式数据（`ref`、`reactive`）\n- 计算属性（`computed`）和侦听器（`watch`）\n- 事件处理\n- 组件基础（父子组件、props、emit）\n\n✅ 动手练习：做一个待办事项（Todo List）应用\n\n#### 第 2 阶段：组件进阶与状态管理（1–2 周）\n- 组件通信（props / emit / provide/inject / 事件总线）\n- 插槽（slot）\n- 生命周期钩子（onMounted 等）\n- 使用 **Pinia**（官方推荐的状态管理库，替代 Vuex）\n- 路由：**Vue Router**\n\n✅ 项目练习：做一个博客列表 + 详情页，带路由跳转和状态共享\n\n#### 第 3 阶段：工程化与工具链（1 周+）\n- 使用 **Vite** 创建项目（比 Vue CLI 更快）\n  ```bash\n  npm create vue@latest\n  ```\n- 单文件组件（.vue 文件结构）\n- 组合式 API（Composition API） vs 选项式 API\n- 自定义 Hook（可复用逻辑）\n- Axios 请求数据\n- 表单验证、动画、过渡效果\n\n✅ 项目练习：调用公开 API（如 JSONPlaceholder）做一个用户管理系统\n\n#### 第 4 阶段：实战与优化\n- 代码拆分、懒加载\n- TypeScript 支持（可选但推荐）\n- 单元测试（Vitest / Vue Test Utils）\n- 部署上线（Vercel / Netlify / GitHub Pages）\n\n---\n\n### 🛠️ 四、推荐工具\n- 编辑器：VS Code + Volar 插件（Vue 官方推荐）\n- 浏览器插件：Vue Devtools（调试组件和状态）\n- 包管理：npm / pnpm / yarn\n\n---\n\n### 🎯 五、学习资源推荐\n- **免费教程**：\n  - [Vue Mastery 免费课程](https://www.vuemastery.com/courses/)\n  - B站：搜索 “Vue 3 入门到实战”（推荐“技术蛋老师”、“程序员鱼皮”等）\n- **书籍**：\n  - 《Vue.js 设计与实现》（深入原理，适合进阶）\n- **实战项目灵感**：\n  - GitHub 上找 `vue3 + pinia + vite` 的开源项目\n  - 尝试复刻：天气 App、电影搜索、电商商品页等\n\n---\n\n### 💡 小贴士\n- **不要死记 API**，多写代码、多查文档。\n- **从小项目开始**，逐步增加复杂度。\n- 遇到问题先看官方文档 → 再查 Stack Overflow / GitHub Issues。\n\n---\n\n如果你告诉我你的当前水平（比如“刚学完 JavaScript”或“会 React 想转 Vue”），我可以给你更个性化的建议！ 😊\n\n要不要我帮你生成一个简单的 Vue 3 入门示例？', 'text', 'null', 1853, '2026-02-05 16:14:20', 1, '2026-02-05 16:14:20', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (31, 9, 'user', '帮我写一个测试用例模板', 'text', 'null', NULL, '2026-02-05 16:17:20', 1, '2026-02-05 16:17:20', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (32, 9, 'assistant', '当然可以！以下是一个 **Vue 3 + Vitest + Vue Test Utils** 的通用测试用例模板，适用于组件单元测试。这是目前 Vue 官方推荐的测试组合（Vite + Vitest + @vue/test-utils）。\n\n---\n\n### 📁 前提条件\n确保你已安装以下依赖（通常通过 `npm create vue@latest` 创建的项目已包含）：\n```bash\nnpm install -D vitest @vue/test-utils jsdom\n```\n\n并在 `vite.config.js` 中配置了测试环境（官方模板通常已配置好）。\n\n---\n\n### ✅ 测试用例模板：`MyComponent.spec.js`\n\n```js\n// tests/MyComponent.spec.js\nimport { describe, it, expect } from \'vitest\'\nimport { mount } from \'@vue/test-utils\'\nimport MyComponent from \'@/components/MyComponent.vue\'\n\ndescribe(\'MyComponent\', () => {\n  // 测试默认渲染\n  it(\'renders correctly\', () => {\n    const wrapper = mount(MyComponent)\n    expect(wrapper.exists()).toBe(true)\n  })\n\n  // 测试 props\n  it(\'displays the correct title when passed via props\', () => {\n    const title = \'Hello World\'\n    const wrapper = mount(MyComponent, {\n      props: {\n        title\n      }\n    })\n    expect(wrapper.text()).toContain(title)\n  })\n\n  // 测试事件触发\n  it(\'emits an event when button is clicked\', async () => {\n    const wrapper = mount(MyComponent)\n    await wrapper.find(\'button\').trigger(\'click\')\n    expect(wrapper.emitted()).toHaveProperty(\'my-event\')\n  })\n\n  // 测试响应式数据更新\n  it(\'updates count when increment button is clicked\', async () => {\n    const wrapper = mount(MyComponent)\n    const button = wrapper.find(\'[data-test=\"increment-btn\"]\')\n    await button.trigger(\'click\')\n    expect(wrapper.vm.count).toBe(1) // 假设组件有 count 响应式变量\n  })\n\n  // 测试异步操作（如 API 调用）\n  it(\'fetches and displays user data\', async () => {\n    // 模拟 API\n    global.fetch = vi.fn().mockResolvedValue({\n      json: () => Promise.resolve({ name: \'Alice\' })\n    })\n\n    const wrapper = mount(MyComponent)\n    await wrapper.vm.loadUser() // 假设组件有 loadUser 方法\n\n    expect(wrapper.text()).toContain(\'Alice\')\n  })\n})\n```\n\n---\n\n### 🧪 对应的示例组件（`MyComponent.vue`）\n\n```vue\n<!-- src/components/MyComponent.vue -->\n<template>\n  <div>\n    <h2>{{ title }}</h2>\n    <p>Count: {{ count }}</p>\n    <button @click=\"increment\">+</button>\n    <button @click=\"$emit(\'my-event\')\">Emit Event</button>\n    <p v-if=\"user\">{{ user.name }}</p>\n  </div>\n</template>\n\n<script setup>\nimport { ref } from \'vue\'\n\nconst props = defineProps({\n  title: {\n    type: String,\n    default: \'\'\n  }\n})\n\nconst emit = defineEmits([\'my-event\'])\n\nconst count = ref(0)\nconst user = ref(null)\n\nfunction increment() {\n  count.value++\n}\n\nasync function loadUser() {\n  const res = await fetch(\'/api/user\')\n  user.value = await res.json()\n}\n\ndefineExpose({\n  count,\n  loadUser\n})\n</script>\n```\n\n---\n\n### ▶️ 运行测试\n在 `package.json` 中添加脚本（如果还没有）：\n```json\n{\n  \"scripts\": {\n    \"test\": \"vitest\",\n    \"test:ui\": \"vitest --ui\"  // 可视化界面（可选）\n  }\n}\n```\n\n然后运行：\n```bash\nnpm run test\n```\n\n---\n\n### 🔑 关键点说明\n| 方法 | 用途 |\n|------|------|\n| `mount()` | 渲染组件并返回 wrapper |\n| `wrapper.find()` / `findAll()` | 查找 DOM 元素 |\n| `wrapper.text()` | 获取文本内容 |\n| `wrapper.vm` | 访问组件实例（组合式 API 需 `defineExpose` 暴露） |\n| `wrapper.emitted()` | 获取触发的事件 |\n| `trigger(\'click\')` | 触发 DOM 事件（需 `await`） |\n\n---\n\n### 💡 提示\n- 使用 `data-test=\"xxx\"` 属性做测试选择器，避免依赖 class 或标签结构。\n- 对于组合式 API（`<script setup>`），需要通过 `defineExpose` 暴露内部变量/方法才能在测试中访问。\n- 异步操作记得加 `await`！\n\n---\n\n如果你使用的是 **选项式 API**、**Pinia**、**Vue Router**，或者想测 **Composition Function（自定义 Hook）**，也可以告诉我，我可以提供对应模板！ 😊', 'text', 'null', 3232, '2026-02-05 16:17:50', 1, '2026-02-05 16:17:50', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (33, 11, 'user', '帮我写一个 Python 快速排序算法', 'text', 'null', NULL, '2026-02-05 16:36:55', 1, '2026-02-05 16:36:55', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (34, 11, 'assistant', '当然！下面是一个经典的 **快速排序（Quick Sort）** 算法的 Python 实现：\n\n```python\ndef quick_sort(arr):\n    \"\"\"\n    快速排序主函数（递归实现）\n    \n    参数:\n        arr (list): 待排序的列表\n    \n    返回:\n        list: 排序后的新列表（不修改原列表）\n    \"\"\"\n    if len(arr) <= 1:\n        return arr\n    \n    pivot = arr[len(arr) // 2]  # 选择中间元素作为基准\n    left = [x for x in arr if x < pivot]\n    middle = [x for x in arr if x == pivot]\n    right = [x for x in arr if x > pivot]\n    \n    return quick_sort(left) + middle + quick_sort(right)\n\n\n# 示例用法\nif __name__ == \"__main__\":\n    data = [3, 6, 8, 10, 1, 2, 1]\n    sorted_data = quick_sort(data)\n    print(\"原始数组:\", data)\n    print(\"排序后:\", sorted_data)\n```\n\n---\n\n### 特点说明：\n- **时间复杂度**：\n  - 平均情况：O(n log n)\n  - 最坏情况（如已排序数组且选首/尾为基准）：O(n²)\n- **空间复杂度**：O(log n)（递归栈深度，平均情况）\n- **稳定性**：不稳定（但本实现通过保留相等元素顺序，在某些情况下表现稳定）\n- **是否原地排序**：否（本实现返回新列表，不修改原数组）\n\n---\n\n### 原地排序版本（节省内存）：\n如果你希望 **原地排序**（in-place），可以使用以下版本：\n\n```python\ndef quick_sort_inplace(arr, low=0, high=None):\n    \"\"\"\n    原地快速排序（修改原数组）\n    \"\"\"\n    if high is None:\n        high = len(arr) - 1\n        \n    if low < high:\n        # 分区操作，返回基准索引\n        pivot_index = partition(arr, low, high)\n        # 递归排序左右子数组\n        quick_sort_inplace(arr, low, pivot_index - 1)\n        quick_sort_inplace(arr, pivot_index + 1, high)\n\ndef partition(arr, low, high):\n    \"\"\"\n    分区函数：将数组分为小于和大于基准的两部分\n    使用最后一个元素作为基准\n    \"\"\"\n    pivot = arr[high]\n    i = low - 1  # 小于基准的区域边界\n    \n    for j in range(low, high):\n        if arr[j] <= pivot:\n            i += 1\n            arr[i], arr[j] = arr[j], arr[i]  # 交换\n    \n    arr[i + 1], arr[high] = arr[high], arr[i + 1]  # 基准放到正确位置\n    return i + 1\n\n# 示例用法\ndata = [3, 6, 8, 10, 1, 2, 1]\nprint(\"排序前:\", data)\nquick_sort_inplace(data)\nprint(\"排序后:\", data)\n```\n\n---\n\n你可以根据需求选择使用**非原地版本**（代码简洁、易理解）或**原地版本**（节省内存）。需要进一步优化（如随机选基准避免最坏情况）也可以告诉我！', 'text', 'null', 1801, '2026-02-05 16:37:09', 1, '2026-02-05 16:37:09', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (35, 13, 'user', '前端性能优化有哪些方法？', 'text', 'null', NULL, '2026-02-05 16:38:07', 1, '2026-02-05 16:38:07', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (36, 13, 'assistant', '前端性能优化是提升用户体验、提高页面加载速度和交互流畅度的关键。以下是一些常见且有效的前端性能优化方法，按类别整理：\n\n---\n\n### 一、资源加载优化\n\n1. **减少 HTTP 请求**\n   - 合并 CSS/JS 文件（如使用构建工具打包）\n   - 使用 CSS Sprites 合并小图标\n   - 内联关键的小资源（如关键 CSS）\n\n2. **压缩资源**\n   - 压缩 HTML、CSS、JavaScript（如使用 Gzip/Brotli）\n   - 压缩图片（使用 WebP、AVIF 等现代格式，或工具如 TinyPNG）\n\n3. **使用 CDN（内容分发网络）**\n   - 将静态资源部署到离用户更近的节点，加快加载速度\n\n4. **懒加载（Lazy Loading）**\n   - 图片、视频、组件等非首屏内容延迟加载（如使用 `loading=\"lazy\"` 或 Intersection Observer）\n\n5. **预加载与预获取**\n   - `<link rel=\"preload\">`：提前加载关键资源\n   - `<link rel=\"prefetch\">`：预获取未来可能用到的资源\n\n6. **代码分割（Code Splitting）**\n   - 使用动态 import() 按需加载模块（如 React 的 lazy + Suspense）\n\n---\n\n### 二、渲染性能优化\n\n1. **减少重排（Reflow）和重绘（Repaint）**\n   - 避免频繁读写 DOM 样式\n   - 使用 `transform` 和 `opacity` 实现动画（触发合成层，不引起重排）\n   - 批量修改 DOM（如使用 DocumentFragment）\n\n2. **使用虚拟 DOM 或高效更新策略**\n   - React/Vue 等框架通过 diff 算法减少不必要的 DOM 操作\n\n3. **避免强制同步布局（Forced Synchronous Layout）**\n   - 不要在循环中读取 offsetWidth 等布局属性后立即修改样式\n\n4. **使用 requestAnimationFrame 优化动画**\n   - 保证动画在浏览器下一帧执行，更流畅\n\n---\n\n### 三、JavaScript 性能优化\n\n1. **减少主线程工作**\n   - 避免长时间运行的 JS 任务（可拆分为多个微任务）\n   - 使用 Web Workers 处理复杂计算\n\n2. **事件委托**\n   - 减少事件监听器数量，提升性能和内存效率\n\n3. **防抖（Debounce）与节流（Throttle）**\n   - 限制高频事件（如滚动、输入）的处理频率\n\n4. **避免内存泄漏**\n   - 及时移除事件监听器、定时器\n   - 注意闭包引用、全局变量\n\n---\n\n### 四、缓存策略\n\n1. **HTTP 缓存**\n   - 设置合理的 `Cache-Control`、`ETag`、`Last-Modified`\n   - 区分强缓存与协商缓存\n\n2. **Service Worker 缓存**\n   - 实现离线访问、资源预缓存（PWA）\n\n3. **本地存储优化**\n   - 合理使用 localStorage、IndexedDB 存储数据，避免阻塞主线程\n\n---\n\n### 五、首屏与关键渲染路径优化\n\n1. **关键渲染路径优化**\n   - 内联关键 CSS\n   - 异步加载非关键 JS（使用 `async` 或 `defer`）\n   - 减少关键资源数量和大小\n\n2. **服务端渲染（SSR）或静态生成（SSG）**\n   - 提升首屏加载速度和 SEO（如 Next.js、Nuxt.js）\n\n3. **骨架屏（Skeleton Screen）**\n   - 在内容加载前展示占位结构，提升感知性能\n\n---\n\n### 六、监控与分析\n\n1. **性能指标监控**\n   - 关注 LCP（最大内容绘制）、FID（首次输入延迟）、CLS（累计布局偏移）等 Core Web Vitals\n\n2. **使用 DevTools 分析**\n   - Chrome DevTools 的 Performance、Lighthouse 工具\n\n3. **真实用户监控（RUM）**\n   - 收集真实用户设备上的性能数据（如使用 Sentry、Google Analytics）\n\n---\n\n### 七、其他技巧\n\n- 使用字体加载策略（如 `font-display: swap`）\n- 减少第三方脚本（如广告、分析工具）的影响\n- 采用响应式设计，避免加载不必要的大图\n- 升级构建工具（如 Vite 替代 Webpack 提升开发体验）\n\n---\n\n> 💡 **核心原则**：  \n> “**快”不仅是技术指标，更是用户体验。**  \n> 优先优化用户可感知的部分（如首屏加载、交互响应），再深入细节优化。\n\n根据项目实际情况选择合适的优化策略，通常“80% 的性能提升来自 20% 的关键优化”。', 'text', 'null', 2156, '2026-02-05 16:38:29', 1, '2026-02-05 16:38:29', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (37, 14, 'user', '你好', 'text', 'null', NULL, '2026-02-05 16:40:29', 1, '2026-02-05 16:40:29', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (38, 14, 'assistant', '你好！很高兴见到你，有什么我可以帮忙的吗？😊', 'text', 'null', 22, '2026-02-05 16:40:30', 1, '2026-02-05 16:40:30', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (39, 14, 'user', '如何学习python', 'text', 'null', NULL, '2026-02-05 16:40:52', 1, '2026-02-05 16:40:52', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (40, 14, 'assistant', '你好！学习 Python 是一个非常棒的选择，因为它语法简洁、应用广泛（如 Web 开发、数据分析、人工智能、自动化等），而且社区活跃、资源丰富。下面是一个适合初学者的 Python 学习路径，帮助你系统地入门并逐步提升：\n\n---\n\n### 🌱 一、打好基础（1-2 周）\n1. **安装 Python 和开发环境**\n   - 官网下载：[https://www.python.org/](https://www.python.org/)\n   - 推荐使用 **VS Code** 或 **PyCharm Community** 作为编辑器。\n   - 安装时记得勾选 “Add to PATH”。\n\n2. **学习基本语法**\n   - 变量与数据类型（int, float, str, bool, list, dict, tuple, set）\n   - 条件语句（if/elif/else）\n   - 循环（for, while）\n   - 函数定义（def）\n   - 输入输出（print(), input()）\n\n3. **推荐免费资源**\n   - [Python 官方教程](https://docs.python.org/zh-cn/3/tutorial/)\n   - [菜鸟教程 - Python3](https://www.runoob.com/python3/)\n   - [廖雪峰的 Python 教程](https://www.liaoxuefeng.com/wiki/1016959643678400)\n   - 视频：B站“小甲鱼”《零基础入门学习Python》\n\n---\n\n### 🧱 二、动手实践（边学边练）\n- 每学一个概念，立刻写代码验证。\n- 尝试解决简单问题，例如：\n  - 计算阶乘\n  - 判断素数\n  - 简单的猜数字游戏\n  - 读取文件并统计单词数量\n\n> 💡 使用 [LeetCode](https://leetcode.cn/)、[牛客网](https://www.nowcoder.com/) 或 [Codecademy](https://www.codecademy.com/learn/learn-python-3) 进行练习。\n\n---\n\n### 🛠️ 三、进阶内容（2-4 周后）\n1. **面向对象编程（OOP）**\n   - 类与对象、继承、封装、多态\n2. **常用模块**\n   - `os`, `sys`, `datetime`, `json`, `re`（正则表达式）\n3. **文件操作**\n   - 读写文本/CSV/JSON 文件\n4. **异常处理**\n   - try/except/finally\n\n---\n\n### 🚀 四、项目驱动学习（关键！）\n通过做小项目巩固知识，例如：\n- **爬虫**：用 `requests` + `BeautifulSoup` 抓取网页数据\n- **数据分析**：用 `pandas` + `matplotlib` 分析 Excel 或 CSV 数据\n- **Web 应用**：用 `Flask` 或 `Django` 搭建一个博客或待办事项网站\n- **自动化脚本**：批量重命名文件、自动发送邮件等\n\n> GitHub 上有很多开源的小项目可以参考和模仿。\n\n---\n\n### 📚 五、持续提升\n- 阅读优秀代码（GitHub）\n- 学习虚拟环境（`venv` 或 `conda`）\n- 了解 PEP8 编码规范\n- 学习使用 Git 进行版本控制\n- 尝试参与开源项目或自己发布工具包（PyPI）\n\n---\n\n### ✅ 小贴士\n- **不要死记硬背**，理解逻辑更重要。\n- **每天写代码**，哪怕只有 15 分钟。\n- **遇到问题先查文档或 Stack Overflow**，再提问。\n- 加入 Python 社区（如知乎、Reddit 的 r/learnpython、本地技术群）。\n\n---\n\n如果你告诉我你的背景（比如是学生、转行者、想做数据分析还是 Web 开发），我可以为你定制更具体的学习建议！😊\n\n祝你学习顺利，早日写出自己的第一个 Python 程序！🐍', 'text', 'null', 1757, '2026-02-05 16:41:11', 1, '2026-02-05 16:41:11', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (41, 14, 'user', '写个冒泡排序脚本', 'text', 'null', NULL, '2026-02-05 16:47:01', 1, '2026-02-05 16:47:01', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (42, 14, 'assistant', '当然可以！下面是一个用 Python 编写的 **冒泡排序（Bubble Sort）** 脚本，包含详细注释，适合学习理解：\n\n```python\ndef bubble_sort(arr):\n    \"\"\"\n    冒泡排序函数\n    参数: arr - 待排序的列表\n    返回: 排序后的新列表（不修改原列表）\n    \"\"\"\n    # 创建原列表的副本，避免修改原始数据\n    sorted_arr = arr.copy()\n    n = len(sorted_arr)\n    \n    # 外层循环：控制排序轮数（最多 n-1 轮）\n    for i in range(n - 1):\n        swapped = False  # 优化标志：记录本轮是否发生交换\n        \n        # 内层循环：每轮比较相邻元素，将最大值“冒泡”到末尾\n        for j in range(0, n - 1 - i):  # 每轮减少比较次数（末尾已有序）\n            if sorted_arr[j] > sorted_arr[j + 1]:\n                # 交换元素\n                sorted_arr[j], sorted_arr[j + 1] = sorted_arr[j + 1], sorted_arr[j]\n                swapped = True\n        \n        # 如果某一轮没有发生交换，说明列表已有序，提前结束\n        if not swapped:\n            break\n    \n    return sorted_arr\n\n\n# 测试示例\nif __name__ == \"__main__\":\n    # 测试数据\n    numbers = [64, 34, 25, 12, 22, 11, 90]\n    print(\"原始列表:\", numbers)\n    \n    # 调用冒泡排序\n    sorted_numbers = bubble_sort(numbers)\n    print(\"排序后列表:\", sorted_numbers)\n    \n    # 验证原列表未被修改\n    print(\"原始列表（验证未变）:\", numbers)\n```\n\n---\n\n### ✅ 运行效果：\n```\n原始列表: [64, 34, 25, 12, 22, 11, 90]\n排序后列表: [11, 12, 22, 25, 34, 64, 90]\n原始列表（验证未变）: [64, 34, 25, 12, 22, 11, 90]\n```\n\n---\n\n### 🔍 冒泡排序原理简述：\n1. **重复遍历列表**，比较相邻元素。\n2. 如果前一个元素 > 后一个元素，就交换它们。\n3. 每一轮会把当前最大的元素“冒泡”到列表末尾。\n4. 最多需要 `n-1` 轮（n 是元素个数）。\n5. **优化点**：如果某一轮没有发生任何交换，说明列表已经有序，可以提前退出。\n\n---\n\n### ⏱️ 时间复杂度：\n- 最坏情况：O(n²)（列表完全逆序）\n- 最好情况：O(n)（列表已经有序，得益于 `swapped` 优化）\n- 空间复杂度：O(1)（原地排序，但这里我们返回新列表，所以是 O(n)）\n\n---\n\n如果你想看**原地排序版本**（直接修改原列表），也可以这样写：\n\n```python\ndef bubble_sort_inplace(arr):\n    n = len(arr)\n    for i in range(n - 1):\n        swapped = False\n        for j in range(n - 1 - i):\n            if arr[j] > arr[j + 1]:\n                arr[j], arr[j + 1] = arr[j + 1], arr[j]\n                swapped = True\n        if not swapped:\n            break\n\n# 使用示例\nnums = [5, 2, 8, 1, 9]\nbubble_sort_inplace(nums)\nprint(nums)  # 输出: [1, 2, 5, 8, 9]\n```\n\n希望这个脚本能帮助你理解冒泡排序！如果你还想学其他排序算法（如快速排序、归并排序等），也可以告诉我 😊', 'text', 'null', 1938, '2026-02-05 16:47:18', 1, '2026-02-05 16:47:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (43, 14, 'user', '输出一个老化测试对比表', 'text', 'null', NULL, '2026-02-05 16:47:31', 1, '2026-02-05 16:47:31', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (44, 14, 'assistant', '当然可以！以下是一个 **老化测试（Burn-in Test）对比表** 的示例，适用于硬件产品（如电子元器件、服务器、电池、LED 等）在研发、生产或质量验证阶段使用。该表格可用于对比不同批次、不同供应商、不同设计或不同测试条件下的老化表现。\n\n---\n\n### 🔧 老化测试对比表\n\n| 项目 | 样品 A（新设计） | 样品 B（旧设计） | 样品 C（竞品） | 测试标准/备注 |\n|------|------------------|------------------|----------------|----------------|\n| **产品型号** | XYZ-2024A | XYZ-2020B | ABC-9000 | — |\n| **测试数量** | 50 台 | 50 台 | 30 台 | 随机抽样 |\n| **老化温度** | 85°C | 85°C | 85°C | 恒温老化箱 |\n| **老化湿度** | 85% RH | 85% RH | 85% RH | 高湿环境 |\n| **老化时间** | 500 小时 | 500 小时 | 500 小时 | 连续通电运行 |\n| **工作电压** | 12V ±5% | 12V ±5% | 12V ±5% | 模拟实际工况 |\n| **初始良率** | 100% | 100% | 100% | 老化前功能测试 |\n| **老化后失效数** | 1 台 | 6 台 | 3 台 | 功能异常或参数超差 |\n| **失效率** | **2.0%** | **12.0%** | **10.0%** | 失效数 / 总数 × 100% |\n| **主要失效模式** | 电源模块轻微温升 | 电容鼓包、通信中断 | LED 光衰 >30% | 记录故障现象 |\n| **关键参数漂移（平均）** | < 3% | 8.5% | 7.2% | 如电流、亮度、频率等 |\n| **MTBF（预估）** | >100,000 小时 | ~60,000 小时 | ~70,000 小时 | 基于老化数据推算 |\n| **结论** | ✅ 通过，可靠性显著提升 | ⚠️ 需改进电容选型 | ⚠️ 光衰控制待优化 | 建议：A 方案可量产 |\n\n---\n\n### 📌 说明：\n- **老化测试目的**：加速暴露早期失效（“婴儿死亡率”），筛选出潜在缺陷产品。\n- **适用场景**：半导体、电源模块、LED 灯具、服务器主板、电池 pack 等。\n- **关键指标**：失效率、参数稳定性、失效模式分析（FMA）。\n- **建议**：结合高温高湿（THB）、温度循环（TC）、HAST 等测试综合评估。\n\n---\n\n### 💡 扩展建议：\n- 若用于 **软件系统**（如服务器长时间运行稳定性），可将“失效”替换为“崩溃次数”、“内存泄漏量”、“响应延迟增长”等指标。\n- 可增加 **图表**（如失效率趋势图、参数漂移曲线）辅助分析。\n\n---\n\n如果你有具体的产品类型（比如锂电池、摄像头模组、SSD 硬盘等），我可以为你定制更专业的老化测试对比表模板！欢迎补充细节 😊', 'text', 'null', 1327, '2026-02-05 16:47:50', 1, '2026-02-05 16:47:50', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (45, 14, 'user', '生成一个曲线图', 'text', 'null', NULL, '2026-02-05 16:48:29', 1, '2026-02-05 16:48:29', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (46, 14, 'assistant', '当然可以！下面我将为你生成一个 **老化测试中“失效率随时间变化”的曲线图**，这是可靠性工程中常见的分析图表。我们将使用 Python 的 `matplotlib` 库来绘制。\n\n---\n\n### 📈 示例：老化测试失效率随时间变化曲线\n\n```python\nimport matplotlib.pyplot as plt\nimport numpy as np\n\n# 设置中文字体（可选，避免中文乱码）\nplt.rcParams[\'font.sans-serif\'] = [\'SimHei\']  # Windows\nplt.rcParams[\'axes.unicode_minus\'] = False    # 正常显示负号\n\n# 模拟老化测试数据（时间单位：小时）\ntime_hours = np.array([0, 50, 100, 200, 300, 400, 500])\nfailure_rate_A = np.array([0, 0.5, 1.0, 1.5, 1.8, 2.0, 2.0])   # 新设计（样品A）\nfailure_rate_B = np.array([0, 2.0, 4.5, 7.0, 9.5, 11.0, 12.0])  # 旧设计（样品B）\nfailure_rate_C = np.array([0, 1.5, 3.0, 5.5, 8.0, 9.5, 10.0])   # 竞品（样品C）\n\n# 绘图\nplt.figure(figsize=(10, 6))\nplt.plot(time_hours, failure_rate_A, marker=\'o\', label=\'样品A（新设计）\', linewidth=2)\nplt.plot(time_hours, failure_rate_B, marker=\'s\', label=\'样品B（旧设计）\', linewidth=2)\nplt.plot(time_hours, failure_rate_C, marker=\'^\', label=\'样品C（竞品）\', linewidth=2)\n\n# 图表设置\nplt.title(\'老化测试失效率随时间变化曲线\', fontsize=16)\nplt.xlabel(\'老化时间（小时）\', fontsize=12)\nplt.ylabel(\'累计失效率（%）\', fontsize=12)\nplt.grid(True, linestyle=\'--\', alpha=0.6)\nplt.legend()\nplt.xlim(0, 500)\nplt.ylim(0, 13)\nplt.xticks(time_hours)\n\n# 显示图表\nplt.tight_layout()\nplt.show()\n```\n\n---\n\n### 🖼️ 输出效果说明：\n- **横轴**：老化时间（0 到 500 小时）\n- **纵轴**：累计失效率（%）\n- **三条曲线** 分别代表不同样品的可靠性表现\n- **样品A** 失效率最低且早期趋于稳定，说明可靠性更好\n\n> ✅ 如果你在本地运行此代码（需安装 `matplotlib` 和 `numpy`），会弹出一个清晰的曲线图窗口。  \n> 安装命令：`pip install matplotlib numpy`\n\n---\n\n### 🌐 无法运行？这里提供一张示意图描述：\n\n```\n失效率（%）\n12 |                ■ 样品B（旧设计）\n10 |             ■        ▲ 样品C（竞品）\n 8 |          ■        ▲\n 6 |       ■        ▲\n 4 |    ■        ▲\n 2 | ○        ▲        ● 样品A（新设计）\n 0 +----------------------------\n     0   100  200  300  400  500 → 时间（小时）\n```\n\n（○、▲、■ 分别代表三种样品的采样点）\n\n---\n\n### 💡 应用场景扩展：\n- 电池容量衰减曲线\n- LED 光通量维持率 vs 时间\n- 服务器 CPU 温度老化趋势\n- 软件内存泄漏增长曲线\n\n---\n\n如果你有具体的数据或想绘制其他类型的曲线（如直方图、散点图、对数坐标等），欢迎提供数据，我可以为你定制代码！📊', 'text', 'null', 1834, '2026-02-05 16:48:49', 1, '2026-02-05 16:48:49', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (47, 14, 'user', '这个图片是什么', 'text', 'null', NULL, '2026-02-05 17:00:38', 1, '2026-02-05 17:00:38', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (48, 14, 'assistant', '你好！你提到“这个图片是什么”，但目前**我无法看到任何图片**。\n\n在当前的对话环境中，我（作为文本型 AI）**不能接收、查看或分析你上传的图像**。如果你希望我帮你识别或解释一张图片的内容，请尝试以下方法：\n\n---\n\n### ✅ 你可以这样做：\n1. **描述图片内容**（例如：  \n   > “图中有一条蓝色曲线，横轴是时间，纵轴是温度，有三个数据系列…”）\n   \n2. 如果是**代码生成的图表**（比如刚才的老化测试曲线），可以告诉我：\n   - 横纵轴代表什么\n   - 曲线的趋势或数据点\n   - 你想分析或改进的地方\n\n3. 如果是**截图或照片**，请用文字说明：\n   - 图片类型（流程图？电路图？仪表盘？错误界面？）\n   - 关键文字或数字\n   - 你的疑问（例如：“这是什么故障？”、“这个符号代表什么？”）\n\n---\n\n### 📌 示例：\n> “我有一张图，显示三条下降的曲线，标签是‘Sample A’、‘B’、‘C’，Y 轴是‘光通量维持率（%）’，X 轴是‘工作时间（小时）’，我想知道哪个样品最耐用。”\n\n我可以根据你的描述进行专业解读！\n\n---\n\n请补充图片的文字描述，我会尽力帮你分析 😊', 'text', 'null', 522, '2026-02-05 17:00:49', 1, '2026-02-05 17:00:49', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (49, 14, 'user', '这个图片是什么', 'text', 'null', NULL, '2026-02-05 17:11:31', 1, '2026-02-05 17:11:31', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (50, 14, 'assistant', '你好！我理解你可能已经上传或试图发送了一张图片，但需要说明的是：**在当前的对话环境中，我无法查看、接收或分析任何图片**。这是一个纯文本交互界面，不支持图像识别功能。\n\n如果你希望我帮你解答图片中的内容，请**用文字描述图片的关键信息**，例如：\n\n- 图片类型（如：曲线图、表格、电路图、错误弹窗、产品标签等）  \n- 横纵轴标签（如果是图表）  \n- 图中出现的文字、数字、符号  \n- 你的具体问题（比如：“这个图标是什么意思？”、“这条曲线代表什么？”）\n\n---\n\n### 📝 举个例子：\n> “图中有一个折线图，X 轴是‘老化时间（小时）’，Y 轴是‘失效率（%）’，有三条线：红色上升快，蓝色平缓，绿色居中。我想知道哪条代表最可靠的产品？”\n\n只要提供类似描述，我就能为你详细分析！\n\n期待你的文字说明 😊', 'text', 'null', 361, '2026-02-05 17:11:43', 1, '2026-02-05 17:11:43', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (51, 14, 'user', '这个文件中有什么内容', 'text', 'null', NULL, '2026-02-05 17:12:06', 1, '2026-02-05 17:12:06', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (52, 14, 'assistant', '你好！你提到“这个文件中有什么内容”，但目前**我无法访问或查看任何文件**。\n\n在当前的对话环境中，我是一个**纯文本交互的 AI 助手**，**不能接收、读取、打开或分析你上传的文件**（无论是 Word、PDF、Excel、图片、日志文件还是代码文件等）。\n\n---\n\n### ✅ 你可以这样做：\n请**复制粘贴文件中的部分内容**到聊天框中（注意：不要包含敏感或机密信息），并告诉我：\n- 文件类型（如：日志文件、配置文件、测试报告、Python 脚本等）\n- 你想了解什么（例如：“这是什么错误？”、“这段配置是什么意思？”、“如何优化这段代码？”）\n\n---\n\n### 📝 示例：\n> “这是一个 Python 脚本，内容如下：\n> ```python\n> import os\n> print(os.listdir(\'/tmp\'))\n> ```\n> 这段代码的作用是什么？”\n\n或者：\n\n> “我在日志中看到这行：\n> `ERROR: Connection timeout after 30s`\n> 是什么原因导致的？”\n\n---\n\n只要你提供文字内容和上下文，我就能帮你分析、解释或解决问题！😊  \n请放心粘贴（非敏感）文本内容吧。', 'text', 'null', 523, '2026-02-05 17:12:18', 1, '2026-02-05 17:12:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (53, 15, 'user', '如何优化数据库查询性能？', 'text', 'null', NULL, '2026-02-05 17:21:56', 1, '2026-02-05 17:21:56', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (54, 15, 'assistant', '优化数据库查询性能是提升系统整体效率的关键。以下是一些通用且实用的优化策略，适用于大多数关系型数据库（如 MySQL、PostgreSQL、SQL Server、Oracle 等）：\n\n---\n\n### 一、索引优化\n1. **为常用查询字段创建索引**  \n   - WHERE、JOIN、ORDER BY、GROUP BY 中频繁使用的列应考虑建立索引。\n   - 复合索引（多列索引）需注意列的顺序（最左前缀原则）。\n\n2. **避免过度索引**  \n   - 索引会增加写操作（INSERT/UPDATE/DELETE）的开销，并占用存储空间。\n   - 定期审查并删除未使用或重复的索引。\n\n3. **使用覆盖索引（Covering Index）**  \n   - 如果索引包含查询所需的所有字段，数据库可直接从索引中获取数据，避免回表。\n\n4. **注意索引失效场景**  \n   - 在索引列上使用函数（如 `UPPER(name)`）、`LIKE \'%xxx\'`、类型转换等可能导致索引失效。\n\n---\n\n### 二、SQL 语句优化\n1. **避免 SELECT \\***  \n   - 只查询需要的字段，减少 I/O 和网络传输。\n\n2. **使用 LIMIT / TOP 限制结果集**  \n   - 尤其在分页或预览场景中，避免返回大量无用数据。\n\n3. **优化 JOIN 操作**  \n   - 确保关联字段有索引。\n   - 避免笛卡尔积（无条件 JOIN）。\n   - 尽量减少 JOIN 表的数量。\n\n4. **避免在 WHERE 子句中对字段进行计算或函数操作**  \n   ```sql\n   -- 不推荐\n   WHERE YEAR(create_time) = 2023\n\n   -- 推荐\n   WHERE create_time >= \'2023-01-01\' AND create_time < \'2024-01-01\'\n   ```\n\n5. **使用 EXISTS 替代 IN（子查询场景）**  \n   - `EXISTS` 通常比 `IN` 更高效，尤其当子查询结果较大时。\n\n---\n\n### 三、数据库设计优化\n1. **合理设计表结构**  \n   - 遵循范式但不过度（适当反范式化以提升读性能）。\n   - 使用合适的数据类型（如用 `INT` 而非 `VARCHAR` 存储 ID）。\n\n2. **分区表（Partitioning）**  \n   - 对大表按时间、范围或哈希分区，提升查询效率。\n\n3. **归档历史数据**  \n   - 将不常访问的历史数据移至归档表，减小主表体积。\n\n---\n\n### 四、执行计划分析\n1. **使用 EXPLAIN / EXPLAIN ANALYZE**  \n   - 查看查询执行计划，识别全表扫描、临时表、文件排序等性能瓶颈。\n\n2. **关注关键指标**  \n   - 是否使用索引？\n   - 扫描行数是否过多？\n   - 是否有“Using filesort”或“Using temporary”？\n\n---\n\n### 五、配置与硬件优化\n1. **调整数据库参数**  \n   - 如缓冲池大小（InnoDB Buffer Pool）、连接数、查询缓存（注意：MySQL 8.0 已移除查询缓存）等。\n\n2. **使用 SSD 存储**  \n   - 提升 I/O 性能，尤其对随机读写密集型应用。\n\n3. **读写分离与分库分表**  \n   - 高并发场景下，通过主从复制实现读写分离，或使用分库分表（Sharding）分散负载。\n\n---\n\n### 六、其他技巧\n- **批量操作代替单条操作**：如 `INSERT INTO ... VALUES (...), (...), ...`。\n- **避免频繁的小查询**：合并为一次查询，减少网络往返。\n- **使用缓存**：如 Redis 缓存热点数据，减少数据库压力。\n- **定期更新统计信息**：帮助优化器生成更优执行计划。\n\n---\n\n### 示例：慢查询优化流程\n1. 开启慢查询日志（slow query log）。\n2. 找出执行时间长的 SQL。\n3. 使用 `EXPLAIN` 分析执行计划。\n4. 添加/调整索引或重写 SQL。\n5. 验证优化效果。\n\n---\n\n> 💡 **提示**：没有“万能”的优化方案，需结合具体业务场景、数据量、查询模式进行针对性调优。建议在测试环境充分验证后再上线。\n\n如果你有具体的 SQL 或数据库类型（如 MySQL、PostgreSQL），我可以提供更针对性的建议。', 'text', 'null', 1950, '2026-02-05 17:22:19', 1, '2026-02-05 17:22:19', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (55, 16, 'user', '你是谁', 'text', 'null', NULL, '2026-02-05 17:32:51', 1, '2026-02-05 17:32:51', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (56, 16, 'assistant', '我是来自阿里云的大规模语言模型，我叫通义千问。', 'text', 'null', 23, '2026-02-05 17:32:53', 1, '2026-02-05 17:32:53', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (57, 17, 'user', '你好，请简单回复', 'text', 'null', NULL, '2026-02-05 18:07:53', 1, '2026-02-05 18:07:53', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (58, 17, 'assistant', '你好！有什么可以帮你的吗？', 'text', 'null', 0, '2026-02-05 18:07:57', 1, '2026-02-05 18:07:57', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (59, 17, 'user', '你好', 'text', 'null', NULL, '2026-02-05 18:13:17', 1, '2026-02-05 18:13:17', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (60, 17, 'assistant', '你好！很高兴能为你服务。有什么我可以帮助你的吗？', 'text', 'null', 24, '2026-02-05 18:13:19', 1, '2026-02-05 18:13:19', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (61, 17, 'user', '今天星期几', 'text', 'null', NULL, '2026-02-05 18:13:27', 1, '2026-02-05 18:13:27', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (62, 17, 'assistant', '抱歉，作为一个AI助手，我无法获取实时信息来告诉你今天的日期和星期几。你可以查看手机日历或者搜索引擎来获取准确的信息。', 'text', 'null', 59, '2026-02-05 18:13:28', 1, '2026-02-05 18:13:28', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (63, 17, 'user', '你能做什么', 'text', 'null', NULL, '2026-02-05 18:13:36', 1, '2026-02-05 18:13:36', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (64, 17, 'assistant', '作为一个人工智能语言模型，我的主要功能是回答问题、提供信息、进行对话等。我能帮你解答各种问题，包括但不限于科学知识、文化常识、生活技巧、历史事件等等。此外，我还能够进行简单的计算、翻译、写作辅助等工作。如果你有任何具体的问题或需求，请随时告诉我，我会尽力帮助你。', 'text', 'null', 131, '2026-02-05 18:13:37', 1, '2026-02-05 18:13:37', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (65, 18, 'user', 'playwright是什么', 'text', 'null', NULL, '2026-02-05 18:22:15', 1, '2026-02-05 18:22:15', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (66, 18, 'assistant', 'Playwright是一个用于编写和测试Web应用程序的Python库。它提供了一种简单的方式来创建自动化脚本，这些脚本可以模拟用户与网页进行交互的行为。\n\n使用Playwright，你可以编写代码来打开浏览器、导航到特定页面、填写表单字段、点击按钮等操作。此外，Playwright还支持录制功能，允许你通过手动执行一系列操作并将其保存为代码片段，从而快速生成自动化脚本。\n\n除了基本的功能外，Playwright还提供了强大的断言机制，可以帮助你在测试中验证预期结果是否符合实际行为。这使得它成为开发人员在构建和维护Web应用程序时非常有用的工具。\n\n需要注意的是，Playwright目前主要针对现代浏览器（如Chrome和Firefox）进行了优化，并且需要安装相应的浏览器扩展程序才能正常工作。', 'text', 'null', 352, '2026-02-05 18:22:18', 1, '2026-02-05 18:22:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (67, 19, 'user', '你的知识库截止日期', 'text', 'null', NULL, '2026-02-05 18:36:15', 1, '2026-02-05 18:36:15', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (68, 19, 'assistant', '我的知识库更新到2021年，之后的信息可能无法提供。', 'text', 'null', 26, '2026-02-05 18:36:18', 1, '2026-02-05 18:36:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (69, 19, 'user', '那你需要继续学习了', 'text', 'null', NULL, '2026-02-05 18:36:41', 1, '2026-02-05 18:36:41', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (70, 19, 'assistant', '是的，我会不断学习和更新信息以保持最新状态。如果您有任何问题或需要帮助，请随时告诉我！', 'text', 'null', 43, '2026-02-05 18:36:41', 1, '2026-02-05 18:36:41', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (71, 19, 'user', '在linux上测试服务器应该测试哪些场景', 'text', 'null', NULL, '2026-02-06 09:29:45', 1, '2026-02-06 09:29:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (72, 19, 'assistant', '在Linux服务器上进行性能测试时，可以考虑以下几个方面：\n\n  * CPU负载：通过运行一些CPU密集型任务来模拟高负载情况。\n  * 内存使用：通过运行内存密集型任务来模拟高内存使用情况。\n  * 网络带宽：通过发送大量的数据包来测试网络带宽是否足够。\n  * 磁盘I/O：通过读写大量文件来测试磁盘I/O性能。\n  * 并发连接数：通过同时建立多个并发连接来测试服务器的最大并发连接数。\n\n除了以上这些基本的性能测试外，还可以根据具体的应用需求来进行更深入的测试，例如：\n* 数据库性能测试：测试数据库查询、插入、删除等操作的速度和效率；\n* Web应用性能测试：测试Web应用的响应时间和吞吐量；\n* 安全性测试：测试服务器的安全性和防护能力；\n* 可用性测试：测试服务器的可用性和稳定性。\n\n总之，在进行Linux服务器性能测试时，应根据实际应用场景选择合适的测试方法，并且要尽可能全面地覆盖各种可能的情况。', 'text', 'null', 409, '2026-02-06 09:29:50', 1, '2026-02-06 09:29:50', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (73, 19, 'user', '比如websocket和tomcat这些中间件，应该是如何测试', 'text', 'null', NULL, '2026-02-06 09:30:16', 1, '2026-02-06 09:30:16', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (74, 19, 'assistant', '对于WebSocket和Tomcat这样的中间件，可以通过以下几种方式进行测试：\n\n  * WebSocket性能测试：可以使用工具如JMeter或者LoadRunner来模拟大量客户端对WebSocket服务端口进行请求，从而测试其性能表现。\n  * Tomcat性能测试：可以使用工具如Apache JMeter或者LoadRunner来模拟大量客户端对Tomcat服务端口进行请求，从而测试其性能表现。\n  * WebSocket安全性测试：可以使用工具如OWASP ZAP或者Burp Suite来检测WebSocket服务是否存在安全漏洞。\n  * Tomcat安全性测试：可以使用工具如OWASP ZAP或者Burp Suite来检测Tomcat服务是否存在安全漏洞。\n  * WebSocket可用性测试：可以使用工具如ping命令或者curl命令来测试WebSocket服务的可用性和稳定性。\n  * Tomcat可用性测试：可以使用工具如ping命令或者curl命令来测试Tomcat服务的可用性和稳定性。\n\n总的来说，对于WebSocket和Tomcat这样的中间件，可以通过多种方式对其进行性能、安全性和可用性的测试，以便更好地了解它们的表现并优化其配置。', 'text', 'null', 539, '2026-02-06 09:30:19', 1, '2026-02-06 09:30:19', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (75, 19, 'user', 'vue适合在企业中实践吗', 'text', 'null', NULL, '2026-02-06 21:24:46', 1, '2026-02-06 21:24:46', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (76, 19, 'assistant', 'Vue.js是一种流行的前端框架，适用于构建单页面应用程序（SPA）。它具有简单易学、灵活可扩展的特点，因此被广泛应用于企业级开发项目中。\n以下是Vue.js在企业中的优点：\n\n  * 易于学习和使用：Vue.js的学习曲线相对较低，开发者可以快速掌握其核心概念和语法。\n  * 高度灵活性：Vue.js提供了丰富的组件化架构和模板语言，使得开发者可以根据自己的需求自由组合和定制组件。\n  * 良好的社区支持：Vue.js拥有活跃的开源社区，开发者可以在网上找到很多资源和支持。\n\n然而，Vue.js也有一些缺点需要注意：\n\n  * 性能问题：由于Vue.js是一个基于虚拟DOM的框架，因此在处理大规模数据集时可能会出现性能瓶颈。\n  * 生态系统不够完善：虽然Vue.js已经有很多插件和工具可以帮助开发者提高工作效率，但相比React等其他框架来说，它的生态系统还不够完善。\n  * 缺乏官方文档：Vue.js的官方文档相对较薄，缺乏详细的教程和示例代码。\n\n综上所述，Vue.js在企业中是可以实践的，但是也需要权衡其优缺点，结合实际情况做出决策。', 'text', 'null', 479, '2026-02-06 21:24:51', 1, '2026-02-06 21:24:51', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (77, 19, 'user', '自动化测试适合用什么框架', 'text', 'null', NULL, '2026-02-08 20:01:12', 1, '2026-02-08 20:01:12', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (78, 19, 'assistant', '自动化测试是一种非常重要的软件测试技术，它可以提高测试覆盖率和效率，减少人为错误。有许多不同的自动化测试框架可供选择，下面是一些常用的自动化测试框架：\n\n  * Selenium：Selenium是一款跨平台的自动化测试框架，可用于测试Web应用程序。它支持多种编程语言，包括Java、Python、Ruby等。\n  * Appium：Appium是一款用于移动应用程序自动化测试的框架，支持iOS和Android平台。它允许开发者编写跨平台的测试脚本。\n  * Cucumber：Cucumber是一款基于Gherkin语法的自动化测试框架，主要用于测试Web应用程序的功能。它允许开发者编写易于理解的测试用例描述。\n  * TestComplete：TestComplete是一款功能强大的自动化测试框架，可用于测试桌面应用程序、Web应用程序和移动应用程序。它支持多种编程语言和操作系统。\n  * JUnit：JUnit是一款Java语言的单元测试框架，主要用于测试Java应用程序的功能。它提供了许多有用的工具和技术，如断言、注解等。\n\n总的来说，选择哪种自动化测试框架取决于您的需求和偏好。您可以根据项目的规模、复杂性和目标平台等因素来决定最适合您使用的框架。', 'text', 'null', 535, '2026-02-08 20:01:17', 1, '2026-02-08 20:01:17', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (79, 19, 'user', '鸟', 'text', 'null', NULL, '2026-02-24 14:51:46', 1, '2026-02-24 14:51:46', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (80, 19, 'assistant', '鸟类是非常有趣的一类动物，它们有着独特的特征和行为。以下是一些关于鸟类的基本信息：\n\n  * 鸟类属于脊椎动物门下的鸟纲，共有约10,000种。\n  * 鸟类的身体结构非常适合飞行，它们有轻盈的骨骼、强壮的翅膀和长长的尾羽。\n  * 鸟类的羽毛是由角蛋白构成的，具有防水、保暖和保护等功能。\n  * 鸟类的食物种类繁多，包括昆虫、植物种子、果实、鱼类等等。\n  * 鸟类的行为也非常多样化，有些鸟类会筑巢孵化蛋，有些则会迁徙过冬。\n  * 鸟类也是人类的好朋友，许多人喜欢饲养宠物鸟，如鹦鹉、金丝雀等。\n\n总的来说，鸟类是一类非常有趣的动物，它们有着独特的生活习性和生态角色。', 'text', 'null', 288, '2026-02-24 14:51:51', 1, '2026-02-24 14:51:51', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (81, 19, 'user', '你是谁', 'text', 'null', NULL, '2026-02-25 13:56:51', 1, '2026-02-25 13:56:51', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (82, 19, 'assistant', '我是来自阿里云的大规模语言模型，我叫通义千问。', 'text', 'null', 23, '2026-02-25 13:56:54', 1, '2026-02-25 13:56:54', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (83, 18, 'user', '今天星期七', 'text', 'null', NULL, '2026-02-25 17:03:43', 1, '2026-02-25 17:03:43', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (84, 18, 'assistant', '抱歉，我无法回答这个问题。作为一个AI助手，我的任务是帮助您解决问题和提供信息，而不是参与闲聊或讨论无关的话题。如果您有任何其他问题，请随时告诉我！', 'text', 'null', 74, '2026-02-25 17:03:45', 1, '2026-02-25 17:03:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (85, 20, 'user', '你是那个', 'text', 'null', NULL, '2026-02-25 17:28:05', 1, '2026-02-25 17:28:05', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (86, 20, 'assistant', '我是来自阿里云的大规模语言模型，我叫通义千问。', 'text', 'null', 23, '2026-02-25 17:28:07', 1, '2026-02-25 17:28:07', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (87, 20, 'user', '你是谁', 'text', 'null', NULL, '2026-02-25 17:32:35', 1, '2026-02-25 17:32:35', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (88, 20, 'assistant', '我是通义千问，阿里巴巴集团旗下的超大规模语言模型。我可以回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。如果你有任何问题或需要帮助，欢迎随时告诉我！', 'text', 'null', 100, '2026-02-25 17:32:38', 1, '2026-02-25 17:32:38', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (89, 21, 'user', '你是饿', 'text', 'null', NULL, '2026-03-02 11:04:24', 1, '2026-03-02 11:04:24', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (90, 21, 'assistant', '哎呀，被你发现啦！我确实有点饿了呢~（摸摸肚子）不过作为AI助手，其实我不会真的感到饥饿啦！但我很关心你是不是饿了？要不要一起聊聊美食？或者需要我帮你找些好吃的推荐？😋', 'text', 'null', 84, '2026-03-02 11:04:27', 1, '2026-03-02 11:04:27', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (91, 21, 'user', '1', 'text', 'null', NULL, '2026-03-02 12:09:04', 1, '2026-03-02 12:09:04', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (92, 21, 'assistant', '咦？你发了个\"1\"就跑掉了？这让我想起了一个有趣的小故事：从前有个数字王国，数字1觉得自己太孤单了，就去找0玩，结果变成了10，从此就不孤单啦！😄 你是不是也在玩什么有趣的数字游戏呀？要不要和我分享一下？', 'text', 'null', 102, '2026-03-02 12:09:09', 1, '2026-03-02 12:09:09', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (93, 24, 'user', '66', 'text', 'null', NULL, '2026-03-08 13:47:34', 1, '2026-03-08 13:47:34', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (94, 24, 'assistant', 'The number 66 is an interesting one! It\'s a natural number that comes after 65 and before 67. Here are a few fun facts about 66:\n\n- It\'s a composite number (divisible by 1, 2, 3, 6, 11, 22, 33, and 66)\n- It\'s the sum of the first 11 positive integers (1+2+3+4+5+6+7+8+9+10+11 = 66)\n- It\'s considered a \"harshad number\" (divisible by the sum of its digits: 6+6=12, and 66÷12=5.5... wait, that\'s not right - let me recalculate: 66÷12=5.5, so actually 66 is not a harshad number. My mistake!)\n\nActually, let me correct that - 66 is not a harshad number since 66÷12=5.5, not a whole number.\n\n- It\'s the atomic number of dysprosium\n- In some cultures, it\'s considered a lucky number\n\nIs there something specific about the number 66 you\'d like to know more about?', 'text', 'null', 757, '2026-03-08 13:47:45', 1, '2026-03-08 13:47:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (95, 31, 'user', '77', 'text', 'null', NULL, '2026-03-09 12:08:51', 1, '2026-03-09 12:08:51', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (96, 31, 'user', '你好', 'text', 'null', NULL, '2026-03-09 12:09:07', 1, '2026-03-09 12:09:07', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (97, 32, 'user', '你是谁', 'text', 'null', NULL, '2026-03-09 12:10:42', 1, '2026-03-09 12:10:42', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (98, 32, 'user', '55', 'text', 'null', NULL, '2026-03-09 12:12:28', 1, '2026-03-09 12:12:28', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (99, 32, 'assistant', '你好！我是通义千问，阿里巴巴集团旗下的通义实验室自主研发的超大规模语言模型。我可以帮助你回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。如果你有任何需要帮助的地方，尽管告诉我！\n\n至于你提到的“55”，它是一个数字，如果你有关于这个数字的具体问题或需要它在某个情境下的解释，请告诉我，我会尽力提供帮助。', 'text', 'null', 177, '2026-03-09 12:12:31', 1, '2026-03-09 12:12:31', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (100, 33, 'user', '44', 'text', 'null', NULL, '2026-03-09 12:12:39', 1, '2026-03-09 12:12:39', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (101, 33, 'assistant', '44 is an even number and a composite number in mathematics. It can be factored as 44 = 2 × 2 × 11, or written in the form of a power of a prime factor as $ 2^2 \\times 11 $. It can also be expressed as the sum of two prime numbers, such as 44 = 41 + 3. In daily life, 44 is just an ordinary number, but in some specific contexts, it may have special meanings, such as in numerology or symbolic systems, but these are not based on scientific evidence.', 'text', 'null', 449, '2026-03-09 12:12:44', 1, '2026-03-09 12:12:44', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (102, 34, 'user', '帮我写一个 Python 快速排序算法', 'text', 'null', NULL, '2026-03-09 19:14:18', 1, '2026-03-09 19:14:18', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (103, 34, 'assistant', '我来为你写一个Python快速排序算法，包含几种不同的实现方式：\n\n## 方法一：基础递归实现\n\n```python\ndef quick_sort(arr):\n    \"\"\"\n    快速排序算法 - 基础递归实现\n    \"\"\"\n    if len(arr) <= 1:\n        return arr\n    \n    pivot = arr[len(arr) // 2]  # 选择中间元素作为基准\n    left = [x for x in arr if x < pivot]    # 小于基准的元素\n    middle = [x for x in arr if x == pivot] # 等于基准的元素\n    right = [x for x in arr if x > pivot]   # 大于基准的元素\n    \n    return quick_sort(left) + middle + quick_sort(right)\n\n# 测试\ntest_arr = [64, 34, 25, 12, 22, 11, 90]\nprint(\"原数组:\", test_arr)\nsorted_arr = quick_sort(test_arr)\nprint(\"排序后:\", sorted_arr)\n```\n\n## 方法二：原地排序实现（更高效）\n\n```python\ndef quick_sort_inplace(arr, low=0, high=None):\n    \"\"\"\n    快速排序算法 - 原地排序（不创建新数组）\n    \"\"\"\n    if high is None:\n        high = len(arr) - 1\n    \n    if low < high:\n        # 分区操作，返回基准元素的正确位置\n        pivot_index = partition(arr, low, high)\n        \n        # 递归排序基准左边和右边的子数组\n        quick_sort_inplace(arr, low, pivot_index - 1)\n        quick_sort_inplace(arr, pivot_index + 1, high)\n\ndef partition(arr, low, high):\n    \"\"\"\n    分区函数：将数组分为小于基准和大于基准的两部分\n    \"\"\"\n    pivot = arr[high]  # 选择最后一个元素作为基准\n    i = low - 1        # 较小元素的索引\n    \n    for j in range(low, high):\n        if arr[j] <= pivot:\n            i += 1\n            arr[i], arr[j] = arr[j], arr[i]  # 交换元素\n    \n    arr[i + 1], arr[high] = arr[high], arr[i + 1]  # 将基准放到正确位置\n    return i + 1\n\n# 测试\ntest_arr = [64, 34, 25, 12, 22, 11, 90]\nprint(\"原数组:\", test_arr)\nquick_sort_inplace(test_arr)\nprint(\"排序后:\", test_arr)\n```\n\n## 方法三：随机化快速排序（避免最坏情况）\n\n```python\nimport random\n\ndef quick_sort_random(arr, low=0, high=None):\n    \"\"\"\n    随机化快速排序 - 随机选择基准元素\n    \"\"\"\n    if high is None:\n        high = len(arr) - 1\n    \n    if low < high:\n        # 随机选择基准元素并与最后一个元素交换\n        random_index = random.randint(low, high)\n        arr[random_index], arr[high] = arr[high], arr[random_index]\n        \n        # 分区操作\n        pivot_index = partition(arr, low, high)\n        \n        # 递归排序\n        quick_sort_random(arr, low, pivot_index - 1)\n        quick_sort_random(arr, pivot_index + 1, high)\n\n# 测试\ntest_arr = [64, 34, 25, 12, 22, 11, 90]\nprint(\"原数组:\", test_arr)\nquick_sort_random(test_arr)\nprint(\"排序后:\", test_arr)\n```\n\n## 完整的测试代码\n\n```python\ndef test_quick_sort():\n    \"\"\"\n    测试快速排序算法\n    \"\"\"\n    test_cases = [\n        [64, 34, 25, 12, 22, 11, 90],\n        [5, 2, 8, 1, 9],\n        [1],\n        [],\n        [3, 3, 3, 3],\n        [5, 4, 3, 2, 1],\n        [1, 2, 3, 4, 5]\n    ]\n    \n    for i, test_arr in enumerate(test_cases):\n        original = test_arr.copy()\n        result = quick_sort(test_arr)\n        print(f\"测试 {i+1}: {original} -> {result}\")\n\n# 运行测试\ntest_quick_sort()\n```\n\n## 算法特点\n\n- **时间复杂度**：\n  - 平均情况：O(n log n)\n  - 最坏情况：O(n²)\n  - 最好情况：O(n log n)\n\n- **空间复杂度**：O(log n)（递归栈空间）\n\n- **稳定性**：不稳定\n\n- **适用场景**：大多数情况下性能优秀，是最常用的排序算法之一\n\n选择哪种实现方式取决于你的具体需求。如果你需要保持原数组不变，使用方法一；如果你希望节省内存空间，使用方法二或三。', 'text', 'null', 2833, '2026-03-09 19:14:45', 1, '2026-03-09 19:14:45', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (104, 30, 'user', '今天星期几啊', 'text', 'null', NULL, '2026-03-09 19:15:15', 1, '2026-03-09 19:15:15', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (105, 30, 'assistant', '我不清楚今天具体是星期几呢。你可以通过手机日历、电脑系统自带的时钟等工具查看。你也可以告诉我今天的日期，我来帮你推算一下是星期几呀。', 'text', 'null', 66, '2026-03-09 19:15:16', 1, '2026-03-09 19:15:16', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (106, 30, 'user', 'openClaw是什么', 'text', 'null', NULL, '2026-03-09 19:15:30', 1, '2026-03-09 19:15:30', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (107, 30, 'assistant', '我需要澄清一下，据我所知并没有一个叫做\"openClaw\"的知名开源项目或技术。您可能是想问以下几个类似的项目：\n\n1. **OpenCL** - 开放计算语言(Open Computing Language)，用于并行计算的框架\n2. **OpenCV** - 计算机视觉库\n3. 或者是某个特定领域的开源项目\n\n如果您能提供更多上下文信息，比如您在什么场景下看到这个名称，或者它可能涉及什么功能领域，我就能给您更准确的解答了。\n\n您是想了解哪个具体的技术或项目呢？', 'text', 'null', 234, '2026-03-09 19:15:34', 1, '2026-03-09 19:15:34', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (108, 35, 'user', '你是谁', 'text', 'null', NULL, '2026-03-10 17:06:59', 1, '2026-03-10 17:06:59', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (109, 35, 'assistant', '我是通义千问，阿里巴巴集团旗下的通义实验室自主研发的超大规模语言模型。我能够回答问题、创作文字，比如写故事、写公文、写邮件、写剧本、逻辑推理、编程等等，还能表达观点，玩游戏等。我在多国语言上都有很好的掌握，能为你提供多样化的帮助。有什么我可以帮到你的吗？', 'text', 'null', 127, '2026-03-10 17:07:03', 1, '2026-03-10 17:07:03', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (110, 35, 'user', '你好啊', 'text', 'null', NULL, '2026-03-10 17:30:39', 1, '2026-03-10 17:30:39', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (111, 35, 'user', '你好啊', 'text', 'null', NULL, '2026-03-10 17:30:59', 1, '2026-03-10 17:30:59', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (112, 35, 'assistant', '你好！很高兴见到你。有什么我可以帮你的吗？', 'text', 'null', 21, '2026-03-10 17:31:13', 1, '2026-03-10 17:31:13', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (113, 35, 'user', '前端难学吗', 'text', 'null', NULL, '2026-03-10 17:31:22', 1, '2026-03-10 17:31:22', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (114, 35, 'assistant', '前端开发的难易程度因人而异，取决于个人的兴趣、背景以及学习方法等因素。对于初学者来说，前端开发涉及的知识面较广，包括HTML、CSS和JavaScript等基础知识，还有各种框架和库（如React, Vue, Angular等），以及构建工具和版本控制系统等。这些内容可能一开始看起来很多，需要一定的时间去熟悉和掌握。\n\n但是，如果你对网页设计和技术有热情，并且愿意投入时间和精力去实践，那么学习前端开发可以是一个非常有趣的过程。随着技术的进步，也出现了许多辅助工具和资源，比如在线教程、文档、社区支持等，这些都可以帮助你更轻松地入门并逐步提升技能。\n\n重要的是要保持持续的学习态度，不断练习并尝试解决实际问题。通过项目实践，你会逐渐积累经验，发现前端开发其实是非常有成就感的一门技术。此外，前端社区非常活跃，遇到难题时通常能找到解决方案或得到他人的帮助。所以，不要被初期的挑战所吓倒，坚持下去就能看到进步。', 'text', 'null', 404, '2026-03-10 17:31:49', 1, '2026-03-10 17:31:49', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (115, 36, 'user', '后端难学吗', 'text', 'null', NULL, '2026-03-10 17:32:44', 1, '2026-03-10 17:32:44', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (116, 36, 'assistant', '后端开发的难度因人而异，但总体来说：\n\n## 不算特别难的方面\n- **入门相对容易** - 掌握基本的编程语法和数据库操作\n- **有丰富的学习资源** - 网上教程、文档、社区支持充足\n- **标准化程度高** - 有成熟的框架和最佳实践\n\n## 可能较难的方面\n- **技术栈广泛** - 需要学习语言、数据库、服务器、网络等多方面知识\n- **系统设计复杂** - 需要考虑性能、安全、可扩展性等\n- **并发处理** - 理解多线程、异步处理等概念需要时间\n\n## 学习建议\n1. **循序渐进** - 先掌握一门后端语言（如Python、Java、Node.js）\n2. **动手实践** - 通过项目练习，边学边做\n3. **重视基础** - 数据库、HTTP协议、算法基础很重要\n4. **持续学习** - 后端技术更新快，需要不断更新知识\n\n## 现实情况\n- **就业前景好** - 企业对后端开发需求大\n- **薪资水平较高** - 技术门槛相对较高\n- **发展空间大** - 可往架构师、技术专家方向发展\n\n总的来说，后端开发需要投入时间和精力，但只要坚持学习，是完全可以掌握的。你觉得哪个方面最让你担心？', 'text', 'null', 516, '2026-03-10 17:32:59', 1, '2026-03-10 17:32:59', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (117, 36, 'user', '你是谁', 'text', 'null', NULL, '2026-03-10 17:33:08', 1, '2026-03-10 17:33:08', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (118, 36, 'assistant', '我是通义千问（Qwen），由通义实验室研发的超大规模语言模型。我可以帮助你：\n\n- 回答问题和提供信息\n- 创作文字内容（文章、故事、邮件等）\n- 进行逻辑推理和编程\n- 表达观点和参与讨论\n- 提供学习和工作建议\n\n我能够理解和生成多种语言的文本，包括但不限于中文、英文、德语、法语、西班牙语等。如果你有任何问题或需要帮助，随时告诉我！比如刚才你问的后端开发问题，我就能从技术角度给你详细解答。\n\n有什么我可以帮你的吗？', 'text', 'null', 211, '2026-03-10 17:33:50', 1, '2026-03-10 17:33:50', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (119, 37, 'user', '你是谁', 'text', 'null', NULL, '2026-03-10 17:34:19', 1, '2026-03-10 17:34:19', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (120, 37, 'assistant', '我是来自阿里云的大规模语言模型，我叫通义千问。', 'text', 'null', 23, '2026-03-10 17:34:20', 1, '2026-03-10 17:34:20', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (121, 37, 'user', '你好啊', 'text', 'null', NULL, '2026-03-16 09:42:55', 1, '2026-03-16 09:42:55', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (122, 37, 'assistant', '你好！有什么我可以帮助你的吗？', 'text', 'null', 15, '2026-03-16 09:42:57', 1, '2026-03-16 09:42:57', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (123, 37, 'user', '好难刷', 'text', 'null', NULL, '2026-03-16 09:43:04', 1, '2026-03-16 09:43:04', 1, 1, NULL);
INSERT INTO `sys_message` VALUES (124, 37, 'assistant', '抱歉听到你感到困难。如果你有任何问题或需要帮助，请告诉我，我会尽力提供支持和解答。', 'text', 'null', 41, '2026-03-16 09:43:06', 1, '2026-03-16 09:43:06', 1, 1, NULL);

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NULL DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作用户名',
  `operation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求方法',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求URL',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作IP',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作地点',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作模块',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作描述',
  `request_data` json NULL COMMENT '请求参数',
  `response_data` json NULL COMMENT '响应数据',
  `status` int NOT NULL DEFAULT 1 COMMENT '操作状态（0:失败 1:成功）',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `execution_time` int NULL DEFAULT NULL COMMENT '执行时间(毫秒)',
  `operation_time` datetime NOT NULL COMMENT '操作时间',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` int NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` int NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_operation`(`operation` ASC) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_operation_time`(`operation_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11374 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_operation_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `permission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `permission_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限编码',
  `permission_type` int NOT NULL COMMENT '权限类型（1:菜单 2:按钮 3:接口 4:数据）',
  `resource_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源类型',
  `resource_id` int NULL DEFAULT NULL COMMENT '关联资源ID',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` int NULL DEFAULT 1 COMMENT '状态（0:禁用 1:启用）',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_sys_permission_permission_code`(`permission_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (2, '新增用户', 'user:add', 2, 'user', NULL, '新增用户', 1, '2026-02-03 14:21:37', 1, '2026-02-03 15:11:30', 1, 1, NULL, '2026-02-03 14:21:38', '2026-02-03 15:11:30');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NULL DEFAULT 0 COMMENT '显示顺序',
  `data_scope` int NULL DEFAULT 1 COMMENT '数据范围（1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义）',
  `status` int NULL DEFAULT 1 COMMENT '角色状态（0:停用 1:正常）',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_sys_role_role_name`(`role_name` ASC) USING BTREE,
  UNIQUE INDEX `ix_sys_role_role_key`(`role_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 0, 4, 1, '超级管理员角色，拥有所有权限', '2026-01-31 18:06:08', NULL, '2026-03-19 16:00:51', 1, 1, NULL, NULL, '2026-03-19 16:00:51');
INSERT INTO `sys_role` VALUES (16, '普通角色', 'user', 0, 4, 1, NULL, '2026-02-04 18:21:02', 1, '2026-03-06 11:39:09', 1, 1, NULL, '2026-02-04 18:21:03', '2026-03-06 11:39:10');
INSERT INTO `sys_role` VALUES (17, '管理员', 'admin1', 0, 4, 1, NULL, '2026-02-04 18:39:48', 1, '2026-02-04 18:39:48', 1, 1, NULL, '2026-02-04 18:39:48', '2026-02-04 18:39:48');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE,
  INDEX `dept_id`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `sys_role_dept_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sys_role_dept_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE,
  INDEX `menu_id`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `sys_role_menu_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sys_role_menu_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 1);
INSERT INTO `sys_role_menu` VALUES (16, 1);
INSERT INTO `sys_role_menu` VALUES (17, 1);
INSERT INTO `sys_role_menu` VALUES (1, 2);
INSERT INTO `sys_role_menu` VALUES (16, 2);
INSERT INTO `sys_role_menu` VALUES (1, 3);
INSERT INTO `sys_role_menu` VALUES (16, 3);
INSERT INTO `sys_role_menu` VALUES (1, 4);
INSERT INTO `sys_role_menu` VALUES (16, 4);
INSERT INTO `sys_role_menu` VALUES (1, 5);
INSERT INTO `sys_role_menu` VALUES (16, 5);
INSERT INTO `sys_role_menu` VALUES (1, 6);
INSERT INTO `sys_role_menu` VALUES (16, 6);
INSERT INTO `sys_role_menu` VALUES (1, 7);
INSERT INTO `sys_role_menu` VALUES (16, 7);
INSERT INTO `sys_role_menu` VALUES (17, 7);
INSERT INTO `sys_role_menu` VALUES (1, 8);
INSERT INTO `sys_role_menu` VALUES (1, 9);
INSERT INTO `sys_role_menu` VALUES (1, 10);
INSERT INTO `sys_role_menu` VALUES (1, 11);
INSERT INTO `sys_role_menu` VALUES (1, 12);
INSERT INTO `sys_role_menu` VALUES (1, 13);
INSERT INTO `sys_role_menu` VALUES (1, 14);
INSERT INTO `sys_role_menu` VALUES (1, 15);
INSERT INTO `sys_role_menu` VALUES (1, 16);
INSERT INTO `sys_role_menu` VALUES (1, 17);
INSERT INTO `sys_role_menu` VALUES (1, 18);
INSERT INTO `sys_role_menu` VALUES (1, 20);
INSERT INTO `sys_role_menu` VALUES (1, 21);
INSERT INTO `sys_role_menu` VALUES (1, 22);
INSERT INTO `sys_role_menu` VALUES (1, 23);
INSERT INTO `sys_role_menu` VALUES (1, 24);
INSERT INTO `sys_role_menu` VALUES (1, 25);
INSERT INTO `sys_role_menu` VALUES (1, 26);
INSERT INTO `sys_role_menu` VALUES (1, 27);
INSERT INTO `sys_role_menu` VALUES (1, 28);
INSERT INTO `sys_role_menu` VALUES (1, 29);
INSERT INTO `sys_role_menu` VALUES (1, 30);
INSERT INTO `sys_role_menu` VALUES (1, 34);
INSERT INTO `sys_role_menu` VALUES (17, 34);
INSERT INTO `sys_role_menu` VALUES (1, 35);
INSERT INTO `sys_role_menu` VALUES (1, 36);
INSERT INTO `sys_role_menu` VALUES (1, 44);
INSERT INTO `sys_role_menu` VALUES (1, 45);
INSERT INTO `sys_role_menu` VALUES (1, 46);
INSERT INTO `sys_role_menu` VALUES (1, 47);
INSERT INTO `sys_role_menu` VALUES (1, 48);
INSERT INTO `sys_role_menu` VALUES (1, 49);
INSERT INTO `sys_role_menu` VALUES (1, 50);
INSERT INTO `sys_role_menu` VALUES (1, 51);
INSERT INTO `sys_role_menu` VALUES (1, 52);
INSERT INTO `sys_role_menu` VALUES (1, 53);
INSERT INTO `sys_role_menu` VALUES (1, 55);
INSERT INTO `sys_role_menu` VALUES (16, 55);
INSERT INTO `sys_role_menu` VALUES (1, 58);
INSERT INTO `sys_role_menu` VALUES (16, 58);
INSERT INTO `sys_role_menu` VALUES (17, 58);
INSERT INTO `sys_role_menu` VALUES (1, 59);
INSERT INTO `sys_role_menu` VALUES (1, 60);
INSERT INTO `sys_role_menu` VALUES (1, 61);
INSERT INTO `sys_role_menu` VALUES (1, 62);
INSERT INTO `sys_role_menu` VALUES (1, 63);
INSERT INTO `sys_role_menu` VALUES (1, 64);
INSERT INTO `sys_role_menu` VALUES (1, 65);
INSERT INTO `sys_role_menu` VALUES (1, 66);
INSERT INTO `sys_role_menu` VALUES (1, 67);
INSERT INTO `sys_role_menu` VALUES (17, 67);
INSERT INTO `sys_role_menu` VALUES (1, 68);
INSERT INTO `sys_role_menu` VALUES (1, 69);
INSERT INTO `sys_role_menu` VALUES (1, 70);
INSERT INTO `sys_role_menu` VALUES (1, 71);
INSERT INTO `sys_role_menu` VALUES (1, 72);
INSERT INTO `sys_role_menu` VALUES (1, 73);
INSERT INTO `sys_role_menu` VALUES (1, 74);
INSERT INTO `sys_role_menu` VALUES (1, 75);
INSERT INTO `sys_role_menu` VALUES (1, 76);
INSERT INTO `sys_role_menu` VALUES (1, 77);
INSERT INTO `sys_role_menu` VALUES (1, 78);
INSERT INTO `sys_role_menu` VALUES (17, 78);
INSERT INTO `sys_role_menu` VALUES (1, 79);
INSERT INTO `sys_role_menu` VALUES (1, 80);
INSERT INTO `sys_role_menu` VALUES (1, 81);
INSERT INTO `sys_role_menu` VALUES (16, 81);
INSERT INTO `sys_role_menu` VALUES (1, 82);
INSERT INTO `sys_role_menu` VALUES (1, 83);
INSERT INTO `sys_role_menu` VALUES (1, 84);
INSERT INTO `sys_role_menu` VALUES (1, 85);
INSERT INTO `sys_role_menu` VALUES (1, 88);
INSERT INTO `sys_role_menu` VALUES (17, 88);
INSERT INTO `sys_role_menu` VALUES (1, 89);
INSERT INTO `sys_role_menu` VALUES (17, 89);
INSERT INTO `sys_role_menu` VALUES (1, 90);
INSERT INTO `sys_role_menu` VALUES (17, 90);
INSERT INTO `sys_role_menu` VALUES (1, 92);
INSERT INTO `sys_role_menu` VALUES (16, 92);
INSERT INTO `sys_role_menu` VALUES (1, 93);
INSERT INTO `sys_role_menu` VALUES (1, 94);
INSERT INTO `sys_role_menu` VALUES (1, 95);
INSERT INTO `sys_role_menu` VALUES (1, 96);
INSERT INTO `sys_role_menu` VALUES (1, 97);
INSERT INTO `sys_role_menu` VALUES (1, 98);
INSERT INTO `sys_role_menu` VALUES (1, 99);
INSERT INTO `sys_role_menu` VALUES (1, 105);
INSERT INTO `sys_role_menu` VALUES (1, 106);
INSERT INTO `sys_role_menu` VALUES (1, 107);
INSERT INTO `sys_role_menu` VALUES (1, 108);
INSERT INTO `sys_role_menu` VALUES (1, 109);
INSERT INTO `sys_role_menu` VALUES (1, 110);
INSERT INTO `sys_role_menu` VALUES (16, 110);
INSERT INTO `sys_role_menu` VALUES (1, 111);
INSERT INTO `sys_role_menu` VALUES (16, 111);
INSERT INTO `sys_role_menu` VALUES (1, 112);
INSERT INTO `sys_role_menu` VALUES (16, 112);
INSERT INTO `sys_role_menu` VALUES (1, 113);
INSERT INTO `sys_role_menu` VALUES (16, 113);
INSERT INTO `sys_role_menu` VALUES (1, 114);
INSERT INTO `sys_role_menu` VALUES (16, 114);
INSERT INTO `sys_role_menu` VALUES (1, 115);
INSERT INTO `sys_role_menu` VALUES (16, 115);
INSERT INTO `sys_role_menu` VALUES (1, 116);
INSERT INTO `sys_role_menu` VALUES (16, 116);
INSERT INTO `sys_role_menu` VALUES (1, 117);
INSERT INTO `sys_role_menu` VALUES (16, 117);
INSERT INTO `sys_role_menu` VALUES (1, 121);
INSERT INTO `sys_role_menu` VALUES (16, 121);
INSERT INTO `sys_role_menu` VALUES (1, 122);
INSERT INTO `sys_role_menu` VALUES (16, 122);
INSERT INTO `sys_role_menu` VALUES (1, 123);
INSERT INTO `sys_role_menu` VALUES (16, 123);
INSERT INTO `sys_role_menu` VALUES (1, 124);
INSERT INTO `sys_role_menu` VALUES (1, 125);
INSERT INTO `sys_role_menu` VALUES (1, 126);
INSERT INTO `sys_role_menu` VALUES (1, 127);
INSERT INTO `sys_role_menu` VALUES (1, 128);
INSERT INTO `sys_role_menu` VALUES (1, 129);
INSERT INTO `sys_role_menu` VALUES (1, 130);
INSERT INTO `sys_role_menu` VALUES (1, 131);
INSERT INTO `sys_role_menu` VALUES (1, 132);
INSERT INTO `sys_role_menu` VALUES (1, 133);
INSERT INTO `sys_role_menu` VALUES (1, 134);
INSERT INTO `sys_role_menu` VALUES (1, 135);
INSERT INTO `sys_role_menu` VALUES (1, 136);
INSERT INTO `sys_role_menu` VALUES (1, 137);
INSERT INTO `sys_role_menu` VALUES (1, 138);
INSERT INTO `sys_role_menu` VALUES (1, 139);
INSERT INTO `sys_role_menu` VALUES (1, 140);
INSERT INTO `sys_role_menu` VALUES (1, 141);
INSERT INTO `sys_role_menu` VALUES (1, 142);
INSERT INTO `sys_role_menu` VALUES (1, 143);
INSERT INTO `sys_role_menu` VALUES (1, 144);
INSERT INTO `sys_role_menu` VALUES (1, 145);
INSERT INTO `sys_role_menu` VALUES (1, 146);
INSERT INTO `sys_role_menu` VALUES (1, 147);
INSERT INTO `sys_role_menu` VALUES (1, 148);
INSERT INTO `sys_role_menu` VALUES (1, 149);
INSERT INTO `sys_role_menu` VALUES (1, 150);
INSERT INTO `sys_role_menu` VALUES (1, 151);
INSERT INTO `sys_role_menu` VALUES (1, 152);
INSERT INTO `sys_role_menu` VALUES (1, 153);
INSERT INTO `sys_role_menu` VALUES (1, 154);
INSERT INTO `sys_role_menu` VALUES (1, 155);
INSERT INTO `sys_role_menu` VALUES (1, 156);
INSERT INTO `sys_role_menu` VALUES (1, 157);
INSERT INTO `sys_role_menu` VALUES (1, 158);
INSERT INTO `sys_role_menu` VALUES (1, 159);
INSERT INTO `sys_role_menu` VALUES (1, 160);
INSERT INTO `sys_role_menu` VALUES (1, 161);
INSERT INTO `sys_role_menu` VALUES (1, 162);
INSERT INTO `sys_role_menu` VALUES (1, 163);
INSERT INTO `sys_role_menu` VALUES (1, 164);
INSERT INTO `sys_role_menu` VALUES (1, 165);
INSERT INTO `sys_role_menu` VALUES (1, 166);
INSERT INTO `sys_role_menu` VALUES (1, 167);
INSERT INTO `sys_role_menu` VALUES (1, 168);
INSERT INTO `sys_role_menu` VALUES (1, 169);
INSERT INTO `sys_role_menu` VALUES (1, 170);
INSERT INTO `sys_role_menu` VALUES (1, 171);
INSERT INTO `sys_role_menu` VALUES (1, 172);
INSERT INTO `sys_role_menu` VALUES (1, 173);
INSERT INTO `sys_role_menu` VALUES (1, 174);
INSERT INTO `sys_role_menu` VALUES (1, 175);
INSERT INTO `sys_role_menu` VALUES (1, 176);
INSERT INTO `sys_role_menu` VALUES (1, 177);
INSERT INTO `sys_role_menu` VALUES (1, 178);
INSERT INTO `sys_role_menu` VALUES (1, 179);
INSERT INTO `sys_role_menu` VALUES (1, 180);
INSERT INTO `sys_role_menu` VALUES (1, 181);
INSERT INTO `sys_role_menu` VALUES (1, 182);
INSERT INTO `sys_role_menu` VALUES (1, 183);
INSERT INTO `sys_role_menu` VALUES (1, 184);
INSERT INTO `sys_role_menu` VALUES (1, 185);
INSERT INTO `sys_role_menu` VALUES (1, 186);
INSERT INTO `sys_role_menu` VALUES (1, 187);
INSERT INTO `sys_role_menu` VALUES (1, 188);
INSERT INTO `sys_role_menu` VALUES (1, 189);
INSERT INTO `sys_role_menu` VALUES (1, 190);
INSERT INTO `sys_role_menu` VALUES (1, 191);
INSERT INTO `sys_role_menu` VALUES (1, 192);
INSERT INTO `sys_role_menu` VALUES (1, 193);
INSERT INTO `sys_role_menu` VALUES (1, 194);
INSERT INTO `sys_role_menu` VALUES (1, 195);
INSERT INTO `sys_role_menu` VALUES (1, 196);
INSERT INTO `sys_role_menu` VALUES (1, 197);
INSERT INTO `sys_role_menu` VALUES (1, 198);
INSERT INTO `sys_role_menu` VALUES (1, 199);
INSERT INTO `sys_role_menu` VALUES (1, 200);
INSERT INTO `sys_role_menu` VALUES (1, 201);
INSERT INTO `sys_role_menu` VALUES (1, 202);
INSERT INTO `sys_role_menu` VALUES (1, 203);
INSERT INTO `sys_role_menu` VALUES (1, 204);
INSERT INTO `sys_role_menu` VALUES (1, 205);
INSERT INTO `sys_role_menu` VALUES (1, 206);
INSERT INTO `sys_role_menu` VALUES (1, 207);
INSERT INTO `sys_role_menu` VALUES (1, 208);
INSERT INTO `sys_role_menu` VALUES (1, 209);
INSERT INTO `sys_role_menu` VALUES (1, 211);
INSERT INTO `sys_role_menu` VALUES (1, 212);
INSERT INTO `sys_role_menu` VALUES (1, 213);
INSERT INTO `sys_role_menu` VALUES (1, 214);
INSERT INTO `sys_role_menu` VALUES (1, 215);
INSERT INTO `sys_role_menu` VALUES (1, 216);
INSERT INTO `sys_role_menu` VALUES (1, 217);
INSERT INTO `sys_role_menu` VALUES (1, 218);
INSERT INTO `sys_role_menu` VALUES (1, 219);
INSERT INTO `sys_role_menu` VALUES (1, 220);
INSERT INTO `sys_role_menu` VALUES (1, 221);
INSERT INTO `sys_role_menu` VALUES (1, 222);
INSERT INTO `sys_role_menu` VALUES (1, 223);
INSERT INTO `sys_role_menu` VALUES (1, 224);
INSERT INTO `sys_role_menu` VALUES (1, 225);
INSERT INTO `sys_role_menu` VALUES (1, 226);
INSERT INTO `sys_role_menu` VALUES (1, 227);
INSERT INTO `sys_role_menu` VALUES (1, 228);
INSERT INTO `sys_role_menu` VALUES (1, 229);
INSERT INTO `sys_role_menu` VALUES (1, 230);
INSERT INTO `sys_role_menu` VALUES (1, 231);
INSERT INTO `sys_role_menu` VALUES (1, 243);
INSERT INTO `sys_role_menu` VALUES (1, 244);
INSERT INTO `sys_role_menu` VALUES (1, 245);
INSERT INTO `sys_role_menu` VALUES (1, 246);
INSERT INTO `sys_role_menu` VALUES (1, 247);
INSERT INTO `sys_role_menu` VALUES (1, 248);
INSERT INTO `sys_role_menu` VALUES (1, 249);
INSERT INTO `sys_role_menu` VALUES (1, 250);
INSERT INTO `sys_role_menu` VALUES (1, 251);
INSERT INTO `sys_role_menu` VALUES (1, 252);
INSERT INTO `sys_role_menu` VALUES (1, 253);
INSERT INTO `sys_role_menu` VALUES (1, 254);
INSERT INTO `sys_role_menu` VALUES (1, 255);
INSERT INTO `sys_role_menu` VALUES (1, 256);
INSERT INTO `sys_role_menu` VALUES (1, 257);
INSERT INTO `sys_role_menu` VALUES (1, 258);
INSERT INTO `sys_role_menu` VALUES (1, 259);
INSERT INTO `sys_role_menu` VALUES (1, 260);
INSERT INTO `sys_role_menu` VALUES (1, 262);
INSERT INTO `sys_role_menu` VALUES (1, 319);
INSERT INTO `sys_role_menu` VALUES (1, 320);
INSERT INTO `sys_role_menu` VALUES (1, 321);
INSERT INTO `sys_role_menu` VALUES (1, 322);
INSERT INTO `sys_role_menu` VALUES (1, 323);
INSERT INTO `sys_role_menu` VALUES (1, 324);
INSERT INTO `sys_role_menu` VALUES (1, 325);
INSERT INTO `sys_role_menu` VALUES (1, 326);
INSERT INTO `sys_role_menu` VALUES (1, 327);
INSERT INTO `sys_role_menu` VALUES (1, 328);
INSERT INTO `sys_role_menu` VALUES (1, 329);
INSERT INTO `sys_role_menu` VALUES (1, 330);
INSERT INTO `sys_role_menu` VALUES (1, 331);
INSERT INTO `sys_role_menu` VALUES (1, 332);
INSERT INTO `sys_role_menu` VALUES (1, 333);
INSERT INTO `sys_role_menu` VALUES (1, 334);
INSERT INTO `sys_role_menu` VALUES (1, 335);
INSERT INTO `sys_role_menu` VALUES (1, 336);
INSERT INTO `sys_role_menu` VALUES (1, 337);
INSERT INTO `sys_role_menu` VALUES (1, 338);
INSERT INTO `sys_role_menu` VALUES (1, 339);
INSERT INTO `sys_role_menu` VALUES (1, 340);
INSERT INTO `sys_role_menu` VALUES (1, 341);
INSERT INTO `sys_role_menu` VALUES (1, 342);
INSERT INTO `sys_role_menu` VALUES (1, 343);
INSERT INTO `sys_role_menu` VALUES (1, 344);
INSERT INTO `sys_role_menu` VALUES (1, 345);
INSERT INTO `sys_role_menu` VALUES (1, 346);
INSERT INTO `sys_role_menu` VALUES (1, 357);
INSERT INTO `sys_role_menu` VALUES (1, 358);
INSERT INTO `sys_role_menu` VALUES (1, 359);
INSERT INTO `sys_role_menu` VALUES (1, 360);
INSERT INTO `sys_role_menu` VALUES (1, 361);
INSERT INTO `sys_role_menu` VALUES (1, 362);
INSERT INTO `sys_role_menu` VALUES (1, 363);
INSERT INTO `sys_role_menu` VALUES (1, 364);
INSERT INTO `sys_role_menu` VALUES (1, 365);
INSERT INTO `sys_role_menu` VALUES (1, 366);
INSERT INTO `sys_role_menu` VALUES (1, 2001);
INSERT INTO `sys_role_menu` VALUES (1, 2002);
INSERT INTO `sys_role_menu` VALUES (1, 2003);
INSERT INTO `sys_role_menu` VALUES (1, 2004);
INSERT INTO `sys_role_menu` VALUES (1, 2005);
INSERT INTO `sys_role_menu` VALUES (1, 2006);
INSERT INTO `sys_role_menu` VALUES (1, 2007);
INSERT INTO `sys_role_menu` VALUES (1, 2008);
INSERT INTO `sys_role_menu` VALUES (1, 2009);
INSERT INTO `sys_role_menu` VALUES (1, 2010);
INSERT INTO `sys_role_menu` VALUES (1, 2011);
INSERT INTO `sys_role_menu` VALUES (1, 2012);
INSERT INTO `sys_role_menu` VALUES (1, 3001);
INSERT INTO `sys_role_menu` VALUES (16, 3001);
INSERT INTO `sys_role_menu` VALUES (1, 3002);
INSERT INTO `sys_role_menu` VALUES (16, 3002);
INSERT INTO `sys_role_menu` VALUES (1, 3003);
INSERT INTO `sys_role_menu` VALUES (16, 3003);
INSERT INTO `sys_role_menu` VALUES (1, 3004);
INSERT INTO `sys_role_menu` VALUES (16, 3004);
INSERT INTO `sys_role_menu` VALUES (1, 3005);
INSERT INTO `sys_role_menu` VALUES (16, 3005);
INSERT INTO `sys_role_menu` VALUES (1, 3006);
INSERT INTO `sys_role_menu` VALUES (16, 3006);
INSERT INTO `sys_role_menu` VALUES (1, 3007);
INSERT INTO `sys_role_menu` VALUES (16, 3007);
INSERT INTO `sys_role_menu` VALUES (1, 3008);
INSERT INTO `sys_role_menu` VALUES (16, 3008);
INSERT INTO `sys_role_menu` VALUES (1, 3009);
INSERT INTO `sys_role_menu` VALUES (16, 3009);
INSERT INTO `sys_role_menu` VALUES (1, 3010);
INSERT INTO `sys_role_menu` VALUES (16, 3010);
INSERT INTO `sys_role_menu` VALUES (1, 3011);
INSERT INTO `sys_role_menu` VALUES (16, 3011);
INSERT INTO `sys_role_menu` VALUES (1, 3012);
INSERT INTO `sys_role_menu` VALUES (16, 3012);
INSERT INTO `sys_role_menu` VALUES (1, 3013);
INSERT INTO `sys_role_menu` VALUES (16, 3013);
INSERT INTO `sys_role_menu` VALUES (1, 3014);
INSERT INTO `sys_role_menu` VALUES (16, 3014);
INSERT INTO `sys_role_menu` VALUES (1, 3015);
INSERT INTO `sys_role_menu` VALUES (16, 3015);
INSERT INTO `sys_role_menu` VALUES (1, 3016);
INSERT INTO `sys_role_menu` VALUES (16, 3016);
INSERT INTO `sys_role_menu` VALUES (1, 3017);
INSERT INTO `sys_role_menu` VALUES (16, 3017);
INSERT INTO `sys_role_menu` VALUES (1, 3018);
INSERT INTO `sys_role_menu` VALUES (16, 3018);
INSERT INTO `sys_role_menu` VALUES (1, 3019);
INSERT INTO `sys_role_menu` VALUES (16, 3019);
INSERT INTO `sys_role_menu` VALUES (1, 3020);
INSERT INTO `sys_role_menu` VALUES (16, 3020);
INSERT INTO `sys_role_menu` VALUES (1, 3021);
INSERT INTO `sys_role_menu` VALUES (16, 3021);
INSERT INTO `sys_role_menu` VALUES (1, 3025);
INSERT INTO `sys_role_menu` VALUES (1, 3026);
INSERT INTO `sys_role_menu` VALUES (1, 3027);
INSERT INTO `sys_role_menu` VALUES (1, 3028);
INSERT INTO `sys_role_menu` VALUES (1, 3029);
INSERT INTO `sys_role_menu` VALUES (1, 3030);
INSERT INTO `sys_role_menu` VALUES (1, 3031);
INSERT INTO `sys_role_menu` VALUES (1, 3032);
INSERT INTO `sys_role_menu` VALUES (1, 4001);
INSERT INTO `sys_role_menu` VALUES (1, 4002);
INSERT INTO `sys_role_menu` VALUES (1, 4003);
INSERT INTO `sys_role_menu` VALUES (1, 4004);
INSERT INTO `sys_role_menu` VALUES (1, 4005);
INSERT INTO `sys_role_menu` VALUES (1, 4006);
INSERT INTO `sys_role_menu` VALUES (1, 4007);
INSERT INTO `sys_role_menu` VALUES (1, 4008);
INSERT INTO `sys_role_menu` VALUES (1, 4009);
INSERT INTO `sys_role_menu` VALUES (1, 4010);
INSERT INTO `sys_role_menu` VALUES (1, 4011);
INSERT INTO `sys_role_menu` VALUES (1, 4012);
INSERT INTO `sys_role_menu` VALUES (1, 4013);
INSERT INTO `sys_role_menu` VALUES (1, 4014);
INSERT INTO `sys_role_menu` VALUES (1, 4015);
INSERT INTO `sys_role_menu` VALUES (1, 4016);
INSERT INTO `sys_role_menu` VALUES (1, 4017);
INSERT INTO `sys_role_menu` VALUES (1, 4018);
INSERT INTO `sys_role_menu` VALUES (1, 4019);
INSERT INTO `sys_role_menu` VALUES (1, 4020);
INSERT INTO `sys_role_menu` VALUES (1, 4021);
INSERT INTO `sys_role_menu` VALUES (1, 4022);
INSERT INTO `sys_role_menu` VALUES (1, 4023);
INSERT INTO `sys_role_menu` VALUES (1, 4024);
INSERT INTO `sys_role_menu` VALUES (1, 4025);
INSERT INTO `sys_role_menu` VALUES (1, 4026);
INSERT INTO `sys_role_menu` VALUES (1, 4027);
INSERT INTO `sys_role_menu` VALUES (1, 4028);
INSERT INTO `sys_role_menu` VALUES (1, 4029);
INSERT INTO `sys_role_menu` VALUES (1, 4030);
INSERT INTO `sys_role_menu` VALUES (1, 4031);
INSERT INTO `sys_role_menu` VALUES (1, 4032);
INSERT INTO `sys_role_menu` VALUES (1, 4033);
INSERT INTO `sys_role_menu` VALUES (1, 4034);
INSERT INTO `sys_role_menu` VALUES (1, 4035);
INSERT INTO `sys_role_menu` VALUES (1, 4036);
INSERT INTO `sys_role_menu` VALUES (1, 4037);
INSERT INTO `sys_role_menu` VALUES (1, 4038);
INSERT INTO `sys_role_menu` VALUES (1, 4039);
INSERT INTO `sys_role_menu` VALUES (1, 4040);
INSERT INTO `sys_role_menu` VALUES (1, 4077);
INSERT INTO `sys_role_menu` VALUES (1, 4078);
INSERT INTO `sys_role_menu` VALUES (1, 4079);
INSERT INTO `sys_role_menu` VALUES (1, 4080);
INSERT INTO `sys_role_menu` VALUES (1, 4081);
INSERT INTO `sys_role_menu` VALUES (1, 4082);
INSERT INTO `sys_role_menu` VALUES (1, 4083);
INSERT INTO `sys_role_menu` VALUES (1, 4084);
INSERT INTO `sys_role_menu` VALUES (1, 4085);
INSERT INTO `sys_role_menu` VALUES (1, 4086);
INSERT INTO `sys_role_menu` VALUES (1, 4087);
INSERT INTO `sys_role_menu` VALUES (1, 4088);
INSERT INTO `sys_role_menu` VALUES (1, 4089);
INSERT INTO `sys_role_menu` VALUES (1, 4090);
INSERT INTO `sys_role_menu` VALUES (1, 4091);
INSERT INTO `sys_role_menu` VALUES (1, 4092);
INSERT INTO `sys_role_menu` VALUES (1, 4093);
INSERT INTO `sys_role_menu` VALUES (1, 4094);
INSERT INTO `sys_role_menu` VALUES (1, 4095);
INSERT INTO `sys_role_menu` VALUES (1, 4096);
INSERT INTO `sys_role_menu` VALUES (1, 4097);
INSERT INTO `sys_role_menu` VALUES (1, 4098);
INSERT INTO `sys_role_menu` VALUES (1, 4099);
INSERT INTO `sys_role_menu` VALUES (1, 4100);
INSERT INTO `sys_role_menu` VALUES (1, 4101);
INSERT INTO `sys_role_menu` VALUES (1, 4102);
INSERT INTO `sys_role_menu` VALUES (1, 4103);
INSERT INTO `sys_role_menu` VALUES (1, 4104);
INSERT INTO `sys_role_menu` VALUES (1, 4105);
INSERT INTO `sys_role_menu` VALUES (1, 4106);
INSERT INTO `sys_role_menu` VALUES (1, 4107);
INSERT INTO `sys_role_menu` VALUES (1, 4108);
INSERT INTO `sys_role_menu` VALUES (1, 4109);
INSERT INTO `sys_role_menu` VALUES (1, 4110);
INSERT INTO `sys_role_menu` VALUES (1, 4111);
INSERT INTO `sys_role_menu` VALUES (1, 4112);
INSERT INTO `sys_role_menu` VALUES (1, 4113);
INSERT INTO `sys_role_menu` VALUES (1, 4114);
INSERT INTO `sys_role_menu` VALUES (1, 4115);
INSERT INTO `sys_role_menu` VALUES (1, 4116);
INSERT INTO `sys_role_menu` VALUES (1, 4117);
INSERT INTO `sys_role_menu` VALUES (1, 4118);
INSERT INTO `sys_role_menu` VALUES (1, 4128);
INSERT INTO `sys_role_menu` VALUES (1, 4129);
INSERT INTO `sys_role_menu` VALUES (1, 4130);
INSERT INTO `sys_role_menu` VALUES (1, 4131);
INSERT INTO `sys_role_menu` VALUES (1, 4132);
INSERT INTO `sys_role_menu` VALUES (1, 4133);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码（加密）',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `avatar` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '头像URL或base64数据',
  `user_type` int NOT NULL DEFAULT 0 COMMENT '用户类型（0:普通用户 10:超级管理员）',
  `status` int NOT NULL DEFAULT 1 COMMENT '用户状态（0:禁用 1:启用）',
  `gender` int NULL DEFAULT 0 COMMENT '性别（0:未知 1:男 2:女）',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `post` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '岗位',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `tags` json NULL COMMENT '个性标签（JSON数组）',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `last_login_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后登录方式',
  `gitee_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Gitee 用户 ID',
  `github_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GitHub 用户 ID',
  `qq_openid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'QQ OpenID',
  `google_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Google 用户 ID',
  `wechat_unionid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信 UnionID',
  `microsoft_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Microsoft 用户 ID',
  `dingtalk_unionid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '钉钉 UnionID',
  `feishu_union_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '飞书 UnionID',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '个人简介',
  `oauth_provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OAuth 提供商',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_sys_user_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `idx_github_id`(`github_id` ASC) USING BTREE,
  UNIQUE INDEX `idx_qq_openid`(`qq_openid` ASC) USING BTREE,
  UNIQUE INDEX `idx_google_id`(`google_id` ASC) USING BTREE,
  UNIQUE INDEX `idx_wechat_unionid`(`wechat_unionid` ASC) USING BTREE,
  UNIQUE INDEX `idx_microsoft_id`(`microsoft_id` ASC) USING BTREE,
  UNIQUE INDEX `idx_dingtalk_unionid`(`dingtalk_unionid` ASC) USING BTREE,
  UNIQUE INDEX `idx_feishu_union_id`(`feishu_union_id` ASC) USING BTREE,
  UNIQUE INDEX `idx_gitee_id`(`gitee_id` ASC) USING BTREE,
  INDEX `dept_id`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `sys_user_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2b$12$XdwqiDrVu3Qdvjlx5Je4D.2uPbcs4wiGtsfxKowL06Npvcn5sbGNq', '超级管理员', 'adminrebort@example.com', NULL, '/static/upload/avatars/avatar_1_0e5c807e.jpeg', 10, 1, 0, 1, NULL, '超级管理员', '[\"超级管理员\"]', '2026-03-31 09:59:26', '127.0.0.1', '2026-01-31 18:06:08', NULL, '2026-03-31 09:59:26', NULL, 1, NULL, NULL, '2026-03-31 09:59:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (34, '测试用户', '$2b$12$zXDhfisubVIfYzlXAzqf9OrXtZnpowee6mIanggilCkdhbxrkjphq', '普通用户', NULL, NULL, NULL, 20, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-06 14:03:47', 1, '2026-03-06 13:54:25', 1, 1, NULL, '2026-02-06 14:03:48', '2026-03-06 13:54:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (35, 'Rebort', '$2b$12$yv8UjM.kyQnGq/wtzN.gsO4rYVCk/2bn37nJAbOXp9JVwH1084yum', 'Rebort', NULL, NULL, NULL, 20, 1, 0, NULL, NULL, NULL, NULL, '2026-03-06 11:31:06', '127.0.0.1', '2026-02-06 18:41:03', 1, '2026-03-06 11:31:06', 1, 1, NULL, '2026-02-06 18:41:04', '2026-03-06 11:31:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `role_id`(`role_id` ASC) USING BTREE,
  CONSTRAINT `sys_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sys_user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (35, 16);
INSERT INTO `sys_user_role` VALUES (34, 17);

-- ----------------------------
-- Table structure for task_notification_settings
-- ----------------------------
DROP TABLE IF EXISTS `task_notification_settings`;
CREATE TABLE `task_notification_settings`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `task_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务类型: API/UI',
  `notification_config_id` bigint NOT NULL COMMENT '通知配置ID',
  `is_enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `notify_on_success` tinyint(1) NULL DEFAULT 0 COMMENT '成功时通知',
  `notify_on_failure` tinyint(1) NULL DEFAULT 1 COMMENT '失败时通知',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task`(`task_id` ASC, `task_type` ASC) USING BTREE,
  INDEX `idx_config`(`notification_config_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务通知配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of task_notification_settings
-- ----------------------------

-- ----------------------------
-- Table structure for template_default_reviewers
-- ----------------------------
DROP TABLE IF EXISTS `template_default_reviewers`;
CREATE TABLE `template_default_reviewers`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_id` bigint NOT NULL COMMENT '模板ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_template_user`(`template_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_template`(`template_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模板默认评审人关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of template_default_reviewers
-- ----------------------------

-- ----------------------------
-- Table structure for template_projects
-- ----------------------------
DROP TABLE IF EXISTS `template_projects`;
CREATE TABLE `template_projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_id` bigint NOT NULL COMMENT '模板ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_template_project`(`template_id` ASC, `project_id` ASC) USING BTREE,
  INDEX `idx_template`(`template_id` ASC) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '模板项目关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of template_projects
-- ----------------------------

-- ----------------------------
-- Table structure for test_case_reviews
-- ----------------------------
DROP TABLE IF EXISTS `test_case_reviews`;
CREATE TABLE `test_case_reviews`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评审标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评审描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '评审状态: pending/in_progress/completed/cancelled',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'medium' COMMENT '优先级: low/medium/high/urgent',
  `deadline` datetime NULL DEFAULT NULL COMMENT '截止日期',
  `template_id` bigint NULL DEFAULT NULL COMMENT '使用的模板ID',
  `creator_id` bigint NOT NULL COMMENT '创建人ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_creator`(`creator_id` ASC) USING BTREE,
  INDEX `idx_deadline`(`deadline` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试用例评审表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_case_reviews
-- ----------------------------

-- ----------------------------
-- Table structure for test_case_steps
-- ----------------------------
DROP TABLE IF EXISTS `test_case_steps`;
CREATE TABLE `test_case_steps`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_case_id` bigint NOT NULL COMMENT '测试用例ID',
  `step_number` int NOT NULL COMMENT '步骤序号',
  `action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作',
  `expected` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预期结果',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_case_step`(`test_case_id` ASC, `step_number` ASC) USING BTREE,
  INDEX `idx_case`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  CONSTRAINT `test_case_steps_ibfk_1` FOREIGN KEY (`test_case_id`) REFERENCES `test_cases` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '测试用例步骤表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_case_steps
-- ----------------------------

-- ----------------------------
-- Table structure for test_case_versions
-- ----------------------------
DROP TABLE IF EXISTS `test_case_versions`;
CREATE TABLE `test_case_versions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_case_id` bigint NOT NULL COMMENT '测试用例ID',
  `version_id` bigint NOT NULL COMMENT '版本ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_case_version`(`test_case_id` ASC, `version_id` ASC) USING BTREE,
  INDEX `idx_case`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_version`(`version_id` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  CONSTRAINT `test_case_versions_ibfk_1` FOREIGN KEY (`test_case_id`) REFERENCES `test_cases` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `test_case_versions_ibfk_2` FOREIGN KEY (`version_id`) REFERENCES `versions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用例版本关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_case_versions
-- ----------------------------

-- ----------------------------
-- Table structure for test_cases
-- ----------------------------
DROP TABLE IF EXISTS `test_cases`;
CREATE TABLE `test_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `module_id` bigint NULL DEFAULT NULL COMMENT '所属模块ID',
  `title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用例标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用例描述',
  `preconditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '前置条件',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预期结果',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'medium' COMMENT '优先级: low/medium/high/critical',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态: draft/active/deprecated',
  `test_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'functional' COMMENT '类型: functional/integration/api/ui/performance/security',
  `tags` json NULL COMMENT '标签',
  `author_id` bigint NOT NULL COMMENT '作者ID',
  `assignee_id` bigint NULL DEFAULT NULL COMMENT '指派人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_author`(`author_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  INDEX `idx_module_id`(`module_id` ASC) USING BTREE,
  CONSTRAINT `test_cases_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 300 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '测试用例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_cases
-- ----------------------------

-- ----------------------------
-- Table structure for testcase_generation_tasks
-- ----------------------------
DROP TABLE IF EXISTS `testcase_generation_tasks`;
CREATE TABLE `testcase_generation_tasks`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '关联项目ID',
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务标题',
  `requirement_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '状态',
  `progress` int NULL DEFAULT 0 COMMENT '进度百分比',
  `output_mode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'stream' COMMENT '输出模式: stream/complete',
  `stream_buffer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '流式输出缓冲区',
  `stream_position` int NULL DEFAULT 0 COMMENT '流式输出位置',
  `last_stream_update` datetime NULL DEFAULT NULL COMMENT '最后流式更新时间',
  `writer_model_config_id` bigint NULL DEFAULT NULL COMMENT '编写模型配置ID',
  `reviewer_model_config_id` bigint NULL DEFAULT NULL COMMENT '评审模型配置ID',
  `writer_prompt_config_id` bigint NULL DEFAULT NULL COMMENT '编写提示词配置ID',
  `reviewer_prompt_config_id` bigint NULL DEFAULT NULL COMMENT '评审提示词配置ID',
  `generated_test_cases` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '生成的测试用例',
  `review_feedback` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评审反馈',
  `final_test_cases` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '最终测试用例',
  `generation_log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '生成日志',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `created_by` bigint NOT NULL COMMENT '创建者ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `is_saved_to_records` tinyint(1) NULL DEFAULT 0 COMMENT '是否已保存到记录',
  `saved_at` datetime NULL DEFAULT NULL COMMENT '保存到记录时间',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志',
  `updated_by` bigint NULL DEFAULT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试用例生成任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of testcase_generation_tasks
-- ----------------------------

-- ----------------------------
-- Table structure for testcase_templates
-- ----------------------------
DROP TABLE IF EXISTS `testcase_templates`;
CREATE TABLE `testcase_templates`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '模板描述',
  `template_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ui' COMMENT '模板类型: ui/api/performance',
  `field_mapping` json NOT NULL COMMENT '字段映射配置',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认模板',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_template_type`(`template_type` ASC) USING BTREE,
  INDEX `idx_is_default`(`is_default` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '测试用例模板配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of testcase_templates
-- ----------------------------
INSERT INTO `testcase_templates` VALUES (1, '默认UI测试用例模板', '系统预置的默认UI测试用例模板，支持标准字段映射', 'ui', '{\"columns\": [{\"type\": \"string\", \"source\": \"用例ID\", \"target\": \"case_id\", \"required\": false}, {\"type\": \"string\", \"source\": \"测试标题\", \"target\": \"name\", \"required\": true}, {\"type\": \"text\", \"source\": \"前置条件\", \"target\": \"preconditions\", \"required\": false}, {\"type\": \"text\", \"source\": \"操作步骤\", \"target\": \"steps\", \"required\": true, \"parse_steps\": true}, {\"type\": \"text\", \"source\": \"预期结果\", \"target\": \"expected_result\", \"required\": true}, {\"type\": \"enum\", \"source\": \"优先级\", \"target\": \"priority\", \"values\": {\"P1\": \"high\", \"P2\": \"medium\", \"P3\": \"low\"}, \"default\": \"medium\"}]}', 1, 1, '2026-02-26 09:49:15', 1, '2026-03-02 14:06:02', 1, 1);
INSERT INTO `testcase_templates` VALUES (2, '默认UI测试用例模板', '系统预置的默认UI测试用例模板，支持标准字段映射', 'ui', '{\"columns\": [{\"type\": \"string\", \"source\": \"用例ID\", \"target\": \"case_id\", \"required\": false}, {\"type\": \"string\", \"source\": \"测试目标\", \"target\": \"name\", \"required\": true}, {\"type\": \"text\", \"source\": \"前置条件\", \"target\": \"preconditions\", \"required\": false}, {\"type\": \"text\", \"source\": \"操作步骤\", \"target\": \"steps\", \"required\": true, \"parse_steps\": true}, {\"type\": \"text\", \"source\": \"预期结果\", \"target\": \"expected_result\", \"required\": true}, {\"type\": \"enum\", \"source\": \"优先级\", \"target\": \"priority\", \"values\": {\"P1\": \"high\", \"P2\": \"medium\", \"P3\": \"low\"}, \"default\": \"medium\"}]}', 1, 1, '2026-02-26 10:09:21', 1, '2026-02-26 10:10:09', NULL, 0);
INSERT INTO `testcase_templates` VALUES (3, '默认主项目测试用例模板', '系统预置的默认主项目测试用例模板，支持标准字段映射', 'main', '{\"columns\": [{\"type\": \"string\", \"source\": \"用例ID\", \"target\": \"case_id\", \"required\": false}, {\"type\": \"string\", \"source\": \"测试标题\", \"target\": \"title\", \"required\": true}, {\"type\": \"text\", \"source\": \"用例描述\", \"target\": \"description\", \"required\": false}, {\"type\": \"text\", \"source\": \"前置条件\", \"target\": \"preconditions\", \"required\": false}, {\"type\": \"text\", \"source\": \"操作步骤\", \"target\": \"test_steps\", \"required\": false, \"description\": \"测试执行的详细步骤\"}, {\"type\": \"text\", \"source\": \"预期结果\", \"target\": \"expected_result\", \"required\": true}, {\"type\": \"enum\", \"source\": \"优先级\", \"target\": \"priority\", \"values\": {\"P1\": \"high\", \"P2\": \"medium\", \"P3\": \"low\"}, \"default\": \"medium\"}, {\"type\": \"enum\", \"source\": \"测试类型\", \"target\": \"test_type\", \"values\": {\"功能测试\": \"functional\", \"安全测试\": \"security\", \"性能测试\": \"performance\", \"兼容性测试\": \"compatibility\"}, \"default\": \"functional\"}], \"target_table\": \"test_cases\"}', 1, 1, '2026-02-26 10:28:26', 1, '2026-03-03 10:42:19', 1, 1);
INSERT INTO `testcase_templates` VALUES (4, 'API测试用例默认模板', 'API测试用例的默认字段映射模板', 'api', '{\"url\": \"请求URL\", \"body\": \"请求体\", \"name\": \"用例名称\", \"method\": \"请求方法\", \"params\": \"请求参数\", \"headers\": \"请求头\", \"assertions\": \"断言\", \"description\": \"用例描述\", \"expected_result\": \"预期结果\"}', 1, 1, '2026-02-26 11:20:52', 1, '2026-02-26 11:20:52', NULL, 1);

-- ----------------------------
-- Table structure for ui_element_groups
-- ----------------------------
DROP TABLE IF EXISTS `ui_element_groups`;
CREATE TABLE `ui_element_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ui_project_id` bigint NOT NULL COMMENT '关联UI项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分组名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分组描述',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父分组ID',
  `order_num` int NULL DEFAULT 0 COMMENT '排序',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project_id`(`ui_project_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI元素分组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_element_groups
-- ----------------------------
INSERT INTO `ui_element_groups` VALUES (1, 1, '登录页面元素', '登录页面相关的元素分组', NULL, 1, '2026-02-08 11:33:42', NULL, '2026-02-08 11:33:42', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (2, 2, '更新后的登录页面', '更新后的描述', NULL, 1, '2026-02-08 11:38:57', NULL, '2026-02-08 11:39:02', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (10, 11, '登录页', NULL, NULL, 1, '2026-02-08 12:09:33', NULL, '2026-02-08 12:09:33', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (11, 14, '更新后的分组', '登录页面元素分组', NULL, 1, '2026-02-08 12:44:36', NULL, '2026-02-08 12:44:40', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (19, 25, '测试', '', NULL, 0, '2026-02-08 14:01:50', NULL, '2026-02-08 14:01:50', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (20, 25, '测试2', '', NULL, 0, '2026-02-08 14:02:17', NULL, '2026-02-08 14:02:17', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (21, 27, '点击百度按钮', '', NULL, 0, '2026-02-08 15:59:00', NULL, '2026-02-08 19:06:22', NULL, 1, NULL);
INSERT INTO `ui_element_groups` VALUES (26, 27, '66', '', 22, 0, '2026-02-08 18:24:17', NULL, '2026-02-08 18:24:17', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_elements
-- ----------------------------
DROP TABLE IF EXISTS `ui_elements`;
CREATE TABLE `ui_elements`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` bigint NOT NULL COMMENT '关联分组ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '元素名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '元素描述',
  `element_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'button' COMMENT '元素类型: button/input/link/text等',
  `locator_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '定位策略: css/xpath/id/name等',
  `locator_value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '定位器值',
  `backup_locators` json NULL COMMENT '备用定位器列表',
  `wait_time` int NULL DEFAULT 5000 COMMENT '等待时间(毫秒)',
  `is_dynamic` tinyint(1) NULL DEFAULT 0 COMMENT '是否动态元素',
  `screenshot` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '元素截图路径',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_group_id`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI元素表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_elements
-- ----------------------------
INSERT INTO `ui_elements` VALUES (1, 1, '用户名输入框', '登录页面的用户名输入框', 'input', 'css', '#username', 'null', 5000, 0, NULL, '2026-02-08 11:33:48', NULL, '2026-02-08 11:33:48', NULL, 1, NULL);
INSERT INTO `ui_elements` VALUES (2, 2, '更新后的用户名输入框', '登录页面用户名输入框', 'input', 'css', '#username', '[{\"value\": \"//input[@id=\'username\']\", \"strategy\": \"xpath\"}, {\"value\": \"username\", \"strategy\": \"name\"}]', 10000, 0, NULL, '2026-02-08 11:39:05', NULL, '2026-02-08 11:39:13', NULL, 1, NULL);
INSERT INTO `ui_elements` VALUES (10, 10, '用户名', NULL, 'input', 'css', '#username', 'null', 5000, 0, NULL, '2026-02-08 12:09:35', NULL, '2026-02-08 12:09:35', NULL, 1, NULL);
INSERT INTO `ui_elements` VALUES (11, 11, '更新后的元素', '登录页用户名输入框', 'input', 'css', '#username', 'null', 5000, 0, NULL, '2026-02-08 12:44:42', NULL, '2026-02-08 12:44:48', NULL, 1, NULL);
INSERT INTO `ui_elements` VALUES (19, 19, '44', '44', 'button', 'css', '44', '[{\"value\": \"44\", \"strategy\": \"css\"}]', 5000, 0, '', '2026-02-08 14:02:41', NULL, '2026-02-08 14:28:50', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_executions
-- ----------------------------
DROP TABLE IF EXISTS `ui_executions`;
CREATE TABLE `ui_executions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ui_project_id` bigint NULL DEFAULT NULL COMMENT 'UI项目ID',
  `suite_id` bigint NULL DEFAULT NULL COMMENT '关联套件ID',
  `test_case_id` bigint NULL DEFAULT NULL COMMENT '关联用例ID',
  `engine_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行引擎',
  `browser_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '浏览器类型',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行状态: running/success/failed/error',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长(毫秒)',
  `total_steps` int NULL DEFAULT 0 COMMENT '总步骤数',
  `passed_steps` int NULL DEFAULT 0 COMMENT '通过步骤数',
  `failed_steps` int NULL DEFAULT 0 COMMENT '失败步骤数',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `screenshots` json NULL COMMENT '截图列表',
  `video_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '录屏路径',
  `logs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '执行日志',
  `executed_by` bigint NULL DEFAULT NULL COMMENT '执行人ID',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_suite_id`(`suite_id` ASC) USING BTREE,
  INDEX `idx_test_case_id`(`test_case_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE,
  INDEX `idx_ui_project_id`(`ui_project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI执行记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_executions
-- ----------------------------
INSERT INTO `ui_executions` VALUES (1, NULL, NULL, 17, 'playwright', 'chromium', 'failed', '2026-02-08 12:58:38', '2026-02-24 10:07:17', NULL, 1, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 12:58:38', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (2, NULL, 14, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 12:58:40', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 12:58:40', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (3, NULL, NULL, 17, 'playwright', 'chromium', 'failed', '2026-02-08 12:58:45', '2026-02-24 10:07:17', NULL, 1, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 12:58:44', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (5, NULL, 15, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 13:02:21', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 13:02:21', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (6, NULL, NULL, 20, 'playwright', 'chromium', 'success', '2026-02-08 13:02:29', '2026-02-08 13:02:29', 1000, 1, 1, 0, NULL, NULL, NULL, 'Playwright执行完成: 测试用例\n步骤1: navigate - 成功', 1, '2026-02-08 13:02:28', NULL, '2026-02-08 13:02:28', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (8, NULL, 16, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 13:06:31', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 13:06:30', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (10, NULL, 17, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 13:08:28', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 13:08:27', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (11, 25, 20, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 14:32:23', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 14:32:23', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);
INSERT INTO `ui_executions` VALUES (12, 25, 18, NULL, 'playwright', 'chromium', 'failed', '2026-02-08 14:41:41', '2026-02-24 10:07:17', NULL, 0, 0, 0, '执行超时（系统自动清理）', NULL, NULL, NULL, 1, '2026-02-08 14:41:41', NULL, '2026-02-24 10:07:17', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_page_object_elements
-- ----------------------------
DROP TABLE IF EXISTS `ui_page_object_elements`;
CREATE TABLE `ui_page_object_elements`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `page_object_id` bigint NOT NULL COMMENT '关联页面对象ID',
  `element_id` bigint NOT NULL COMMENT '关联元素ID',
  `method_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方法名称',
  `is_property` tinyint(1) NULL DEFAULT 0 COMMENT '是否为属性',
  `order_num` int NULL DEFAULT 0 COMMENT '排序',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_page_object_id`(`page_object_id` ASC) USING BTREE,
  INDEX `idx_element_id`(`element_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '页面对象元素关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_page_object_elements
-- ----------------------------
INSERT INTO `ui_page_object_elements` VALUES (8, 20, 22, '百度输入框', 1, 1, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (9, 20, 21, '点击百度按钮', 1, 2, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (10, 20, 23, '00', 0, 2, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (11, 20, 24, '00', 0, 3, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (12, 20, 25, '00', 0, 4, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (13, 20, 26, '00', 0, 5, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (14, 20, 27, '00', 0, 6, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (15, 20, 28, '00', 0, 7, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (16, 20, 29, '99', 0, 8, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (17, 20, 30, '99', 0, 9, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (18, 20, 31, '99', 0, 10, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (19, 20, 32, '6868', 0, 11, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);
INSERT INTO `ui_page_object_elements` VALUES (20, 20, 33, '87687686', 0, 12, '2026-02-25 09:14:46', '2026-02-25 09:14:46', NULL, NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_page_objects
-- ----------------------------
DROP TABLE IF EXISTS `ui_page_objects`;
CREATE TABLE `ui_page_objects`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ui_project_id` bigint NOT NULL COMMENT '关联UI项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '页面对象名称',
  `class_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '页面对象描述',
  `url_pattern` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'URL模式',
  `template_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '生成的代码模板',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project_id`(`ui_project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI页面对象表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_page_objects
-- ----------------------------
INSERT INTO `ui_page_objects` VALUES (1, 2, '更新后的登录页面对象', 'LoginPage', '更新后的描述', '/login', NULL, '2026-02-08 11:39:15', NULL, '2026-02-08 11:39:23', NULL, 1, NULL);
INSERT INTO `ui_page_objects` VALUES (9, 11, '登录页', 'LoginPage', '登录页面对象', NULL, NULL, '2026-02-08 12:09:37', NULL, '2026-02-08 12:09:37', NULL, 1, NULL);
INSERT INTO `ui_page_objects` VALUES (10, 14, '更新后的页面对象', 'LoginPage', '登录页面对象', NULL, NULL, '2026-02-08 12:44:50', NULL, '2026-02-08 12:44:56', NULL, 1, NULL);
INSERT INTO `ui_page_objects` VALUES (18, 25, '44', '44', '44', '44', NULL, '2026-02-08 14:03:01', NULL, '2026-02-08 14:03:01', NULL, 1, NULL);
INSERT INTO `ui_page_objects` VALUES (19, 25, '66', '66', '66', '66', NULL, '2026-02-08 14:29:26', NULL, '2026-02-08 14:29:53', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_projects
-- ----------------------------
DROP TABLE IF EXISTS `ui_projects`;
CREATE TABLE `ui_projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` bigint NOT NULL COMMENT '关联项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'UI项目名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目描述',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基础URL',
  `browser_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'chromium' COMMENT '浏览器类型: chromium/firefox/webkit',
  `viewport_width` int NULL DEFAULT 1920 COMMENT '视口宽度',
  `viewport_height` int NULL DEFAULT 1080 COMMENT '视口高度',
  `timeout` int NULL DEFAULT 30000 COMMENT '默认超时时间(毫秒)',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI自动化项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_projects
-- ----------------------------
INSERT INTO `ui_projects` VALUES (40, 7, '00', '', '', 'chromium', 1920, 1080, 30000, '2026-02-25 10:52:54', NULL, '2026-02-25 10:52:54', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_suite_cases
-- ----------------------------
DROP TABLE IF EXISTS `ui_suite_cases`;
CREATE TABLE `ui_suite_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `suite_id` bigint NOT NULL COMMENT '关联套件ID',
  `test_case_id` bigint NOT NULL COMMENT '关联测试用例ID',
  `order_num` int NULL DEFAULT 0 COMMENT '执行顺序',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_suite_id`(`suite_id` ASC) USING BTREE,
  INDEX `idx_test_case_id`(`test_case_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI套件用例关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_suite_cases
-- ----------------------------
INSERT INTO `ui_suite_cases` VALUES (1, 2, 2, 1, '2026-02-08 11:41:47', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (2, 3, 3, 1, '2026-02-08 11:43:31', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (3, 4, 4, 1, '2026-02-08 11:45:19', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (4, 5, 6, 1, '2026-02-08 11:49:20', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (5, 6, 7, 1, '2026-02-08 11:52:46', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (6, 7, 8, 1, '2026-02-08 12:04:28', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (7, 8, 9, 1, '2026-02-08 12:07:24', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (8, 9, 10, 1, '2026-02-08 12:09:41', '2026-02-08 12:09:41', NULL, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (9, 10, 13, 1, '2026-02-08 12:45:07', '2026-02-08 12:45:07', NULL, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (10, 11, 14, 1, '2026-02-08 12:46:51', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (11, 12, 15, 1, '2026-02-08 12:50:50', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (12, 13, 16, 1, '2026-02-08 12:54:52', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (13, 14, 17, 1, '2026-02-08 12:58:25', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (14, 15, 20, 1, '2026-02-08 13:01:57', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (15, 16, 21, 1, '2026-02-08 13:05:58', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (16, 17, 22, 1, '2026-02-08 13:07:56', '2026-02-24 11:34:51', 1, NULL, 1, NULL);
INSERT INTO `ui_suite_cases` VALUES (17, 18, 23, 1, '2026-02-08 14:41:28', '2026-02-08 14:41:28', NULL, NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `ui_test_cases`;
CREATE TABLE `ui_test_cases`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ui_project_id` bigint NOT NULL COMMENT '关联UI项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用例名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用例描述',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'medium' COMMENT '优先级: low/medium/high',
  `tags` json NULL COMMENT '标签列表',
  `preconditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '前置条件',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预期结果',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project_id`(`ui_project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 188 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI测试用例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_test_cases
-- ----------------------------
INSERT INTO `ui_test_cases` VALUES (1, 2, '更新后的登录功能测试', '测试用户登录功能', 'medium', '[\"登录\", \"冒烟测试\"]', '用户已注册', '登录成功', '2026-02-08 11:39:25', NULL, '2026-02-08 11:39:33', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (5, 6, 'TestCase', NULL, 'high', 'null', NULL, NULL, '2026-02-08 11:47:30', NULL, '2026-02-08 11:47:30', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (10, 11, '登录测试', NULL, 'high', 'null', NULL, NULL, '2026-02-08 12:09:39', NULL, '2026-02-08 12:09:39', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (13, 14, '更新后的测试用例', '测试用户登录功能', 'high', 'null', NULL, NULL, '2026-02-08 12:44:58', NULL, '2026-02-08 12:45:05', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (23, 25, '44', '44', 'medium', '[\"44\"]', '44', '44', '2026-02-08 14:03:37', NULL, '2026-02-08 14:03:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (40, 1, '验证用户名长度下限（4字符）正常登录', 'LOGIN_001', 'high', NULL, '用户已注册，用户名为4字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (41, 1, '验证用户名长度上限（20字符）正常登录', 'LOGIN_002', 'high', NULL, '用户已注册，用户名为20字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (42, 1, '验证用户名长度为3字符时无法登录', 'LOGIN_003', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (43, 1, '验证用户名长度为21字符时无法登录', 'LOGIN_004', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (44, 1, '验证用户名为空时无法登录', 'LOGIN_005', 'high', NULL, '在登录页', '提示“用户名不能为空”，登录失败', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (45, 1, '验证密码长度下限（6字符）正常登录', 'LOGIN_006', 'high', NULL, '用户已注册，密码为6字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (46, 1, '验证密码长度上限（20字符）正常登录', 'LOGIN_007', 'high', NULL, '用户已注册，密码为20字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (47, 1, '验证密码长度为5字符时无法登录', 'LOGIN_008', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:12:26', 1, '2026-02-26 10:12:26', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (48, 1, '验证密码长度为21字符时无法登录', 'LOGIN_009', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (49, 1, '验证密码为空时无法登录', 'LOGIN_010', 'high', NULL, '在登录页', '提示“密码不能为空”，登录失败', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (50, 1, '验证用户名和密码均正确时成功跳转首页', 'LOGIN_011', 'high', NULL, '用户已注册', '成功跳转至首页，URL变为 /home', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (51, 1, '验证用户名错误时显示错误提示', 'LOGIN_012', 'high', NULL, '至少存在两个已注册用户（A和B）', '显示“用户名或密码错误”', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (52, 1, '验证密码错误时显示错误提示', 'LOGIN_013', 'high', NULL, '用户已注册', '显示“用户名或密码错误”', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (53, 1, '验证用户名和密码均错误时显示错误提示', 'LOGIN_014', 'high', NULL, '在登录页', '显示“用户名或密码错误”', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (54, 1, '验证勾选“记住密码”后7天内免密登录', 'LOGIN_015', 'medium', NULL, '用户已注册', '用户名和密码自动填充，可直接登录', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (55, 1, '验证未勾选“记住密码”则不保存凭证', 'LOGIN_016', 'medium', NULL, '用户已注册', '用户名和密码字段为空', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (56, 1, '验证“记住密码”超过7天后失效', 'LOGIN_017', 'medium', NULL, '用户已注册并已勾选记住密码', '用户名和密码未自动填充', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (57, 1, '验证第1次登录失败不触发锁定', 'LOGIN_018', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (58, 1, '验证第2次连续登录失败不触发锁定', 'LOGIN_019', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定，可继续尝试', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (59, 1, '验证第3次连续登录失败后账号锁定', 'LOGIN_020', 'high', NULL, '用户已注册', '第三次失败后提示“账号已锁定，请30分钟后重试”，登录按钮前端禁用且后端拒绝请求', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (60, 1, '验证账号锁定后30分钟内无法登录（即使密码正确）', 'LOGIN_021', 'high', NULL, '用户账号已被锁定', '提示“账号已锁定，请30分钟后重试”，无法登录', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (61, 1, '验证账号锁定30分钟后自动解锁', 'LOGIN_022', 'high', NULL, '用户账号已被锁定', '成功登录并跳转首页，URL为 /home', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (62, 1, '验证非连续失败（中间成功）不累计失败次数', 'LOGIN_023', 'medium', NULL, '用户已注册', '第三次失败后仅计1次失败，账号未锁定', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (63, 1, '验证点击“找回密码”跳转至找回密码页面', 'LOGIN_024', 'medium', NULL, '在登录页', '页面跳转至 /forgot-password，URL正确', '2026-02-26 10:12:27', 1, '2026-02-26 10:12:27', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (64, 1, '验证用户名长度下限（4字符）正常登录', 'LOGIN_001', 'high', NULL, '用户已注册，用户名为4字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (65, 1, '验证用户名长度上限（20字符）正常登录', 'LOGIN_002', 'high', NULL, '用户已注册，用户名为20字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (66, 1, '验证用户名长度为3字符时无法登录', 'LOGIN_003', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (67, 1, '验证用户名长度为21字符时无法登录', 'LOGIN_004', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (68, 1, '验证用户名为空时无法登录', 'LOGIN_005', 'high', NULL, '在登录页', '提示“用户名不能为空”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (69, 1, '验证密码长度下限（6字符）正常登录', 'LOGIN_006', 'high', NULL, '用户已注册，密码为6字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (70, 1, '验证密码长度上限（20字符）正常登录', 'LOGIN_007', 'high', NULL, '用户已注册，密码为20字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (71, 1, '验证密码长度为5字符时无法登录', 'LOGIN_008', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (72, 1, '验证密码长度为21字符时无法登录', 'LOGIN_009', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (73, 1, '验证密码为空时无法登录', 'LOGIN_010', 'high', NULL, '在登录页', '提示“密码不能为空”，登录失败', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (74, 1, '验证用户名和密码均正确时成功跳转首页', 'LOGIN_011', 'high', NULL, '用户已注册', '成功跳转至首页，URL变为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (75, 1, '验证用户名错误时显示错误提示', 'LOGIN_012', 'high', NULL, '至少存在两个已注册用户（A和B）', '显示“用户名或密码错误”', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (76, 1, '验证密码错误时显示错误提示', 'LOGIN_013', 'high', NULL, '用户已注册', '显示“用户名或密码错误”', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (77, 1, '验证用户名和密码均错误时显示错误提示', 'LOGIN_014', 'high', NULL, '在登录页', '显示“用户名或密码错误”', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (78, 1, '验证勾选“记住密码”后7天内免密登录', 'LOGIN_015', 'medium', NULL, '用户已注册', '用户名和密码自动填充，可直接登录', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (79, 1, '验证未勾选“记住密码”则不保存凭证', 'LOGIN_016', 'medium', NULL, '用户已注册', '用户名和密码字段为空', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (80, 1, '验证“记住密码”超过7天后失效', 'LOGIN_017', 'medium', NULL, '用户已注册并已勾选记住密码', '用户名和密码未自动填充', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (81, 1, '验证第1次登录失败不触发锁定', 'LOGIN_018', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (82, 1, '验证第2次连续登录失败不触发锁定', 'LOGIN_019', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定，可继续尝试', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (83, 1, '验证第3次连续登录失败后账号锁定', 'LOGIN_020', 'high', NULL, '用户已注册', '第三次失败后提示“账号已锁定，请30分钟后重试”，登录按钮前端禁用且后端拒绝请求', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (84, 1, '验证账号锁定后30分钟内无法登录（即使密码正确）', 'LOGIN_021', 'high', NULL, '用户账号已被锁定', '提示“账号已锁定，请30分钟后重试”，无法登录', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (85, 1, '验证账号锁定30分钟后自动解锁', 'LOGIN_022', 'high', NULL, '用户账号已被锁定', '成功登录并跳转首页，URL为 /home', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (86, 1, '验证非连续失败（中间成功）不累计失败次数', 'LOGIN_023', 'medium', NULL, '用户已注册', '第三次失败后仅计1次失败，账号未锁定', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (87, 1, '验证点击“找回密码”跳转至找回密码页面', 'LOGIN_024', 'medium', NULL, '在登录页', '页面跳转至 /forgot-password，URL正确', '2026-02-26 10:14:44', 1, '2026-02-26 10:14:44', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (88, 1, '验证用户名长度下限（4字符）正常登录', 'LOGIN_001', 'high', NULL, '用户已注册，用户名为4字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (89, 1, '验证用户名长度上限（20字符）正常登录', 'LOGIN_002', 'high', NULL, '用户已注册，用户名为20字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (90, 1, '验证用户名长度为3字符时无法登录', 'LOGIN_003', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (91, 1, '验证用户名长度为21字符时无法登录', 'LOGIN_004', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (92, 1, '验证用户名为空时无法登录', 'LOGIN_005', 'high', NULL, '在登录页', '提示“用户名不能为空”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (93, 1, '验证密码长度下限（6字符）正常登录', 'LOGIN_006', 'high', NULL, '用户已注册，密码为6字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (94, 1, '验证密码长度上限（20字符）正常登录', 'LOGIN_007', 'high', NULL, '用户已注册，密码为20字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (95, 1, '验证密码长度为5字符时无法登录', 'LOGIN_008', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (96, 1, '验证密码长度为21字符时无法登录', 'LOGIN_009', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (97, 1, '验证密码为空时无法登录', 'LOGIN_010', 'high', NULL, '在登录页', '提示“密码不能为空”，登录失败', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (98, 1, '验证用户名和密码均正确时成功跳转首页', 'LOGIN_011', 'high', NULL, '用户已注册', '成功跳转至首页，URL变为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (99, 1, '验证用户名错误时显示错误提示', 'LOGIN_012', 'high', NULL, '至少存在两个已注册用户（A和B）', '显示“用户名或密码错误”', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (100, 1, '验证密码错误时显示错误提示', 'LOGIN_013', 'high', NULL, '用户已注册', '显示“用户名或密码错误”', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (101, 1, '验证用户名和密码均错误时显示错误提示', 'LOGIN_014', 'high', NULL, '在登录页', '显示“用户名或密码错误”', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (102, 1, '验证勾选“记住密码”后7天内免密登录', 'LOGIN_015', 'medium', NULL, '用户已注册', '用户名和密码自动填充，可直接登录', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (103, 1, '验证未勾选“记住密码”则不保存凭证', 'LOGIN_016', 'medium', NULL, '用户已注册', '用户名和密码字段为空', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (104, 1, '验证“记住密码”超过7天后失效', 'LOGIN_017', 'medium', NULL, '用户已注册并已勾选记住密码', '用户名和密码未自动填充', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (105, 1, '验证第1次登录失败不触发锁定', 'LOGIN_018', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (106, 1, '验证第2次连续登录失败不触发锁定', 'LOGIN_019', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定，可继续尝试', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (107, 1, '验证第3次连续登录失败后账号锁定', 'LOGIN_020', 'high', NULL, '用户已注册', '第三次失败后提示“账号已锁定，请30分钟后重试”，登录按钮前端禁用且后端拒绝请求', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (108, 1, '验证账号锁定后30分钟内无法登录（即使密码正确）', 'LOGIN_021', 'high', NULL, '用户账号已被锁定', '提示“账号已锁定，请30分钟后重试”，无法登录', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (109, 1, '验证账号锁定30分钟后自动解锁', 'LOGIN_022', 'high', NULL, '用户账号已被锁定', '成功登录并跳转首页，URL为 /home', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (110, 1, '验证非连续失败（中间成功）不累计失败次数', 'LOGIN_023', 'medium', NULL, '用户已注册', '第三次失败后仅计1次失败，账号未锁定', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (111, 1, '验证点击“找回密码”跳转至找回密码页面', 'LOGIN_024', 'medium', NULL, '在登录页', '页面跳转至 /forgot-password，URL正确', '2026-02-26 10:15:34', 1, '2026-02-26 10:15:34', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (112, 1, '验证用户名长度下限（4字符）正常登录', 'LOGIN_001', 'high', NULL, '用户已注册，用户名为4字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (113, 1, '验证用户名长度上限（20字符）正常登录', 'LOGIN_002', 'high', NULL, '用户已注册，用户名为20字符，密码正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (114, 1, '验证用户名长度为3字符时无法登录', 'LOGIN_003', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (115, 1, '验证用户名长度为21字符时无法登录', 'LOGIN_004', 'high', NULL, '在登录页', '提示“用户名长度应为4-20个字符”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (116, 1, '验证用户名为空时无法登录', 'LOGIN_005', 'high', NULL, '在登录页', '提示“用户名不能为空”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (117, 1, '验证密码长度下限（6字符）正常登录', 'LOGIN_006', 'high', NULL, '用户已注册，密码为6字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (118, 1, '验证密码长度上限（20字符）正常登录', 'LOGIN_007', 'high', NULL, '用户已注册，密码为20字符且正确', '成功跳转至首页，URL为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (119, 1, '验证密码长度为5字符时无法登录', 'LOGIN_008', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (120, 1, '验证密码长度为21字符时无法登录', 'LOGIN_009', 'high', NULL, '在登录页', '提示“密码长度应为6-20个字符”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (121, 1, '验证密码为空时无法登录', 'LOGIN_010', 'high', NULL, '在登录页', '提示“密码不能为空”，登录失败', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (122, 1, '验证用户名和密码均正确时成功跳转首页', 'LOGIN_011', 'high', NULL, '用户已注册', '成功跳转至首页，URL变为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (123, 1, '验证用户名错误时显示错误提示', 'LOGIN_012', 'high', NULL, '至少存在两个已注册用户（A和B）', '显示“用户名或密码错误”', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (124, 1, '验证密码错误时显示错误提示', 'LOGIN_013', 'high', NULL, '用户已注册', '显示“用户名或密码错误”', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (125, 1, '验证用户名和密码均错误时显示错误提示', 'LOGIN_014', 'high', NULL, '在登录页', '显示“用户名或密码错误”', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (126, 1, '验证勾选“记住密码”后7天内免密登录', 'LOGIN_015', 'medium', NULL, '用户已注册', '用户名和密码自动填充，可直接登录', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (127, 1, '验证未勾选“记住密码”则不保存凭证', 'LOGIN_016', 'medium', NULL, '用户已注册', '用户名和密码字段为空', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (128, 1, '验证“记住密码”超过7天后失效', 'LOGIN_017', 'medium', NULL, '用户已注册并已勾选记住密码', '用户名和密码未自动填充', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (129, 1, '验证第1次登录失败不触发锁定', 'LOGIN_018', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (130, 1, '验证第2次连续登录失败不触发锁定', 'LOGIN_019', 'high', NULL, '用户已注册', '显示“用户名或密码错误”，账号未锁定，可继续尝试', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (131, 1, '验证第3次连续登录失败后账号锁定', 'LOGIN_020', 'high', NULL, '用户已注册', '第三次失败后提示“账号已锁定，请30分钟后重试”，登录按钮前端禁用且后端拒绝请求', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (132, 1, '验证账号锁定后30分钟内无法登录（即使密码正确）', 'LOGIN_021', 'high', NULL, '用户账号已被锁定', '提示“账号已锁定，请30分钟后重试”，无法登录', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (133, 1, '验证账号锁定30分钟后自动解锁', 'LOGIN_022', 'high', NULL, '用户账号已被锁定', '成功登录并跳转首页，URL为 /home', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (134, 1, '验证非连续失败（中间成功）不累计失败次数', 'LOGIN_023', 'medium', NULL, '用户已注册', '第三次失败后仅计1次失败，账号未锁定', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);
INSERT INTO `ui_test_cases` VALUES (135, 1, '验证点击“找回密码”跳转至找回密码页面', 'LOGIN_024', 'medium', NULL, '在登录页', '页面跳转至 /forgot-password，URL正确', '2026-02-26 10:16:37', 1, '2026-02-26 10:16:37', NULL, 1, NULL);

-- ----------------------------
-- Table structure for ui_test_steps
-- ----------------------------
DROP TABLE IF EXISTS `ui_test_steps`;
CREATE TABLE `ui_test_steps`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_case_id` bigint NOT NULL COMMENT '关联测试用例ID',
  `step_number` int NOT NULL COMMENT '步骤序号',
  `action_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型: click/input/select/wait等',
  `element_id` bigint NULL DEFAULT NULL COMMENT '关联元素ID',
  `action_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '步骤描述',
  `assertion_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '断言类型',
  `assertion_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '断言值',
  `screenshot_on_failure` tinyint(1) NULL DEFAULT 1 COMMENT '失败时截图',
  `continue_on_failure` tinyint(1) NULL DEFAULT 0 COMMENT '失败时继续',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_test_case_id`(`test_case_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 409 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI测试步骤表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_test_steps
-- ----------------------------
INSERT INTO `ui_test_steps` VALUES (1, 8, 1, 'navigate', NULL, 'https://example.com', '打开登录页', NULL, NULL, 1, 0, '2026-02-08 12:04:30', '2026-02-08 12:04:30', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (2, 8, 2, 'fill', 8, 'admin', '输入用户名', NULL, NULL, 1, 0, '2026-02-08 12:04:32', '2026-02-08 12:04:32', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (3, 9, 1, 'navigate', NULL, 'https://example.com', '打开登录页', NULL, NULL, 1, 0, '2026-02-08 12:07:26', '2026-02-08 12:07:26', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (4, 9, 2, 'fill', 9, 'admin', '输入用户名', NULL, NULL, 1, 0, '2026-02-08 12:07:28', '2026-02-08 12:07:28', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (5, 10, 1, 'navigate', NULL, 'https://example.com', '打开登录页', NULL, NULL, 1, 0, '2026-02-08 12:09:43', '2026-02-08 12:09:43', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (6, 10, 2, 'fill', 10, 'admin', '输入用户名', NULL, NULL, 1, 0, '2026-02-08 12:09:45', '2026-02-08 12:09:45', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (7, 11, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 12:15:27', '2026-02-08 12:15:27', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (8, 12, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 12:16:55', '2026-02-08 12:16:55', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (9, 13, 1, 'navigate', NULL, 'https://example.com/login', '打开登录页面', NULL, NULL, 1, 0, '2026-02-08 12:45:15', '2026-02-08 12:45:19', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (10, 13, 2, 'fill', 11, 'admin', '输入用户名', NULL, NULL, 1, 0, '2026-02-08 12:45:17', '2026-02-08 12:45:17', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (11, 13, 3, 'click', 11, NULL, '点击登录按钮', NULL, NULL, 1, 0, '2026-02-08 12:45:17', '2026-02-08 12:45:17', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (13, 14, 2, 'click', 12, NULL, NULL, NULL, NULL, 1, 0, '2026-02-08 12:47:02', '2026-02-08 12:47:02', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (14, 15, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 12:50:48', '2026-02-08 12:50:48', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (15, 16, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 12:54:50', '2026-02-08 12:54:50', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (16, 17, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 12:58:23', '2026-02-08 12:58:23', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (17, 18, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 13:00:17', '2026-02-08 13:00:17', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (18, 19, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 13:01:22', '2026-02-08 13:01:24', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (19, 20, 1, 'navigate', NULL, 'https://example.com', '打开页面', NULL, NULL, 1, 0, '2026-02-08 13:01:54', '2026-02-08 13:01:59', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (21, 21, 2, 'fill', 17, 'admin', '输入用户名', NULL, NULL, 1, 0, '2026-02-08 13:06:09', '2026-02-08 13:06:09', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (22, 21, 3, 'click', 17, NULL, '点击登录按钮', NULL, NULL, 1, 0, '2026-02-08 13:06:09', '2026-02-08 13:06:09', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (24, 22, 2, 'click', 18, NULL, NULL, NULL, NULL, 1, 0, '2026-02-08 13:08:06', '2026-02-08 13:08:06', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (29, 25, 1, 'click', 21, 'tester平台', '输入数据', 'textContains', '你好啊', 1, 0, '2026-02-24 13:40:44', '2026-02-25 10:49:04', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (32, 25, 3, 'assert', 21, '', '', 'textContains', '你好世界啊，这么好的世界是好的失物关', 0, 0, '2026-02-24 17:12:36', '2026-02-25 10:49:04', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (33, 25, 2, 'wait', NULL, '5000', '', NULL, '', 1, 0, '2026-02-24 17:21:19', '2026-02-25 10:49:04', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (35, 25, 4, 'fill', 22, '78787878', '', NULL, '', 1, 0, '2026-02-25 09:57:07', '2026-02-25 10:49:04', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (36, 40, 1, 'manual', NULL, NULL, '在登录页输入4字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (37, 40, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (38, 40, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (39, 41, 1, 'manual', NULL, NULL, '在登录页输入20字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (40, 41, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (41, 41, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (42, 42, 1, 'manual', NULL, NULL, '输入3字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (43, 42, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (44, 42, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (45, 43, 1, 'manual', NULL, NULL, '输入21字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (46, 43, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (47, 43, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (48, 44, 1, 'manual', NULL, NULL, '用户名留空', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (49, 44, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (50, 44, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (51, 45, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (52, 45, 2, 'manual', NULL, NULL, '输入6字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (53, 45, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (54, 46, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (55, 46, 2, 'manual', NULL, NULL, '输入20字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (56, 46, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (57, 47, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (58, 47, 2, 'manual', NULL, NULL, '输入5字符密码', NULL, NULL, 1, 0, '2026-02-26 10:12:26', '2026-02-26 10:12:26', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (59, 47, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (60, 48, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (61, 48, 2, 'manual', NULL, NULL, '输入21字符密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (62, 48, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (63, 49, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (64, 49, 2, 'manual', NULL, NULL, '密码留空', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (65, 49, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (66, 50, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (67, 50, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (68, 50, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (69, 51, 1, 'manual', NULL, NULL, '使用用户A的账号，输入用户B的用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (70, 51, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (71, 51, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (72, 52, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (73, 52, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (74, 52, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (75, 53, 1, 'manual', NULL, NULL, '输入不存在的用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (76, 53, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (77, 53, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (78, 54, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (79, 54, 2, 'manual', NULL, NULL, '勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (80, 54, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (81, 54, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (82, 54, 5, 'manual', NULL, NULL, '7天内重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (83, 55, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (84, 55, 2, 'manual', NULL, NULL, '不勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (85, 55, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (86, 55, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (87, 55, 5, 'manual', NULL, NULL, '重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (88, 56, 1, 'manual', NULL, NULL, '记住密码已保存', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (89, 56, 2, 'manual', NULL, NULL, '系统时间调整为8天后', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (90, 56, 3, 'manual', NULL, NULL, '打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (91, 57, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (92, 57, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (93, 57, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (94, 58, 1, 'manual', NULL, NULL, '第一次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (95, 58, 2, 'manual', NULL, NULL, '第二次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (96, 58, 3, 'manual', NULL, NULL, '检查账号状态', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (97, 59, 1, 'manual', NULL, NULL, '连续三次输入正确用户名+错误密码，每次点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (98, 60, 1, 'manual', NULL, NULL, '在锁定期间输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (99, 60, 2, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (100, 61, 1, 'manual', NULL, NULL, '等待30分钟（或模拟系统时间）', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (101, 61, 2, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (102, 61, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (103, 62, 1, 'manual', NULL, NULL, '第一次：输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (104, 62, 2, 'manual', NULL, NULL, '第二次：输对密码 → 成功登录并退出', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (105, 62, 3, 'manual', NULL, NULL, '第三次：再次输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (106, 63, 1, 'manual', NULL, NULL, '点击“找回密码”链接', NULL, NULL, 1, 0, '2026-02-26 10:12:27', '2026-02-26 10:12:27', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (107, 64, 1, 'manual', NULL, NULL, '在登录页输入4字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (108, 64, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (109, 64, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (110, 65, 1, 'manual', NULL, NULL, '在登录页输入20字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (111, 65, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (112, 65, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (113, 66, 1, 'manual', NULL, NULL, '输入3字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (114, 66, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (115, 66, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (116, 67, 1, 'manual', NULL, NULL, '输入21字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (117, 67, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (118, 67, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (119, 68, 1, 'manual', NULL, NULL, '用户名留空', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (120, 68, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (121, 68, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (122, 69, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (123, 69, 2, 'manual', NULL, NULL, '输入6字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (124, 69, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (125, 70, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (126, 70, 2, 'manual', NULL, NULL, '输入20字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (127, 70, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (128, 71, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (129, 71, 2, 'manual', NULL, NULL, '输入5字符密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (130, 71, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (131, 72, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (132, 72, 2, 'manual', NULL, NULL, '输入21字符密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (133, 72, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (134, 73, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (135, 73, 2, 'manual', NULL, NULL, '密码留空', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (136, 73, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (137, 74, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (138, 74, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (139, 74, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (140, 75, 1, 'manual', NULL, NULL, '使用用户A的账号，输入用户B的用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (141, 75, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (142, 75, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (143, 76, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (144, 76, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (145, 76, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (146, 77, 1, 'manual', NULL, NULL, '输入不存在的用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (147, 77, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (148, 77, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (149, 78, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (150, 78, 2, 'manual', NULL, NULL, '勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (151, 78, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (152, 78, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (153, 78, 5, 'manual', NULL, NULL, '7天内重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (154, 79, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (155, 79, 2, 'manual', NULL, NULL, '不勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (156, 79, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (157, 79, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (158, 79, 5, 'manual', NULL, NULL, '重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (159, 80, 1, 'manual', NULL, NULL, '记住密码已保存', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (160, 80, 2, 'manual', NULL, NULL, '系统时间调整为8天后', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (161, 80, 3, 'manual', NULL, NULL, '打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (162, 81, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (163, 81, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (164, 81, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (165, 82, 1, 'manual', NULL, NULL, '第一次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (166, 82, 2, 'manual', NULL, NULL, '第二次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (167, 82, 3, 'manual', NULL, NULL, '检查账号状态', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (168, 83, 1, 'manual', NULL, NULL, '连续三次输入正确用户名+错误密码，每次点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (169, 84, 1, 'manual', NULL, NULL, '在锁定期间输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (170, 84, 2, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (171, 85, 1, 'manual', NULL, NULL, '等待30分钟（或模拟系统时间）', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (172, 85, 2, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (173, 85, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (174, 86, 1, 'manual', NULL, NULL, '第一次：输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (175, 86, 2, 'manual', NULL, NULL, '第二次：输对密码 → 成功登录并退出', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (176, 86, 3, 'manual', NULL, NULL, '第三次：再次输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (177, 87, 1, 'manual', NULL, NULL, '点击“找回密码”链接', NULL, NULL, 1, 0, '2026-02-26 10:14:44', '2026-02-26 10:14:44', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (178, 88, 1, 'manual', NULL, NULL, '在登录页输入4字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (179, 88, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (180, 88, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (181, 89, 1, 'manual', NULL, NULL, '在登录页输入20字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (182, 89, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (183, 89, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (184, 90, 1, 'manual', NULL, NULL, '输入3字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (185, 90, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (186, 90, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (187, 91, 1, 'manual', NULL, NULL, '输入21字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (188, 91, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (189, 91, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (190, 92, 1, 'manual', NULL, NULL, '用户名留空', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (191, 92, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (192, 92, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (193, 93, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (194, 93, 2, 'manual', NULL, NULL, '输入6字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (195, 93, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (196, 94, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (197, 94, 2, 'manual', NULL, NULL, '输入20字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (198, 94, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (199, 95, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (200, 95, 2, 'manual', NULL, NULL, '输入5字符密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (201, 95, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (202, 96, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (203, 96, 2, 'manual', NULL, NULL, '输入21字符密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (204, 96, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (205, 97, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (206, 97, 2, 'manual', NULL, NULL, '密码留空', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (207, 97, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (208, 98, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (209, 98, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (210, 98, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (211, 99, 1, 'manual', NULL, NULL, '使用用户A的账号，输入用户B的用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (212, 99, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (213, 99, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (214, 100, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (215, 100, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (216, 100, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (217, 101, 1, 'manual', NULL, NULL, '输入不存在的用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (218, 101, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (219, 101, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (220, 102, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (221, 102, 2, 'manual', NULL, NULL, '勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (222, 102, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (223, 102, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (224, 102, 5, 'manual', NULL, NULL, '7天内重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (225, 103, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (226, 103, 2, 'manual', NULL, NULL, '不勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (227, 103, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (228, 103, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (229, 103, 5, 'manual', NULL, NULL, '重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (230, 104, 1, 'manual', NULL, NULL, '记住密码已保存', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (231, 104, 2, 'manual', NULL, NULL, '系统时间调整为8天后', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (232, 104, 3, 'manual', NULL, NULL, '打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (233, 105, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (234, 105, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (235, 105, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (236, 106, 1, 'manual', NULL, NULL, '第一次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (237, 106, 2, 'manual', NULL, NULL, '第二次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (238, 106, 3, 'manual', NULL, NULL, '检查账号状态', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (239, 107, 1, 'manual', NULL, NULL, '连续三次输入正确用户名+错误密码，每次点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (240, 108, 1, 'manual', NULL, NULL, '在锁定期间输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (241, 108, 2, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (242, 109, 1, 'manual', NULL, NULL, '等待30分钟（或模拟系统时间）', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (243, 109, 2, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (244, 109, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (245, 110, 1, 'manual', NULL, NULL, '第一次：输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (246, 110, 2, 'manual', NULL, NULL, '第二次：输对密码 → 成功登录并退出', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (247, 110, 3, 'manual', NULL, NULL, '第三次：再次输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (248, 111, 1, 'manual', NULL, NULL, '点击“找回密码”链接', NULL, NULL, 1, 0, '2026-02-26 10:15:34', '2026-02-26 10:15:34', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (249, 112, 1, 'manual', NULL, NULL, '在登录页输入4字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (250, 112, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (251, 112, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (252, 113, 1, 'manual', NULL, NULL, '在登录页输入20字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (253, 113, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (254, 113, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (255, 114, 1, 'manual', NULL, NULL, '输入3字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (256, 114, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (257, 114, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (258, 115, 1, 'manual', NULL, NULL, '输入21字符用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (259, 115, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (260, 115, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (261, 116, 1, 'manual', NULL, NULL, '用户名留空', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (262, 116, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (263, 116, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (264, 117, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (265, 117, 2, 'manual', NULL, NULL, '输入6字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (266, 117, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (267, 118, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (268, 118, 2, 'manual', NULL, NULL, '输入20字符正确密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (269, 118, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (270, 119, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (271, 119, 2, 'manual', NULL, NULL, '输入5字符密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (272, 119, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (273, 120, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (274, 120, 2, 'manual', NULL, NULL, '输入21字符密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (275, 120, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (276, 121, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (277, 121, 2, 'manual', NULL, NULL, '密码留空', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (278, 121, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (279, 122, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (280, 122, 2, 'manual', NULL, NULL, '输入正确密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (281, 122, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (282, 123, 1, 'manual', NULL, NULL, '使用用户A的账号，输入用户B的用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (283, 123, 2, 'manual', NULL, NULL, '输入任意密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (284, 123, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (285, 124, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (286, 124, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (287, 124, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (288, 125, 1, 'manual', NULL, NULL, '输入不存在的用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (289, 125, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (290, 125, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (291, 126, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (292, 126, 2, 'manual', NULL, NULL, '勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (293, 126, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (294, 126, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (295, 126, 5, 'manual', NULL, NULL, '7天内重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (296, 127, 1, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (297, 127, 2, 'manual', NULL, NULL, '不勾选“记住密码”', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (298, 127, 3, 'manual', NULL, NULL, '登录成功', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (299, 127, 4, 'manual', NULL, NULL, '退出账号', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (300, 127, 5, 'manual', NULL, NULL, '重新打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (301, 128, 1, 'manual', NULL, NULL, '记住密码已保存', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (302, 128, 2, 'manual', NULL, NULL, '系统时间调整为8天后', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (303, 128, 3, 'manual', NULL, NULL, '打开登录页', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (304, 129, 1, 'manual', NULL, NULL, '输入正确用户名', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (305, 129, 2, 'manual', NULL, NULL, '输入错误密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (306, 129, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (307, 130, 1, 'manual', NULL, NULL, '第一次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (308, 130, 2, 'manual', NULL, NULL, '第二次：输入正确用户名+错误密码 → 点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (309, 130, 3, 'manual', NULL, NULL, '检查账号状态', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (310, 131, 1, 'manual', NULL, NULL, '连续三次输入正确用户名+错误密码，每次点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (311, 132, 1, 'manual', NULL, NULL, '在锁定期间输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (312, 132, 2, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (313, 133, 1, 'manual', NULL, NULL, '等待30分钟（或模拟系统时间）', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (314, 133, 2, 'manual', NULL, NULL, '输入正确用户名和密码', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (315, 133, 3, 'manual', NULL, NULL, '点击登录', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (316, 134, 1, 'manual', NULL, NULL, '第一次：输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (317, 134, 2, 'manual', NULL, NULL, '第二次：输对密码 → 成功登录并退出', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (318, 134, 3, 'manual', NULL, NULL, '第三次：再次输错密码 → 失败', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:16:37', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (319, 135, 1, 'click', 1, NULL, '点击“找回密码”链接', NULL, NULL, 1, 0, '2026-02-26 10:16:37', '2026-02-26 10:39:54', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (320, 135, 2, 'assert', 1, '', '', 'isVisible', '', 1, 0, '2026-02-26 10:39:54', '2026-02-26 10:39:54', NULL, NULL, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (321, 136, 1, 'manual', NULL, NULL, '点击导航栏\"固件升级\"菜单', NULL, NULL, 1, 0, '2026-03-03 10:43:09', '2026-03-03 10:43:09', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (322, 136, 2, 'manual', NULL, NULL, '等待页面完全加载', NULL, NULL, 1, 0, '2026-03-03 10:43:09', '2026-03-03 10:43:09', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (323, 137, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (324, 137, 2, 'manual', NULL, NULL, '记录页面加载完成时间', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (325, 138, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (326, 139, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (327, 140, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (328, 141, 1, 'manual', NULL, NULL, '点击\"升级固件\"按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (329, 142, 1, 'manual', NULL, NULL, '点击文件选择按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (330, 142, 2, 'manual', NULL, NULL, '选择固件文件', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (331, 143, 1, 'manual', NULL, NULL, '点击文件选择按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (332, 143, 2, 'manual', NULL, NULL, '选择.txt文件', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (333, 144, 1, 'manual', NULL, NULL, '选择超过限制大小的固件文件', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (334, 145, 1, 'manual', NULL, NULL, '不选择任何文件', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (335, 145, 2, 'manual', NULL, NULL, '点击开始升级按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (336, 146, 1, 'manual', NULL, NULL, '开始固件升级', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (337, 146, 2, 'manual', NULL, NULL, '观察升级进度', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (338, 147, 1, 'manual', NULL, NULL, '模拟网络中断（断开网络连接）', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (339, 147, 2, 'manual', NULL, NULL, '等待30秒', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (340, 147, 3, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (341, 148, 1, 'manual', NULL, NULL, '模拟设备断开连接', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (342, 148, 2, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (343, 149, 1, 'manual', NULL, NULL, '完成固件升级', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (344, 149, 2, 'manual', NULL, NULL, '观察页面状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (345, 150, 1, 'manual', NULL, NULL, '故意中断升级过程', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (346, 150, 2, 'manual', NULL, NULL, '观察页面状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (347, 151, 1, 'manual', NULL, NULL, '在升级过程中刷新页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (348, 151, 2, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (349, 152, 1, 'manual', NULL, NULL, '在升级过程中关闭页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (350, 152, 2, 'manual', NULL, NULL, '重新打开页面', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (351, 153, 1, 'manual', NULL, NULL, '观察升级过程中的按钮状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (352, 154, 1, 'manual', NULL, NULL, '点击\"取消升级\"按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (353, 154, 2, 'manual', NULL, NULL, '等待取消操作完成', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (354, 154, 3, 'manual', NULL, NULL, '验证设备状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (355, 155, 1, 'manual', NULL, NULL, '选择固件文件后', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (356, 155, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (357, 156, 1, 'manual', NULL, NULL, '点击确认弹窗的取消按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (358, 157, 1, 'manual', NULL, NULL, '点击确认弹窗的确认按钮', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (359, 158, 1, 'manual', NULL, NULL, '选择不兼容的固件版本', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (360, 158, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (361, 159, 1, 'manual', NULL, NULL, '选择被损坏的固件文件', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (362, 159, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (363, 160, 1, 'manual', NULL, NULL, '观察设备状态', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (364, 160, 2, 'manual', NULL, NULL, '等待升级完成', NULL, NULL, 1, 0, '2026-03-03 10:43:10', '2026-03-03 10:43:10', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (365, 162, 1, 'manual', NULL, NULL, '点击导航栏\"固件升级\"菜单', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (366, 162, 2, 'manual', NULL, NULL, '等待页面完全加载', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (367, 163, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (368, 163, 2, 'manual', NULL, NULL, '记录页面加载完成时间', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (369, 164, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (370, 165, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (371, 166, 1, 'manual', NULL, NULL, '进入固件升级页面', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (372, 167, 1, 'manual', NULL, NULL, '点击\"升级固件\"按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (373, 168, 1, 'manual', NULL, NULL, '点击文件选择按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (374, 168, 2, 'manual', NULL, NULL, '选择固件文件', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (375, 169, 1, 'manual', NULL, NULL, '点击文件选择按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (376, 169, 2, 'manual', NULL, NULL, '选择.txt文件', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (377, 170, 1, 'manual', NULL, NULL, '选择超过限制大小的固件文件', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (378, 171, 1, 'manual', NULL, NULL, '不选择任何文件', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (379, 171, 2, 'manual', NULL, NULL, '点击开始升级按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (380, 172, 1, 'manual', NULL, NULL, '开始固件升级', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (381, 172, 2, 'manual', NULL, NULL, '观察升级进度', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (382, 173, 1, 'manual', NULL, NULL, '模拟网络中断（断开网络连接）', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (383, 173, 2, 'manual', NULL, NULL, '等待30秒', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (384, 173, 3, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (385, 174, 1, 'manual', NULL, NULL, '模拟设备断开连接', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (386, 174, 2, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (387, 175, 1, 'manual', NULL, NULL, '完成固件升级', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (388, 175, 2, 'manual', NULL, NULL, '观察页面状态', NULL, NULL, 1, 0, '2026-03-03 10:44:46', '2026-03-03 10:44:46', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (389, 176, 1, 'manual', NULL, NULL, '故意中断升级过程', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (390, 176, 2, 'manual', NULL, NULL, '观察页面状态', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (391, 177, 1, 'manual', NULL, NULL, '在升级过程中刷新页面', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (392, 177, 2, 'manual', NULL, NULL, '观察升级状态', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (393, 178, 1, 'manual', NULL, NULL, '在升级过程中关闭页面', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (394, 178, 2, 'manual', NULL, NULL, '重新打开页面', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (395, 179, 1, 'manual', NULL, NULL, '观察升级过程中的按钮状态', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (396, 180, 1, 'manual', NULL, NULL, '点击\"取消升级\"按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (397, 180, 2, 'manual', NULL, NULL, '等待取消操作完成', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (398, 180, 3, 'manual', NULL, NULL, '验证设备状态', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (399, 181, 1, 'manual', NULL, NULL, '选择固件文件后', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (400, 181, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (401, 182, 1, 'manual', NULL, NULL, '点击确认弹窗的取消按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (402, 183, 1, 'manual', NULL, NULL, '点击确认弹窗的确认按钮', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (403, 184, 1, 'manual', NULL, NULL, '选择不兼容的固件版本', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (404, 184, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (405, 185, 1, 'manual', NULL, NULL, '选择被损坏的固件文件', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (406, 185, 2, 'manual', NULL, NULL, '点击开始升级', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (407, 186, 1, 'manual', NULL, NULL, '观察设备状态', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);
INSERT INTO `ui_test_steps` VALUES (408, 186, 2, 'manual', NULL, NULL, '等待升级完成', NULL, NULL, 1, 0, '2026-03-03 10:44:47', '2026-03-03 10:44:47', NULL, 1, 1, NULL);

-- ----------------------------
-- Table structure for ui_test_suites
-- ----------------------------
DROP TABLE IF EXISTS `ui_test_suites`;
CREATE TABLE `ui_test_suites`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ui_project_id` bigint NOT NULL COMMENT '关联UI项目ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套件名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '套件描述',
  `engine_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'playwright' COMMENT '执行引擎: playwright/selenium',
  `browser_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'chromium' COMMENT '浏览器类型',
  `headless` tinyint(1) NULL DEFAULT 1 COMMENT '无头模式',
  `parallel` tinyint(1) NULL DEFAULT 0 COMMENT '并行执行',
  `max_workers` int NULL DEFAULT 1 COMMENT '最大并行数',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ui_project_id`(`ui_project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UI测试套件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ui_test_suites
-- ----------------------------
INSERT INTO `ui_test_suites` VALUES (1, 2, '登录模块测试套件', '包含所有登录相关的测试用例', 'playwright', 'chromium', 1, 0, 1, '2026-02-08 11:39:35', NULL, '2026-02-08 11:39:35', NULL, 1, NULL);
INSERT INTO `ui_test_suites` VALUES (9, 11, '登录套件', NULL, 'playwright', 'chromium', 1, 0, 1, '2026-02-08 12:09:41', NULL, '2026-02-08 12:09:41', NULL, 1, NULL);
INSERT INTO `ui_test_suites` VALUES (10, 14, '更新后的测试套件', '登录相关测试套件', 'playwright', 'chromium', 1, 0, 1, '2026-02-08 12:45:07', NULL, '2026-02-08 12:45:13', NULL, 1, NULL);
INSERT INTO `ui_test_suites` VALUES (18, 25, '66', '66', 'playwright', 'chromium', 1, 0, 1, '2026-02-08 14:04:03', NULL, '2026-02-08 14:41:28', NULL, 1, NULL);
INSERT INTO `ui_test_suites` VALUES (20, 25, '99', '99', 'playwright', 'chromium', 1, 0, 1, '2026-02-08 14:32:16', NULL, '2026-02-08 14:32:16', NULL, 1, NULL);

-- ----------------------------
-- Table structure for unified_notification_configs
-- ----------------------------
DROP TABLE IF EXISTS `unified_notification_configs`;
CREATE TABLE `unified_notification_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名称',
  `config_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'webhook_feishu' COMMENT '配置类型: webhook_feishu/webhook_wechat/webhook_dingtalk/telegram/email',
  `notification_config` json NULL COMMENT '通知配置信息(JSON格式，根据不同类型存储不同字段)',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认配置',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled_flag` tinyint(1) NULL DEFAULT 1 COMMENT '启用标志',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_config_type`(`config_type` ASC) USING BTREE,
  INDEX `idx_is_default`(`is_default` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  INDEX `idx_config_type_active`(`config_type` ASC, `is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '统一通知配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of unified_notification_configs
-- ----------------------------
INSERT INTO `unified_notification_configs` VALUES (11, '真实测试', 'webhook_wechat', '{\"webhook_url\": \"https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=bfcdd260-4562-4757-8130-ec158d06c37d\", \"mentioned_list\": [\"555\"], \"mentioned_mobile_list\": [\"555\"]}', 0, 1, '2026-03-05 19:45:13', '2026-03-05 19:45:13', 1, '2026-03-05 19:45:13', 1, '2026-03-05 19:45:13', NULL, NULL);
INSERT INTO `unified_notification_configs` VALUES (17, '真实邮件测试', 'email', '{\"use_ssl\": false, \"use_tls\": true, \"password\": \"Tkdceshi@997\", \"username\": \"rebort.chen@howentech.com\", \"smtp_port\": 587, \"to_emails\": [\"rebort.chen@howentech.com\"], \"from_email\": \"rebort.chen@howentech.com\", \"smtp_server\": \"smtp.qiye.aliyun.com\"}', 0, 1, '2026-03-06 10:07:21', '2026-03-06 10:07:21', 1, '2026-03-06 10:07:21', 1, '2026-03-06 10:07:21', NULL, NULL);

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_user_role_user_id`(`user_id` ASC) USING BTREE,
  INDEX `ix_user_role_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (2, 3, 2, '2026-01-30 17:35:05', 1, NULL, NULL, 1, NULL);
INSERT INTO `user_role` VALUES (3, 4, 3, '2026-01-30 17:35:05', 1, NULL, NULL, 1, NULL);
INSERT INTO `user_role` VALUES (1, 1, 4, '2026-01-30 17:35:29', 1, NULL, NULL, 1, NULL);
INSERT INTO `user_role` VALUES (7, 6, 7, '2026-01-30 18:02:56', 1, '2026-01-30 18:02:56', 1, 1, NULL);
INSERT INTO `user_role` VALUES (8, 8, 10, '2026-01-30 18:22:57', 1, '2026-01-30 18:22:57', 1, 1, NULL);
INSERT INTO `user_role` VALUES (21, 1, 11, '2026-02-04 18:35:21', 21, '2026-02-04 18:35:21', NULL, 1, NULL);
INSERT INTO `user_role` VALUES (22, 1, 12, '2026-02-04 18:40:41', 22, '2026-02-04 18:40:41', NULL, 1, NULL);
INSERT INTO `user_role` VALUES (23, 1, 13, '2026-02-04 18:43:16', 23, '2026-02-04 18:43:16', NULL, 1, NULL);
INSERT INTO `user_role` VALUES (24, 1, 14, '2026-02-04 18:56:00', 24, '2026-02-04 18:56:00', NULL, 1, NULL);
INSERT INTO `user_role` VALUES (25, 1, 15, '2026-02-04 21:05:48', 25, '2026-02-04 21:05:48', NULL, 1, NULL);
INSERT INTO `user_role` VALUES (29, 1, 16, '2026-02-05 09:15:55', 29, '2026-02-05 09:15:55', NULL, 1, NULL);

-- ----------------------------
-- Table structure for versions
-- ----------------------------
DROP TABLE IF EXISTS `versions`;
CREATE TABLE `versions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '版本名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '版本描述',
  `is_baseline` tinyint(1) NULL DEFAULT 0 COMMENT '是否基线版本',
  `creation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NOT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint NULL DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
  `trace_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '追踪ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_enabled`(`enabled_flag` ASC) USING BTREE,
  INDEX `idx_baseline`(`is_baseline` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '版本表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of versions
-- ----------------------------

-- ----------------------------
-- Table structure for web_management_element_menus
-- ----------------------------
DROP TABLE IF EXISTS `web_management_element_menus`;
CREATE TABLE `web_management_element_menus`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '元素菜单名称',
  `pid` bigint NOT NULL COMMENT '父菜单ID',
  `type` int NOT NULL COMMENT '菜单类型',
  `element_id` bigint NULL DEFAULT NULL COMMENT '元素ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_element_menus
-- ----------------------------
INSERT INTO `web_management_element_menus` VALUES ('默认分组', 0, 0, NULL, 1, '2026-03-14 12:17:27', NULL, NULL, NULL, 1, NULL);

-- ----------------------------
-- Table structure for web_management_elements
-- ----------------------------
DROP TABLE IF EXISTS `web_management_elements`;
CREATE TABLE `web_management_elements`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '元素名称',
  `element` json NOT NULL COMMENT '元素选择器信息',
  `menu_id` bigint NULL DEFAULT NULL COMMENT '菜单ID',
  `element_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '元素类型',
  `locator_strategy` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '定位策略',
  `locator_value` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '定位器值',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_elements
-- ----------------------------

-- ----------------------------
-- Table structure for web_management_groups
-- ----------------------------
DROP TABLE IF EXISTS `web_management_groups`;
CREATE TABLE `web_management_groups`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '脚本集名称',
  `script` json NULL COMMENT '脚本集配置',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '脚本集描述',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_groups
-- ----------------------------

-- ----------------------------
-- Table structure for web_management_menus
-- ----------------------------
DROP TABLE IF EXISTS `web_management_menus`;
CREATE TABLE `web_management_menus`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '菜单名称',
  `pid` bigint NOT NULL COMMENT '父菜单ID',
  `type` int NOT NULL COMMENT '菜单类型: 0-文件夹, 1-脚本组, 2-脚本',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_menus
-- ----------------------------
INSERT INTO `web_management_menus` VALUES ('默认分组', 0, 0, 1, '2026-03-14 12:17:27', NULL, NULL, NULL, 1, NULL);

-- ----------------------------
-- Table structure for web_management_result_details
-- ----------------------------
DROP TABLE IF EXISTS `web_management_result_details`;
CREATE TABLE `web_management_result_details`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '脚本名称',
  `result_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '执行ID',
  `browser` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '浏览器类型',
  `log` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '执行日志',
  `status` int NOT NULL COMMENT '执行状态: 0-失败, 1-成功',
  `before_img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '执行前截图',
  `after_img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '执行后截图',
  `video` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '视频地址',
  `trace` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'Playwright trace文件',
  `assert_result` json NOT NULL COMMENT '断言结果',
  `menu_id` bigint NULL DEFAULT NULL COMMENT '脚本菜单ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_result_details
-- ----------------------------

-- ----------------------------
-- Table structure for web_management_result_lists
-- ----------------------------
DROP TABLE IF EXISTS `web_management_result_lists`;
CREATE TABLE `web_management_result_lists`  (
  `task_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务名称',
  `result_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '执行ID',
  `script_list` json NOT NULL COMMENT '脚本列表',
  `browser_list` json NOT NULL COMMENT '浏览器列表',
  `result` json NOT NULL COMMENT '执行结果',
  `pid_list` json NULL COMMENT '执行进程PID列表（兼容旧 stop_web_script）',
  `start_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` int NULL DEFAULT NULL COMMENT '执行状态: 0-执行中, 1-完成',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_result_lists
-- ----------------------------

-- ----------------------------
-- Table structure for web_management_scripts
-- ----------------------------
DROP TABLE IF EXISTS `web_management_scripts`;
CREATE TABLE `web_management_scripts`  (
  `script` json NOT NULL COMMENT '脚本步骤',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `creation_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `updation_date` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `updated_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `enabled_flag` tinyint(1) NOT NULL COMMENT '是否删除, 0 删除 1 非删除',
  `trace_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'trace_id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of web_management_scripts
-- ----------------------------
INSERT INTO `web_management_scripts` VALUES ('[{\"name\": \"左键点击-f3u\", \"type\": 1, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [{\"role\": \"button\", \"type\": 1, \"element\": \"\", \"locator\": 2, \"page_type\": 1, \"locator_select\": 7}], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"右键点击-161g\", \"type\": 16, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"双击事件-3yw\", \"type\": 2, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"长按事件-4c1g\", \"type\": 3, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"拖拽事件-3ol\", \"type\": 4, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"直接输入-6f6u\", \"type\": 5, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"补充输入-3v20\", \"type\": 6, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"清空文本-2h1q\", \"type\": 7, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"上下滑动-2o10\", \"type\": 8, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [{\"role\": \"button\", \"type\": 1, \"element\": \"\", \"locator\": 1, \"page_type\": 1, \"locator_select\": 1}], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"上传文件-z1j\", \"type\": 18, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"if 事件-3f4y\", \"type\": 10, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"for 循环-162i\", \"type\": 11, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"等待事件-542j\", \"type\": 12, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}]', 5, 1, '2026-03-14 13:03:39', 1, '2026-03-14 18:35:19', NULL, 0, NULL);
INSERT INTO `web_management_scripts` VALUES ('[{\"name\": \"打开\", \"type\": 0, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"http://47.113.104.130:9966\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"输入用户名\", \"type\": 5, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"admin\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"请输入用户名\", \"locator\": 2, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 5, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"输入密码\", \"type\": 5, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"请输入密码\", \"locator\": 2, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 5, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}, {\"name\": \"左键点击登录按钮\", \"type\": 1, \"action\": {\"role\": \"button\", \"type\": 1, \"input\": \"\", \"assert\": [{\"role\": \"button\", \"type\": 1, \"element\": \"00\", \"locator\": 1, \"page_type\": 1, \"locator_select\": 1}], \"target\": \"\", \"cookies\": [], \"element\": \"//*[@id=\\\"app\\\"]/div/div[2]/div[2]/form/div[4]/div/button\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 7, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}]', 6, 2, '2026-03-14 18:35:39', 1, '2026-03-23 09:13:00', NULL, 0, NULL);
INSERT INTO `web_management_scripts` VALUES ('[{\"name\": \"打开\", \"type\": 0, \"action\": {\"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}]', 7, 3, '2026-03-14 21:27:06', 1, '2026-03-14 21:27:49', NULL, 0, NULL);
INSERT INTO `web_management_scripts` VALUES ('[{\"name\": \"打开\", \"type\": 0, \"action\": {\"type\": 1, \"input\": \"\", \"assert\": [], \"target\": \"\", \"cookies\": [], \"element\": \"\", \"locator\": 1, \"timeout\": 15, \"up_type\": 1, \"sway_type\": 1, \"target_id\": \"\", \"wait_time\": 1, \"after_wait\": 1, \"element_id\": null, \"before_wait\": 1, \"target_type\": 1, \"localstorage\": [], \"locator_select\": 1, \"target_locator\": 1, \"target_locator_select\": 1}, \"status\": true, \"children\": []}]', 9, 4, '2026-03-30 15:30:40', 1, '2026-03-30 16:43:50', NULL, 0, NULL);

SET FOREIGN_KEY_CHECKS = 1;
