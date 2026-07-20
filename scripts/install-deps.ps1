# 一键安装后端（uv）+ 前端（yarn/npm）依赖（Windows PowerShell）
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========== 安装后端依赖 (uv) =========="
& (Join-Path $ScriptDir "install-backend.ps1")

Write-Host ""
Write-Host "========== 安装前端依赖 =========="
& (Join-Path $ScriptDir "install-frontend.ps1")

Write-Host ""
Write-Host "========== 全部完成 =========="
Write-Host "后端: cd backend; uv run python main.py"
Write-Host "前端: cd frontend; yarn dev"
