"""add app_mgmt appium server and run phone tables

Revision ID: 20260411_1200
Revises: 20260410_2000
Create Date: 2026-04-11 12:00:00
"""

from alembic import op
import sqlalchemy as sa


revision = "20260411_1200"
down_revision = "20260410_2000"
branch_labels = None
depends_on = None


def _base_columns():
    return [
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("creation_date", sa.DateTime(), server_default=sa.func.now()),
        sa.Column("created_by", sa.BigInteger(), nullable=True),
        sa.Column("updation_date", sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
        sa.Column("updated_by", sa.BigInteger(), nullable=True),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, server_default=sa.text("1")),
        sa.Column("trace_id", sa.String(length=255), nullable=True),
    ]


def upgrade() -> None:
    op.create_table(
        "app_mgmt_appium_server",
        *_base_columns(),
        sa.Column("user_id", sa.BigInteger(), nullable=False, comment="用户ID"),
        sa.Column("name", sa.String(length=255), nullable=False, comment="服务器名称"),
        sa.Column("num", sa.Integer(), nullable=True, server_default="0", comment="排序序号"),
        sa.Column("server_os", sa.String(length=16), nullable=True, comment="系统类型"),
        sa.Column("ip", sa.String(length=64), nullable=False, comment="IP"),
        sa.Column("port", sa.String(length=16), nullable=False, server_default="4723", comment="端口"),
        sa.Column("appium_version", sa.String(length=16), nullable=False, server_default="2.x", comment="Appium主版本"),
        sa.Column("status", sa.Integer(), nullable=False, server_default="0", comment="连通性"),
        sa.UniqueConstraint("user_id", "name", name="uq_app_mgmt_appium_server_user_name"),
        mysql_charset="utf8mb4",
        comment="APP自动化 Appium 服务器",
    )
    op.create_index("idx_app_mgmt_appium_server_user", "app_mgmt_appium_server", ["user_id"])

    op.create_table(
        "app_mgmt_run_phone",
        *_base_columns(),
        sa.Column("user_id", sa.BigInteger(), nullable=False, comment="用户ID"),
        sa.Column("name", sa.String(length=255), nullable=False, comment="设备别名"),
        sa.Column("num", sa.Integer(), nullable=True, server_default="0", comment="排序序号"),
        sa.Column("phone_os", sa.String(length=16), nullable=True, comment="Android/ios"),
        sa.Column("os_version", sa.String(length=255), nullable=True, comment="系统版本"),
        sa.Column("device_id", sa.String(length=255), nullable=False, comment="设备ID/UDID"),
        sa.Column("extends", sa.JSON(), nullable=True, comment="扩展"),
        sa.Column("screen", sa.String(length=64), nullable=True, comment="分辨率"),
        sa.UniqueConstraint("user_id", "name", name="uq_app_mgmt_run_phone_user_name"),
        mysql_charset="utf8mb4",
        comment="APP自动化运行设备",
    )
    op.create_index("idx_app_mgmt_run_phone_user", "app_mgmt_run_phone", ["user_id"])


def downgrade() -> None:
    op.drop_index("idx_app_mgmt_run_phone_user", table_name="app_mgmt_run_phone")
    op.drop_table("app_mgmt_run_phone")
    op.drop_index("idx_app_mgmt_appium_server_user", table_name="app_mgmt_appium_server")
    op.drop_table("app_mgmt_appium_server")
