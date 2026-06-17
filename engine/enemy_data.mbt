///|
/// 敌人数据

// ─── 嘶鸣游荡者 ───
pub fn howling_drifter() -> Enemy {
  {
    id: "howling-drifter", name: "嘶鸣游荡者", name_en: "Howling Drifter",
    lore: "曾是人类，被旧日回音侵蚀后声带异化为可发射次声波的器官。",
    hp_1p: 18, hp_2p: 26, hp_3p: 34, hp_4p: 42,
    is_boss: false, has_phase2: false,
    phase2_trigger: "", phase2_effect: "",
    actions: [
      { dice_min: 1, dice_max: 2, name: "次声冲撞", name_en: "Infrasonic Charge", action_type: Attack_, effect: "造成 6 点伤害", damage: 6, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 3, dice_max: 3, name: "撕裂嘶鸣", name_en: "Tearing Howl", action_type: AttackDebuff, effect: "造成 4 点伤害，附加 2 层声爆", damage: 4, armor: 0, sonic_boom: 2, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "声波蓄积", name_en: "Wave Accumulation", action_type: Buff_, effect: "获得 8 点护甲，污染度 +5", damage: 0, armor: 8, sonic_boom: 0, pollution_increase: 5, piercing: false, special: "" },
      { dice_min: 5, dice_max: 5, name: "共振增幅", name_en: "Resonance Amplify", action_type: Special_, effect: "本回合伤害 +3，再次掷骰", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "reroll_with_bonus_3" },
      { dice_min: 6, dice_max: 6, name: "低频感染", name_en: "Low Frequency Infection", action_type: Aoe_, effect: "对全体造成 3 点伤害，附加 1 层声爆", damage: 3, armor: 0, sonic_boom: 1, pollution_increase: 0, piercing: false, special: "" },
    ],
    phase2_actions: [],
  }
}

// ─── 静默拟态体 ───
pub fn silent_mimic() -> Enemy {
  {
    id: "silent-mimic", name: "静默拟态体", name_en: "Silent Mimic",
    lore: "一种诡异的畸变体，它不发出任何声音——它吞噬声音。",
    hp_1p: 22, hp_2p: 30, hp_3p: 38, hp_4p: 46,
    is_boss: false, has_phase2: false,
    phase2_trigger: "", phase2_effect: "",
    actions: [
      { dice_min: 1, dice_max: 1, name: "真空触手", name_en: "Vacuum Tentacle", action_type: Attack_, effect: "造成 8 点伤害", damage: 8, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 2, dice_max: 2, name: "消音力场", name_en: "Silencing Field", action_type: Buff_, effect: "获得 10 点护甲。下次攻击伤害 -3", damage: 0, armor: 10, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "reduce_next_attack_3" },
      { dice_min: 3, dice_max: 4, name: "声波吞噬", name_en: "Wave Devour", action_type: AttackDebuff, effect: "造成 5 点伤害，随机弃1张手牌", damage: 5, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "discard_1_card" },
      { dice_min: 5, dice_max: 5, name: "拟态伪装", name_en: "Mimic Disguise", action_type: Special_, effect: "反弹50%伤害", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "reflect_50_percent" },
      { dice_min: 6, dice_max: 6, name: "绝对寂静", name_en: "Absolute Silence", action_type: Aoe_, effect: "污染度+10。攻击伤害-21回合", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 10, piercing: false, special: "deafen_all" },
    ],
    phase2_actions: [],
  }
}

// ─── 深渊颂歌·穆托斯(Boss) ───
pub fn mutos() -> Enemy {
  {
    id: "mutos", name: "深渊颂歌·穆托斯", name_en: "Abyssal Hymn · Mutos",
    lore: "回响裂谷深处的支配者。它的歌声足以碾碎一切生灵。",
    hp_1p: 80, hp_2p: 120, hp_3p: 160, hp_4p: 200,
    is_boss: true, has_phase2: true,
    phase2_trigger: "HP <= 50%",
    phase2_effect: "清空护甲；污染度+25；获得咏叹调状态(每回合+8护甲、污染+10、伤害+5)",
    actions: [
      { dice_min: 1, dice_max: 2, name: "震颤低音", name_en: "Tremor Bass", action_type: Attack_, effect: "造成 10 点伤害", damage: 10, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 3, dice_max: 3, name: "回响轰击", name_en: "Echo Bombardment", action_type: Aoe_, effect: "对全体造成 7 点伤害", damage: 7, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "声学护盾", name_en: "Acoustic Shield", action_type: Buff_, effect: "获得 12 点护甲", damage: 0, armor: 12, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 5, dice_max: 5, name: "深渊呼唤", name_en: "Abyssal Call", action_type: Special_, effect: "污染度+10。召唤嘶鸣游荡者", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 10, piercing: false, special: "summon_drifter_half" },
      { dice_min: 6, dice_max: 6, name: "共鸣压制", name_en: "Resonance Suppress", action_type: AttackDebuff, effect: "造成6伤害，附加3层声爆", damage: 6, armor: 0, sonic_boom: 3, pollution_increase: 0, piercing: false, special: "sonic_boom_detonate" },
    ],
    phase2_actions: [
      { dice_min: 1, dice_max: 2, name: "坍缩音爆", name_en: "Collapsing Boom", action_type: Attack_, effect: "造成 15 点伤害", damage: 15, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 3, dice_max: 3, name: "裂谷共鸣", name_en: "Rift Resonance", action_type: Aoe_, effect: "对全体造成 12 点伤害", damage: 12, armor: 0, sonic_boom: 0, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 4, dice_max: 4, name: "绝对音域", name_en: "Absolute Frequency", action_type: Buff_, effect: "获得 15 点护甲。所有玩家+2声爆", damage: 0, armor: 15, sonic_boom: 2, pollution_increase: 0, piercing: false, special: "" },
      { dice_min: 5, dice_max: 5, name: "深渊再呼", name_en: "Abyssal Recall", action_type: Special_, effect: "污染度+15。召唤嘶鸣游荡者(75%)", damage: 0, armor: 0, sonic_boom: 0, pollution_increase: 15, piercing: false, special: "summon_drifter_75" },
      { dice_min: 6, dice_max: 6, name: "末日和弦", name_en: "Doomsday Chord", action_type: Aoe_, effect: "造成8伤害+3声爆。污染>=20时额外5穿透伤害", damage: 8, armor: 0, sonic_boom: 3, pollution_increase: 0, piercing: true, special: "pollution_threshold_bonus" },
    ],
  }
}

pub fn all_enemies() -> Array[Enemy] {
  [ howling_drifter(), silent_mimic(), mutos() ]
}
