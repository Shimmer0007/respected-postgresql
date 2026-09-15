-- 第 09 章参考实现：服务器周报
SET search_path TO blockworld, public;

WITH calendar AS (
    SELECT day::date
    FROM generate_series(DATE '2026-08-01', DATE '2026-08-07', INTERVAL '1 day') AS day
), gather_daily AS (
    SELECT gathered_at::date AS day,
           COUNT(DISTINCT player_id) AS active_players,
           SUM(quantity) AS gathered_blocks,
           SUM(quantity) FILTER (WHERE block_id IN (6, 11)) AS rare_blocks
    FROM gather_logs
    GROUP BY gathered_at::date
), trade_daily AS (
    SELECT traded_at::date AS day, SUM(emeralds) AS trade_emeralds
    FROM trades
    GROUP BY traded_at::date
), quest_daily AS (
    SELECT completed_at AS day, COUNT(*) AS completed_quests
    FROM quests
    WHERE status = 'completed' AND completed_at IS NOT NULL
    GROUP BY completed_at
), daily_player AS (
    SELECT gathered_at::date AS day, player_id, SUM(quantity) AS blocks
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
), daily_rank AS (
    SELECT day, player_id, blocks,
           RANK() OVER (PARTITION BY day ORDER BY blocks DESC) AS rnk
    FROM daily_player
), daily_leader AS (
    SELECT day, STRING_AGG(p.player_name, ', ' ORDER BY p.player_name) AS leaders
    FROM daily_rank AS r
    JOIN players AS p ON p.player_id = r.player_id
    WHERE r.rnk = 1
    GROUP BY day
)
SELECT c.day,
       COALESCE(g.active_players, 0) AS active_players,
       COALESCE(g.gathered_blocks, 0) AS gathered_blocks,
       COALESCE(g.rare_blocks, 0) AS rare_blocks,
       COALESCE(t.trade_emeralds, 0) AS trade_emeralds,
       COALESCE(q.completed_quests, 0) AS completed_quests,
       COALESCE(l.leaders, '无采集记录') AS daily_leaders
FROM calendar AS c
LEFT JOIN gather_daily AS g ON g.day = c.day
LEFT JOIN trade_daily AS t ON t.day = c.day
LEFT JOIN quest_daily AS q ON q.day = c.day
LEFT JOIN daily_leader AS l ON l.day = c.day
ORDER BY c.day;
