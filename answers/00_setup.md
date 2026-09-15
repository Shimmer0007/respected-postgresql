# 第 00 章参考答案

```sql
SET search_path TO blockworld, public;

SELECT COUNT(*) FROM players;
SELECT COUNT(*) FROM gather_logs;
SELECT COUNT(*) FROM trades;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'blockworld'
ORDER BY table_name;

SELECT table_name
FROM information_schema.columns
WHERE table_schema = 'blockworld'
  AND column_name = 'player_id'
ORDER BY table_name;
```

`gather_logs` 一行代表一次采集事件；`quantity` 才是该事件包含的方块数量，所以事件数用 `COUNT(*)`，总方块数用 `SUM(quantity)`。
