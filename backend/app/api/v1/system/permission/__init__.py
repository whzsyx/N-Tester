#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
"""
权限管理模块
"""

from fastapi import APIRouter
from app.api.v1.system.permission.controller import router

__all__ = ["router"]
