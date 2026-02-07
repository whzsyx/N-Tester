# -*- coding: utf-8 -*-
"""
编码生成器数据模型
"""
from typing import Optional, List
from pydantic import BaseModel, Field


class GenerateCodeRequest(BaseModel):
    """生成编码请求"""
    prefix: str = Field(default='', description="前缀")
    separator: str = Field(default='', description="分隔符")
    generate_mode: str = Field(default='date_seq', description="生成方式")
    date_format: str = Field(default='YYYYMMDD', description="日期格式")
    seq_length: int = Field(default=4, ge=1, le=10, description="序号位数")
    seq_reset_rule: str = Field(default='daily', description="序号重置规则")
    random_length: int = Field(default=6, ge=4, le=32, description="随机字符长度")
    custom_template: str = Field(default='', description="自定义模板")
    business_type: str = Field(default='default', description="业务类型")


class GenerateCodeResponse(BaseModel):
    """生成编码响应"""
    code: str = Field(..., description="生成的编码")


class GenerateModeItem(BaseModel):
    """生成方式选项"""
    value: str = Field(..., description="值")
    label: str = Field(..., description="标签")
    example: str = Field(..., description="示例")


class ResetRuleItem(BaseModel):
    """重置规则选项"""
    value: str = Field(..., description="值")
    label: str = Field(..., description="标签")


class GenerateModesResponse(BaseModel):
    """生成方式列表响应"""
    modes: List[GenerateModeItem] = Field(..., description="生成方式列表")
    reset_rules: List[ResetRuleItem] = Field(..., description="重置规则列表")
