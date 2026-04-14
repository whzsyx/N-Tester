"""add skill execution job tables

Revision ID: 20260410_2000
Revises: a1b2c3d4e5f6 (project_skill，文件名 20260409_1200_*)
Create Date: 2026-04-10 20:00:00
"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "20260410_2000"
down_revision = "a1b2c3d4e5f6"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "skill_execution_job",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("creation_date", sa.DateTime(), server_default=sa.func.now()),
        sa.Column("created_by", sa.BigInteger(), nullable=True),
        sa.Column("updation_date", sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
        sa.Column("updated_by", sa.BigInteger(), nullable=True),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, server_default=sa.text("1")),
        sa.Column("trace_id", sa.String(length=255), nullable=True),
        sa.Column("project_id", sa.BigInteger(), nullable=False),
        sa.Column("user_id", sa.BigInteger(), nullable=False),
        sa.Column("skill_id", sa.BigInteger(), nullable=False),
        sa.Column("action_name", sa.String(length=120), nullable=True),
        sa.Column("command", sa.Text(), nullable=True),
        sa.Column("input_args", sa.JSON(), nullable=True),
        sa.Column("session_id", sa.String(length=120), nullable=True),
        sa.Column("status", sa.String(length=30), nullable=False, server_default="pending"),
        sa.Column("queued_at", sa.DateTime(), server_default=sa.func.now()),
        sa.Column("started_at", sa.DateTime(), nullable=True),
        sa.Column("finished_at", sa.DateTime(), nullable=True),
        sa.Column("return_code", sa.Integer(), nullable=True),
        sa.Column("stdout", sa.Text(), nullable=True),
        sa.Column("stderr", sa.Text(), nullable=True),
        sa.Column("error_message", sa.Text(), nullable=True),
        sa.Column("runtime_key", sa.String(length=120), nullable=False),
        sa.Column("runner_type", sa.String(length=30), nullable=False, server_default="local"),
        sa.Column("runner_meta", sa.JSON(), nullable=True),
        sa.ForeignKeyConstraint(["skill_id"], ["project_skill.id"], name="fk_sej_skill"),
        sa.Index("idx_sej_project", "project_id"),
        sa.Index("idx_sej_user", "user_id"),
        sa.Index("idx_sej_skill", "skill_id"),
        sa.Index("idx_sej_status", "status"),
        mysql_charset="utf8mb4",
        comment="Skill执行任务表",
    )

    op.create_table(
        "skill_execution_event",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("creation_date", sa.DateTime(), server_default=sa.func.now()),
        sa.Column("created_by", sa.BigInteger(), nullable=True),
        sa.Column("updation_date", sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
        sa.Column("updated_by", sa.BigInteger(), nullable=True),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, server_default=sa.text("1")),
        sa.Column("trace_id", sa.String(length=255), nullable=True),
        sa.Column("job_id", sa.BigInteger(), nullable=False),
        sa.Column("seq", sa.Integer(), nullable=False),
        sa.Column("level", sa.String(length=20), nullable=False, server_default="info"),
        sa.Column("message", sa.Text(), nullable=False),
        sa.Column("ts", sa.DateTime(), server_default=sa.func.now()),
        sa.ForeignKeyConstraint(["job_id"], ["skill_execution_job.id"], name="fk_see_job"),
        sa.Index("idx_see_job", "job_id"),
        sa.Index("idx_see_job_seq", "job_id", "seq"),
        mysql_charset="utf8mb4",
        comment="Skill执行事件流（日志）",
    )

    op.create_table(
        "skill_execution_artifact",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("creation_date", sa.DateTime(), server_default=sa.func.now()),
        sa.Column("created_by", sa.BigInteger(), nullable=True),
        sa.Column("updation_date", sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
        sa.Column("updated_by", sa.BigInteger(), nullable=True),
        sa.Column("enabled_flag", sa.Boolean(), nullable=False, server_default=sa.text("1")),
        sa.Column("trace_id", sa.String(length=255), nullable=True),
        sa.Column("job_id", sa.BigInteger(), nullable=False),
        sa.Column("kind", sa.String(length=20), nullable=False),
        sa.Column("name", sa.String(length=255), nullable=False),
        sa.Column("relative_path", sa.String(length=1200), nullable=False),
        sa.Column("size", sa.BigInteger(), nullable=True),
        sa.Column("content_type", sa.String(length=120), nullable=True),
        sa.Column("is_deleted", sa.Boolean(), server_default=sa.text("0")),
        sa.ForeignKeyConstraint(["job_id"], ["skill_execution_job.id"], name="fk_sea_job"),
        sa.Index("idx_sea_job", "job_id"),
        sa.Index("idx_sea_job_kind", "job_id", "kind"),
        mysql_charset="utf8mb4",
        comment="Skill执行产物索引",
    )


def downgrade() -> None:
    op.drop_table("skill_execution_artifact")
    op.drop_table("skill_execution_event")
    op.drop_table("skill_execution_job")

