"""add api_automation_perf_reports

Revision ID: a1b2c3d4e5f6
Revises: 74c098babcee
Create Date: 2026-05-09

"""
from alembic import op
import sqlalchemy as sa


revision = "a1b2c3d4e5f6"
down_revision = "74c098babcee"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "api_automation_perf_reports",
        sa.Column("api_id", sa.BigInteger(), nullable=False, comment="接口ID"),
        sa.Column("api_service_id", sa.BigInteger(), nullable=True, comment="服务ID"),
        sa.Column("env_id", sa.BigInteger(), nullable=True, comment="环境ID"),
        sa.Column("title", sa.String(length=255), nullable=True, comment="报告标题"),
        sa.Column("perf_config", sa.JSON(), nullable=True, comment="压测参数"),
        sa.Column("summary", sa.JSON(), nullable=True, comment="汇总指标"),
        sa.Column("detail", sa.JSON(), nullable=True, comment="扩展明细"),
        sa.Column("id", sa.BigInteger(), autoincrement=True, nullable=False, comment="主键"),
        sa.Column("creation_date", sa.DateTime(), nullable=True, comment="创建时间"),
        sa.Column("created_by", sa.BigInteger(), nullable=True, comment="创建人ID"),
        sa.Column("updation_date", sa.DateTime(), nullable=True, comment="更新时间"),
        sa.Column("updated_by", sa.BigInteger(), nullable=True, comment="更新人ID"),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, comment="是否删除, 0 删除 1 非删除"),
        sa.Column("trace_id", sa.String(length=255), nullable=True, comment="trace_id"),
        sa.PrimaryKeyConstraint("id"),
        mysql_charset="utf8",
    )
    op.create_index("ix_perf_reports_api_id", "api_automation_perf_reports", ["api_id"], unique=False)


def downgrade() -> None:
    op.drop_index("ix_perf_reports_api_id", table_name="api_automation_perf_reports")
    op.drop_table("api_automation_perf_reports")
