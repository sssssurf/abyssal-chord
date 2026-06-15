///|
/// 交互式CLI模式 - 玩家可选择敌人、难度和流派

// ─── 游戏模式 ───
pub enum GameMode {
  QuickBattle
  SurvivalMode
  BossRush
  Training
} derive(Eq)

// ─── 模式名称 ───
pub fn game_mode_name(mode : GameMode) -> String {
  match mode {
    QuickBattle => "快速对战"
    SurvivalMode => "生存模式"
    BossRush => "Boss挑战"
    Training => "训练模式"
  }
}

// ─── 所有游戏模式 ───
pub fn all_game_modes() -> Array[GameMode] {
  [ QuickBattle, SurvivalMode, BossRush, Training ]
}

// ─── 快速对战配置 ───
pub fn quick_battle_configs() -> Array[String] {
  [
    "钟律 vs 嘶鸣游荡者 (简单)",
    "钟律 vs 静默拟态体 (中等)",
    "钟律 vs 回声残像 (简单)",
    "钟律 vs 共振晶体 (中等)",
    "钟律 vs 深渊尖啸者 (中等)",
    "弦音 vs 嘶鸣游荡者 (简单)",
    "弦音 vs 静默拟态体 (中等)",
    "钟律 vs 穆托斯 (Boss)",
    "弦音 vs 穆托斯 (Boss)",
    "钟律 vs 谐波构造体 (Boss)",
  ]
}

// ─── 解析对战配置 ───
pub fn parse_quick_battle(config_id : Int) -> (String, String) {
  match config_id {
    0 => ("zhong-lv", "howling-drifter")
    1 => ("zhong-lv", "silent-mimic")
    2 => ("zhong-lv", "echo-remnant")
    3 => ("zhong-lv", "resonance-crystal")
    4 => ("zhong-lv", "abyssal-shrieker")
    5 => ("xian-yin", "howling-drifter")
    6 => ("xian-yin", "silent-mimic")
    7 => ("zhong-lv", "mutos")
    8 => ("xian-yin", "mutos")
    9 => ("zhong-lv", "harmonic-construct")
    _ => ("zhong-lv", "howling-drifter")
  }
}

// ─── 根据ID获取角色 ───
pub fn get_character_by_id(char_id : String) -> Character {
  match char_id {
    "zhong-lv" => zhong_lv()
    "xian-yin" => xian_yin()
    _ => zhong_lv()
  }
}

// ─── 初始化快速对战 ───
pub fn init_quick_battle(config_id : Int, difficulty_id : Int) -> BattleState {
  let (char_id, enemy_id) = parse_quick_battle(config_id)
  let char = get_character_by_id(char_id)
  let enemy = get_enemy_by_id(enemy_id)
  let mut state = init_battle(char, enemy)
  // Apply difficulty
  let diff = difficulty_from_id(difficulty_id)
  let cfg = get_difficulty_config(diff)
  state = scale_battle_for_difficulty(state, cfg)
  state
}

// ─── Boss Rush 模式枚举 ───
pub enum BossRushState {
  NotStarted
  InProgress
  Completed_
  Failed
} derive(Eq)

// ─── Boss Rush 配置 ───
pub fn boss_rush_enemies() -> Array[String] {
  [ "mutos", "harmonic-construct" ]
}

// ─── Boss Rush 初始化 ───
pub fn init_boss_rush() -> (BattleState, BossRushState) {
  let boss_id = boss_rush_enemies()[0]
  let char = zhong_lv()
  let enemy = get_enemy_by_id(boss_id)
  let state = init_battle(char, enemy)
  (state, InProgress)
}

// ─── 进入下一个Boss ───
pub fn next_boss_rush(current_index : Int, player_hp : Int) -> (BattleState, BossRushState) {
  let next_idx = current_index + 1
  let bosses = boss_rush_enemies()
  if next_idx >= bosses.length() {
    let char = zhong_lv()
    let enemy = mutos()
    let state = init_battle(char, enemy)
    // 已完成，返回最后一场
    (state, Completed_)
  } else {
    let char = zhong_lv()
    let enemy = get_enemy_by_id(bosses[next_idx])
    let mut state = init_battle(char, enemy)
    // 保留玩家HP
    state = { ..state, player: { ..state.player, hp: player_hp } }
    (state, InProgress)
  }
}

// ─── 训练模式 ───
pub struct TrainingSession {
  target_enemy : Enemy
  target_archetype : String
  tips : Array[String]
  practice_attempts : Int
}

// ─── 创建训练 ───
pub fn create_training(archetype : String) -> TrainingSession {
  let enemy = match archetype {
    "fortress" => silent_mimic()
    "overload" => resonance_crystal()
    "assassin" => howling_drifter()
    "echo" => abyssal_shrieker()
    _ => howling_drifter()
  }
  let tips = match archetype {
    "fortress" => [
      "先打出频率锚定建立每回合护甲",
      "用谐波叠加配合多张低费牌叠甲",
      "次声崩塌是主要输出手段",
      "共振壁垒溢出伤害是额外AOE",
    ]
    "overload" => [
      "自伤牌激活后立即用反馈回路",
      "断弦极限提供爆发AP和伤害加成",
      "痛觉回响让自伤转化为增伤",
      "注意HP管理，不要自我毁灭",
    ]
    "assassin" => [
      "高频切割配合声爆联动额外伤害",
      "声纹连斩可以免费再打一次",
      "断裂琴弦遗物额外+2声爆",
      "保持高频出牌触发遗物效果",
    ]
    "echo" => [
      "先打出回声标记建立复制机制",
      "相位镜像复制关键攻击牌",
      "残响追击在3张牌后伤害翻倍",
      "全频共振提升声爆效率",
    ]
    _ => [ "选择合适的流派开始训练" ]
  }
  { target_enemy: enemy, target_archetype: archetype, tips: tips, practice_attempts: 0 }
}

// ─── 获取训练提示 ───
pub fn get_training_tip(session : TrainingSession) -> String {
  let idx = session.practice_attempts
  if idx < session.tips.length() {
    session.tips[idx]
  } else {
    "你已经掌握了基础，尝试对抗更强的敌人吧！"
  }
}

// ─── 记录训练尝试 ───
pub fn record_training_attempt(session : TrainingSession) -> TrainingSession {
  { ..session, practice_attempts: session.practice_attempts + 1 }
}

// ─── 难度选择菜单 ───
pub fn difficulty_menu() -> String {
  "Select Difficulty:\n" +
  "1. Easy - 简单 (HPx0.8, DMG-2)\n" +
  "2. Normal - 普通 (标准)\n" +
  "3. Hard - 困难 (HPx1.3, DMG+3)\n" +
  "4. Nightmare - 噩梦 (HPx1.6, DMG+6, AP-1)"
}

// ─── 流派选择菜单 ───
pub fn archetype_menu() -> String {
  "Select Archetype:\n" +
  "1. Fortress - 低频堡垒 (高生存/后期)\n" +
  "2. Overload - 过载冲击 (高风险/高爆发)\n" +
  "3. Assassin - 高频刺客 (稳定持续输出)\n" +
  "4. Echo - 回声幻影 (资源效率极致)"
}

// ─── 主菜单文本 ───
pub fn main_menu_text() -> String {
  "╔══════════════════════════════╗\n" +
  "║   ABYSSAL CHORD · 深渊协奏  ║\n" +
  "║      MoonBit Edition        ║\n" +
  "╠══════════════════════════════╣\n" +
  "║ 1. Quick Battle - 快速对战  ║\n" +
  "║ 2. Survival - 生存模式      ║\n" +
  "║ 3. Boss Rush - Boss挑战     ║\n" +
  "║ 4. Training - 训练模式      ║\n" +
  "║ 5. Stats - 查看统计         ║\n" +
  "║ 6. Exit - 退出              ║\n" +
  "╚══════════════════════════════╝"
}

// ─── 战斗UI字符串 ───
pub fn battle_ui(state : BattleState) -> String {
  let lv = get_pollution_level(state.pollution)
  "\n╔══════════════════════════════════╗\n" +
  "║  Turn " + state.turn_number.to_string() + " | " + state.player.name + " vs " + state.enemy.name + "\n" +
  "╠══════════════════════════════════╣\n" +
  "║  HP:  " + state.player.hp.to_string() + "/" + state.player.max_hp.to_string() +
  "  AP: " + state.player.ap.to_string() +
  "  Armor: " + state.player.armor.to_string() + "\n" +
  "║  Enemy: " + state.enemy.hp.to_string() + "/" + state.enemy.max_hp.to_string() +
  "  Armor: " + state.enemy.armor.to_string() + "\n" +
  "║  Pollution: " + state.pollution.to_string() + "/100 (" + lv.name + ")\n" +
  "╚══════════════════════════════════╝"
}

// ─── 手牌显示 ───
pub fn format_hand(state : BattleState) -> String {
  let hand = get_hand(state)
  let mut s = "=== Your Hand ===\n"
  let mut i = 0
  while i < hand.length() {
    let c = hand[i]
    let type_str = match c.card_type {
      Attack => "⚔️"
      Skill => "🛡️"
      Ability => "🔮"
    }
    let cost_str = if c.cost <= state.player.ap { "✓" } else { "✗" }
    s = s + "[" + (i + 1).to_string() + "] " + type_str + " " + c.name +
        " (Cost:" + c.cost.to_string() + " " + cost_str + ")\n" +
        "    " + c.effect + "\n"
    i = i + 1
  }
  s
}

// ─── 胜利动画文本 ───
pub fn victory_text(state : BattleState) -> String {
  "╔══════════════════════════════╗\n" +
  "║     🎉  VICTORY! 🎉         ║\n" +
  "╠══════════════════════════════╣\n" +
  "║  " + state.enemy.name + " defeated!     ║\n" +
  "║  Turns: " + state.turn_number.to_string() + "\n" +
  "║  HP Remaining: " + state.player.hp.to_string() + "/" + state.player.max_hp.to_string() + "\n" +
  "║  Pollution: " + state.pollution.to_string() + "/100\n" +
  "╚══════════════════════════════╝"
}

// ─── 失败动画文本 ───
pub fn defeat_text(state : BattleState) -> String {
  let reason = if state.player.hp <= 0 { "HP depleted" } else { "Pollution maxed" }
  "╔══════════════════════════════╗\n" +
  "║      💀  DEFEATED 💀        ║\n" +
  "╠══════════════════════════════╣\n" +
  "║  " + reason + "\n" +
  "║  Turns survived: " + state.turn_number.to_string() + "\n" +
  "║  Final pollution: " + state.pollution.to_string() + "/100\n" +
  "╚══════════════════════════════╝"
}

// ─── 颜色代码 ───
pub fn color_reset() -> String { "\x1b[0m" }
pub fn color_red() -> String { "\x1b[31m" }
pub fn color_green() -> String { "\x1b[32m" }
pub fn color_yellow() -> String { "\x1b[33m" }
pub fn color_blue() -> String { "\x1b[34m" }
pub fn color_purple() -> String { "\x1b[35m" }

// ─── 角色选择菜单 ───
pub fn character_select_menu() -> String {
  "Select Character:\n" +
  "1. 钟律 (Zhong Lu) - HP:80 过载音叉\n" +
  "   流派: 低频堡垒 / 过载冲击\n" +
  "2. 弦音 (Xian Yin) - HP:55 断裂琴弦\n" +
  "   流派: 高频刺客 / 回声幻影"
}

// ─── 帮助文本 ───
pub fn help_text() -> String {
  "=== ABYSSAL CHORD Help ===\n" +
  "\n" +
  "BASIC RULES:\n" +
  "- You have 3 AP per turn to play cards\n" +
  "- Cards cost 0-3 AP\n" +
  "- End turn to let enemy act\n" +
  "- Enemy HP=0 -> Victory\n" +
  "- Your HP=0 or Pollution=100 -> Defeat\n" +
  "\n" +
  "CARD TYPES:\n" +
  "- ⚔️ Attack: Deal damage to enemy\n" +
  "- 🛡️ Skill: Gain armor, draw cards, etc.\n" +
  "- 🔮 Ability: Permanent effects\n" +
  "\n" +
  "KEY MECHANICS:\n" +
  "- Sonic Boom (声爆): X2 true damage at turn end\n" +
  "- Pollution (污染度): Affects enemy power\n" +
  "- Armor (护甲): Absorbs non-piercing damage\n" +
  "\n" +
  "TIPS:\n" +
  "- Play ability cards early for long-term benefits\n" +
  "- Keep pollution under control with purge cards\n" +
  "- Stack sonic boom before big attacks\n" +
  "- Don't neglect defense - armor saves lives"
}

// ─── 版本信息 ───
pub fn version_info() -> String {
  "Abyssal Chord v0.1.0\n" +
  "MoonBit Edition\n" +
  "Engine: ~3200+ lines of MoonBit\n" +
  "7 enemies, 40 cards, 2 characters\n" +
  "License: Apache-2.0"
}
