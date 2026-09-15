# 安装与首次连接

这篇文档带你从“电脑上还没有 PostgreSQL”走到“成功查询第一名玩家”。教程示例要求 PostgreSQL 14 或更高版本；如果你只想先阅读内容，可以跳过安装。

## 先选择一种方式

| 方式 | 适合谁 | 需要安装 | 数据保存位置 |
|---|---|---|---|
| Windows 安装包 | 第一次接触 PostgreSQL 的 Windows 用户 | PostgreSQL + 可选 pgAdmin | 本机服务 |
| macOS / Linux | 想使用系统包管理器的用户 | PostgreSQL | 本机服务 |
| Docker Compose | 不想修改本机数据库环境的用户 | Docker Desktop 或 Docker Engine | Docker volume |

三种方式得到的是同一套 `blockworld` 教学数据。不要同时启动本机 PostgreSQL 和 Docker 数据库占用同一个 5432 端口；如果端口冲突，先停掉其中一个，或者修改 Compose 的端口映射。

## A. Windows 安装包

### 1. 安装 PostgreSQL

从 [PostgreSQL Windows 下载页](https://www.postgresql.org/download/windows/) 进入 EDB 安装器，安装 PostgreSQL 14、15 或 16。安装器中的选项可以这样填写：

- Installation Directory：保持默认即可；
- Components：至少勾选 PostgreSQL Server、Command Line Tools，pgAdmin 4 可选；
- Password：为 `postgres` 管理员用户设置一个自己记得的密码；
- Port：保持 `5432`，除非该端口已经被占用；
- Locale：使用系统默认值即可。

安装完成后，打开“SQL Shell (psql)”验证连接。依次按回车接受 `localhost`、端口 `5432` 和默认数据库 `postgres`，再输入用户 `postgres` 与安装时设置的密码：

```text
Server [localhost]:
Database [postgres]:
Port [5432]:
Username [postgres]:
Password for user postgres:
postgres=# SELECT version();
```

看到版本信息后，输入 `\q` 退出。

### 2. 如果 PowerShell 找不到 `psql`

打开新的 PowerShell 窗口，再执行：

```powershell
psql --version
```

如果仍然提示“找不到 psql”，可以暂时使用完整路径。PostgreSQL 16 的默认路径通常是：

```powershell
& 'C:\Program Files\PostgreSQL\16\bin\psql.exe' --version
```

也可以把 `C:\Program Files\PostgreSQL\16\bin` 加入系统的 `Path` 环境变量，然后重新打开终端。版本号如果不是 16，请替换路径中的数字。

## B. macOS 安装

安装 [Homebrew](https://brew.sh/) 后，在终端执行：

```bash
brew install postgresql@16
brew services start postgresql@16
psql --version
```

创建教学数据库：

```bash
createdb blockworld
psql -d blockworld -c "SELECT version();"
```

如果 `createdb` 报权限错误，可以先执行 `whoami` 查看当前用户名，再运行 `createdb -O 你的用户名 blockworld`。Homebrew 的 PostgreSQL 默认使用当前 macOS 用户作为数据库用户。

## C. Ubuntu / Debian 安装

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl enable --now postgresql
psql --version
```

使用 PostgreSQL 管理员创建一个专门用于学习的用户和数据库：

```bash
sudo -u postgres psql
```

在出现的 `postgres=#` 提示符中执行：

```sql
CREATE USER learner WITH PASSWORD 'learner_local_only';
CREATE DATABASE blockworld OWNER learner;
\q
```

然后测试密码连接：

```bash
psql -h localhost -U learner -d blockworld -c "SELECT version();"
```

`learner_local_only` 只是本地学习示例密码，不要在公网服务器或正式项目中照搬。

## D. Docker Compose

Docker 路线需要先安装并启动 [Docker Desktop](https://www.docker.com/products/docker-desktop/)（Windows/macOS）或 Docker Engine（Linux）。在项目根目录，也就是包含 `docker-compose.yml` 的目录执行：

```bash
docker --version
docker compose version
docker compose up -d db
docker compose ps
```

看到 `blockworld-postgres` 状态为 `running` 或 `healthy` 后，导入结构和教学数据：

```bash
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/00_schema.sql
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/01_seed.sql
```

连接到交互式 `psql`：

```bash
docker compose exec db psql -U learner -d blockworld
```

退出交互式客户端使用 `\q`；停止容器但保留数据使用：

```bash
docker compose stop db
```

## 导入本教程数据

先进入仓库目录。Windows PowerShell 示例：

```powershell
Set-Location 'D:\Projects\DataWhale\respected-postgresql'
```

已有本地 PostgreSQL 的用户，先创建数据库，再按顺序执行两个 SQL 文件：

```bash
createdb blockworld
psql -d blockworld -v ON_ERROR_STOP=1 -f sql/00_schema.sql
psql -d blockworld -v ON_ERROR_STOP=1 -f sql/01_seed.sql
```

Windows 安装包默认创建的是 `postgres` 管理员用户。如果直接运行 `createdb` 提示用户不存在，请改用：

```powershell
psql -U postgres -d postgres -c "CREATE DATABASE blockworld;"
psql -U postgres -d blockworld -v ON_ERROR_STOP=1 -f sql/00_schema.sql
psql -U postgres -d blockworld -v ON_ERROR_STOP=1 -f sql/01_seed.sql
```

Windows 用户也可以使用项目脚本。它要求 `psql` 已加入 `Path`，并且 `blockworld` 数据库已经创建：

```powershell
.\scripts\init.ps1 -Database blockworld -User postgres
```

脚本会重建 `blockworld` schema 并重新导入样例数据。它不会删除整个数据库，但会覆盖本教程创建的 schema；不要在重要数据库上运行。

## 第一次查询

本地安装和 Docker 的验证查询相同：

```sql
SET search_path TO blockworld, public;

SELECT player_name, xp_level
FROM players
ORDER BY xp_level DESC
LIMIT 3;
```

预期会看到经验等级最高的三名玩家，其中包括 `EnderMochi`。再检查教学数据规模：

```sql
SELECT
    (SELECT COUNT(*) FROM players) AS players,
    (SELECT COUNT(*) FROM gather_logs) AS gather_events,
    (SELECT COUNT(*) FROM trades) AS trades;
```

预期结果是 `8` 名玩家、`30` 条采集事件和 `12` 条交易记录。完成这一步后，就可以开始 [第 00 章](../lessons/00_setup.md)。

## 常见问题

### `psql is not recognized` / `command not found`

PostgreSQL 未加入 `Path`，或者终端是在安装前打开的。关闭终端后重新打开；Windows 仍不行时，使用上文的完整路径或把 PostgreSQL 的 `bin` 目录加入 `Path`。

### `connection refused` 或 `could not connect to server`

本地安装时检查 PostgreSQL 服务是否启动；Windows 可以在“服务”中查找 `postgresql-x64-*`，Ubuntu 使用 `sudo systemctl status postgresql`。Docker 路线重新执行 `docker compose ps`，确认容器已经运行。

### `password authentication failed`

用户名、密码或连接到的数据库实例不对。先用安装时创建的管理员用户测试；Docker 路线固定使用 `learner` 用户，不需要输入 `postgres` 的本机密码。

### `database "blockworld" does not exist`

先执行 `createdb blockworld`。如果你连接的是 Docker 数据库，请使用 `docker compose exec db psql -U learner -d blockworld`，不要把本机的 `psql` 和容器的数据库混用。

### `5432 is already allocated` 或端口被占用

说明本机已经有一个 PostgreSQL 服务。优先复用已有服务；如果必须使用 Docker，可以把 `docker-compose.yml` 中的 `"5432:5432"` 改为 `"55432:5432"`，之后仍然使用容器内的 `docker compose exec` 命令，不需要在主机上改数据库端口。
