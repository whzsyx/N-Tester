"""add app_ui_pages and app_ui_elements for APP page management (ntest-aligned)

Revision ID: 20260412_1000
Revises: 20260411_1430
Create Date: 2026-04-12 10:00:00
"""

from alembic import op
import sqlalchemy as sa


revision = "20260412_1000"
down_revision = "20260411_1430"
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
        "app_ui_pages",
        *_base_columns(),
        sa.Column("user_id", sa.BigInteger(), nullable=False, comment="用户ID"),
        sa.Column("module_menu_id", sa.BigInteger(), nullable=False, comment="app_menus 模块 id"),
        sa.Column("name", sa.String(length=255), nullable=False, comment="页面名称"),
        sa.Column("num", sa.Integer(), nullable=True, server_default="0", comment="排序"),
        sa.Column("remark", sa.Text(), nullable=True, comment="备注"),
        sa.Column("activity", sa.String(length=512), nullable=True, comment="Activity"),
        sa.Column("package_name", sa.String(length=255), nullable=True, comment="包名"),
        sa.UniqueConstraint("user_id", "module_menu_id", "name", name="uq_app_ui_pages_user_module_name"),
        mysql_charset="utf8mb4",
        comment="APP UI 页面",
    )
    op.create_index("idx_app_ui_pages_user_module", "app_ui_pages", ["user_id", "module_menu_id"])

    op.create_table(
        "app_ui_elements",
        *_base_columns(),
        sa.Column("user_id", sa.BigInteger(), nullable=False, comment="用户ID"),
        sa.Column("page_id", sa.BigInteger(), nullable=False, comment="页面 id"),
        sa.Column("name", sa.String(length=255), nullable=False, comment="元素名"),
        sa.Column("locate_type", sa.String(length=64), nullable=False, server_default="id", comment="定位类型"),
        sa.Column("locate_value", sa.Text(), nullable=False, comment="定位值"),
        sa.Column("num", sa.Integer(), nullable=True, server_default="0", comment="排序"),
        mysql_charset="utf8mb4",
        comment="APP UI 元素",
    )
    op.create_index("idx_app_ui_elements_page", "app_ui_elements", ["page_id"])
    op.create_index("idx_app_ui_elements_user", "app_ui_elements", ["user_id"])


def downgrade() -> None:
    op.drop_index("idx_app_ui_elements_user", table_name="app_ui_elements")
    op.drop_index("idx_app_ui_elements_page", table_name="app_ui_elements")
    op.drop_table("app_ui_elements")
    op.drop_index("idx_app_ui_pages_user_module", table_name="app_ui_pages")
    op.drop_table("app_ui_pages")
