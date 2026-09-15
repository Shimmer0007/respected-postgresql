# 第 06 章参考答案

```sql
SET search_path TO blockworld, public;

WITH daily AS (
    SELECT gathered_at::date AS day, player_id, SUM(quantity) AS blocks
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
), ranked AS (
    SELECT daily.*, DENSE_RANK() OVER (PARTITION BY day ORDER BY blocks DESC) AS rnk
    FROM daily
)
SELECT p.player_name, r.day, r.blocks, r.rnk
FROM ranked AS r
JOIN players AS p ON p.player_id = r.player_id
WHERE r.rnk <= 2
ORDER BY r.day, r.rnk, p.player_name;

WITH daily AS (
    SELECT gathered_at::date AS day, player_id, SUM(quantity) AS blocks
    FROM gather_logs
    GROUP BY gathered_at::date, player_id
)
SELECT p.player_name, day, blocks,
       SUM(blocks) OVER (PARTITION BY player_id ORDER BY day
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_blocks
FROM daily AS d
JOIN players AS p ON p.player_id = d.player_id
ORDER BY p.player_name, day;
```
