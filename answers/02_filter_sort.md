# 第 02 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT * FROM gather_logs
WHERE dimension_id = 2 AND quantity >= 10
ORDER BY gathered_at;

SELECT * FROM gather_logs
WHERE y < 0
ORDER BY y;

SELECT block_name
FROM blocks
WHERE rarity IN ('rare', 'epic')
ORDER BY block_name;

SELECT gather_id, note
FROM gather_logs
WHERE note IS NOT NULL AND note ILIKE '%农场%';

SELECT player_name, xp_level,
       CASE WHEN xp_level < 10 THEN '新手'
            WHEN xp_level < 25 THEN '熟练'
            ELSE '老玩家' END AS level_group
FROM players
ORDER BY xp_level;
```
