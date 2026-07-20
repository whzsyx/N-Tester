#!/usr/bin/env bash
# 一键安装后端（uv）+ 前端（yarn/npm）依赖
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========== 安装后端依赖 (uv) =========="
bash "${SCRIPT_DIR}/install-backend.sh"

echo ""
echo "========== 安装前端依赖 =========="
bash "${SCRIPT_DIR}/install-frontend.sh"

echo ""
echo "========== 全部完成 =========="
echo "后端: cd backend && uv run python main.py"
echo "前端: cd frontend && yarn dev"
