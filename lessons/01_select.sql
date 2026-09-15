SET search_path TO blockworld, public;

-- 1. 玩家名片
SELECT player_name AS 玩家, xp_level AS 经验等级
FROM players
ORDER BY xp_level DESC, player_name;

-- 2. 最近的八条采集事件
SELECT gather_id, player_id, gathered_at, quantity, tool
FROM gather_logs
ORDER BY gathered_at DESC
LIMIT 8;

-- 3. 采集日志覆盖了哪些维度
SELECT DISTINCT dimension_id
FROM gather_logs
ORDER BY dimension_id;

-- 4. 一行事件与方块数量的区别
SELECT COUNT(*) AS 事件数,
       SUM(quantity) AS 方块总数,
       COUNT(DISTINCT block_id) AS 方块种类数
FROM gather_logs;
