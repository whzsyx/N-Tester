-- 第二阶段：测试用例管理 + 版本管理模块
-- 创建时间：2026-02-06

-- 1. 测试用例表
CREATE TABLE IF NOT EXISTS test_cases (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    title VARCHAR(500) NOT NULL COMMENT '用例标题',
    description TEXT COMMENT '用例描述',
    preconditions TEXT COMMENT '前置条件',
    expected_result TEXT COMMENT '预期结果',
    priority VARCHAR(20) DEFAULT 'medium' COMMENT '优先级: low/medium/high/critical',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态: draft/active/deprecated',
    test_type VARCHAR(20) DEFAULT 'functional' COMMENT '类型: functional/integration/api/ui/performance/security',
    tags JSON COMMENT '标签',
    author_id BIGINT NOT NULL COMMENT '作者ID',
    assignee_id BIGINT COMMENT '指派人ID',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_project (project_id),
    INDEX idx_author (author_id),
    INDEX idx_status (status),
    INDEX idx_enabled (enabled_flag),
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测试用例表';

-- 2. 测试用例步骤表
CREATE TABLE IF NOT EXISTS test_case_steps (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    test_case_id BIGINT NOT NULL COMMENT '测试用例ID',
    step_number INT NOT NULL COMMENT '步骤序号',
    action TEXT NOT NULL COMMENT '操作',
    expected TEXT NOT NULL COMMENT '预期结果',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
    
    UNIQUE KEY uk_case_step (test_case_id, step_number),
    INDEX idx_case (test_case_id),
    INDEX idx_enabled (enabled_flag),
    FOREIGN KEY (test_case_id) REFERENCES test_cases(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测试用例步骤表';

-- 3. 版本表
CREATE TABLE IF NOT EXISTS versions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    name VARCHAR(100) NOT NULL COMMENT '版本名称',
    description TEXT COMMENT '版本描述',
    is_baseline BOOLEAN DEFAULT FALSE COMMENT '是否基线版本',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT NOT NULL COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_enabled (enabled_flag),
    INDEX idx_baseline (is_baseline)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='版本表';

-- 4. 项目版本关联表
CREATE TABLE IF NOT EXISTS project_versions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    version_id BIGINT NOT NULL COMMENT '版本ID',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
    
    UNIQUE KEY uk_project_version (project_id, version_id),
    INDEX idx_project (project_id),
    INDEX idx_version (version_id),
    INDEX idx_enabled (enabled_flag),
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目版本关联表';

-- 5. 用例版本关联表
CREATE TABLE IF NOT EXISTS test_case_versions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    test_case_id BIGINT NOT NULL COMMENT '测试用例ID',
    version_id BIGINT NOT NULL COMMENT '版本ID',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 1启用 0禁用',
    
    UNIQUE KEY uk_case_version (test_case_id, version_id),
    INDEX idx_case (test_case_id),
    INDEX idx_version (version_id),
    INDEX idx_enabled (enabled_flag),
    FOREIGN KEY (test_case_id) REFERENCES test_cases(id) ON DELETE CASCADE,
    FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用例版本关联表';
