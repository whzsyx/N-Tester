#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: Rebort

import random
import string
import uuid
import re
from datetime import datetime
from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.v1.system.code_generator.model import CodeSequenceModel


class CodeGeneratorService:
    """编码生成服务"""

    GENERATE_MODES = {
        'datetime': '日期时间',
        'date_seq': '日期+序号',
        'uuid': 'UUID片段',
        'snowflake': '雪花ID',
        'random': '随机字符',
        'custom': '自定义模板',
    }

    SEQ_RESET_RULES = {
        'daily': '每日重置',
        'monthly': '每月重置',
        'yearly': '每年重置',
        'never': '不重置',
    }

    @classmethod
    async def generate(
            cls,
            prefix: str = '',
            separator: str = '',
            generate_mode: str = 'date_seq',
            date_format: str = 'YYYYMMDD',
            seq_length: int = 4,
            seq_reset_rule: str = 'daily',
            random_length: int = 6,
            custom_template: str = '',
            business_type: str = 'default',
            db: AsyncSession = None,
    ) -> str:
        """
        生成编码
        
        Args:
            prefix: 前缀
            separator: 分隔符
            generate_mode: 生成方式
            date_format: 日期格式
            seq_length: 序号位数
            seq_reset_rule: 序号重置规则
            random_length: 随机字符长度
            custom_template: 自定义模板
            business_type: 业务类型
            db: 数据库会话
        
        Returns:
            生成的编码
        """
        now = datetime.now()

        if generate_mode == 'datetime':
            return cls._generate_datetime(prefix, separator, date_format, now)
        elif generate_mode == 'date_seq':
            return await cls._generate_date_seq(
                prefix, separator, date_format, seq_length,
                seq_reset_rule, business_type, now, db
            )
        elif generate_mode == 'uuid':
            return cls._generate_uuid(prefix, separator)
        elif generate_mode == 'snowflake':
            return cls._generate_snowflake(prefix, separator)
        elif generate_mode == 'random':
            return cls._generate_random(prefix, separator, random_length)
        elif generate_mode == 'custom':
            return await cls._generate_custom(
                prefix, separator, custom_template, seq_length,
                seq_reset_rule, business_type, now, db
            )
        else:
            return await cls._generate_date_seq(
                prefix, separator, date_format, seq_length,
                seq_reset_rule, business_type, now, db
            )

    @classmethod
    def _convert_date_format(cls, date_format: str) -> str:
        """将前端日期格式转换为 Python strftime 格式"""
        mapping = {
            'YYYY': '%Y',
            'YY': '%y',
            'MM': '%m',
            'DD': '%d',
            'HH': '%H',
            'mm': '%M',
            'ss': '%S',
        }
        result = date_format
        for key, value in mapping.items():
            result = result.replace(key, value)
        return result

    @classmethod
    def _generate_datetime(
            cls, prefix: str, separator: str, date_format: str, now: datetime
    ) -> str:
        """生成日期时间格式编码: PREFIX20241222103000"""
        py_format = cls._convert_date_format(date_format + 'HHmmss')
        date_str = now.strftime(py_format)

        if prefix:
            return f'{prefix}{separator}{date_str}'
        return date_str

    @classmethod
    async def _generate_date_seq(
            cls, prefix: str, separator: str, date_format: str,
            seq_length: int, seq_reset_rule: str, business_type: str, 
            now: datetime, db: AsyncSession
    ) -> str:
        """生成日期+序号格式编码: PREFIX20241222-0001"""
        py_format = cls._convert_date_format(date_format)
        date_str = now.strftime(py_format)

        # 获取日期键（用于序号重置）
        date_key = cls._get_date_key(seq_reset_rule, now)

        # 获取下一个序号
        seq = await cls._get_next_sequence(business_type, prefix, date_key, db)
        seq_str = str(seq).zfill(seq_length)

        parts = []
        if prefix:
            parts.append(prefix)
        parts.append(date_str)
        parts.append(seq_str)

        return separator.join(parts) if separator else ''.join(parts)

    @classmethod
    def _generate_uuid(cls, prefix: str, separator: str) -> str:
        """生成 UUID 片段格式编码: PREFIX-a1b2c3d4"""
        uuid_str = uuid.uuid4().hex[:8]

        if prefix:
            return f'{prefix}{separator}{uuid_str}'
        return uuid_str

    @classmethod
    def _generate_snowflake(cls, prefix: str, separator: str) -> str:
        """生成雪花ID格式编码（简化版）"""
        # 简化版雪花ID：时间戳 + 随机数
        timestamp = int(datetime.now().timestamp() * 1000)
        random_part = random.randint(1000, 9999)
        snowflake_id = f'{timestamp}{random_part}'

        if prefix:
            return f'{prefix}{separator}{snowflake_id}'
        return snowflake_id

    @classmethod
    def _generate_random(cls, prefix: str, separator: str, length: int) -> str:
        """生成随机字符格式编码: PREFIX-X7K9M2"""
        chars = string.ascii_uppercase + string.digits
        random_str = ''.join(random.choices(chars, k=length))

        if prefix:
            return f'{prefix}{separator}{random_str}'
        return random_str

    @classmethod
    async def _generate_custom(
            cls, prefix: str, separator: str, template: str,
            seq_length: int, seq_reset_rule: str, business_type: str, 
            now: datetime, db: AsyncSession
    ) -> str:
        """
        生成自定义模板格式编码
        
        模板变量:
        - {PREFIX}: 前缀
        - {YYYY}: 4位年份
        - {YY}: 2位年份
        - {MM}: 月份
        - {DD}: 日期
        - {HH}: 小时
        - {mm}: 分钟
        - {ss}: 秒
        - {SEQ}: 序号
        - {SEQ:N}: N位序号
        - {UUID}: UUID片段
        - {RANDOM}: 随机字符
        - {RANDOM:N}: N位随机字符
        """
        if not template:
            return await cls._generate_date_seq(
                prefix, separator, 'YYYYMMDD', seq_length,
                seq_reset_rule, business_type, now, db
            )

        result = template

        # 替换前缀
        result = result.replace('{PREFIX}', prefix)

        # 替换日期时间
        result = result.replace('{YYYY}', now.strftime('%Y'))
        result = result.replace('{YY}', now.strftime('%y'))
        result = result.replace('{MM}', now.strftime('%m'))
        result = result.replace('{DD}', now.strftime('%d'))
        result = result.replace('{HH}', now.strftime('%H'))
        result = result.replace('{mm}', now.strftime('%M'))
        result = result.replace('{ss}', now.strftime('%S'))

        # 替换序号
        seq_match = re.search(r'\{SEQ(?::(\d+))?\}', result)
        if seq_match:
            length = int(seq_match.group(1)) if seq_match.group(1) else seq_length
            date_key = cls._get_date_key(seq_reset_rule, now)
            seq = await cls._get_next_sequence(business_type, prefix, date_key, db)
            seq_str = str(seq).zfill(length)
            result = re.sub(r'\{SEQ(?::\d+)?\}', seq_str, result)

        # 替换 UUID
        result = result.replace('{UUID}', uuid.uuid4().hex[:8])

        # 替换随机字符
        random_match = re.search(r'\{RANDOM(?::(\d+))?\}', result)
        if random_match:
            length = int(random_match.group(1)) if random_match.group(1) else 6
            chars = string.ascii_uppercase + string.digits
            random_str = ''.join(random.choices(chars, k=length))
            result = re.sub(r'\{RANDOM(?::\d+)?\}', random_str, result)

        return result

    @classmethod
    def _get_date_key(cls, reset_rule: str, now: datetime) -> str:
        """根据重置规则获取日期键"""
        if reset_rule == 'daily':
            return now.strftime('%Y%m%d')
        elif reset_rule == 'monthly':
            return now.strftime('%Y%m')
        elif reset_rule == 'yearly':
            return now.strftime('%Y')
        else:  # never
            return 'all'

    @classmethod
    async def _get_next_sequence(
            cls, business_type: str, prefix: str, date_key: str, db: AsyncSession
    ) -> int:
        """获取下一个序号（并发安全）"""
        # 使用 with_for_update 确保并发安全
        stmt = select(CodeSequenceModel).where(
            CodeSequenceModel.business_type == business_type,
            CodeSequenceModel.prefix == prefix,
            CodeSequenceModel.date_key == date_key
        ).with_for_update()
        
        result = await db.execute(stmt)
        seq_obj = result.scalar_one_or_none()
        
        if not seq_obj:
            # 创建新记录
            seq_obj = CodeSequenceModel(
                business_type=business_type,
                prefix=prefix,
                date_key=date_key,
                current_seq=1
            )
            db.add(seq_obj)
            await db.commit()
            await db.refresh(seq_obj)
            return 1
        else:
            # 更新序号
            seq_obj.current_seq += 1
            await db.commit()
            await db.refresh(seq_obj)
            return seq_obj.current_seq
