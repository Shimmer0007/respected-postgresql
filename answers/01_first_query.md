# 第 01 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT player_name, joined_at, xp_level
FROM players
ORDER BY joined_at, xp_level DESC;

SELECT gather_id, player_id, gathered_at, quantity
FROM gather_logs
ORDER BY gathered_at DESC
LIMIT 5;

SELECT COUNT(DISTINCT block_id) AS block_kinds,
       COUNT(DISTINCT player_id) AS players
FROM gather_logs;

SELECT gather_id, player_id, gathered_at, quantity
FROM gather_logs
ORDER BY gather_id
LIMIT 5 OFFSET 5;
```
