# 第 06 章：制作每日排行榜

> 等级：Lv.4 · 建议用时：50 分钟 · 前置：第 05 章

## 本章任务

排行榜要回答两个不同问题：“每一天谁排第几？”和“某位玩家比前一天多挖了多少？”这类比较需要窗口函数：它们会保留明细行，同时参考同一结果集中的其他行。

## 1. `ROW_NUMBER` 与 `RANK`

```sql
SET search_path TO blockworld, public;

WITH daily AS (
    SELECT gathered_at::date AS day,
           player_id,
           SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
)
SELECT day, player_id, block_count,
       ROW_NUMBER() OVER (PARTITION BY day ORDER BY block_count DESC) AS row_number,
       RANK() OVER (PARTITION BY day ORDER BY block_count DESC) AS rank
FROM daily
ORDER BY day, rank, player_id;
```

`PARTITION BY day` 表示每天重新排名；`ORDER BY block_count DESC` 定义排名依据。出现并列时，`ROW_NUMBER` 仍会给出不同序号，`RANK` 会保留并列名次并跳号，`DENSE_RANK` 会保留并列名次但不跳号。

## 2. `LAG` 比较前一天

```sql
WITH daily AS (
    SELECT gathered_at::date AS day,
           player_id,
           SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
)
SELECT p.player_name, day, block_count,
       LAG(block_count) OVER (
           PARTITION BY player_id ORDER BY day
       ) AS previous_day,
       block_count - LAG(block_count) OVER (
           PARTITION BY player_id ORDER BY day
       ) AS change_from_previous
FROM daily AS d
JOIN players AS p ON p.player_id = d.player_id
ORDER BY p.player_name, day;
```

第一条记录没有“前一天”，所以 `LAG` 返回 `NULL`。不要急着把它替换为 0：`NULL` 表示“没有可比较的记录”，和“前一天确实采集了 0 个”是两种不同的事实。

## 3. 取每天前两名

窗口函数不能直接写在 `WHERE` 中，需要先放进 CTE：

```sql
WITH daily AS (...), ranked AS (
    SELECT daily.*,
           DENSE_RANK() OVER (PARTITION BY day ORDER BY block_count DESC) AS rnk
    FROM daily
)
SELECT *
FROM ranked
WHERE rnk <= 2
ORDER BY day, rnk;
```

## 4. 动手练

打开 [第 06 章练习](../exercises/06_window.md)，完成每日采集排行榜、玩家进步幅度和连续活跃天数。可运行示例在 [`06_window.sql`](06_window.sql)，答案在 [参考答案](../answers/06_window.md)。

## 本章小结

聚合函数把多行压成一行，窗口函数则保留原来的行，再附加排名、前后值或累计值。遇到“每组前 N 名”和“与上一条比较”，优先想到窗口函数。

