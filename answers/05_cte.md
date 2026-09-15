# 第 05 章参考答案

```sql
SET search_path TO blockworld, public;

WITH summary AS (
    SELECT player_id, SUM(quantity) AS blocks,
           COUNT(DISTINCT dimension_id) AS dimensions,
           COUNT(DISTINCT block_id) AS block_kinds
    FROM gather_logs
    GROUP BY player_id
)
SELECT p.player_name, s.blocks, s.dimensions, s.block_kinds
FROM summary AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.blocks >= 100 AND s.dimensions >= 2
ORDER BY s.blocks DESC;

WITH rare AS (
    SELECT g.player_id, SUM(g.quantity) AS rare_blocks
    FROM gather_logs AS g
    JOIN blocks AS b ON b.block_id = g.block_id
    WHERE b.rarity IN ('rare', 'epic')
    GROUP BY g.player_id
), build AS (
    SELECT player_id, SUM(block_count) AS built_blocks
    FROM builds
    GROUP BY player_id
)
SELECT p.player_name, COALESCE(r.rare_blocks, 0) AS rare_blocks,
       COALESCE(b.built_blocks, 0) AS built_blocks
FROM players AS p
LEFT JOIN rare AS r ON r.player_id = p.player_id
LEFT JOIN build AS b ON b.player_id = p.player_id
ORDER BY rare_blocks DESC;
```
