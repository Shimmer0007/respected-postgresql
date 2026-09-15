SET search_path TO blockworld, public;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM gather_logs
WHERE player_id = 1
  AND gathered_at >= TIMESTAMPTZ '2026-08-01 00:00+08';

CREATE TABLE IF NOT EXISTS server_announcements (
    announcement_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL CHECK (length(trim(title)) > 0),
    published_at timestamptz NOT NULL DEFAULT now(),
    author_id integer NOT NULL REFERENCES players(player_id),
    tags text[] NOT NULL DEFAULT '{}'
);

BEGIN;
INSERT INTO server_announcements (title, author_id, tags)
VALUES ('本周末下界远征', 1, ARRAY['event', 'nether']);
ROLLBACK;
