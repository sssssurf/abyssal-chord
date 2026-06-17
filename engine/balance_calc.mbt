///|
/// 游戏平衡性计算器 - 卡牌数值模型与战斗模拟统计

// ─── 卡牌效率评估 ───
pub struct CardEfficiency {
  name : String
  ap_cost : Int
  raw_damage : Int
  raw_armor : Int
  self_damage : Int
  sonic_boom_value : Int // 每层声爆≈2点延迟伤害
  utility_score : Double  // 综合效用分数
  archetype_label : String
  tier : String // S/A/B/C
}

// ─── 计算单张卡牌效率 ───
pub fn evaluate_card(card : Card) -> CardEfficiency {
  let sb_value = card.sonic_boom * 2
  let net_dmg = card.base_damage + sb_value - card.self_damage
  let net_armor = card.base_armor
  // 基准: 1AP = 5伤害 = 5护甲
  let dmg_efficiency = if card.cost == 0 { net_dmg.to_double() * 2.0 } else { net_dmg.to_double() / card.cost.to_double() }
  let armor_efficiency = if card.cost == 0 { net_armor.to_double() * 2.0 } else { net_armor.to_double() / card.cost.to_double() }
  let utility = if dmg_efficiency > armor_efficiency { dmg_efficiency } else { armor_efficiency }
  let tier = if utility >= 8.0 { "S" } else { if utility >= 6.0 { "A" } else { if utility >= 4.0 { "B" } else { "C" } } }
  let arch = match card.archetype {
    Basic => "基础"
    Fortress => "堡垒"
    Overload => "过载"
  }
  {
    name: card.name,
    ap_cost: card.cost,
    raw_damage: card.base_damage,
    raw_armor: card.base_armor,
    self_damage: card.self_damage,
    sonic_boom_value: sb_value,
    utility_score: utility,
    archetype_label: arch,
    tier: tier,
  }
}

// ─── 评估整个牌库 ───
pub fn evaluate_deck(cards : Array[Card]) -> Array[CardEfficiency] {
  let result : Array[CardEfficiency] = []
  let mut i = 0
  while i < cards.length() {
    result.push(evaluate_card(cards[i]))
    i = i + 1
  }
  result
}

// ─── 牌库统计 ───
pub struct DeckStats {
  total_cards : Int
  total_damage_potential : Int
  total_armor_potential : Int
  average_ap_cost : Double
  attack_ratio : Double
  skill_ratio : Double
  ability_ratio : Double
  s_tier_cards : Int
  a_tier_cards : Int
  b_tier_cards : Int
  c_tier_cards : Int
}

// ─── 计算牌库统计 ───
pub fn analyze_deck(cards : Array[Card]) -> DeckStats {
  let evaluations = evaluate_deck(cards)
  let mut total_dmg = 0
  let mut total_armor = 0
  let mut total_ap = 0
  let mut attack_count = 0
  let mut skill_count = 0
  let mut ability_count = 0
  let mut s_count = 0
  let mut a_count = 0
  let mut b_count = 0
  let mut c_count = 0
  let mut i = 0
  while i < evaluations.length() {
    let ev = evaluations[i]
    total_dmg = total_dmg + ev.raw_damage
    total_armor = total_armor + ev.raw_armor
    total_ap = total_ap + ev.ap_cost
    match cards[i].card_type {
      Attack => { attack_count = attack_count + 1 }
      Skill => { skill_count = skill_count + 1 }
      Ability => { ability_count = ability_count + 1 }
    }
    match ev.tier {
      "S" => { s_count = s_count + 1 }
      "A" => { a_count = a_count + 1 }
      "B" => { b_count = b_count + 1 }
      _ => { c_count = c_count + 1 }
    }
    i = i + 1
  }
  let avg_ap = if cards.length() == 0 { 0.0 } else { total_ap.to_double() / cards.length().to_double() }
  let atk_ratio = if cards.length() == 0 { 0.0 } else { attack_count.to_double() / cards.length().to_double() }
  let skl_ratio = if cards.length() == 0 { 0.0 } else { skill_count.to_double() / cards.length().to_double() }
  let abl_ratio = if cards.length() == 0 { 0.0 } else { ability_count.to_double() / cards.length().to_double() }
  {
    total_cards: cards.length(),
    total_damage_potential: total_dmg,
    total_armor_potential: total_armor,
    average_ap_cost: avg_ap,
    attack_ratio: atk_ratio,
    skill_ratio: skl_ratio,
    ability_ratio: abl_ratio,
    s_tier_cards: s_count,
    a_tier_cards: a_count,
    b_tier_cards: b_count,
    c_tier_cards: c_count,
  }
}

// ─── 战斗模拟统计 ───
pub struct BattleMetrics {
  turns_played : Int
  total_damage_dealt : Int
  total_damage_taken : Int
  total_armor_gained : Int
  total_sonic_boom_applied : Int
  cards_played : Int
  abilities_activated : Int
  pollution_peak : Int
  victory : Bool
}

// ─── 创建度量收集器 ───
pub fn new_metrics() -> BattleMetrics {
  {
    turns_played: 0,
    total_damage_dealt: 0,
    total_damage_taken: 0,
    total_armor_gained: 0,
    total_sonic_boom_applied: 0,
    cards_played: 0,
    abilities_activated: 0,
    pollution_peak: 0,
    victory: false,
  }
}

// ─── 记录打牌 ───
pub fn record_card_play(metrics : BattleMetrics, card : Card) -> BattleMetrics {
  {
    ..metrics,
    total_damage_dealt: metrics.total_damage_dealt + card.base_damage,
    total_armor_gained: metrics.total_armor_gained + card.base_armor,
    total_sonic_boom_applied: metrics.total_sonic_boom_applied + card.sonic_boom,
    cards_played: metrics.cards_played + 1,
    abilities_activated: metrics.abilities_activated + (if card.card_type == Ability { 1 } else { 0 }),
  }
}

// ─── 记录回合 ───
pub fn record_turn(metrics : BattleMetrics, state : BattleState) -> BattleMetrics {
  {
    ..metrics,
    turns_played: metrics.turns_played + 1,
    pollution_peak: if state.pollution > metrics.pollution_peak { state.pollution } else { metrics.pollution_peak },
  }
}

// ─── 记录失败 ───
pub fn record_defeat(metrics : BattleMetrics) -> BattleMetrics {
  { ..metrics, victory: false }
}

// ─── 记录胜利 ───
pub fn record_victory(metrics : BattleMetrics) -> BattleMetrics {
  { ..metrics, victory: true }
}

// ─── 生成战斗报告字符串 ───
pub fn metrics_report(metrics : BattleMetrics) -> String {
  "=== Battle Report ===\n" +
  "Turns: " + metrics.turns_played.to_string() + "\n" +
  "Damage dealt: " + metrics.total_damage_dealt.to_string() + "\n" +
  "Damage taken: " + metrics.total_damage_taken.to_string() + "\n" +
  "Armor gained: " + metrics.total_armor_gained.to_string() + "\n" +
  "Sonic booms: " + metrics.total_sonic_boom_applied.to_string() + "\n" +
  "Cards played: " + metrics.cards_played.to_string() + "\n" +
  "Abilities: " + metrics.abilities_activated.to_string() + "\n" +
  "Peak pollution: " + metrics.pollution_peak.to_string() + "\n" +
  "Victory: " + metrics.victory.to_string()
}

// ─── 卡牌对比 ───
pub fn compare_cards(card_a : Card, card_b : Card) -> String {
  let ev_a = evaluate_card(card_a)
  let ev_b = evaluate_card(card_b)
  let winner = if ev_a.utility_score > ev_b.utility_score { card_a.name } else { if ev_b.utility_score > ev_a.utility_score { card_b.name } else { "Tie" } }
  card_a.name + "(" + ev_a.tier + "/" + ev_a.utility_score.to_string() + ") vs " +
  card_b.name + "(" + ev_b.tier + "/" + ev_b.utility_score.to_string() + ") -> " + winner
}

// ─── 最有效卡牌 ───
pub fn most_efficient_card(cards : Array[Card]) -> String {
  let evals = evaluate_deck(cards)
  let mut best_score = -1.0
  let mut best_name = ""
  let mut i = 0
  while i < evals.length() {
    if evals[i].utility_score > best_score {
      best_score = evals[i].utility_score
      best_name = evals[i].name
    }
    i = i + 1
  }
  best_name
}

// ─── 计算最佳起手（贪心算法） ───
pub fn suggest_opening_hand(cards : Array[Card]) -> Array[Int] {
  let evals = evaluate_deck(cards)
  // 返回最高效6张牌的索引
  let indices : Array[Int] = []
  let n = cards.length()
  let max_pick = if n < 6 { n } else { 6 }
  let mut picked = 0
  while picked < max_pick {
    let mut best_idx = -1
    let mut best_score = -100.0
    let mut i = 0
    while i < n {
      let mut already_picked = false
      let mut j = 0
      while j < indices.length() {
        if indices[j] == i { already_picked = true; break }
        j = j + 1
      }
      if !already_picked && evals[i].utility_score > best_score {
        best_score = evals[i].utility_score
        best_idx = i
      }
      i = i + 1
    }
    if best_idx >= 0 { indices.push(best_idx) }
    picked = picked + 1
  }
  indices
}
