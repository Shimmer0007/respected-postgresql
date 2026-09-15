SET search_path TO blockworld, public;

-- 玩家采集贡献
SELECT player_id, COUNT(*) AS event_count, SUM(quantity) AS block_count
FROM gather_logs
GROUP BY player_id
ORDER BY block_count DESC;

-- 每天的采集量与活跃玩家
SELECT gathered_at::date AS day,
       SUM(quantity) AS block_count,
       COUNT(DISTINCT player_id) AS active_players
FROM gather_logs
GROUP BY gathered_at::date
ORDER BY day;

-- 采集总量至少 150 的玩家
SELECT player_id, SUM(quantity) AS block_count
FROM gather_logs
GROUP BY player_id
HAVING SUM(quantity) >= 150
ORDER BY block_count DESC;

-- 每种方块的采集量
SELECT block_id, COUNT(*) AS event_count, SUM(quantity) AS block_count
FROM gather_logs
GROUP BY block_id
ORDER BY block_count DESC;
