///|
/// 卡牌协同系统 - 分析卡牌间combo和流派配合

// ─── 协同类型 ───
pub enum SynergyType {
  DirectCombo     // 直接连击
  Conditional     // 条件触发
  PassiveBoost    // 被动增益
  ArchetypeCore   // 流派核心
} derive(Eq)

// ─── 协同关系 ───
pub struct Synergy {
  card_a_id : String
  card_b_id : String
  synergy_type : SynergyType
  description : String
  power_rating : Int  // 1-10
}

// ─── 钟律堡叻流协同 ───
pub fn fortress_synergies() -> Array[Synergy] {
  [
    {
      card_a_id: "zl-ability-01", card_b_id: "zl-fortress-02",
      synergy_type: PassiveBoost, description: "频率锚定(每回合+3护甲) + 谐波叠加(每张牌+2护甲) = 超高护甲积累",
      power_rating: 8,
    },
    {
      card_a_id: "zl-ability-01", card_b_id: "zl-fortress-01",
      synergy_type: Conditional, description: "频率锚定+共振壁垒：每回合稳定叠甲后触发溢出伤害",
      power_rating: 7,
    },
    {
      card_a_id: "zl-fortress-02", card_b_id: "zl-fortress-03",
      synergy_type: DirectCombo, description: "谐波叠加快速叠甲后接次声崩塌：护甲→伤害转化率50%",
      power_rating: 9,
    },
    {
      card_a_id: "zl-fortress-01", card_b_id: "zl-ability-02",
      synergy_type: PassiveBoost, description: "共振壁垒+低频共振：叠甲的同时自动输出",
      power_rating: 8,
    },
  ]
}

// ─── 钟律过载流协同 ───
pub fn overload_synergies() -> Array[Synergy] {
  [
    {
      card_a_id: "zl-overload-03", card_b_id: "zl-overload-02",
      synergy_type: DirectCombo, description: "断弦极限(自伤) + 反馈回路(翻倍)：10自伤触发+8伤害+免费再打",
      power_rating: 10,
    },
    {
      card_a_id: "zl-overload-03", card_b_id: "zl-overload-01",
      synergy_type: Conditional, description: "断弦极限(+2AP,+10攻击) -> 过载轰鸣(16+10=26伤害)",
      power_rating: 9,
    },
    {
      card_a_id: "zl-overload-01", card_b_id: "zl-ability-03",
      synergy_type: PassiveBoost, description: "过载轰鸣(5自伤) + 痛觉回响(+5下一张攻击)：自伤转增伤",
      power_rating: 7,
    },
    {
      card_a_id: "zl-ability-04", card_b_id: "zl-overload-01",
      synergy_type: Conditional, description: "终末定音(HP<20时+5攻击) + 过载轰鸣：背水一战爆发",
      power_rating: 9,
    },
    {
      card_a_id: "zl-overload-03", card_b_id: "zl-ability-04",
      synergy_type: ArchetypeCore, description: "断弦+终末定音：双极限Buff叠加，单牌最高+15攻击",
      power_rating: 10,
    },
  ]
}

// ─── 弦音刺客流协同 ───
pub fn assassin_synergies() -> Array[Synergy] {
  [
    {
      card_a_id: "xy-assassin-01", card_b_id: "xy-assassin-02",
      synergy_type: DirectCombo, description: "声纹连斩(免费再打) + 共振穿刺(声爆联动+3) = 声爆叠加后爆发",
      power_rating: 9,
    },
    {
      card_a_id: "xy-basic-01", card_b_id: "xy-assassin-02",
      synergy_type: Conditional, description: "高频切割(+声爆联动) -> 共振穿刺(声爆检测+3伤害)",
      power_rating: 7,
    },
    {
      card_a_id: "xy-assassin-01", card_b_id: "xy-assassin-03",
      synergy_type: ArchetypeCore, description: "声纹连斩(免费) + 超频驱动(AOE+声爆计数) = 多目标清场",
      power_rating: 8,
    },
  ]
}

// ─── 弦音回声流协同 ───
pub fn echo_synergies() -> Array[Synergy] {
  [
    {
      card_a_id: "xy-echo-01", card_b_id: "xy-echo-02",
      synergy_type: DirectCombo, description: "回声标记(复制效果) + 相位镜像(复制卡牌) = 双重复制暴力输出",
      power_rating: 10,
    },
    {
      card_a_id: "xy-echo-01", card_b_id: "xy-echo-03",
      synergy_type: Conditional, description: "回声标记激活 -> 残响追击(3牌翻倍) -> 回声再触发残响",
      power_rating: 9,
    },
    {
      card_a_id: "xy-echo-04", card_b_id: "xy-echo-01",
      synergy_type: PassiveBoost, description: "全频共振(声爆每层3伤害) + 回声标记(回合末额外伤害)",
      power_rating: 8,
    },
  ]
}

// ─── 所有协同 ───
pub fn all_synergies() -> Array[Synergy] {
  let result : Array[Synergy] = []
  let fortress = fortress_synergies()
  let overload = overload_synergies()
  let assassin = assassin_synergies()
  let echo = echo_synergies()
  let mut i = 0
  while i < fortress.length() { result.push(fortress[i]); i = i + 1 }
  let mut j = 0
  while j < overload.length() { result.push(overload[j]); j = j + 1 }
  let mut k = 0
  while k < assassin.length() { result.push(assassin[k]); k = k + 1 }
  let mut l = 0
  while l < echo.length() { result.push(echo[l]); l = l + 1 }
  result
}

// ─── 获取最高评级协同 ───
pub fn top_synergies() -> Array[Synergy] {
  let all = all_synergies()
  let top : Array[Synergy] = []
  let mut i = 0
  while i < all.length() {
    if all[i].power_rating >= 9 { top.push(all[i]) }
    i = i + 1
  }
  top
}

// ─── 查询卡牌的协同 ───
pub fn find_synergies_for_card(card_id : String) -> Array[Synergy] {
  let all = all_synergies()
  let matches : Array[Synergy] = []
  let mut i = 0
  while i < all.length() {
    let s = all[i]
    if s.card_a_id == card_id || s.card_b_id == card_id { matches.push(s) }
    i = i + 1
  }
  matches
}

// ─── 协同数量统计 ───
pub fn synergy_count_by_type(syn_type : SynergyType) -> Int {
  let all = all_synergies()
  let mut count = 0
  let mut i = 0
  while i < all.length() {
    if all[i].synergy_type == syn_type { count = count + 1 }
    i = i + 1
  }
  count
}

// ─── 卡牌推荐 ───
pub fn recommend_cards_for_archetype(archetype : String) -> Array[String] {
  match archetype {
    "fortress" => [ "zl-ability-01", "zl-fortress-02", "zl-fortress-03", "zl-ability-02" ]
    "overload" => [ "zl-overload-03", "zl-overload-01", "zl-overload-02", "zl-ability-04" ]
    "assassin" => [ "xy-assassin-01", "xy-assassin-02", "xy-basic-01", "xy-assassin-03" ]
    "echo" => [ "xy-echo-01", "xy-echo-02", "xy-echo-03", "xy-echo-04" ]
    _ => [ "zl-basic-01", "zl-basic-05", "zl-basic-09" ]
  }
}

// ─── 总协同数 ───
pub fn total_synergy_count() -> Int { 16 }

// ─── 最高协同 ───
pub fn highest_rated_synergy() -> Synergy {
  let all = all_synergies()
  let mut best = all[0]
  let mut i = 1
  while i < all.length() {
    if all[i].power_rating > best.power_rating { best = all[i] }
    i = i + 1
  }
  best
}
