#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

from typing import Optional, List
from pydantic import Field
from app.core.base_schema import BaseSchema, TimestampSchema


class DeptCreateSchema(BaseSchema):
    """部门创建Schema"""
    
    dept_name: str = Field(..., min_length=1, max_length=100, description="部门名称")
    dept_code: Optional[str] = Field(None, max_length=64, description="部门编码")
    parent_id: int = Field(0, ge=0, description="父部门ID")
    
    leader_id: Optional[int] = Field(None, description="负责人ID")
    phone: Optional[str] = Field(None, max_length=20, description="联系电话")
    email: Optional[str] = Field(None, max_length=100, description="邮箱")
    
    sort: int = Field(0, ge=0, description="排序")
    status: int = Field(1, ge=0, le=1, description="状态")
    description: Optional[str] = Field(None, max_length=500, description="部门描述")


class DeptUpdateSchema(BaseSchema):
    """部门更新Schema"""
    
    dept_name: Optional[str] = Field(None, min_length=1, max_length=100, description="部门名称")
    dept_code: Optional[str] = Field(None, max_length=64, description="部门编码")
    parent_id: Optional[int] = Field(None, ge=0, description="父部门ID")
    
    leader_id: Optional[int] = Field(None, description="负责人ID")
    phone: Optional[str] = Field(None, max_length=20, description="联系电话")
    email: Optional[str] = Field(None, max_length=100, description="邮箱")
    
    sort: Optional[int] = Field(None, ge=0, description="排序")
    status: Optional[int] = Field(None, ge=0, le=1, description="状态")
    description: Optional[str] = Field(None, max_length=500, description="部门描述")


class DeptOutSchema(TimestampSchema):
    """部门输出Schema"""
    
    id: int = Field(..., description="部门ID")
    dept_name: str = Field(..., description="部门名称")
    dept_code: Optional[str] = Field(None, description="部门编码")
    parent_id: int = Field(..., description="父部门ID")
    ancestors: Optional[str] = Field(None, description="祖级列表")
    
    leader_id: Optional[int] = Field(None, description="负责人ID")
    leader_name: Optional[str] = Field(None, description="负责人姓名")
    phone: Optional[str] = Field(None, description="联系电话")
    email: Optional[str] = Field(None, description="邮箱")
    
    sort: int = Field(..., description="排序")
    status: int = Field(..., description="状态")
    description: Optional[str] = Field(None, description="部门描述")
    
    children: Optional[List['DeptOutSchema']] = Field(None, description="子部门列表")


class DeptTreeSchema(BaseSchema):
    """部门树Schema"""
    
    id: int = Field(..., description="部门ID")
    label: str = Field(..., description="部门名称")
    parent_id: int = Field(..., description="父部门ID")
    children: Optional[List['DeptTreeSchema']] = Field(None, description="子部门")
