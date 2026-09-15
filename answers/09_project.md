# 第 09 章参考答案

```sql
SET search_path TO blockworld, public;

WITH calendar AS (
    SELECT day::date
    FROM generate_series(DATE '2026-08-01', DATE '2026-08-07', INTERVAL '1 day') AS day
), gather_daily AS (
    SELECT gathered_at::date AS day,
           COUNT(DISTINCT player_id) AS active_players,
           SUM(quantity) AS gathered_blocks,
           SUM(quantity) FILTER (WHERE block_id IN (6, 11)) AS rare_blocks
    FROM gather_logs GROUP BY gathered_at::date
), trade_daily AS (
    SELECT traded_at::date AS day, SUM(emeralds) AS trade_emeralds
    FROM trades GROUP BY traded_at::date
), quest_daily AS (
    SELECT completed_at AS day, COUNT(*) AS completed_quests
    FROM quests WHERE status = 'completed' AND completed_at IS NOT NULL
    GROUP BY completed_at
)
SELECT c.day,
       COALESCE(g.active_players, 0) AS active_players,
       COALESCE(g.gathered_blocks, 0) AS gathered_blocks,
       COALESCE(g.rare_blocks, 0) AS rare_blocks,
       COALESCE(t.trade_emeralds, 0) AS trade_emeralds,
       COALESCE(q.completed_quests, 0) AS completed_quests
FROM calendar AS c
LEFT JOIN gather_daily AS g ON g.day = c.day
LEFT JOIN trade_daily AS t ON t.day = c.day
LEFT JOIN quest_daily AS q ON q.day = c.day
ORDER BY c.day;
```

示例解读：报告应指出高峰日的采集量和活跃玩家数是否同步；再观察稀有资源、交易额和任务完成是否出现不同步，避免只用单一指标判断服务器活跃度。
