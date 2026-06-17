///|
/// 污染度系统 - 5个等级

// ─── 污染度等级表 ───
pub fn pollution_levels() -> Array[PollutionLevel] {
  [
    { min_val: 0,  max_val: 15, name: "寂静期", name_en: "Silent",   damage_bonus: 0,  armor_per_turn: 0, player_piercing_dmg: 0 },
    { min_val: 16, max_val: 40, name: "低鸣期", name_en: "Humming",   damage_bonus: 2,  armor_per_turn: 0, player_piercing_dmg: 0 },
    { min_val: 41, max_val: 70, name: "共振期", name_en: "Resonance", damage_bonus: 4,  armor_per_turn: 3, player_piercing_dmg: 0 },
    { min_val: 71, max_val: 90, name: "咆哮期", name_en: "Roaring",   damage_bonus: 6,  armor_per_turn: 5, player_piercing_dmg: 3 },
    { min_val: 91, max_val: 100, name: "终焉和弦", name_en: "Finale",  damage_bonus: 10, armor_per_turn: 5, player_piercing_dmg: 5 },
  ]
}

// ─── 获取当前污染等级 ───
pub fn get_pollution_level(pollution : Int) -> PollutionLevel {
  let levels = pollution_levels()
  if pollution >= 91 {
    levels[4]
  } else if pollution >= 71 {
    levels[3]
  } else if pollution >= 41 {
    levels[2]
  } else if pollution >= 16 {
    levels[1]
  } else {
    levels[0]
  }
}

pub fn max_pollution() -> Int {
  100
}

pub fn initial_pollution() -> Int {
  0
}

pub fn is_pollution_max(pollution : Int) -> Bool {
  pollution >= 100
}
