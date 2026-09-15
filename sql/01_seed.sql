-- 方块世界教学数据。可重复执行。
SET search_path TO blockworld, public;
SET TIME ZONE 'Asia/Shanghai';

TRUNCATE TABLE
    inventory_snapshots, quests, trades, builds, craft_logs, craft_recipes,
    gather_logs, blocks, players, worlds, dimensions
RESTART IDENTITY CASCADE;

INSERT INTO dimensions (dimension_id, dimension_key, display_name, hostile) VALUES
    (1, 'overworld', '主世界', true),
    (2, 'nether', '下界', true),
    (3, 'end', '末地', true);

INSERT INTO worlds (world_id, world_name, seed_label, difficulty, created_at) VALUES
    (1, 'DataWhale 生存服', 'DW-2026-A', 'normal', '2026-07-25'),
    (2, '建筑测试服', 'BUILD-42', 'peaceful', '2026-07-28'),
    (3, '周末挑战服', 'WEEKEND-7', 'hard', '2026-08-01');

INSERT INTO players (player_id, player_name, joined_at, home_world_id, home_dimension_id, xp_level) VALUES
    (1, 'PixelFox', '2026-07-25', 1, 1, 32),
    (2, 'RedstoneCat', '2026-07-25', 1, 1, 28),
    (3, 'CreeperChef', '2026-07-26', 1, 1, 21),
    (4, 'EnderMochi', '2026-07-27', 1, 2, 35),
    (5, 'OakBuilder', '2026-07-28', 2, 1, 18),
    (6, 'QuartzBee', '2026-07-29', 1, 2, 24),
    (7, 'MapMaker', '2026-07-30', 2, 1, 15),
    (8, 'NewMiner', '2026-08-01', 3, 1, 4);

INSERT INTO blocks (block_id, block_name, category, rarity, is_ore, stack_size) VALUES
    (1, '石头', 'building', 'common', false, 64),
    (2, '煤矿石', 'ore', 'common', true, 64),
    (3, '铁矿石', 'ore', 'uncommon', true, 64),
    (4, '铜矿石', 'ore', 'uncommon', true, 64),
    (5, '金矿石', 'ore', 'rare', true, 64),
    (6, '钻石矿石', 'ore', 'epic', true, 64),
    (7, '红石矿石', 'redstone', 'rare', true, 64),
    (8, '橡木原木', 'building', 'common', false, 64),
    (9, '云杉原木', 'building', 'common', false, 64),
    (10, '小麦', 'food', 'common', false, 64),
    (11, '远古残骸', 'ore', 'epic', true, 64),
    (12, '沙子', 'building', 'common', false, 64),
    (13, '黑曜石', 'building', 'rare', false, 64),
    (14, '荧石粉', 'utility', 'rare', false, 64);

INSERT INTO gather_logs
    (gather_id, player_id, world_id, dimension_id, block_id, gathered_at, quantity, tool, x, y, z, note)
VALUES
    (1, 1, 1, 1, 2,  '2026-08-01 09:10+08', 48, '铁镐',  120, 38, -42, '矿洞入口'),
    (2, 1, 1, 1, 3,  '2026-08-01 09:22+08', 32, '铁镐',  122, 22, -46, NULL),
    (3, 1, 1, 1, 6,  '2026-08-01 09:45+08',  6, '铁镐',  130,  -8, -51, '意外发现'),
    (4, 2, 1, 1, 7,  '2026-08-01 13:05+08', 64, '钻石镐',  88,  10,  77, '红石工程材料'),
    (5, 2, 1, 1, 3,  '2026-08-01 13:20+08', 24, '钻石镐',  91,  10,  72, NULL),
    (6, 3, 1, 1, 8,  '2026-08-01 16:00+08', 96, '石斧',  -12, 65,  30, '农场扩建'),
    (7, 4, 1, 2, 5,  '2026-08-01 20:10+08', 18, '钻石镐',  14,  55, -20, '下界堡垒附近'),
    (8, 4, 1, 2, 11, '2026-08-01 20:40+08',  3, '钻石镐',  28,  15, -22, '稀有材料'),
    (9, 6, 1, 2, 14, '2026-08-02 10:30+08', 42, '钻石镐', -40,  64,  12, NULL),
    (10, 1, 1, 1, 6, '2026-08-02 11:00+08',  4, '铁镐',  180, -20,  90, NULL),
    (11, 2, 1, 1, 4, '2026-08-02 14:15+08', 80, '钻石镐',   5,  33,  19, '铜农场'),
    (12, 3, 1, 1, 10,'2026-08-02 15:40+08', 72, '石锄',   -20,  64,  38, '村庄农田'),
    (13, 5, 2, 1, 12,'2026-08-02 18:25+08', 128,'铁锹',   300,  70,  11, '沙漠采集'),
    (14, 7, 2, 1, 8, '2026-08-02 19:10+08', 64, '铁斧',   308,  70,  14, NULL),
    (15, 8, 3, 1, 2, '2026-08-02 21:30+08', 16, '石镐',     4,  42,   8, '新手任务'),
    (16, 1, 1, 1, 3, '2026-08-03 09:00+08', 40, '铁镐',   140,  24, -70, NULL),
    (17, 2, 1, 1, 6, '2026-08-03 09:15+08',  8, '钻石镐',  95, -18,  80, NULL),
    (18, 4, 1, 2, 5, '2026-08-03 20:00+08', 24, '钻石镐',  42,  50, -12, NULL),
    (19, 6, 1, 2, 11,'2026-08-03 20:22+08',  5, '钻石镐',  45,  18, -11, NULL),
    (20, 3, 1, 1, 9, '2026-08-04 12:10+08', 80, '石斧',   -45,  68,  55, '木材补给'),
    (21, 5, 2, 1, 13,'2026-08-04 15:10+08', 48, '钻石镐',  210,  64,  90, '下界门材料'),
    (22, 7, 2, 1, 12,'2026-08-04 16:00+08', 96, '铁锹',    220,  70,  88, NULL),
    (23, 1, 1, 1, 2, '2026-08-05 09:30+08', 72, '铁镐',   200,  32, -18, NULL),
    (24, 2, 1, 1, 7, '2026-08-05 10:20+08', 96, '钻石镐',  205,  12, -22, NULL),
    (25, 4, 1, 2, 11,'2026-08-05 21:10+08',  2, '钻石镐',  60,  12,  -2, '第三次远征'),
    (26, 6, 1, 2, 14,'2026-08-06 18:05+08', 64, '钻石镐', -12,  60,  40, NULL),
    (27, 8, 3, 1, 3, '2026-08-06 19:15+08', 20, '铁镐',     8,  35,  12, '开始独立探险'),
    (28, 1, 1, 1, 6, '2026-08-07 08:45+08', 10, '铁镐',   218, -14, -30, NULL),
    (29, 2, 1, 1, 3, '2026-08-07 09:10+08', 60, '钻石镐',  220,  20, -28, NULL),
    (30, 4, 1, 2, 5, '2026-08-07 20:30+08', 30, '钻石镐',  70,  48,  -8, NULL);

INSERT INTO craft_recipes (recipe_id, item_name, station, recipe_level) VALUES
    (1, '火把', 'crafting_table', 1),
    (2, '铁镐', 'crafting_table', 1),
    (3, '面包', 'inventory', 1),
    (4, '红石灯', 'crafting_table', 2),
    (5, '钻石镐', 'crafting_table', 3),
    (6, '铁路', 'crafting_table', 3),
    (7, '下界合金锭', 'smithing_table', 5),
    (8, '盾牌', 'crafting_table', 2),
    (9, '信标', 'crafting_table', 5),
    (10, '玻璃', 'furnace', 1);

INSERT INTO craft_logs (craft_id, player_id, recipe_id, crafted_at, quantity) VALUES
    (1, 1, 1, '2026-08-01 10:00+08', 128),
    (2, 1, 2, '2026-08-01 10:05+08', 2),
    (3, 2, 4, '2026-08-01 14:00+08', 16),
    (4, 3, 3, '2026-08-02 16:10+08', 24),
    (5, 4, 7, '2026-08-02 21:20+08', 2),
    (6, 5, 10,'2026-08-03 12:00+08', 96),
    (7, 2, 5, '2026-08-03 10:00+08', 1),
    (8, 6, 7, '2026-08-03 21:00+08', 1),
    (9, 7, 6, '2026-08-04 17:00+08', 64),
    (10,1, 9, '2026-08-05 11:00+08', 1),
    (11,4, 7, '2026-08-05 22:00+08', 3),
    (12,8, 2, '2026-08-06 20:00+08', 1),
    (13,3, 3, '2026-08-06 16:20+08', 32),
    (14,6, 4, '2026-08-06 19:00+08', 24),
    (15,2, 9, '2026-08-07 10:00+08', 1);

INSERT INTO builds (build_id, player_id, world_id, dimension_id, build_name, build_type, status, started_at, completed_at, block_count) VALUES
    (1, 1, 1, 1, '出生点仓库', 'storage', 'completed', '2026-07-26', '2026-07-28', 860),
    (2, 2, 1, 1, '自动农场', 'redstone', 'completed', '2026-07-27', '2026-08-02', 1240),
    (3, 3, 1, 1, '蜂蜜小屋', 'home', 'building', '2026-08-01', NULL, 420),
    (4, 4, 1, 2, '下界铁路站', 'transport', 'completed', '2026-07-30', '2026-08-05', 2180),
    (5, 5, 2, 1, '沙漠图书馆', 'community', 'building', '2026-08-02', NULL, 1530),
    (6, 6, 1, 2, '猪灵交易塔', 'farm', 'completed', '2026-08-01', '2026-08-04', 980),
    (7, 7, 2, 1, '地图室', 'utility', 'completed', '2026-08-01', '2026-08-03', 610),
    (8, 8, 3, 1, '第一间小屋', 'home', 'completed', '2026-08-02', '2026-08-03', 180),
    (9, 1, 1, 1, '末地传送厅', 'community', 'building', '2026-08-06', NULL, 760),
    (10,2, 1, 1, '红石仓门', 'redstone', 'completed', '2026-08-05', '2026-08-07', 340);

INSERT INTO trades (trade_id, seller_id, buyer_id, item_name, quantity, emeralds, traded_at) VALUES
    (1, 1, 3, '铁锭', 32, 16, '2026-08-01 18:00+08'),
    (2, 2, 1, '红石粉', 64, 12, '2026-08-01 18:20+08'),
    (3, 4, 6, '荧石粉', 32, 20, '2026-08-02 22:00+08'),
    (4, 5, 7, '玻璃', 64, 18, '2026-08-03 18:30+08'),
    (5, 3, 5, '面包', 16, 8, '2026-08-03 19:00+08'),
    (6, 6, 4, '下界合金锭', 1, 24, '2026-08-04 21:00+08'),
    (7, 1, 8, '钻石', 4, 28, '2026-08-05 12:00+08'),
    (8, 7, 2, '铁路', 32, 10, '2026-08-05 17:00+08'),
    (9, 4, 1, '远古残骸', 1, 30, '2026-08-05 22:30+08'),
    (10,2, 5, '红石灯', 8, 14, '2026-08-06 13:00+08'),
    (11,8, 3, '铁锭', 8, 6, '2026-08-06 20:30+08'),
    (12,6, 7, '荧石粉', 16, 9, '2026-08-07 18:10+08');

INSERT INTO quests (quest_id, player_id, quest_name, status, reward_xp, completed_at) VALUES
    (1, 1, '给出生点补充煤炭', 'completed', 80, '2026-08-01'),
    (2, 2, '点亮红石工坊', 'completed', 120, '2026-08-02'),
    (3, 3, '收获第一批小麦', 'completed', 60, '2026-08-02'),
    (4, 4, '寻找远古残骸', 'completed', 200, '2026-08-03'),
    (5, 5, '完成沙漠图书馆地基', 'accepted', 150, NULL),
    (6, 6, '修建下界交易塔', 'completed', 180, '2026-08-04'),
    (7, 7, '绘制出生点地图', 'completed', 90, '2026-08-03'),
    (8, 8, '独立完成一次采矿', 'completed', 50, '2026-08-06'),
    (9, 1, '准备末地传送厅', 'accepted', 220, NULL),
    (10,2, '为服务器制作信标', 'completed', 240, '2026-08-07');

INSERT INTO inventory_snapshots (snapshot_id, player_id, snapshot_at, items) VALUES
    (1, 1, '2026-08-01 23:00+08', '{"diamond": 10, "iron_ingot": 48, "torch": 96}'),
    (2, 2, '2026-08-02 23:00+08', '{"redstone": 144, "copper": 80, "torch": 32}'),
    (3, 3, '2026-08-03 23:00+08', '{"wheat": 72, "bread": 24, "oak_log": 40}'),
    (4, 4, '2026-08-03 23:00+08', '{"ancient_debris": 8, "gold": 42, "obsidian": 16}'),
    (5, 5, '2026-08-04 23:00+08', '{"sand": 128, "glass": 96, "book": 12}'),
    (6, 6, '2026-08-05 23:00+08', '{"glowstone_dust": 106, "ancient_debris": 5}'),
    (7, 7, '2026-08-06 23:00+08', '{"rail": 64, "map": 8, "glass": 24}'),
    (8, 8, '2026-08-07 23:00+08', '{"iron_ore": 20, "stone": 64, "bread": 6}');

-- 由于种子数据使用了固定主键，让后续新增记录继续从最大值之后开始。
SELECT setval(pg_get_serial_sequence('blockworld.dimensions', 'dimension_id'), max(dimension_id)) FROM dimensions;
SELECT setval(pg_get_serial_sequence('blockworld.worlds', 'world_id'), max(world_id)) FROM worlds;
SELECT setval(pg_get_serial_sequence('blockworld.players', 'player_id'), max(player_id)) FROM players;
SELECT setval(pg_get_serial_sequence('blockworld.blocks', 'block_id'), max(block_id)) FROM blocks;
SELECT setval(pg_get_serial_sequence('blockworld.gather_logs', 'gather_id'), max(gather_id)) FROM gather_logs;
SELECT setval(pg_get_serial_sequence('blockworld.craft_recipes', 'recipe_id'), max(recipe_id)) FROM craft_recipes;
SELECT setval(pg_get_serial_sequence('blockworld.craft_logs', 'craft_id'), max(craft_id)) FROM craft_logs;
SELECT setval(pg_get_serial_sequence('blockworld.builds', 'build_id'), max(build_id)) FROM builds;
SELECT setval(pg_get_serial_sequence('blockworld.trades', 'trade_id'), max(trade_id)) FROM trades;
SELECT setval(pg_get_serial_sequence('blockworld.quests', 'quest_id'), max(quest_id)) FROM quests;
SELECT setval(pg_get_serial_sequence('blockworld.inventory_snapshots', 'snapshot_id'), max(snapshot_id)) FROM inventory_snapshots;
