# 第 04 章：把多张表拼成一份报告

> 等级：Lv.2 · 建议用时：45 分钟 · 前置：第 03 章

## 本章任务

`gather_logs` 里只有数字 ID，管理员看不出 `player_id = 4` 是谁，也不知道 `block_id = 11` 对应什么。通过 `JOIN`，我们把事实表和维度表拼成可以直接阅读的报告。

## 1. 最小的内连接

```sql
SET search_path TO blockworld, public;

SELECT g.gather_id,
       p.player_name,
       b.block_name,
       g.quantity,
       g.gathered_at
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
JOIN blocks AS b ON b.block_id = g.block_id
ORDER BY g.gathered_at DESC
LIMIT 10;
```

`g`、`p`、`b` 是表别名。`ON` 描述两张表如何对应。这里的关系是：一个玩家有多条采集记录，一个方块也会出现在多条采集记录中。

## 2. 为什么有时要用 `LEFT JOIN`

```sql
SELECT p.player_name,
       COUNT(g.gather_id) AS event_count,
       COALESCE(SUM(g.quantity), 0) AS block_count
FROM players AS p
LEFT JOIN gather_logs AS g ON g.player_id = p.player_id
GROUP BY p.player_id, p.player_name
ORDER BY block_count DESC;
```

`LEFT JOIN` 会保留左表中的所有玩家，即使这个玩家暂时没有采集记录。`COUNT(g.gather_id)` 不会把补出来的空行算成一次事件；`COUNT(*)` 则会把这行算进去。`COALESCE` 把没有匹配记录时的 `NULL` 总量显示成 0。

## 3. 连接维度与地点

```sql
SELECT p.player_name,
       w.world_name,
       d.display_name AS dimension,
       SUM(g.quantity) AS block_count
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
JOIN worlds AS w ON w.world_id = g.world_id
JOIN dimensions AS d ON d.dimension_id = g.dimension_id
GROUP BY p.player_id, p.player_name, w.world_id, w.world_name,
         d.dimension_id, d.display_name
ORDER BY block_count DESC;
```

分组时使用稳定的主键和展示名称，避免同名玩家或同名世界导致合并错误。

## 4. 小心一对多重复

如果先把 `gather_logs` 和 `trades` 都直接按玩家连接，再做 `SUM`，一个玩家的 30 条采集和 12 条交易可能互相相乘。安全的做法是先各自聚合，再连接：

```sql
WITH gather AS (
    SELECT player_id, SUM(quantity) AS gathered_blocks
    FROM gather_logs
    GROUP BY player_id
), trade AS (
    SELECT player_id, SUM(emeralds) AS emeralds
    FROM (
        SELECT seller_id AS player_id, emeralds FROM trades
        UNION ALL
        SELECT buyer_id AS player_id, -emeralds FROM trades
    ) AS movement
    GROUP BY player_id
)
SELECT p.player_name,
       COALESCE(g.gathered_blocks, 0) AS gathered_blocks,
       COALESCE(t.emeralds, 0) AS net_emeralds
FROM players AS p
LEFT JOIN gather AS g ON g.player_id = p.player_id
LEFT JOIN trade AS t ON t.player_id = p.player_id
ORDER BY gathered_blocks DESC;
```

## 5. 动手练

打开 [第 04 章练习](../exercises/04_join.md)，完成可读采集明细、零采集玩家列表和建筑报告。可运行示例在 [`04_join.sql`](04_join.sql)，答案在 [参考答案](../answers/04_join.md)。

## 本章小结

`JOIN` 的难点不是关键字，而是确认连接键和连接后的行数。看到统计结果突然变大时，优先检查是否把两个“一对多”关系直接乘在了一起。

