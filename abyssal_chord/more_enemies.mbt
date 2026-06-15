///|
/// 更多敌人 - 扩展敌人图鉴

// ─── 回声残像 ───
pub fn echo_remnant() -> Enemy {
  {
    id: "echo-remnant", name: "回声残像", name_en: "Echo Remnant",
    lore: "调音师陨落后留下的声波印记。它们没有自我意识，只会不断重复生前最后的声音。",
    hp_1p: 12, hp_2p: 18, hp_3p: 24, hp_4p: 30,
    is_boss: false, has_phase2: false,
    phase2_trigger: "", phase2_effect: "",
    actions: [
      { dice_min: 1, dice_max: 2, name: "回音冲击", name_en: "Echo Impact", action_type: Attack_, effect: "造成 4 点伤害", damage: 4, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 3, dice_max: 4, name: "重复频率", name_en: "Repeat Frequency", action_type: AttackDebuff, effect: "造成 3 点伤害，附加 1 层声爆", damage: 3, armor: 0, sonic_boom: 1, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 5, dice_max: 5, name: "自我复制", name_en: "Self-Replicate", action_type: Buff_, effect: "获得 5 点护甲，污染度+3", damage: 0, armor: 5, sonic_boom: 0, pollution_increase: 3, piercing: false, special: "" },
      { dice_min: 6, dice_max: 6, name: "频率崩溃", name_en: "Frequency Collapse", action_type: Special_, effect: "对自身造成 3 点伤害，对所有玩家造成 5 点伤害", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 2, piercing: false, special: "self_harm_aoe" },
    ],
    phase2_actions: [],
  }
}

// ─── 共振晶体 ───
pub fn resonance_crystal() -> Enemy {
  {
    id: "resonance-crystal", name: "共振晶体", name_en: "Resonance Crystal",
    lore: "旧日回音在矿物中结晶形成的活体结构。它能增幅周围一切声波，让微弱的共鸣变成毁灭性的声浪。",
    hp_1p: 30, hp_2p: 40, hp_3p: 50, hp_4p: 60,
    is_boss: false, has_phase2: false,
    phase2_trigger: "", phase2_effect: "",
    actions: [
      { dice_min: 1, dice_max: 1, name: "晶体共鸣", name_en: "Crystal Resonance", action_type: Buff_, effect: "获得 6 点护甲。本回合所有声爆伤害翻倍", damage: 0, armor: 6, sonic_boom: 0, pollution_increase: 2, piercing: false, special: "double_sonic_boom" },
      { dice_min: 2, dice_max: 3, name: "高频振荡", name_en: "High Frequency Oscillation", action_type: Attack_, effect: "造成 7 点伤害", damage: 7, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "声波折射", name_en: "Wave Refraction", action_type: Aoe_, effect: "对全体造成 4 点伤害，附加 2 层声爆", damage: 4, armor: 0, sonic_boom: 2, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 5, dice_max: 5, name: "谐波增幅", name_en: "Harmonic Amplification", action_type: Special_, effect: "本回合所有伤害 +4。污染度 +5", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 5, piercing: false, special: "amplify_damage" },
      { dice_min: 6, dice_max: 6, name: "晶体碎裂", name_en: "Crystal Shatter", action_type: Aoe_, effect: "失去所有护甲。对全体造成等于失去护甲值的伤害", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: true, special: "shatter_armor" },
    ],
    phase2_actions: [],
  }
}

// ─── 深渊尖啸者 ───
pub fn abyssal_shrieker() -> Enemy {
  {
    id: "abyssal-shrieker", name: "深渊尖啸者", name_en: "Abyssal Shrieker",
    lore: "一种罕见的飞行畸变体。它的尖啸可以直接撕裂声学护盾，振动穿透护甲直接伤害调音师的内脏。",
    hp_1p: 25, hp_2p: 35, hp_3p: 45, hp_4p: 55,
    is_boss: false, has_phase2: false,
    phase2_trigger: "", phase2_effect: "",
    actions: [
      { dice_min: 1, dice_max: 2, name: "穿刺尖啸", name_en: "Piercing Shriek", action_type: Attack_, effect: "造成 5 点穿透伤害（无视护甲）", damage: 5, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: true, special: "" },
      { dice_min: 3, dice_max: 3, name: "声波俯冲", name_en: "Sonic Dive", action_type: AttackDebuff, effect: "造成 6 点伤害，附加 2 层声爆", damage: 6, armor: 0, sonic_boom: 2, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "掠食盘旋", name_en: "Predator Circle", action_type: Buff_, effect: "获得 4 点护甲。下一回合伤害 +4", damage: 0, armor: 4, sonic_boom: 0, pollution_increase: 2, piercing: false, special: "next_turn_bonus" },
      { dice_min: 5, dice_max: 5, name: "群体尖啸", name_en: "Swarm Shriek", action_type: Aoe_, effect: "对全体造成 4 点伤害", damage: 4, armor: 0, sonic_boom: 0, pollution_increase: 3, piercing: false, special: "" },
      { dice_min: 6, dice_max: 6, name: "次声共振", name_en: "Infrasonic Pulse", action_type: Special_, effect: "污染度 +8。若当前有召唤生物，召唤生物攻击一次", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 8, piercing: false, special: "minion_attack" },
    ],
    phase2_actions: [],
  }
}

// ─── 谐波构造体（Boss） ───
pub fn harmonic_construct() -> Enemy {
  {
    id: "harmonic-construct", name: "谐波构造体", name_en: "Harmonic Construct",
    lore: "锚点塔核心失控后形成的自主声学结构。它由纯粹的声波能量构成，能够分析并模仿调音师的攻击模式。",
    hp_1p: 60, hp_2p: 90, hp_3p: 120, hp_4p: 150,
    is_boss: true, has_phase2: true,
    phase2_trigger: "HP <= 40%",
    phase2_effect: "激活'自适应谐振'状态：每受到一种类型的伤害后，对该类型的伤害获得 3 点抗性",
    actions: [
      { dice_min: 1, dice_max: 2, name: "声波扫描", name_en: "Sonic Scan", action_type: Buff_, effect: "获得 8 点护甲。分析玩家手牌，减少下回合玩家1AP", damage: 0, armor: 8, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "ap_drain" },
      { dice_min: 3, dice_max: 3, name: "谐波反击", name_en: "Harmonic Counter", action_type: Attack_, effect: "造成 8 点伤害。若玩家上回合打出攻击牌，伤害 +4", damage: 8, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "counter_attack" },
      { dice_min: 4, dice_max: 4, name: "频率复制", name_en: "Frequency Copy", action_type: Special_, effect: "复制玩家上回合最后一张牌的伤害数值，对玩家造成该数值的伤害", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "copy_last_card" },
      { dice_min: 5, dice_max: 5, name: "共振场", name_en: "Resonance Field", action_type: Aoe_, effect: "对全体造成 5 点伤害，污染度 +5，附加 1 层声爆", damage: 5, armor: 0, sonic_boom: 1, pollution_increase: 5, piercing: false, special: "" },
      { dice_min: 6, dice_max: 6, name: "结构重组", name_en: "Structural Reform", action_type: Buff_, effect: "恢复 10 点生命。获得 10 点护甲。污染度 +8", damage: 0, armor: 10, sonic_boom: 0, pollution_increase: 8, piercing: false, special: "heal" },
    ],
    phase2_actions: [
      { dice_min: 1, dice_max: 2, name: "自适应脉冲", name_en: "Adaptive Pulse", action_type: Attack_, effect: "造成 10 点伤害。使玩家下回合AP-1", damage: 10, armor: 0, sonic_boom: 0, pollution_increase: 2, piercing: false, special: "ap_drain_2" },
      { dice_min: 3, dice_max: 3, name: "谐波过载", name_en: "Harmonic Overload", action_type: Aoe_, effect: "对全体造成 8 点伤害", damage: 8, armor: 0, sonic_boom: 0, pollution_increase: 3, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "完全复制", name_en: "Perfect Copy", action_type: Special_, effect: "复制玩家上回合总伤害的80%，反弹给玩家", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: true, special: "copy_80_percent" },
      { dice_min: 5, dice_max: 5, name: "共振坍缩", name_en: "Resonance Collapse", action_type: Aoe_, effect: "造成 6 点伤害。引爆所有声爆（每层2点伤害）", damage: 6, armor: 0, sonic_boom: 0, pollution_increase: 5, piercing: false, special: "detonate_all_sonic" },
      { dice_min: 6, dice_max: 6, name: "终末谐振", name_en: "Final Harmony", action_type: Special_, effect: "污染度直接 +15。对所有玩家造成等于污染度/5的穿透伤害", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 15, piercing: true, special: "pollution_scaling" },
    ],
  }
}

// ─── 所有扩展敌人 ───
pub fn extra_enemies() -> Array[Enemy] {
  [ echo_remnant(), resonance_crystal(), abyssal_shrieker(), harmonic_construct() ]
}

// ─── 根据ID获取敌人 ───
pub fn get_enemy_by_id(id : String) -> Enemy {
  match id {
    "howling-drifter" => howling_drifter()
    "silent-mimic" => silent_mimic()
    "mutos" => mutos()
    "echo-remnant" => echo_remnant()
    "resonance-crystal" => resonance_crystal()
    "abyssal-shrieker" => abyssal_shrieker()
    "harmonic-construct" => harmonic_construct()
    _ => howling_drifter()
  }
}

// ─── 获取所有敌人 ───
pub fn all_enemies_full() -> Array[Enemy] {
  let existing = all_enemies()
  let extra = extra_enemies()
  let result : Array[Enemy] = []
  let mut i = 0
  while i < existing.length() { result.push(existing[i]); i = i + 1 }
  let mut j = 0
  while j < extra.length() { result.push(extra[j]); j = j + 1 }
  result
}

// ─── 总敌人数 ───
pub fn total_enemy_count() -> Int { 7 }

// ─── 获取所有敌人名称 ───
pub fn all_enemy_names() -> Array[String] {
  let all = all_enemies_full()
  let names : Array[String] = []
  let mut i = 0
  while i < all.length() {
    names.push(all[i].name)
    i = i + 1
  }
  names
}
