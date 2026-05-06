#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

"""
用户管理模块
"""

from fastapi import APIRouter
from app.api.v1.system.user.controller import router

__all__ = ["router"]
