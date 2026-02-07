-- API测试模块数据表创建脚本
-- 创建时间: 2026-02-06

-- 1. API项目表
CREATE TABLE IF NOT EXISTS api_projects (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    project_id BIGINT NOT NULL COMMENT '关联项目ID',
    name VARCHAR(200) NOT NULL COMMENT 'API项目名称',
    description TEXT COMMENT '项目描述',
    project_type VARCHAR(20) DEFAULT 'HTTP' COMMENT '类型: HTTP/WEBSOCKET',
    base_url VARCHAR(500) COMMENT '基础URL',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_project (project_id),
    INDEX idx_enabled (enabled_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API项目表';

-- 2. API集合表
CREATE TABLE IF NOT EXISTS api_collections (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    api_project_id BIGINT NOT NULL COMMENT 'API项目ID',
    name VARCHAR(200) NOT NULL COMMENT '集合名称',
    description TEXT COMMENT '集合描述',
    parent_id BIGINT COMMENT '父级集合ID',
    order_num INT DEFAULT 0 COMMENT '排序',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_api_project (api_project_id),
    INDEX idx_parent (parent_id),
    INDEX idx_enabled (enabled_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API集合表';

-- 3. API请求表
CREATE TABLE IF NOT EXISTS api_requests (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    collection_id BIGINT NOT NULL COMMENT '所属集合ID',
    name VARCHAR(200) NOT NULL COMMENT '请求名称',
    description TEXT COMMENT '请求描述',
    request_type VARCHAR(20) DEFAULT 'HTTP' COMMENT '请求类型: HTTP/WEBSOCKET',
    method VARCHAR(10) DEFAULT 'GET' COMMENT '请求方法: GET/POST/PUT/DELETE/PATCH/HEAD/OPTIONS',
    url TEXT NOT NULL COMMENT '请求URL',
    headers JSON COMMENT '请求头',
    params JSON COMMENT 'URL参数',
    body JSON COMMENT '请求体',
    auth JSON COMMENT '认证信息',
    pre_request_script TEXT COMMENT '请求前脚本',
    post_request_script TEXT COMMENT '请求后脚本',
    assertions JSON COMMENT '断言规则',
    order_num INT DEFAULT 0 COMMENT '排序',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_collection (collection_id),
    INDEX idx_enabled (enabled_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API请求表';

-- 4. API环境变量表
CREATE TABLE IF NOT EXISTS api_environments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    project_id BIGINT NOT NULL COMMENT '关联项目ID',
    name VARCHAR(200) NOT NULL COMMENT '环境名称',
    scope VARCHAR(10) DEFAULT 'LOCAL' COMMENT '作用域: GLOBAL/LOCAL',
    variables JSON COMMENT '环境变量',
    is_active BOOLEAN DEFAULT FALSE COMMENT '是否激活',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_project (project_id),
    INDEX idx_enabled (enabled_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API环境变量表';

-- 5. API请求历史表
CREATE TABLE IF NOT EXISTS api_request_histories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    request_id BIGINT NOT NULL COMMENT '关联请求ID',
    environment_id BIGINT COMMENT '使用环境ID',
    request_data JSON COMMENT '请求数据',
    response_data JSON COMMENT '响应数据',
    status_code INT COMMENT '状态码',
    response_time FLOAT COMMENT '响应时间(ms)',
    error_message TEXT COMMENT '错误信息',
    assertions_results JSON COMMENT '断言结果',
    executed_by BIGINT NOT NULL COMMENT '执行者ID',
    executed_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '执行时间',
    
    INDEX idx_request (request_id),
    INDEX idx_executed_at (executed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API请求历史表';

-- 6. API测试套件表
CREATE TABLE IF NOT EXISTS api_test_suites (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    api_project_id BIGINT NOT NULL COMMENT 'API项目ID',
    name VARCHAR(200) NOT NULL COMMENT '套件名称',
    description TEXT COMMENT '套件描述',
    environment_id BIGINT COMMENT '执行环境ID',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    INDEX idx_api_project (api_project_id),
    INDEX idx_enabled (enabled_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API测试套件表';

-- 7. 套件请求关联表
CREATE TABLE IF NOT EXISTS api_test_suite_requests (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    test_suite_id BIGINT NOT NULL COMMENT '测试套件ID',
    request_id BIGINT NOT NULL COMMENT 'API请求ID',
    order_num INT DEFAULT 0 COMMENT '执行顺序',
    assertions JSON COMMENT '断言规则',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人ID',
    updation_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by BIGINT COMMENT '更新人ID',
    enabled_flag TINYINT DEFAULT 1 COMMENT '启用标志: 0-禁用, 1-启用',
    trace_id VARCHAR(50) COMMENT '追踪ID',
    
    UNIQUE KEY uk_suite_request (test_suite_id, request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='套件请求关联表';

-- 8. API测试执行表
CREATE TABLE IF NOT EXISTS api_test_executions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    test_suite_id BIGINT NOT NULL COMMENT '测试套件ID',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '执行状态: PENDING/RUNNING/SUCCESS/FAILED',
    start_time DATETIME COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    total_requests INT DEFAULT 0 COMMENT '总请求数',
    passed_requests INT DEFAULT 0 COMMENT '通过请求数',
    failed_requests INT DEFAULT 0 COMMENT '失败请求数',
    results JSON COMMENT '执行结果',
    executed_by BIGINT NOT NULL COMMENT '执行者ID',
    
    -- 基础字段
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_suite (test_suite_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API测试执行表';
