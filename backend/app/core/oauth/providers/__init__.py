# -*- coding: utf-8 -*-
"""
OAuth 提供商实现
"""
from app.core.oauth.providers.gitee import GiteeOAuthService
from app.core.oauth.providers.github import GitHubOAuthService
from app.core.oauth.providers.qq import QQOAuthService
from app.core.oauth.providers.google import GoogleOAuthService
from app.core.oauth.providers.wechat import WeChatOAuthService
from app.core.oauth.providers.microsoft import MicrosoftOAuthService
from app.core.oauth.providers.dingtalk import DingTalkOAuthService
from app.core.oauth.providers.feishu import FeishuOAuthService

__all__ = [
    'GiteeOAuthService',
    'GitHubOAuthService',
    'QQOAuthService',
    'GoogleOAuthService',
    'WeChatOAuthService',
    'MicrosoftOAuthService',
    'DingTalkOAuthService',
    'FeishuOAuthService',
]
