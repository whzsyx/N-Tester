"""
项目管理数据模型
"""

from sqlalchemy import Column, String, Text, Integer, ForeignKey, JSON, Boolean, Index, BigInteger
from sqlalchemy.orm import relationship
from app.models.base import Base


class ProjectModel(Base):
    """项目模型"""
    
    __tablename__ = "projects"
    __table_args__ = (
        Index("idx_project_owner", "owner_id"),
        Index("idx_project_status", "status"),
        {'comment': '项目表', 'mysql_charset': 'utf8mb4'}
    )
    
    name = Column(String(200), nullable=False, comment="项目名称")
    description = Column(Text, comment="项目描述")
    status = Column(String(20), default="active", comment="状态: active/paused/completed/archived")
    owner_id = Column(BigInteger, ForeignKey("sys_user.id"), nullable=False, comment="负责人ID")
    
    # 关系
    owner = relationship("UserModel", foreign_keys=[owner_id])
    members = relationship("ProjectMemberModel", back_populates="project", cascade="all, delete-orphan")
    environments = relationship("ProjectEnvironmentModel", back_populates="project", cascade="all, delete-orphan")


class ProjectMemberModel(Base):
    """项目成员模型"""
    
    __tablename__ = "project_members"
    __table_args__ = (
        Index("idx_pm_project_user", "project_id", "user_id", unique=True),
        Index("idx_pm_user", "user_id"),
        {'comment': '项目成员表', 'mysql_charset': 'utf8mb4'}
    )
    
    project_id = Column(BigInteger, ForeignKey("projects.id", ondelete="CASCADE"), nullable=False, comment="项目ID")
    user_id = Column(BigInteger, ForeignKey("sys_user.id", ondelete="CASCADE"), nullable=False, comment="用户ID")
    role = Column(String(20), default="tester", comment="角色: owner/admin/developer/tester/viewer")
    
    # 关系
    project = relationship("ProjectModel", back_populates="members")
    user = relationship("UserModel")


class ProjectEnvironmentModel(Base):
    """项目环境模型"""
    
    __tablename__ = "project_environments"
    __table_args__ = (
        Index("idx_pe_project", "project_id"),
        {'comment': '项目环境表', 'mysql_charset': 'utf8mb4'}
    )
    
    project_id = Column(BigInteger, ForeignKey("projects.id", ondelete="CASCADE"), nullable=False, comment="项目ID")
    name = Column(String(100), nullable=False, comment="环境名称")
    base_url = Column(String(500), comment="基础URL")
    description = Column(Text, comment="环境描述")
    variables = Column(JSON, comment="环境变量")
    is_default = Column(Boolean, default=False, comment="是否默认")
    
    # 关系
    project = relationship("ProjectModel", back_populates="environments")
