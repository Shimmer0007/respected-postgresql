# 第 03 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT p.player_name, COUNT(*) AS events,
       SUM(g.quantity) AS blocks, ROUND(AVG(g.quantity), 1) AS avg_batch
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
GROUP BY p.player_id, p.player_name
ORDER BY blocks DESC;

SELECT b.category, SUM(g.quantity) AS blocks
FROM gather_logs AS g
JOIN blocks AS b ON b.block_id = g.block_id
GROUP BY b.category
ORDER BY blocks DESC;

SELECT traded_at::date AS day, COUNT(*) AS trades, SUM(emeralds) AS emeralds
FROM trades
GROUP BY traded_at::date
ORDER BY day;

SELECT player_id, SUM(quantity) AS blocks
FROM gather_logs
GROUP BY player_id
HAVING SUM(quantity) > 200
ORDER BY blocks DESC;

SELECT d.display_name, COUNT(DISTINCT g.player_id) AS players,
       COUNT(*) AS events, SUM(g.quantity) AS blocks
FROM gather_logs AS g
JOIN dimensions AS d ON d.dimension_id = g.dimension_id
GROUP BY d.dimension_id, d.display_name
ORDER BY blocks DESC;
```
