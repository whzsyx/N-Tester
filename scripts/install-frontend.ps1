# 安装前端 Node.js 依赖（Windows PowerShell）
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Frontend = Join-Path $Root "frontend"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
	Write-Host "请先安装 Node.js >= 20: https://nodejs.org/"
	exit 1
}

Set-Location $Frontend

if (Get-Command yarn -ErrorAction SilentlyContinue) {
	Write-Host ">>> 使用 yarn 安装前端依赖..."
	yarn install
} elseif (Get-Command pnpm -ErrorAction SilentlyContinue) {
	Write-Host ">>> 使用 pnpm 安装前端依赖..."
	pnpm install
} else {
	Write-Host ">>> 使用 npm 安装前端依赖..."
	npm install
}

Write-Host ""
Write-Host ">>> 前端依赖安装完成。"
Write-Host "    启动开发服务: cd frontend; yarn dev"
