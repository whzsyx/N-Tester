"""
对话管理服务
"""
import uuid
from typing import List, Optional, Dict, Any
from sqlalchemy import select, func, desc
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime

from app.models.ai.conversation import ConversationModel
from app.models.ai.message import MessageModel
from app.services.ai.llm_service_langchain import get_llm_service, get_llm_service_by_id, LLMMessage
from .schema import (
    ConversationCreateRequest,
    ConversationUpdateRequest,
    SendMessageRequest
)


class ConversationService:
    """对话服务"""
    
    @staticmethod
    async def create_conversation(
        db: AsyncSession,
        user_id: int,
        data: ConversationCreateRequest
    ) -> ConversationModel:
        """创建对话"""
        # 生成会话ID
        session_id = str(uuid.uuid4())
        
        # 创建对话
        conversation = ConversationModel(
            session_id=session_id,
            title=data.title or "新对话",
            llm_config_id=data.llm_config_id,
            user_id=user_id,
            is_active=1,
            created_by=user_id,
            updated_by=user_id
        )
        
        db.add(conversation)
        await db.commit()
        await db.refresh(conversation)
        
        return conversation
    
    @staticmethod
    async def get_conversation_list(
        db: AsyncSession,
        user_id: int,
        skip: int = 0,
        limit: int = 20
    ) -> tuple[List[ConversationModel], int]:
        """获取对话列表"""
        # 查询总数
        count_stmt = select(func.count(ConversationModel.id)).where(
            ConversationModel.user_id == user_id,
            ConversationModel.enabled_flag == 1
        )
        result = await db.execute(count_stmt)
        total = result.scalar()
        
        # 查询列表
        stmt = select(ConversationModel).where(
            ConversationModel.user_id == user_id,
            ConversationModel.enabled_flag == 1
        ).order_by(desc(ConversationModel.updation_date)).offset(skip).limit(limit)
        
        result = await db.execute(stmt)
        conversations = result.scalars().all()
        
        return conversations, total
    
    @staticmethod
    async def get_conversation(
        db: AsyncSession,
        conversation_id: int,
        user_id: int
    ) -> Optional[ConversationModel]:
        """获取对话详情"""
        stmt = select(ConversationModel).where(
            ConversationModel.id == conversation_id,
            ConversationModel.user_id == user_id,
            ConversationModel.enabled_flag == 1
        )
        result = await db.execute(stmt)
        return result.scalar_one_or_none()
    
    @staticmethod
    async def update_conversation(
        db: AsyncSession,
        conversation_id: int,
        user_id: int,
        data: ConversationUpdateRequest
    ) -> Optional[ConversationModel]:
        """更新对话"""
        conversation = await ConversationService.get_conversation(db, conversation_id, user_id)
        if not conversation:
            return None
        
        # 更新字段
        if data.title is not None:
            conversation.title = data.title
        if data.llm_config_id is not None:
            conversation.llm_config_id = data.llm_config_id
        if data.is_active is not None:
            conversation.is_active = 1 if data.is_active else 0
        
        conversation.updated_by = user_id
        
        await db.commit()
        await db.refresh(conversation)
        
        return conversation
    
    @staticmethod
    async def delete_conversation(
        db: AsyncSession,
        conversation_id: int,
        user_id: int
    ) -> bool:
        """删除对话（软删除）"""
        conversation = await ConversationService.get_conversation(db, conversation_id, user_id)
        if not conversation:
            return False
        
        conversation.enabled_flag = 0
        conversation.updated_by = user_id
        
        await db.commit()
        return True
    
    @staticmethod
    async def get_message_count(
        db: AsyncSession,
        conversation_id: int
    ) -> int:
        """获取对话消息数量"""
        stmt = select(func.count(MessageModel.id)).where(
            MessageModel.conversation_id == conversation_id,
            MessageModel.enabled_flag == 1
        )
        result = await db.execute(stmt)
        return result.scalar()


class MessageService:
    """消息服务"""
    
    @staticmethod
    async def get_message_list(
        db: AsyncSession,
        conversation_id: int,
        user_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> tuple[List[MessageModel], int]:
        """获取消息列表"""
        # 验证对话权限
        conversation = await ConversationService.get_conversation(db, conversation_id, user_id)
        if not conversation:
            return [], 0
        
        # 查询总数
        count_stmt = select(func.count(MessageModel.id)).where(
            MessageModel.conversation_id == conversation_id,
            MessageModel.enabled_flag == 1
        )
        result = await db.execute(count_stmt)
        total = result.scalar()
        
        # 查询列表
        stmt = select(MessageModel).where(
            MessageModel.conversation_id == conversation_id,
            MessageModel.enabled_flag == 1
        ).order_by(MessageModel.creation_date).offset(skip).limit(limit)
        
        result = await db.execute(stmt)
        messages = result.scalars().all()
        
        return messages, total
    
    @staticmethod
    async def create_message(
        db: AsyncSession,
        conversation_id: int,
        user_id: int,
        role: str,
        content: str,
        message_type: str = "text",
        meta_data: Optional[Dict[str, Any]] = None,
        tokens_used: Optional[int] = None
    ) -> MessageModel:
        """创建消息"""
        message = MessageModel(
            conversation_id=conversation_id,
            role=role,
            content=content,
            message_type=message_type,
            meta_data=meta_data,
            tokens_used=tokens_used,
            created_by=user_id,
            updated_by=user_id
        )
        
        db.add(message)
        await db.commit()
        await db.refresh(message)
        
        return message
    
    @staticmethod
    async def send_message(
        db: AsyncSession,
        conversation_id: int,
        user_id: int,
        data: SendMessageRequest
    ) -> tuple[MessageModel, MessageModel, Optional[int]]:
        """发送消息并获取AI响应"""
        # 验证对话权限
        conversation = await ConversationService.get_conversation(db, conversation_id, user_id)
        if not conversation:
            raise ValueError("Conversation not found")
        
        # 1. 保存用户消息
        user_message = await MessageService.create_message(
            db, conversation_id, user_id, "user", data.content
        )
        
        # 2. 获取对话历史
        messages, _ = await MessageService.get_message_list(db, conversation_id, user_id, limit=50)
        
        # 3. 构建LLM消息列表
        llm_messages = []
        for msg in messages:
            llm_messages.append(LLMMessage(role=msg.role, content=msg.content))
        
        # 4. 调用LLM服务
        if conversation.llm_config_id:
            llm_service = await get_llm_service_by_id(conversation.llm_config_id)
        else:
            llm_service = await get_llm_service()
        
        response = await llm_service.chat_completion(
            messages=llm_messages,
            stream=False
        )
        
        # 5. 保存AI响应
        assistant_message = await MessageService.create_message(
            db,
            conversation_id,
            user_id,
            "assistant",
            response.content,
            tokens_used=response.total_tokens
        )
        
        # 6. 更新对话标题（如果是第一条消息）
        if not conversation.title or conversation.title == "新对话":
            # 使用用户第一条消息的前30个字符作为标题
            conversation.title = data.content[:30] + ("..." if len(data.content) > 30 else "")
            conversation.updated_by = user_id
            await db.commit()
        
        return user_message, assistant_message, response.total_tokens
    
    @staticmethod
    async def send_message_stream(
        db: AsyncSession,
        conversation_id: int,
        user_id: int,
        data: SendMessageRequest
    ):
        """发送消息并获取AI流式响应（生成器）"""
        # 验证对话权限
        conversation = await ConversationService.get_conversation(db, conversation_id, user_id)
        if not conversation:
            raise ValueError("Conversation not found")
        
        # 1. 保存用户消息
        user_message = await MessageService.create_message(
            db, conversation_id, user_id, "user", data.content
        )
        
        # 发送用户消息事件
        yield {
            "type": "user_message",
            "data": {
                "id": user_message.id,
                "role": "user",
                "content": user_message.content,
                "creation_date": user_message.creation_date.isoformat()
            }
        }
        
        # 2. 获取对话历史
        messages, _ = await MessageService.get_message_list(db, conversation_id, user_id, limit=50)
        
        # 3. 构建LLM消息列表
        llm_messages = []
        for msg in messages:
            llm_messages.append(LLMMessage(role=msg.role, content=msg.content))
        
        # 4. 调用LLM服务（流式）
        if conversation.llm_config_id:
            llm_service = await get_llm_service_by_id(conversation.llm_config_id)
        else:
            llm_service = await get_llm_service()
        
        # 收集完整的响应内容
        full_content = ""
        
        # 流式获取响应
        stream = await llm_service.chat_completion(
            messages=llm_messages,
            stream=True
        )
        
        async for chunk in stream:
            full_content += chunk
            # 发送内容块事件
            yield {
                "type": "content",
                "data": {
                    "content": chunk
                }
            }
        
        # 5. 保存AI响应
        assistant_message = await MessageService.create_message(
            db,
            conversation_id,
            user_id,
            "assistant",
            full_content,
            tokens_used=len(full_content)  # 简单估算，实际应该从LLM响应中获取
        )
        
        # 发送完成事件
        yield {
            "type": "assistant_message",
            "data": {
                "id": assistant_message.id,
                "role": "assistant",
                "content": assistant_message.content,
                "tokens_used": assistant_message.tokens_used,
                "creation_date": assistant_message.creation_date.isoformat()
            }
        }
        
        # 6. 更新对话标题（如果是第一条消息）
        if not conversation.title or conversation.title == "新对话":
            conversation.title = data.content[:30] + ("..." if len(data.content) > 30 else "")
            conversation.updated_by = user_id
            await db.commit()

