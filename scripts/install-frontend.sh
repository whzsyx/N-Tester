#!/usr/bin/env bash
# 安装前端 Node.js 依赖
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND="${ROOT}/frontend"

if ! command -v node >/dev/null 2>&1; then
	echo "请先安装 Node.js >= 20: https://nodejs.org/"
	exit 1
fi

cd "${FRONTEND}"

if command -v yarn >/dev/null 2>&1; then
	echo ">>> 使用 yarn 安装前端依赖..."
	yarn install
elif command -v pnpm >/dev/null 2>&1; then
	echo ">>> 使用 pnpm 安装前端依赖..."
	pnpm install
else
	echo ">>> 使用 npm 安装前端依赖..."
	npm install
fi

echo ""
echo ">>> 前端依赖安装完成。"
echo "    启动开发服务: cd frontend && yarn dev"
