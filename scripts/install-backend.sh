#!/usr/bin/env bash
# 使用 uv 安装后端 Python 依赖（Linux / macOS）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND="${ROOT}/backend"

if ! command -v uv >/dev/null 2>&1; then
	echo ">>> 未检测到 uv，正在安装..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
	export PATH="${HOME}/.local/bin:${PATH}"
fi

cd "${BACKEND}"

echo ">>> 使用 uv 同步后端依赖（含开发依赖）..."
uv sync --group dev

echo ""
echo ">>> 后端依赖安装完成。"
echo "    激活虚拟环境: source ${BACKEND}/.venv/bin/activate"
echo "    或直接运行:     cd backend && uv run python main.py"
