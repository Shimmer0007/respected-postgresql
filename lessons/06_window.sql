SET search_path TO blockworld, public;

WITH daily AS (
    SELECT gathered_at::date AS day, player_id, SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
)
SELECT day, player_id, block_count,
       RANK() OVER (PARTITION BY day ORDER BY block_count DESC) AS rank
FROM daily
ORDER BY day, rank, player_id;

WITH daily AS (
    SELECT gathered_at::date AS day, player_id, SUM(quantity) AS block_count
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
)
SELECT p.player_name, day, block_count,
       LAG(block_count) OVER (PARTITION BY player_id ORDER BY day) AS previous_day,
       block_count - LAG(block_count) OVER (PARTITION BY player_id ORDER BY day) AS change_from_previous
FROM daily AS d
JOIN players AS p ON p.player_id = d.player_id
ORDER BY p.player_name, day;
