-- 添加历史记录的环境名称和断言通过字段
-- 2026-02-07

-- 添加environment_name字段
ALTER TABLE api_request_histories ADD COLUMN environment_name VARCHAR(200) COMMENT '环境名称';

-- 添加assertions_passed字段
ALTER TABLE api_request_histories ADD COLUMN assertions_passed TINYINT(1) COMMENT '断言是否通过';

-- 更新现有数据的assertions_passed字段（根据assertions_results计算）
-- 如果assertions_results为空或NULL，设置为NULL
-- 如果所有断言都通过，设置为1，否则设置为0
UPDATE api_request_histories 
SET assertions_passed = CASE 
    WHEN assertions_results IS NULL OR JSON_LENGTH(assertions_results) = 0 THEN NULL
    WHEN JSON_SEARCH(assertions_results, 'one', 0, NULL, '$[*].passed') IS NOT NULL THEN 0
    ELSE 1
END
WHERE assertions_passed IS NULL;
