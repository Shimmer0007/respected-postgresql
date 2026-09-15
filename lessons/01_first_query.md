# 第 01 章：第一次观察服务器

> 等级：Lv.1 · 建议用时：30 分钟 · 前置：第 00 章

## 本章任务

服务器管理员想先快速认识数据：有哪些玩家、有哪些方块、最近发生了哪些采集事件。我们只使用一张表，练习 `SELECT`、别名、排序、限制行数和去重。

## 1. 选择需要的列

```sql
SET search_path TO blockworld, public;

SELECT player_name, xp_level
FROM players;
```

`SELECT` 决定列，`FROM` 决定表。调试时可以使用 `SELECT * FROM players LIMIT 5`，但写给别人阅读的查询最好列出字段，避免表结构变化后悄悄改变结果。

给输出列起一个更适合报告的名字：

```sql
SELECT
    player_name AS 玩家,
    xp_level AS 经验等级,
    xp_level * 10 AS 经验点估算
FROM players;
```

列别名只改变结果的显示名称，不会修改表中的数据。

## 2. 排序和限制

```sql
SELECT player_name, joined_at, xp_level
FROM players
ORDER BY xp_level DESC, joined_at ASC
LIMIT 5;
```

`ORDER BY` 中先写的列优先级更高；`DESC` 是降序，默认是 `ASC`。没有 `ORDER BY` 时，数据库不保证返回顺序，即使你多次运行看起来一样，也不要依赖这个偶然结果。

查看最新的采集记录：

```sql
SELECT gather_id, player_id, gathered_at, quantity
FROM gather_logs
ORDER BY gathered_at DESC
LIMIT 8;
```

## 3. 去重与计数

```sql
SELECT DISTINCT dimension_id
FROM gather_logs
ORDER BY dimension_id;

SELECT COUNT(*) AS 事件数,
       COUNT(DISTINCT player_id) AS 参与玩家数
FROM gather_logs;
```

`DISTINCT` 作用于整行选出的列组合。`DISTINCT player_id` 和 `DISTINCT player_id, dimension_id` 统计的不是同一件事。

## 4. 分页查看

```sql
SELECT gather_id, player_id, gathered_at, quantity
FROM gather_logs
ORDER BY gather_id
LIMIT 5 OFFSET 5;
```

`OFFSET` 适合教学和小数据集。数据量很大时，后面可以学习基于主键的游标分页，避免跳过大量行。

## 5. 动手练

打开 [第 01 章练习](../exercises/01_first_query.md)，完成玩家名片、最近事件和去重统计。可运行示例在 [`01_select.sql`](01_select.sql)，答案在 [参考答案](../answers/01_first_query.md)。

## 本章小结

`SELECT ... FROM ... ORDER BY ... LIMIT ...` 是最常用的观察模板。先确定需要的列，再决定排序和行数，查询会更容易检查。

