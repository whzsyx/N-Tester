#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

"""
部门管理模块
"""

from fastapi import APIRouter
from app.api.v1.system.dept.controller import router

__all__ = ["router"]
