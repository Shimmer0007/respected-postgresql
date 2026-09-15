SET search_path TO blockworld, public;

WITH player_summary AS (
    SELECT player_id,
           SUM(quantity) AS block_count,
           COUNT(DISTINCT dimension_id) AS dimension_count,
           BOOL_OR(block_id IN (6, 11)) AS found_rare
    FROM gather_logs
    GROUP BY player_id
)
SELECT p.player_name, s.block_count, s.dimension_count, s.found_rare
FROM player_summary AS s
JOIN players AS p ON p.player_id = s.player_id
WHERE s.block_count >= 100
  AND s.dimension_count >= 2
  AND s.found_rare
ORDER BY s.block_count DESC;

WITH rare_blocks AS (
    SELECT block_id FROM blocks WHERE rarity IN ('rare', 'epic')
), rare_gather AS (
    SELECT g.player_id, SUM(g.quantity) AS rare_quantity
    FROM gather_logs AS g
    JOIN rare_blocks AS r ON r.block_id = g.block_id
    GROUP BY g.player_id
), build_total AS (
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
