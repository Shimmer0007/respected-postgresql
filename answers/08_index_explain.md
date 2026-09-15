# 第 08 章参考答案

```sql
SET search_path TO blockworld, public;

BEGIN;
-- 重复名称会触发 players_player_name_key
-- INSERT INTO players (player_name, joined_at, home_world_id, home_dimension_id)
-- VALUES ('PixelFox', CURRENT_DATE, 1, 1);
ROLLBACK;

CREATE TABLE IF NOT EXISTS server_announcements (
    announcement_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL CHECK (length(trim(title)) > 0),
    published_at timestamptz NOT NULL DEFAULT now(),
    author_id integer NOT NULL REFERENCES players(player_id),
    tags text[] NOT NULL DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS idx_builds_status ON builds (status)
WHERE status <> 'completed';
```

部分数据集很小，`EXPLAIN` 可能选择顺序扫描；这不代表索引失效。应关注估算行数与实际行数是否接近，以及数据规模增长后的计划。
