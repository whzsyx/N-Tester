# 使用 uv 安装后端 Python 依赖（Windows PowerShell）
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Backend = Join-Path $Root "backend"

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
	Write-Host ">>> 未检测到 uv，正在安装..."
	irm https://astral.sh/uv/install.ps1 | iex
	$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}

Set-Location $Backend

Write-Host ">>> 使用 uv 同步后端依赖（含开发依赖）..."
uv sync --group dev

Write-Host ""
Write-Host ">>> 后端依赖安装完成。"
Write-Host "    激活虚拟环境: $($Backend)\.venv\Scripts\activate"
Write-Host "    或直接运行:     cd backend; uv run python main.py"
