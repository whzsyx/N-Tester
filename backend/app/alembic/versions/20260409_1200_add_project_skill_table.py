"""add project skill table

Revision ID: a1b2c3d4e5f6
Revises: 83dceeccadc0
Create Date: 2026-04-09 12:00:00.000000
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "a1b2c3d4e5f6"
down_revision: Union[str, None] = "83dceeccadc0"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "project_skill",
        sa.Column("project_id", sa.BigInteger(), nullable=False, comment="项目ID"),
        sa.Column("user_id", sa.BigInteger(), nullable=False, comment="所属用户"),
        sa.Column("name", sa.String(length=255), nullable=False, comment="技能名称"),
        sa.Column("description", sa.Text(), nullable=True, comment="技能描述"),
        sa.Column("scenario_category", sa.String(length=100), nullable=True, comment="场景分类，如agent-browser-skill"),
        sa.Column("source_type", sa.String(length=30), nullable=False, comment="来源类型 builtin/github/gitee/upload"),
        sa.Column("repo_url", sa.String(length=2048), nullable=True, comment="仓库URL"),
        sa.Column("skill_path", sa.String(length=2000), nullable=True, comment="技能本地目录"),
        sa.Column("entry_command", sa.String(length=500), nullable=True, comment="执行命令"),
        sa.Column("is_active", sa.Boolean(), nullable=True, comment="是否启用"),
        sa.Column("extra_config", sa.JSON(), nullable=True, comment="附加配置"),
        sa.Column("id", sa.BigInteger(), autoincrement=True, nullable=False, comment="主键"),
        sa.Column("creation_date", sa.DateTime(), nullable=True, comment="创建时间"),
        sa.Column("created_by", sa.BigInteger(), nullable=True, comment="创建人ID"),
        sa.Column("updation_date", sa.DateTime(), nullable=True, comment="更新时间"),
        sa.Column("updated_by", sa.BigInteger(), nullable=True, comment="更新人ID"),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, comment="是否删除, 0 删除 1 非删除"),
        sa.Column("trace_id", sa.String(length=255), nullable=True, comment="trace_id"),
        sa.ForeignKeyConstraint(["project_id"], ["projects.id"], name="fk_ps_project", use_alter=True),
        sa.ForeignKeyConstraint(["user_id"], ["sys_user.id"], name="fk_ps_user", use_alter=True),
        sa.PrimaryKeyConstraint("id"),
        comment="项目技能表",
        mysql_charset="utf8mb4",
    )
    op.create_index("idx_project_skill_project", "project_skill", ["project_id"], unique=False)
    op.create_index("idx_project_skill_user", "project_skill", ["user_id"], unique=False)
    op.create_index(
        "uq_project_skill_user_project_name",
        "project_skill",
        ["user_id", "project_id", "name"],
        unique=True,
    )


def downgrade() -> None:
    op.drop_index("uq_project_skill_user_project_name", table_name="project_skill")
    op.drop_index("idx_project_skill_user", table_name="project_skill")
    op.drop_index("idx_project_skill_project", table_name="project_skill")
    op.drop_table("project_skill")

