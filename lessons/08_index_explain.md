# 第 08 章：表设计与索引

> 等级：Lv.5 · 建议用时：50 分钟 · 前置：第 07 章

## 本章任务

查询能跑只是起点。服务器日志越来越多后，管理员还要保证错误数据进不来，并知道查询是否用上了索引。本章练习约束、索引和 `EXPLAIN`。

## 1. 约束是数据库里的护栏

`players.player_name` 有 `UNIQUE`，所以重复名字会被拒绝；`gather_logs.quantity > 0` 的 `CHECK` 会阻止负数采集；外键保证日志不会指向不存在的玩家。

```sql
INSERT INTO players (player_name, joined_at, home_world_id, home_dimension_id)
VALUES ('PixelFox', CURRENT_DATE, 1, 1);
```

这条语句应当失败。练习时可以使用事务回滚，避免修改教学数据：

```sql
BEGIN;
-- 尝试一条测试 INSERT 或 UPDATE
ROLLBACK;
```

## 2. 看执行计划

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM gather_logs
WHERE player_id = 1
  AND gathered_at >= TIMESTAMPTZ '2026-08-01 00:00+08';
```

`EXPLAIN` 显示计划，`ANALYZE` 会真正执行查询并给出实际行数。教学数据只有几十行，优化器可能认为顺序扫描更便宜，这是正常的；不要为了看到 `Index Scan` 就强行改配置。

## 3. 用符合查询条件的索引

初始化脚本已经创建：

```sql
CREATE INDEX idx_gather_logs_player_time
    ON gather_logs (player_id, gathered_at);
```

它适合“先按玩家，再按时间范围”的查询。索引不是越多越好：每个索引都会占空间，并让 `INSERT`、`UPDATE`、`DELETE` 变慢。

## 4. 设计一个带约束的新表

```sql
CREATE TABLE IF NOT EXISTS server_announcements (
    announcement_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL CHECK (length(trim(title)) > 0),
    published_at timestamptz NOT NULL DEFAULT now(),
    author_id integer NOT NULL REFERENCES players(player_id),
    tags text[] NOT NULL DEFAULT '{}'
);
```

`text[]` 是 PostgreSQL 数组类型；如果标签需要复杂筛选，也可以拆成独立的多对多表。表设计先服务于查询和约束，再考虑“看起来方便”的字段形式。

## 5. 动手练

打开 [第 08 章练习](../exercises/08_index_explain.md)，完成约束实验、计划阅读和公告表设计。答案在 [参考答案](../answers/08_index_explain.md)。

## 本章小结

数据质量由约束守住，查询性能由执行计划验证。先写出正确查询，再用实际计划判断是否需要索引；不要凭感觉添加索引。

