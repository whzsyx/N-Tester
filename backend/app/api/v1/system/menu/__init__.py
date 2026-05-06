#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

"""
菜单管理模块
"""

from fastapi import APIRouter
from app.api.v1.system.menu.controller import router

__all__ = ["router"]
