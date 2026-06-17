///|
/// 弦音（频率猎手）专属牌库 - 高频刺客 & 回声幻影流

pub fn xian_yin_cards() -> Array[Card] {
  [
    // ═══ 基础牌 (8张) ═══
    { id: "xy-basic-01", name: "高频切割", name_en: "High Frequency Cut", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 4 点伤害。若目标有声爆，额外造成 2 点伤害", design_note: "基础攻击+声爆联动", base_damage: 4, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-02", name: "高频切割", name_en: "High Frequency Cut", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 4 点伤害。若目标有声爆，额外造成 2 点伤害", design_note: "基础攻击+声爆联动", base_damage: 4, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-03", name: "高频切割", name_en: "High Frequency Cut", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 4 点伤害。若目标有声爆，额外造成 2 点伤害", design_note: "基础攻击+声爆联动", base_damage: 4, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-04", name: "高频切割", name_en: "High Frequency Cut", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 4 点伤害。若目标有声爆，额外造成 2 点伤害", design_note: "基础攻击+声爆联动", base_damage: 4, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-05", name: "音纹闪避", name_en: "Sonic Dodge", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 4 点护甲。若本回合已打出攻击牌，额外获得 3 点护甲", design_note: "攻击+防御联动", base_damage: 0, base_armor: 4, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-06", name: "音纹闪避", name_en: "Sonic Dodge", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "获得 4 点护甲。若本回合已打出攻击牌，额外获得 3 点护甲", design_note: "攻击+防御联动", base_damage: 0, base_armor: 4, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-basic-07", name: "谐波感知", name_en: "Harmonic Sense", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "抽 2 张牌。降低 5 点污染度", design_note: "抽牌+净化", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: -5, exhaust: false, retain: false },
    { id: "xy-basic-08", name: "谐波感知", name_en: "Harmonic Sense", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "抽 2 张牌。降低 5 点污染度", design_note: "抽牌+净化", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: -5, exhaust: false, retain: false },

    // ═══ 高频刺客流 (4张) ═══
    { id: "xy-assassin-01", name: "声纹连斩", name_en: "Sonic Flurry", card_type: Attack, archetype: Basic, cost: 1, target: Single, effect: "造成 3 点伤害。本回合可以再打出一次（不消耗额外AP）", design_note: "高频快攻核心，多次触发遗物", base_damage: 3, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-assassin-02", name: "共振穿刺", name_en: "Resonance Pierce", card_type: Attack, archetype: Basic, cost: 2, target: Single, effect: "造成 7 点伤害。附加 2 层声爆。若目标已有声爆则伤害 +3", design_note: "声爆叠层+爆发", base_damage: 7, base_armor: 0, self_damage: 0, sonic_boom: 2, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-assassin-03", name: "超频驱动", name_en: "Overclock Drive", card_type: Attack, archetype: Basic, cost: 2, target: Aoe, effect: "对全体敌人造成 5 点伤害。每有一个带声爆的敌人，伤害 +2", design_note: "AOE清场+声爆联动", base_damage: 5, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-assassin-04", name: "次声潜行", name_en: "Infrasonic Stealth", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "本回合获得隐身（敌人无法指定你为目标）。下回合首次攻击伤害 +8", design_note: "防守+爆发准备", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },

    // ═══ 回声幻影流 (4张) ═══
    { id: "xy-echo-01", name: "回声标记", name_en: "Echo Mark", card_type: Ability, archetype: Basic, cost: 2, target: Self, effect: "【永久】你打出的每张牌在回合末复制一次效果（伤害减半向下取整）", design_note: "回声流核心——一牌双响", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-echo-02", name: "相位镜像", name_en: "Phase Mirror", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "选择手牌中一张攻击牌，将其一张临时复制加入手牌（本回合有效）", design_note: "关键牌复制", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-echo-03", name: "残响追击", name_en: "Afterimage Pursuit", card_type: Attack, archetype: Basic, cost: 2, target: Single, effect: "造成 6 点伤害。若本回合已打出至少 3 张牌，伤害翻倍", design_note: "高频出牌奖励", base_damage: 6, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "xy-echo-04", name: "全频共振", name_en: "Full Spectrum Resonance", card_type: Ability, archetype: Basic, cost: 3, target: Self, effect: "【永久】每当你附加声爆时，额外附加 1 层。你的声爆伤害变为每层 3 点", design_note: "声爆特化——质变能力牌", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
  ]
}

// ─── 通用中立牌 (4张) ───
pub fn neutral_cards() -> Array[Card] {
  [
    { id: "neutral-01", name: "锚点充能", name_en: "Anchor Charge", card_type: Skill, archetype: Basic, cost: 2, target: Self, effect: "获得 8 点护甲。恢复 2 点 AP 给下一回合", design_note: "紧急防御+资源回收", base_damage: 0, base_armor: 8, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: false, retain: false },
    { id: "neutral-02", name: "净化谐波", name_en: "Purify Harmonic", card_type: Skill, archetype: Basic, cost: 1, target: Self, effect: "降低 20 点污染度。抽 1 张牌", design_note: "污染管理工具", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: -20, exhaust: false, retain: false },
    { id: "neutral-03", name: "紧急修复", name_en: "Emergency Repair", card_type: Skill, archetype: Basic, cost: 2, target: Self, effect: "恢复 15 点生命值。消耗", design_note: "生命线——一次性救命牌", base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 0, exhaust: true, retain: false },
    { id: "neutral-04", name: "声子爆弹", name_en: "Phonon Bomb", card_type: Attack, archetype: Basic, cost: 3, target: Aoe, effect: "造成 12 点伤害。使污染度 +10。保留", design_note: "高费AOE+污染代价+可保留", base_damage: 12, base_armor: 0, self_damage: 0, sonic_boom: 0, pollution_modifier: 10, exhaust: false, retain: true },
  ]
}

// ─── 获取所有卡牌 ───
pub fn all_cards() -> Array[Card] {
  let zl = zhong_lv_cards()
  let xy = xian_yin_cards()
  let neutral = neutral_cards()
  let result : Array[Card] = []
  let mut i = 0
  while i < zl.length() { result.push(zl[i]); i = i + 1 }
  let mut j = 0
  while j < xy.length() { result.push(xy[j]); j = j + 1 }
  let mut k = 0
  while k < neutral.length() { result.push(neutral[k]); k = k + 1 }
  result
}

// ─── 总卡牌数 ───
pub fn total_card_count() -> Int { 40 }
