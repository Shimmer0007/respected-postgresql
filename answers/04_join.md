# 第 04 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT p.player_name, b.block_name, b.category, d.display_name AS dimension,
       g.quantity, g.gathered_at
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
JOIN blocks AS b ON b.block_id = g.block_id
JOIN dimensions AS d ON d.dimension_id = g.dimension_id
ORDER BY g.gathered_at;

SELECT p.player_name, COUNT(b.build_id) AS build_count,
       COALESCE(SUM(b.block_count), 0) AS blocks
FROM players AS p
LEFT JOIN builds AS b ON b.player_id = p.player_id
GROUP BY p.player_id, p.player_name
ORDER BY blocks DESC;

SELECT w.world_name, COUNT(b.build_id) AS build_count,
       COALESCE(SUM(b.block_count), 0) AS blocks,
       COUNT(*) FILTER (WHERE b.status = 'completed') AS completed_builds
FROM worlds AS w
LEFT JOIN builds AS b ON b.world_id = w.world_id
GROUP BY w.world_id, w.world_name
ORDER BY blocks DESC;

SELECT DISTINCT p.player_name
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
WHERE g.dimension_id = 2
ORDER BY p.player_name;
```
