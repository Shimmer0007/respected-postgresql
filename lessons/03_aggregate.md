# 第 03 章：服务器资源统计

> 等级：Lv.2 · 建议用时：40 分钟 · 前置：第 02 章

## 本章任务

管理员不只想看单条日志，还要回答“本周总共采集了多少？”、“每天哪种资源最多？”、“哪些玩家贡献超过 100 个方块？”。本章学习 `COUNT`、`SUM`、`AVG`、`GROUP BY`、`HAVING` 和日期分组。

## 1. 先做整体统计

```sql
SET search_path TO blockworld, public;

SELECT COUNT(*) AS event_count,
       SUM(quantity) AS block_count,
       ROUND(AVG(quantity), 2) AS avg_per_event,
       MIN(gathered_at) AS first_event,
       MAX(gathered_at) AS last_event
FROM gather_logs;
```

聚合函数把多行压缩成一行。`COUNT(*)` 会计算行数；`COUNT(note)` 只计算 `note` 非空的行；`COUNT(DISTINCT player_id)` 计算去重后的玩家数。

## 2. 按玩家分组

```sql
SELECT player_id,
       COUNT(*) AS event_count,
       SUM(quantity) AS block_count,
       ROUND(AVG(quantity), 1) AS avg_batch
FROM gather_logs
GROUP BY player_id
ORDER BY block_count DESC;
```

出现 `GROUP BY` 后，`SELECT` 中的普通列必须出现在分组键里，或者被聚合函数包住。`ORDER BY block_count` 可以使用上面的别名，让报告更易读。

## 3. 先分组再筛选：`HAVING`

```sql
SELECT player_id, SUM(quantity) AS block_count
FROM gather_logs
GROUP BY player_id
HAVING SUM(quantity) >= 150
ORDER BY block_count DESC;
```

`WHERE` 针对明细行，`HAVING` 针对分组后的结果。把 `SUM(quantity) >= 150` 写进 `WHERE` 会报错，因为聚合还没有发生。

## 4. 按天统计

```sql
SELECT gathered_at::date AS day,
       SUM(quantity) AS block_count,
       COUNT(DISTINCT player_id) AS active_players
FROM gather_logs
GROUP BY gathered_at::date
ORDER BY day;
```

如果要按时区截断时间，推荐显式写出时区：

```sql
SELECT date_trunc('day', gathered_at AT TIME ZONE 'Asia/Shanghai') AS day,
       SUM(quantity) AS block_count
FROM gather_logs
GROUP BY 1
ORDER BY 1;
```

`GROUP BY 1` 表示按 `SELECT` 的第一列分组，适合短查询；教学和长期维护的 SQL 可以写出完整表达式，减少改列顺序时的意外。

## 5. 动手练

打开 [第 03 章练习](../exercises/03_aggregate.md)，完成玩家资源榜、每日活跃玩家和交易额统计。可运行示例在 [`03_aggregate.sql`](03_aggregate.sql)，答案在 [参考答案](../answers/03_aggregate.md)。

## 本章小结

聚合查询的关键是先确定结果粒度：一行代表一个玩家、一天，还是一种方块。确定粒度后再选择分组键和聚合函数，结果才不会“看起来合理但其实重复”。

