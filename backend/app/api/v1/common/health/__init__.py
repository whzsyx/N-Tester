#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort
"""
健康检查模块
"""

from fastapi import APIRouter
from app.api.v1.common.health.controller import router

__all__ = ["router"]
