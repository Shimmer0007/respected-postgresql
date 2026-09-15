SET search_path TO blockworld, public;

-- 下界的稀有采集
SELECT gather_id, player_id, block_id, quantity, gathered_at
FROM gather_logs
WHERE dimension_id = 2
  AND block_id IN (5, 11, 14)
ORDER BY gathered_at;

-- 深层采集：y 在 -64 到 20 之间
SELECT gather_id, player_id, y, quantity
FROM gather_logs
WHERE y BETWEEN -64 AND 20
ORDER BY y, quantity DESC;

-- 采集备注为空的记录
SELECT gather_id, note
FROM gather_logs
WHERE note IS NULL
ORDER BY gather_id;

-- 按批量给事件贴标签
SELECT gather_id, quantity,
       CASE WHEN quantity >= 64 THEN '整组'
            WHEN quantity >= 16 THEN '一大批'
            ELSE '少量' END AS batch_label
FROM gather_logs
ORDER BY quantity DESC;
