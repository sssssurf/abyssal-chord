///|
/// 战斗阵型系统 - 多角色编队与协同作战

// ─── 阵型类型 ───
pub enum FormationType {
  Vanguard     // 先锋阵：前排+ATK，后排+DEF
  Phalanx      // 方阵：全体+DEF
  Assault      // 突击阵：全体+ATK
  Resonant     // 共鸣阵：声爆效果+50%
  Adaptive     // 自适应阵：根据污染度调整
} derive(Eq)

// ─── 阵型配置 ───
pub struct Formation {
  name : String
  name_en : String
  formation_type : FormationType
  attack_bonus : Int
  armor_bonus : Int
  sonic_boom_multiplier : Double
  pollution_resistance : Int
  ap_bonus : Int
}

// ─── 预置阵型 ───
pub fn vanguard() -> Formation {
  { name: "先锋阵", name_en: "Vanguard", formation_type: Vanguard, attack_bonus: 3, armor_bonus: 1, sonic_boom_multiplier: 1.0, pollution_resistance: 0, ap_bonus: 0 }
}

pub fn phalanx() -> Formation {
  { name: "方阵", name_en: "Phalanx", formation_type: Phalanx, attack_bonus: 0, armor_bonus: 5, sonic_boom_multiplier: 1.0, pollution_resistance: 2, ap_bonus: 0 }
}

pub fn assault() -> Formation {
  { name: "突击阵", name_en: "Assault", formation_type: Assault, attack_bonus: 5, armor_bonus: -2, sonic_boom_multiplier: 1.0, pollution_resistance: 0, ap_bonus: 1 }
}

pub fn resonant() -> Formation {
  { name: "共鸣阵", name_en: "Resonant", formation_type: Resonant, attack_bonus: 2, armor_bonus: 2, sonic_boom_multiplier: 1.5, pollution_resistance: -3, ap_bonus: 0 }
}

pub fn adaptive() -> Formation {
  { name: "自适应阵", name_en: "Adaptive", formation_type: Adaptive, attack_bonus: 0, armor_bonus: 0, sonic_boom_multiplier: 1.0, pollution_resistance: 5, ap_bonus: 0 }
}

// ─── 应用阵型加成 ───
pub fn apply_formation(state : BattleState, formation : Formation) -> BattleState {
  {
    ..state,
    player: { ..state.player,
      damage_bonus: state.player.damage_bonus + formation.attack_bonus,
      armor: state.player.armor + formation.armor_bonus,
      ap: if state.player.ap + formation.ap_bonus > state.player.max_ap + 2 { state.player.max_ap + 2 } else { state.player.ap + formation.ap_bonus },
    },
    pollution: if state.pollution - formation.pollution_resistance < 0 { 0 } else { state.pollution - formation.pollution_resistance },
  }
}

// ─── 获取声爆倍率 ───
pub fn get_sonic_boom_multiplier(formation : Formation) -> Double {
  formation.sonic_boom_multiplier
}

// ─── 所有阵型 ───
pub fn all_formations() -> Array[Formation] {
  [ vanguard(), phalanx(), assault(), resonant(), adaptive() ]
}

// ─── 根据污染度推荐阵型 ───
pub fn recommend_formation(pollution : Int) -> Formation {
  if pollution >= 70 {
    adaptive()
  } else if pollution >= 40 {
    phalanx()
  } else {
    assault()
  }
}

// ─── 阵型名称列表 ───
pub fn formation_names() -> Array[String] {
  let formations = all_formations()
  let name_list : Array[String] = []
  let mut i = 0
  while i < formations.length() { name_list.push(formations[i].name); i = i + 1 }
  name_list
}

// ─── 队伍配置 ───
pub struct TeamConfig {
  leader : Character
  formation : Formation
  difficulty : Int  // 1-4
  enemy_id : String
}

// ─── 创建队伍配置 ───
pub fn create_team_config(char_id : String, formation_type : FormationType, difficulty : Int, enemy_id : String) -> TeamConfig {
  let char = match char_id {
    "zhong-lv" => zhong_lv()
    "xian-yin" => xian_yin()
    _ => zhong_lv()
  }
  let formation = match formation_type {
    Vanguard => vanguard()
    Phalanx => phalanx()
    Assault => assault()
    Resonant => resonant()
    Adaptive => adaptive()
  }
  {
    leader: char,
    formation: formation,
    difficulty: difficulty,
    enemy_id: enemy_id,
  }
}

// ─── 根据队伍配置启动战斗 ───
pub fn start_team_battle(config : TeamConfig) -> BattleState {
  let enemy_data = get_enemy_by_id(config.enemy_id)
  let battle = init_battle(config.leader, enemy_data)
  let battle_with_formation = apply_formation(battle, config.formation)
  battle_with_formation
}

// ─── 获取配置摘要 ───
pub fn team_config_summary(config : TeamConfig) -> String {
  "Team: " + config.leader.name +
  " | Formation: " + config.formation.name +
  " | Difficulty: " + config.difficulty.to_string() +
  " | Enemy: " + config.enemy_id
}
