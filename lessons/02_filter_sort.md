# 第 02 章：筛选稀有资源

> 等级：Lv.1 · 建议用时：35 分钟 · 前置：第 01 章

## 本章任务

“下界本周找到了多少远古残骸？”、“哪些玩家在深层拿到钻石？”这些问题需要先筛选行，再决定排序。我们会使用 `WHERE`、`AND`、`OR`、`IN`、`BETWEEN`、模式匹配、空值判断和 `CASE`。

## 1. 只保留符合条件的行

```sql
SET search_path TO blockworld, public;

SELECT gather_id, player_id, block_id, quantity, y
FROM gather_logs
WHERE dimension_id = 2
  AND quantity >= 3
ORDER BY quantity DESC;
```

`WHERE` 在聚合前过滤行。文本、日期和数字都可以比较，但日期最好写成明确的 ISO 格式：`DATE '2026-08-01'` 或 `TIMESTAMPTZ '2026-08-01 00:00+08'`。

按范围筛选：

```sql
SELECT gather_id, gathered_at, y, quantity
FROM gather_logs
WHERE gathered_at >= TIMESTAMPTZ '2026-08-01 00:00+08'
  AND gathered_at <  TIMESTAMPTZ '2026-08-04 00:00+08'
  AND y BETWEEN -64 AND 20
ORDER BY gathered_at;
```

日期范围使用“左闭右开”更安全：包含起始时刻，不包含结束时刻，不会把下一天的 00:00 重复计算。

## 2. `IN`、`LIKE` 与空值

```sql
SELECT block_name, category, rarity
FROM blocks
WHERE category IN ('ore', 'redstone');

SELECT player_name
FROM players
WHERE player_name ILIKE '%fox%';

SELECT gather_id, note
FROM gather_logs
WHERE note IS NULL;
```

`NULL` 不是字符串，也不等于 0。判断空值必须写 `IS NULL` 或 `IS NOT NULL`。`ILIKE` 是 PostgreSQL 的不区分大小写模式匹配；`%` 表示任意长度的字符。

## 3. 用 `CASE` 给结果分级

```sql
SELECT gather_id, quantity,
       CASE
           WHEN quantity >= 64 THEN '整组'
           WHEN quantity >= 16 THEN '一大批'
           ELSE '少量'
       END AS batch_label
FROM gather_logs
ORDER BY quantity DESC;
```

`CASE` 从上到下判断，第一个满足的分支生效。条件顺序会改变结果：如果先判断 `quantity >= 16`，那么 64 也会被归入“一大批”。

## 4. 动手练

打开 [第 02 章练习](../exercises/02_filter_sort.md)，自己找出下界稀有矿物、深层矿洞和缺少备注的事件。可运行示例在 [`02_filter_sort.sql`](02_filter_sort.sql)，答案在 [参考答案](../answers/02_filter_sort.md)。

## 本章小结

先用 `WHERE` 定义“哪些记录算进去”，再用 `ORDER BY` 定义“结果如何阅读”。涉及时间时使用明确时区和左闭右开区间，能少掉很多边界错误。

