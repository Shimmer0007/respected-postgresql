# 第 00 章：进入方块世界

> 等级：Lv.0 · 建议用时：45 分钟 · 前置：阅读 [安装与首次连接](../docs/INSTALLATION.md)

## 本章任务

把教学数据导入 PostgreSQL，学会在 `blockworld` schema 中定位表，并理解后面会反复出现的“粒度”概念：一行到底代表一个玩家、一次采集，还是一次交易？

## 1. 先完成安装

如果电脑上还没有 PostgreSQL，请先按 [安装与首次连接](../docs/INSTALLATION.md) 选择一种方式。安装文档会带你完成：

- 安装 PostgreSQL 或启动 Docker；
- 验证 `psql` 和数据库服务；
- 创建 `blockworld` 数据库；
- 导入本教程的结构与样例数据；
- 执行第一条玩家查询。

不要跳过最后一步。能看到查询结果后，后面的语法练习才有稳定的实验环境。

## 2. 启动数据库

已有 PostgreSQL 的同学可以直接创建数据库：

```bash
createdb blockworld
psql -d blockworld -f sql/00_schema.sql
psql -d blockworld -f sql/01_seed.sql
```

没有本地安装时，在项目根目录执行：

```bash
docker compose up -d db
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/00_schema.sql
docker compose exec db psql -U learner -d blockworld -f /workspace/sql/01_seed.sql
```

进入 `psql` 后：

```sql
\conninfo
SET search_path TO blockworld, public;
\dt
\d gather_logs
```

`\` 开头的是 `psql` 客户端命令，不是 SQL；在图形化工具中请跳过它们。

## 3. 先认识三种粒度

```sql
SET search_path TO blockworld, public;

SELECT COUNT(*) AS player_count FROM players;
SELECT COUNT(*) AS gather_event_count FROM gather_logs;
SELECT COUNT(*) AS trade_count FROM trades;
```

目前的结果应该是 8 名玩家、30 条采集记录和 12 条交易记录。`gather_logs` 的一行不是“一个方块”，而是某个玩家在某个时间、某个位置记录的一次采集事件；`quantity` 才是这次事件采集的数量。

这一区别会影响每一个统计：

- 想知道玩家做过几次远征，用 `COUNT(*)`；
- 想知道玩家拿到多少方块，用 `SUM(quantity)`；
- 想知道有多少种方块，应该数 `COUNT(DISTINCT block_id)`。

## 4. 找到表之间的关系

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'blockworld'
ORDER BY table_name;
```

表中的 `*_id` 是连接数据的线索。例如，`gather_logs.player_id` 指向 `players.player_id`，`gather_logs.block_id` 指向 `blocks.block_id`。下一章会先只看一张表，等掌握筛选后再把它们连接起来。

## 5. 动手练

打开 [第 00 章练习](../exercises/00_setup.md)，完成环境检查和粒度判断题。答案在 [参考答案](../answers/00_setup.md)。

## 本章小结

数据库负责保存事实，SQL 负责把事实组合成问题的答案。开始写查询前，先说清楚一行代表什么，往往比记住更多函数更重要。
