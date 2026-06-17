///|
/// 卡牌平衡分析与新卡牌补充 - 基于数值模型进行平衡调整

// ─── 卡牌平衡问题分析报告 ───
// - 过载轰鸣 2AP=16伤害+5自伤：超模（净11伤害/2AP=5.5），但自伤有隐形成本。平衡。
// - 断弦极限 0AP=10自伤+2AP+10攻击：超高价值，但需要后续打出攻击牌兑现。平衡。
// - 共振壁垒 2AP=14护甲：超模（+4），但溢出伤害需要先堆甲。平衡。
// - 声学壁垒 1AP=5护甲：标准。平衡。
// - 重频打击 1AP=5伤害：标准。平衡。
// - 谐波叠加 1AP=3+2×N护甲：N=3时=9 (+4超模)，N=5时=13 (+8超模)。略超模，但需要高密度出牌。
// - 次声崩塌 3AP=armor/2伤害+armor/2损失：需要40护甲才=20伤害(+5超模)。条件苛刻，平衡。
// - 稳频调谐 1AP=3护甲+10净化：双重效果，总效用=3+~2.5(净化)=5.5，略超模。
// - 反馈回路 1AP=4(条件8)伤害：条件满足时8伤害(+3超模)+免费再打。完美平衡。
// - 能力牌 1-3AP=永久效果：1回合回本，长期超高收益。合理。
// 结论：整体平衡良好，但缺少以下方向的卡牌来丰富牌组

// ─── 新增卡牌 (15张) - 弥补流派缺口 ───
pub fn expansion_cards() -> Array[Card] {
  [
    // ═══ 钟律专属补充 (5张) ═══
    {
      id: "zl-exp-01", name: "声子护盾", name_en: "Phonon Shield",
      card_type: Skill, archetype: Fortress, cost: 1, target: Self,
      effect: "获得 6 点护甲。保留", design_note: "可保留的防御牌——提供战术灵活性",
      base_damage: 0, base_armor: 6, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: true,
    },
    {
      id: "zl-exp-02", name: "低频脉冲", name_en: "Low Frequency Pulse",
      card_type: Attack, archetype: Fortress, cost: 2, target: Aoe,
      effect: "造成 8 点伤害。每有 10 点护甲额外 +2 伤害", design_note: "堡垒流AOE，护甲转伤害",
      base_damage: 8, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
    {
      id: "zl-exp-03", name: "共振爆发", name_en: "Resonance Burst",
      card_type: Attack, archetype: Overload, cost: 1, target: Single,
      effect: "造成 7 点伤害。消耗", design_note: "一次性高伤害，用过即弃",
      base_damage: 7, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: true, retain: false,
    },
    {
      id: "zl-exp-04", name: "声学共鸣", name_en: "Acoustic Resonance",
      card_type: Skill, archetype: Fortress, cost: 2, target: Self,
      effect: "降低 15 点污染度。抽 2 张牌", design_note: "污染管理+过牌",
      base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: -15, exhaust: false, retain: false,
    },
    {
      id: "zl-exp-05", name: "极限过载", name_en: "Extreme Overload",
      card_type: Attack, archetype: Overload, cost: 3, target: Single,
      effect: "造成 25 点伤害。污染度 +10。消耗", design_note: "终极爆发，但污染代价高",
      base_damage: 25, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 10, exhaust: true, retain: false,
    },

    // ═══ 弦音专属补充 (5张) ═══
    {
      id: "xy-exp-01", name: "音速切割", name_en: "Sonic Slash",
      card_type: Attack, archetype: Basic, cost: 0, target: Single,
      effect: "造成 2 点伤害。保留", design_note: "0费保留攻击——灵活补刀",
      base_damage: 2, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: true,
    },
    {
      id: "xy-exp-02", name: "声纹印记", name_en: "Sonic Mark",
      card_type: Skill, archetype: Basic, cost: 1, target: Single,
      effect: "标记敌人。下2次攻击额外附加 2 层声爆", design_note: "声爆叠加快键",
      base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
    {
      id: "xy-exp-03", name: "回音墙壁", name_en: "Echo Wall",
      card_type: Skill, archetype: Basic, cost: 2, target: Self,
      effect: "获得 7 点护甲。若本回合有声爆被引爆，额外获得 5 点护甲", design_note: "声爆联动防御",
      base_damage: 0, base_armor: 7, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
    {
      id: "xy-exp-04", name: "无声潜行", name_en: "Silent Step",
      card_type: Skill, archetype: Basic, cost: 1, target: Self,
      effect: "降低 10 点污染度。抽 1 张牌", design_note: "小净化+过牌",
      base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: -10, exhaust: false, retain: false,
    },
    {
      id: "xy-exp-05", name: "致命频率", name_en: "Lethal Frequency",
      card_type: Attack, archetype: Basic, cost: 3, target: Single,
      effect: "造成 12 点伤害。附加 3 层声爆", design_note: "弦音高费终结技",
      base_damage: 12, base_armor: 0, self_damage: 0, sonic_boom: 3,
      pollution_modifier: 0, exhaust: false, retain: false,
    },

    // ═══ 通用补充 (5张) ═══
    {
      id: "neutral-exp-01", name: "声波引爆", name_en: "Sonic Detonate",
      card_type: Attack, archetype: Basic, cost: 1, target: Single,
      effect: "造成 3 点伤害。立即引爆目标所有声爆（每层2点）", design_note: "声爆爆发——提前引爆代替等待",
      base_damage: 3, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
    {
      id: "neutral-exp-02", name: "能量转换", name_en: "Energy Convert",
      card_type: Skill, archetype: Basic, cost: 0, target: Self,
      effect: "失去 5 点生命值。获得 1 点 AP", design_note: "0费血换AP——高风险资源",
      base_damage: 0, base_armor: 0, self_damage: 5, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
    {
      id: "neutral-exp-03", name: "谐波净化", name_en: "Harmonic Purify",
      card_type: Skill, archetype: Basic, cost: 2, target: Self,
      effect: "清除所有负面状态。恢复 8 点生命值。消耗", design_note: "救命牌——一键清debuff+回血",
      base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: true, retain: false,
    },
    {
      id: "neutral-exp-04", name: "声子护罩", name_en: "Phonon Barrier",
      card_type: Skill, archetype: Basic, cost: 1, target: Self,
      effect: "获得 8 点护甲。污染度 +3", design_note: "高防低污染代价",
      base_damage: 0, base_armor: 8, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 3, exhaust: false, retain: false,
    },
    {
      id: "neutral-exp-05", name: "深渊共鸣", name_en: "Abyssal Resonance",
      card_type: Ability, archetype: Basic, cost: 2, target: Self,
      effect: "【永久】每当你造成声爆伤害时，额外造成 3 点穿透伤害", design_note: "通用声爆特化能力",
      base_damage: 0, base_armor: 0, self_damage: 0, sonic_boom: 0,
      pollution_modifier: 0, exhaust: false, retain: false,
    },
  ]
}

// ─── 获取所有扩展卡牌数量 ───
pub fn expansion_card_count() -> Int { 15 }

// ─── 更新后的卡牌总数 ───
pub fn updated_total_card_count() -> Int { 55 }

// ─── 获取全部卡牌（含扩展） ───
pub fn all_cards_with_expansion() -> Array[Card] {
  let base = all_cards()
  let expansion = expansion_cards()
  let result : Array[Card] = []
  let mut i = 0
  while i < base.length() { result.push(base[i]); i = i + 1 }
  let mut j = 0
  while j < expansion.length() { result.push(expansion[j]); j = j + 1 }
  result
}
