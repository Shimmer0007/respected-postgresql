# 第 09 章：交付一份服务器周报

> 等级：Lv.5 · 建议用时：60 分钟 · 前置：第 01～08 章

## 项目目标

服务器管理员要在周会上回答四个问题：

1. 本周共有多少活跃玩家？采集量和交易额如何变化？
2. 哪些资源即将短缺，应该安排谁去采集？
3. 哪些玩家同时贡献了资源和建筑？
4. 新玩家是否完成了入门任务？

请把结果组织成一份查询或视图，至少包含：日期、活跃玩家数、采集方块数、稀有资源数、交易绿宝石净流量。建议先用 CTE 分别得到每天的采集、交易和任务统计，再用 `calendar` 补齐日期。

## 起始骨架

```sql
SET search_path TO blockworld, public;

WITH calendar AS (
    SELECT day::date
    FROM generate_series(DATE '2026-08-01', DATE '2026-08-07', INTERVAL '1 day') AS day
), gather_daily AS (
    SELECT gathered_at::date AS day,
           COUNT(DISTINCT player_id) AS active_players,
           SUM(quantity) AS gathered_blocks,
           SUM(quantity) FILTER (WHERE block_id IN (6, 11)) AS rare_blocks
    FROM gather_logs
    GROUP BY gathered_at::date
), trade_daily AS (
    SELECT traded_at::date AS day,
           SUM(emeralds) FILTER (WHERE seller_id IS NOT NULL) AS trade_volume
    FROM trades
    GROUP BY traded_at::date
)
SELECT c.day,
       COALESCE(g.active_players, 0) AS active_players,
       COALESCE(g.gathered_blocks, 0) AS gathered_blocks,
       COALESCE(g.rare_blocks, 0) AS rare_blocks,
       COALESCE(t.trade_volume, 0) AS trade_volume
FROM calendar AS c
LEFT JOIN gather_daily AS g ON g.day = c.day
LEFT JOIN trade_daily AS t ON t.day = c.day
ORDER BY c.day;
```

上面的 `trade_volume` 只表示成交额。如果要表示每位玩家的净流量，需要先把卖出记为正数、买入记为负数，再按玩家或日期聚合。请在最终报告中明确指标定义。

## 交付要求

- [ ] 结果至少覆盖 7 天，并保留没有采集记录的日期；
- [ ] 统计至少使用一次 `JOIN`、一次窗口函数或 `FILTER`；
- [ ] 对可能为空的指标使用合适的 `COALESCE`；
- [ ] 用一段文字解释两个异常或趋势，并引用查询中的数字；
- [ ] 把最终 SQL 保存到 `exercises/09_project_solution.sql`。

参考实现见 [答案](../answers/09_project.md)，也可以直接运行 [`09_project_solution.sql`](../exercises/09_project_solution.sql) 查看一个可扩展的版本。完成后可以把 SQL 接到 BI 工具，制作“方块世界周报”看板。
