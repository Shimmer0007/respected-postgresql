SET search_path TO blockworld, public;

-- 可读的采集明细
SELECT g.gather_id, p.player_name, b.block_name,
       d.display_name AS dimension, g.quantity, g.gathered_at
FROM gather_logs AS g
JOIN players AS p ON p.player_id = g.player_id
JOIN blocks AS b ON b.block_id = g.block_id
JOIN dimensions AS d ON d.dimension_id = g.dimension_id
ORDER BY g.gathered_at DESC
LIMIT 12;

-- 让没有采集记录的玩家也出现在结果中
SELECT p.player_name,
       COUNT(g.gather_id) AS event_count,
       COALESCE(SUM(g.quantity), 0) AS block_count
FROM players AS p
LEFT JOIN gather_logs AS g ON g.player_id = p.player_id
GROUP BY p.player_id, p.player_name
ORDER BY block_count DESC;

-- 建筑报告
SELECT b.build_name, p.player_name, w.world_name,
       b.status, b.block_count
FROM builds AS b
JOIN players AS p ON p.player_id = b.player_id
JOIN worlds AS w ON w.world_id = b.world_id
ORDER BY b.block_count DESC;
