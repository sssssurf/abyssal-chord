///|
/// 钟律牌库 - 26张卡牌

// ─── 钟律完整牌库 ───
pub fn zhong_lv_cards() -> Array[Card] {
  [
    // ═══ 基础牌 (10张) ═══
    { id: "zl-basic-01", name: "重频打击", name_en: "Heavy Frequency Strike", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 5 点伤害", design_note: "基准攻击牌", base_damage: 5, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-02", name: "重频打击", name_en: "Heavy Frequency Strike", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 5 点伤害", design_note: "基准攻击牌", base_damage: 5, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-03", name: "重频打击", name_en: "Heavy Frequency Strike", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 5 点伤害", design_note: "基准攻击牌", base_damage: 5, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-04", name: "重频打击", name_en: "Heavy Frequency Strike", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 5 点伤害", design_note: "基准攻击牌", base_damage: 5, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-05", name: "声学壁垒", name_en: "Acoustic Barrier", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 5 点护甲", design_note: "基准防御牌", base_damage: 0, base_armor: 5, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-06", name: "声学壁垒", name_en: "Acoustic Barrier", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 5 点护甲", design_note: "基准防御牌", base_damage: 0, base_armor: 5, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-07", name: "声学壁垒", name_en: "Acoustic Barrier", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 5 点护甲", design_note: "基准防御牌", base_damage: 0, base_armor: 5, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-08", name: "声学壁垒", name_en: "Acoustic Barrier", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 5 点护甲", design_note: "基准防御牌", base_damage: 0, base_armor: 5, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-basic-09", name: "稳频调谐", name_en: "Stable Frequency Tuning", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 3 点护甲，降低 10 点污染度", design_note: "防御+净化", base_damage: 0, base_armor: 3, self_damage: 0, sonic_boom: 0, pollution_modifier: -10, exhaust: false, retain: false },
    { id: "zl-basic-10", name: "余音震击", name_en: "Resonant Shock", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 3 点伤害，附加 1 层声爆", design_note: "3伤害+1声爆", base_damage: 3, base_armor: 0, self_damage: 0, sonic_boom: 1, pollution_modifier: 0, exhaust: false, retain: false },
    // ═══ 低频堡垒流 (3张) ═══
    { id: "zl-fortress-01", name: "共振壁垒", name_en: "Resonance Bulwark", card_type: Skill, archetype: Fortress, cost: 2, target: Self, effect: "获得 14 点护甲。若护甲超过20，对敌人造成溢出伤害", design_note: "以守为攻核心", base_damage: 0, base_armor: 14, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-fortress-02", name: "谐波叠加", name_en: "Harmonic Stack", card_type: Skill, archetype: Fortress, cost: 1, target: Self, effect: "获得 3 点护甲。本回合每打出一张牌再获得 2 点护甲", design_note: "高密度出牌", base_damage: 0, base_armor: 3, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-fortress-03", name: "次声崩塌", name_en: "Infrasonic Collapse", card_type: Attack, archetype: Fortress, cost: 3, target: Aoe, effect: "造成等于护甲50%的伤害，失去一半护甲", design_note: "护甲转化伤害", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    // ═══ 过载冲击流 (3张) ═══
    { id: "zl-overload-01", name: "过载轰鸣", name_en: "Overload Roar", card_type: Attack, archetype: Overload, cost: 2, target: Single, effect: "造成 16 点伤害，对自身造成 5 点伤害", design_note: "血线换杀线", base_damage: 16, base_armor: 0, self_damage: 5, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-overload-02", name: "反馈回路", name_en: "Feedback Loop", card_type: Attack, archetype: Overload, cost: 1, target: Single, effect: "造成 4 点伤害。若本回合已受自伤，伤害翻倍并可免费再打一次", design_note: "Combo核心", base_damage: 4, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-overload-03", name: "断弦极限", name_en: "Broken String Limit", card_type: Attack, archetype: Overload, cost: 0, target: Self, effect: "失去 10 点生命值。获得 2 AP。下一张攻击牌伤害 +10", design_note: "0AP爆发启动", base_damage: 0, base_armor: 0, self_damage: 10, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    // ═══ 永久能力牌 (4张) ═══
    { id: "zl-ability-01", name: "频率锚定", name_en: "Frequency Anchor", card_type: Ability, archetype: Fortress, cost: 1, target: Self, effect: "【永久】每回合开始时获得 3 点护甲", design_note: "长期投资", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-ability-02", name: "低频共振", name_en: "Low Frequency Resonance", card_type: Ability, archetype: Fortress, cost: 2, target: Self, effect: "【永久】每获得 5 点护甲，对敌人造成 3 点伤害", design_note: "叠甲=攻击", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-ability-03", name: "痛觉回响", name_en: "Pain Echo", card_type: Ability, archetype: Overload, cost: 1, target: Self, effect: "【永久】每受1点自伤，下一张攻击牌+1伤害(最多+8)", design_note: "自伤转增伤", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "zl-ability-04", name: "终末定音", name_en: "Final Tuning", card_type: Ability, archetype: Overload, cost: 3, target: Self, effect: "【永久】HP<20时，所有攻击牌+5伤害，每回合受2穿透伤害", design_note: "背水一战", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
  ]
}

// ─── 初始手牌 ───
pub fn initial_hand() -> Array[Card] {
  let all = zhong_lv_cards()
  [ all[0], all[1], all[4], all[5], all[8], all[9] ]
}
