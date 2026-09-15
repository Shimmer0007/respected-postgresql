# Respected PostgreSQL：方块世界 SQL 学习路线

> 用一个小型《Minecraft》风格生存服的数据集，循序渐进学会 PostgreSQL。
> 项目为非官方学习材料，与 Mojang/Microsoft 无隶属关系。

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-14%2B-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL 14+"/>
  <img src="https://img.shields.io/badge/SQL-讲练结合-2ea043?style=flat-square" alt="讲练结合"/>
  <img src="https://img.shields.io/badge/难度-零基础到实战-f59e0b?style=flat-square" alt="零基础到实战"/>
</p>

## 这套教程解决什么问题

很多 SQL 教程把语法当成字典来背：今天学 `SELECT`，明天学 `JOIN`，遇到真实问题就不知道该从哪里下手。本项目把所有练习放进一个连续的故事里：你是一名生存服的数据管理员，要帮助玩家了解资源采集、合成、建筑和交易情况。

每章都遵循同一条节奏：

1. 先看一个方块世界里的问题；
2. 用最少的新语法得到第一版结果；
3. 解释结果和语法为什么这样写；
4. 打开练习文件独立完成任务；
5. 用参考答案核对，并尝试一个变式。

## 快速开始

第一次安装 PostgreSQL 请先阅读 [安装与首次连接](docs/INSTALLATION.md)。它覆盖 Windows 安装包、macOS、Ubuntu/Debian 和 Docker Compose，并说明常见连接错误。

### 方式一：已有 PostgreSQL

```bash
createdb blockworld
psql -d blockworld -f sql/00_schema.sql
psql -d blockworld -f sql/01_seed.sql
psql -d blockworld -f lessons/01_select.sql
```

Windows PowerShell 也可以执行：

```powershell
.\scripts\init.ps1 -Database blockworld
```

### 方式二：Docker

```bash
docker compose up -d db
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/00_schema.sql
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/01_seed.sql
```

如果只想阅读 Markdown，可以直接从 [学习路线](docs/ROADMAP.md) 开始，不需要安装任何东西。

## 课程目录

| 章 | 主题 | 你会完成的任务 | 等级 | 建议用时 |
|:--:|---|---|:--:|:--:|
| 00 | [准备工作](lessons/00_setup.md) | 安装 PostgreSQL、创建数据库、认识数据表 | Lv.0 | 45 分钟 |
| 01 | [第一个查询](lessons/01_first_query.md) | 查看玩家、方块和采集日志 | Lv.1 | 30 分钟 |
| 02 | [筛选与排序](lessons/02_filter_sort.md) | 找出下界的稀有矿石并给结果分级 | Lv.1 | 35 分钟 |
| 03 | [聚合与分组](lessons/03_aggregate.md) | 统计每日资源、玩家贡献和交易额 | Lv.2 | 40 分钟 |
| 04 | [连接多张表](lessons/04_join.md) | 把玩家、维度、方块和建筑拼成报告 | Lv.2 | 45 分钟 |
| 05 | [子查询与 CTE](lessons/05_cte.md) | 找出高产玩家，并拆解一条分析管线 | Lv.3 | 45 分钟 |
| 06 | [窗口函数](lessons/06_window.md) | 制作每日排行榜，比较玩家的连续表现 | Lv.4 | 50 分钟 |
| 07 | [PostgreSQL 特色](lessons/07_postgresql_features.md) | 使用 `FILTER`、`DISTINCT ON`、`generate_series`、`JSONB` | Lv.4 | 50 分钟 |
| 08 | [表设计与索引](lessons/08_index_explain.md) | 为新表加约束，用 `EXPLAIN` 找出查询路径 | Lv.5 | 50 分钟 |
| 09 | [综合项目](lessons/09_project.md) | 写一份“服务器周报”并给出运营建议 | Lv.5 | 60 分钟 |

每章正文在 [`lessons/`](lessons/)；题目在 [`exercises/`](exercises/)；参考答案在 [`answers/`](answers/)。带有 `.sql` 后缀的文件可以直接交给 `psql` 执行。

## 数据世界

本教程使用 `blockworld` schema，数据表之间的关系如下：

```text
players ──< gather_logs >── blocks
   │             │             │
   │             └────────── dimensions
   │
   ├──< craft_logs >── craft_recipes
   ├──< builds >────── worlds + dimensions
   ├──< quests
   └──< trades（buyer / seller 都是玩家）
```

数据是教学用的确定性样例，不代表真实游戏统计。为了让窗口函数和时间分析更有意义，采集记录覆盖了连续几天，也刻意保留了零记录玩家、空值和重复类别。

## 学习建议

- 第 1～3 章先不要追求“写得短”，先把结果和每一步对上。
- 每章先复制练习文件到临时文件再作答，避免直接改掉题目。
- 查询出现空结果时，先执行 `SELECT * FROM ... LIMIT 5` 检查表名、列名和数据范围。
- `JOIN` 之后行数变多是常见现象，先问自己：这是“一对一”还是“一对多”？
- 完成第 6 章后，尝试把排行榜改成你关心的指标，例如合成数量或交易额。

## 仓库结构

```text
respected-postgresql/
├── README.md
├── docker-compose.yml
├── docs/ROADMAP.md
├── lessons/                  # 讲解：Markdown + 可运行 SQL
├── sql/                      # 数据库结构与种子数据
├── exercises/                # 每章独立练习
├── answers/                  # 参考答案与思路提示
└── scripts/init.ps1          # Windows 初始化脚本
```

## 版本与许可

示例按 PostgreSQL 14 及以上版本编写。教程文本采用 CC BY-NC-SA 4.0；代码示例可在学习和非商业项目中自由修改，请保留出处。
