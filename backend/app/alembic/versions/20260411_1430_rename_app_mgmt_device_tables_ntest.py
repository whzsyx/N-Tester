"""rename app device tables to ntest names (app_ui_test_run_server / app_ui_test_run_phone)

Revision ID: 20260411_1430
Revises: 20260411_1200
Create Date: 2026-04-11 14:30:00
"""

from alembic import op


revision = "20260411_1430"
down_revision = "20260411_1200"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.rename_table("app_mgmt_appium_server", "app_ui_test_run_server")
    op.rename_table("app_mgmt_run_phone", "app_ui_test_run_phone")


def downgrade() -> None:
    op.rename_table("app_ui_test_run_server", "app_mgmt_appium_server")
    op.rename_table("app_ui_test_run_phone", "app_mgmt_run_phone")
