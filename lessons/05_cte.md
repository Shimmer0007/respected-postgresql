# 第 05 章：用 CTE 拆解一次探险分析

> 等级：Lv.3 · 建议用时：45 分钟 · 前置：第 04 章

## 本章任务

管理组想评选“资源探险队”：玩家至少采集 100 个方块、去过两个维度，并且挖到过一种稀有资源。这个问题如果一口气写在一条 SQL 里会很难检查，我们用子查询和 CTE（`WITH`）拆成几步。

## 1. 先做一个派生表

```sql
SET search_path TO blockworld, public;

SELECT p.player_name, summary.block_count
FROM players AS p
JOIN (
    SELECT player_id, SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY player_id
) AS summary ON summary.player_id = p.player_id
WHERE summary.block_count >= 100
ORDER BY summary.block_count DESC;
```

括号中的查询先产生一张临时结果表，再被外层查询使用。派生表适合短小的中间结果，但多步分析时，CTE 更容易阅读。

## 2. 用 CTE 分层表达

```sql
WITH player_summary AS (
    SELECT player_id,
           SUM(quantity) AS block_count,
           COUNT(DISTINCT dimension_id) AS dimension_count,
           BOOL_OR(block_id IN (6, 11)) AS found_rare
    FROM gather_logs
    GROUP BY player_id
)
SELECT p.player_name,
       s.block_count,
       s.dimension_count,
       s.found_rare
FROM player_summary AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.block_count >= 100
  AND s.dimension_count >= 2
  AND s.found_rare
ORDER BY s.block_count DESC;
```

CTE 像一个命名的中间步骤。这里先把日志压缩到“每个玩家一行”，再在外层做筛选。`BOOL_OR` 在一个分组中只要有一行满足条件就返回 `true`。

## 3. 多个 CTE 组成分析管线

```sql
WITH rare_blocks AS (
    SELECT block_id, block_name
    FROM blocks
    WHERE rarity IN ('rare', 'epic')
),
rare_gather AS (
    SELECT g.player_id, SUM(g.quantity) AS rare_quantity
    FROM gather_logs AS g
    JOIN rare_blocks AS r ON r.block_id = g.block_id
    GROUP BY g.player_id
),
build_total AS (
    SELECT player_id, SUM(block_count) AS built_blocks
    FROM builds
    GROUP BY player_id
)
SELECT p.player_name,
       COALESCE(r.rare_quantity, 0) AS rare_quantity,
       COALESCE(b.built_blocks, 0) AS built_blocks
FROM players AS p
LEFT JOIN rare_gather AS r ON r.player_id = p.player_id
LEFT JOIN build_total AS b ON b.player_id = p.player_id
ORDER BY rare_quantity DESC, built_blocks DESC;
```

每个 CTE 只负责一种事实：稀有采集、建筑总量或玩家名单。这样更容易单独执行某一步查错，也方便以后替换指标。

## 4. 动手练

打开 [第 05 章练习](../exercises/05_cte.md)，完成“资源探险队”和“建筑贡献”分析。可运行示例在 [`05_cte.sql`](05_cte.sql)，答案在 [参考答案](../answers/05_cte.md)。

## 本章小结

复杂 SQL 不是越短越好。先把问题拆成粒度清晰的中间结果，再连接和筛选，查询更容易验证，也更适合以后改成视图或报表。

