param(
    [string]$Database = "blockworld",
    [string]$HostName = "localhost",
    [int]$Port = 5432,
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "[1/2] 创建 blockworld schema..."
& psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f (Join-Path $root "sql\00_schema.sql")
if ($LASTEXITCODE -ne 0) { throw "schema 初始化失败" }

Write-Host "[2/2] 导入教学数据..."
& psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f (Join-Path $root "sql\01_seed.sql")
if ($LASTEXITCODE -ne 0) { throw "seed 数据导入失败" }

Write-Host "完成。可运行：psql -h $HostName -p $Port -U $User -d $Database"
