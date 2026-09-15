SET search_path TO blockworld, public;

SELECT player_id,
       SUM(quantity) AS all_blocks,
       COALESCE(SUM(quantity) FILTER (WHERE dimension_id = 2), 0) AS nether_blocks,
       COALESCE(SUM(quantity) FILTER (WHERE block_id IN (6, 11)), 0) AS rare_blocks
FROM gather_logs
GROUP BY player_id
ORDER BY all_blocks DESC;

SELECT DISTINCT ON (player_id)
       player_id, gather_id, gathered_at, quantity, block_id
FROM gather_logs
ORDER BY player_id, gathered_at DESC, gather_id DESC;

SELECT p.player_name,
       s.snapshot_at,
       (s.items ->> 'diamond')::integer AS diamond_count
FROM inventory_snapshots AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.items ? 'diamond'
ORDER BY diamond_count DESC;
