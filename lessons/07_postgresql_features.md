# 第 07 章：解锁 PostgreSQL 特色工具

> 等级：Lv.4 · 建议用时：50 分钟 · 前置：第 06 章

## 本章任务

标准 SQL 能解决大多数问题，但 PostgreSQL 还提供了一些很适合分析工作的工具：带条件聚合的 `FILTER`、每组取一条的 `DISTINCT ON`、生成日期的 `generate_series`，以及查询半结构化背包数据的 `JSONB`。

## 1. `FILTER`：一条查询统计多个条件

```sql
SET search_path TO blockworld, public;

SELECT player_id,
       SUM(quantity) AS all_blocks,
       SUM(quantity) FILTER (WHERE dimension_id = 2) AS nether_blocks,
       SUM(quantity) FILTER (WHERE block_id IN (6, 11)) AS rare_blocks,
       COUNT(*) FILTER (WHERE note IS NOT NULL) AS noted_events
FROM gather_logs
GROUP BY player_id
ORDER BY all_blocks DESC;
```

这比写多次子查询更紧凑。某个玩家没有符合条件的行时，`SUM(...) FILTER (...)` 返回 `NULL`，报告中可以用 `COALESCE` 显示为 0。

## 2. `DISTINCT ON`：每位玩家最近一次事件

```sql
SELECT DISTINCT ON (player_id)
       player_id, gather_id, gathered_at, quantity, block_id
FROM gather_logs
ORDER BY player_id, gathered_at DESC, gather_id DESC;
```

`DISTINCT ON` 是 PostgreSQL 扩展。`ORDER BY` 必须先写同样的分组列，再写“哪一条优先”的排序列，否则取到的记录可能不是你想要的那条。

## 3. `generate_series`：补齐没有活动的日期

```sql
WITH calendar AS (
    SELECT day::date
    FROM generate_series(DATE '2026-08-01', DATE '2026-08-07', INTERVAL '1 day') AS day
), daily AS (
    SELECT gathered_at::date AS day, SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY gathered_at::date
)
SELECT c.day, COALESCE(d.block_count, 0) AS block_count
FROM calendar AS c
LEFT JOIN daily AS d ON d.day = c.day
ORDER BY c.day;
```

没有日志的日期也会出现，这对画图和计算连续日期很重要。

## 4. `JSONB`：查询背包快照

```sql
SELECT p.player_name,
       s.snapshot_at,
       s.items ->> 'diamond' AS diamond_text,
       (s.items ->> 'diamond')::integer AS diamond_count
FROM inventory_snapshots AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.items ? 'diamond'
ORDER BY diamond_count DESC;
```

`->` 返回 JSON 值，`->>` 返回文本。做算术前要显式转换成整数。`?` 判断对象中是否存在某个键。

按“背包里有远古残骸”筛选：

```sql
SELECT player_id, snapshot_at
FROM inventory_snapshots
WHERE items ? 'ancient_debris';
```

## 5. 动手练

打开 [第 07 章练习](../exercises/07_postgresql_features.md)，完成多条件资源表、最近一次采集、零活动日期和背包查询。答案在 [参考答案](../answers/07_postgresql_features.md)。

## 本章小结

PostgreSQL 的特色语法不是炫技：`FILTER` 让统计更集中，`generate_series` 让时间轴完整，`JSONB` 让逐步变化的数据也能被查询。使用扩展语法时记得说明数据库版本和意图。

