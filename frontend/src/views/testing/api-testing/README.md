# API测试模块 - 前端使用说明

## 功能概述

API测试模块提供了类似Postman的API测试功能，包括：

1. **API项目管理** - 创建和管理API项目
2. **集合管理** - 组织API请求的树形结构
3. **请求编辑器** - 完整的HTTP请求编辑功能
4. **环境变量** - 管理不同环境的配置
5. **测试套件** - 批量执行API测试
6. **执行历史** - 查看请求执行记录

## 页面结构

```
api-testing/
├── index.vue                          # 主页面
├── components/
│   ├── RequestEditor.vue              # 请求编辑器
│   ├── KeyValueEditor.vue             # 键值对编辑器
│   ├── AssertionEditor.vue            # 断言编辑器
│   ├── ApiProjectDialog.vue           # API项目对话框
│   ├── CollectionDialog.vue           # 集合对话框
│   ├── RequestDialog.vue              # 请求对话框
│   ├── EnvironmentDialog.vue          # 环境管理对话框
│   └── TestSuiteDialog.vue            # 测试套件对话框
└── README.md                          # 本文档
```

## 使用流程

### 1. 创建API项目

1. 点击顶部工具栏的"新建API项目"按钮
2. 填写项目名称、类型（HTTP/WebSocket）、基础URL等信息
3. 保存后在下拉框中选择该项目

### 2. 创建集合

1. 选择API项目后，点击左侧"API集合"卡片的"+"按钮
2. 输入集合名称和描述
3. 集合可以嵌套，支持树形结构

### 3. 创建请求

1. 在集合树中，点击集合节点的"+"按钮
2. 填写请求名称、方法、URL等基本信息
3. 保存后可以在右侧编辑器中详细配置

### 4. 编辑请求

请求编辑器包含以下标签页：

- **Params** - URL查询参数
- **Headers** - 请求头
- **Body** - 请求体（支持JSON、Form Data）
- **Auth** - 认证配置（Bearer Token、Basic Auth、API Key）
- **Pre-request Script** - 请求前执行的脚本
- **Post-request Script** - 请求后执行的脚本
- **Assertions** - 断言规则

### 5. 执行请求

1. 配置好请求后，点击"发送"按钮
2. 响应结果会显示在下方，包括：
   - 状态码和响应时间
   - 响应体（自动格式化JSON）
   - 响应头
   - 断言结果

### 6. 环境管理

1. 点击顶部工具栏的"环境管理"按钮
2. 创建不同的环境（开发、测试、生产等）
3. 为每个环境配置变量（如base_url、api_key等）
4. 激活需要使用的环境
5. 在请求中使用 `{{variable_name}}` 引用环境变量

### 7. 测试套件

1. 点击顶部工具栏的"测试套件"按钮
2. 创建测试套件，选择要执行的请求
3. 配置执行环境
4. 点击"执行"按钮批量运行测试
5. 查看执行结果和统计信息

## 高级功能

### 脚本功能

在Pre-request Script和Post-request Script中可以使用JavaScript代码：

```javascript
// 访问环境变量
context.env.api_key

// 设置环境变量
context.env.token = 'new_token_value'

// 访问请求数据（仅Post-request Script）
context.request.url
context.request.method

// 访问响应数据（仅Post-request Script）
context.response.status_code
context.response.body
```

### 断言类型

支持以下断言类型：

- **状态码** - 验证HTTP状态码
- **响应时间** - 验证响应时间
- **JSONPath** - 使用JSONPath表达式验证响应数据
- **包含文本** - 验证响应体是否包含指定文本
- **响应头** - 验证响应头的值

### 变量引用

在请求的URL、Headers、Params、Body中都可以使用 `{{variable_name}}` 引用环境变量。

## 路由配置

需要在路由配置中添加：

```typescript
{
  path: '/testing/api-testing',
  name: 'ApiTesting',
  component: () => import('@/views/testing/api-testing/index.vue'),
  meta: {
    title: 'API测试',
    icon: 'ele-Connection'
  }
}
```

## 注意事项

1. 请求执行前会自动保存当前编辑的内容
2. 删除集合会同时删除其下的所有请求
3. 环境变量的作用域分为全局（GLOBAL）和本地（LOCAL）
4. 测试套件执行时会按照请求的顺序依次执行
5. 脚本执行在受限的沙箱环境中，只能访问有限的API

## 待实现功能

- [ ] 导入/导出Postman Collection
- [ ] 请求历史记录查看
- [ ] Mock服务器
- [ ] 性能测试
- [ ] 协作功能
