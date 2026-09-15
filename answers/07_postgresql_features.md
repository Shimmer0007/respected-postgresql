# 第 07 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT player_id,
       SUM(quantity) AS all_blocks,
       COALESCE(SUM(quantity) FILTER (WHERE dimension_id = 2), 0) AS nether_blocks,
       COALESCE(SUM(quantity) FILTER (
           WHERE block_id IN (SELECT block_id FROM blocks WHERE is_ore)
       ), 0) AS ore_blocks,
       COUNT(*) FILTER (WHERE note IS NOT NULL) AS noted_events
FROM gather_logs
GROUP BY player_id;

SELECT DISTINCT ON (block_id) block_id, gather_id, gathered_at, quantity
FROM gather_logs
ORDER BY block_id, gathered_at DESC, gather_id DESC;

WITH days AS (
    SELECT day::date FROM generate_series(DATE '2026-08-01', DATE '2026-08-07', INTERVAL '1 day') AS day
), daily AS (
    SELECT gathered_at::date AS day, SUM(quantity) AS blocks
    FROM gather_logs GROUP BY gathered_at::date
)
SELECT days.day, COALESCE(daily.blocks, 0) AS blocks
FROM days LEFT JOIN daily USING (day) ORDER BY days.day;

SELECT p.player_name, (s.items->>'diamond')::int AS diamonds,
       (s.items->>'iron_ingot')::int AS iron,
       (s.items->>'diamond')::int + (s.items->>'iron_ingot')::int AS total
FROM inventory_snapshots AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.items ?& ARRAY['diamond', 'iron_ingot'];
```
