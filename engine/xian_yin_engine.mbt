///|
/// 弦音（频率猎手）专属引擎 - 高频刺客流 & 回声幻影流

// ─── 弦音角色初始化 ───
pub fn init_xian_yin_player() -> PlayerState {
  let cards = xian_yin_cards()
  let hand_ids = ["xy-basic-01", "xy-basic-02", "xy-basic-05", "xy-basic-06", "xy-basic-07", "xy-assassin-01"]
  let hand : Array[Card] = []
  let deck : Array[Card] = []
  let mut i = 0
  while i < hand_ids.length() {
    let mut j = 0
    while j < cards.length() {
      if cards[j].id == hand_ids[i] {
        hand.push(cards[j])
        break
      }
      j = j + 1
    }
    i = i + 1
  }
  let mut k = 0
  while k < cards.length() {
    let card = cards[k]
    let mut in_hand = false
    let mut h = 0
    while h < hand.length() {
      if hand[h].id == card.id { in_hand = true; break }
      h = h + 1
    }
    if !in_hand { deck.push(card) }
    k = k + 1
  }
  {
    id: "xian-yin", name: "弦音", hp: 55, max_hp: 55,
    armor: 0, ap: 3, max_ap: 3,
    hand: hand, deck: deck, discard: [], exiled: [],
    permanent_abilities: [], damage_bonus: 0, armor_per_turn: 0,
    extra_damage_per_armor: 0.0, cards_played_this_turn: 0,
    has_taken_self_damage: false, next_attack_bonus: 0,
    harmonic_active: false, free_second_attack: false, debuffs: [],
  }
}

// ─── 弦音专属卡牌效果处理器 ───
pub fn apply_xian_yin_effect(state : BattleState, card : Card) -> BattleState {
  let mut s = state
  let lv = get_pollution_level(s.pollution)
  let ed = lv.damage_bonus

  match card.id {
    // 高频切割: 4伤害，声爆联动+2
    "xy-basic-01" | "xy-basic-02" | "xy-basic-03" | "xy-basic-04" => {
      let mut dmg = 4 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      // 检查敌人是否有声爆
      let mut has_boom = false
      let mut bi = 0
      while bi < s.enemy.debuffs.length() {
        if s.enemy.debuffs[bi].debuff_type == SonicBoom { has_boom = true; break }
        bi = bi + 1
      }
      if has_boom { dmg = dmg + 2 }
      s = deal_damage_to_enemy(s, dmg, false)
      s
    }
    // 音纹闪避: 4护甲，已打出攻击牌+额外3
    "xy-basic-05" | "xy-basic-06" => {
      let base_armor = if s.player.cards_played_this_turn > 0 { 7 } else { 4 }
      s = add_player_armor(s, base_armor)
      s
    }
    // 谐波感知: 抽2张牌，-5污染
    "xy-basic-07" | "xy-basic-08" => {
      s = draw_cards(s, 2)
      let np = if s.pollution - 5 < 0 { 0 } else { s.pollution - 5 }
      { ..s, pollution: np }
    }
    // 声纹连斩: 3伤害，可免费再打一次
    "xy-assassin-01" => {
      let dmg = 3 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      s = deal_damage_to_enemy(s, dmg, false)
      // 免费再打（模拟多段攻击）
      s = { ..s, player: { ..s.player, free_second_attack: true } }
      s = add_log(s, "Sonic Flurry: can attack again for free!")
      s
    }
    // 共振穿刺: 7伤害+2声爆，有声爆时+3
    "xy-assassin-02" => {
      let mut dmg = 7 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      let mut has_boom = false
      let mut bi = 0
      while bi < s.enemy.debuffs.length() {
        if s.enemy.debuffs[bi].debuff_type == SonicBoom { has_boom = true; break }
        bi = bi + 1
      }
      if has_boom { dmg = dmg + 3 }
      s = deal_damage_to_enemy(s, dmg, false)
      s = add_sonic_boom(s, 2)
      s
    }
    // 超频驱动: 5 AOE伤害，每有一个带声爆的敌人+2
    "xy-assassin-03" => {
      let mut dmg = 5 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      let mut bi = 0
      while bi < s.enemy.debuffs.length() {
        if s.enemy.debuffs[bi].debuff_type == SonicBoom { dmg = dmg + 2 }
        bi = bi + 1
      }
      s = deal_damage_to_enemy(s, dmg, false)
      s
    }
    // 次声潜行: 隐身1回合，下次攻击+8
    "xy-assassin-04" => {
      s = { ..s, player: { ..s.player, next_attack_bonus: s.player.next_attack_bonus + 8 } }
      // 获得护甲代表示踪
      s = add_player_armor(s, 3)
      s = add_log(s, "Infrasonic Stealth: next attack +8!")
      s
    }
    // 回声标记: 永久，回合末复制效果（伤害减半）
    "xy-echo-01" => {
      let ab = { id: "ECHO_MARK", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut ai = 0
      while ai < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[ai]); ai = ai + 1 }
      abs.push(ab)
      s = { ..s, player: { ..s.player, permanent_abilities: abs } }
      s = add_log(s, "Echo Mark: cards echo at turn end!")
      s
    }
    // 相位镜像: 复制一张手牌中的攻击牌
    "xy-echo-02" => {
      // 找到第一张攻击牌并复制
      let mut found_idx = -1
      let mut fi = 0
      while fi < s.player.hand.length() {
        if s.player.hand[fi].card_type == Attack { found_idx = fi; break }
        fi = fi + 1
      }
      if found_idx >= 0 {
        let copy = s.player.hand[found_idx]
        let nh : Array[Card] = []
        let mut ci = 0
        while ci < s.player.hand.length() { nh.push(s.player.hand[ci]); ci = ci + 1 }
        nh.push(copy)
        s = { ..s, player: { ..s.player, hand: nh } }
        s = add_log(s, "Phase Mirror: duplicated " + copy.name)
      }
      s
    }
    // 残响追击: 6伤害，打3张以上牌翻倍
    "xy-echo-03" => {
      let mut dmg = 6 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      if s.player.cards_played_this_turn >= 3 { dmg = dmg * 2; s = add_log(s, "Afterimage Pursuit: doubled!") }
      s = deal_damage_to_enemy(s, dmg, false)
      s
    }
    // 全频共振: 声爆特化，每层+3伤害而非+2
    "xy-echo-04" => {
      let ab = { id: "FULL_SPECTRUM", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut ai = 0
      while ai < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[ai]); ai = ai + 1 }
      abs.push(ab)
      // 额外声爆伤害标记（声爆结算时每层3点而非2点）
      s = { ..s, player: { ..s.player, permanent_abilities: abs, damage_bonus: s.player.damage_bonus + 2 } }
      s = add_log(s, "Full Spectrum Resonance: sonic boom now 3 dmg/stack!")
      s
    }
    _ => s
  }
}

// ─── 弦音遗物效果：断裂琴弦 ───
// 每回合前2张攻击牌，若未被格挡，额外+2声爆
pub fn apply_xian_yin_relic(state : BattleState, cards_played : Int) -> BattleState {
  if cards_played < 2 {
    // 自动附加声爆（模拟"未被格挡的额外效果"）
    add_sonic_boom(state, 2)
  } else {
    state
  }
}

// ─── 回声标记结算（回合末） ───
pub fn settle_echo_mark(state : BattleState) -> BattleState {
  let mut s = state
  // 检查是否有回声标记能力
  let mut has_echo = false
  let mut ei = 0
  while ei < s.player.permanent_abilities.length() {
    if s.player.permanent_abilities[ei].id == "ECHO_MARK" { has_echo = true; break }
    ei = ei + 1
  }
  if has_echo && s.player.cards_played_this_turn > 0 {
    // 回声：造成本回合总伤害的50%（额外伤害）
    let extra = if s.player.cards_played_this_turn >= 3 { 4 } else { 2 }
    s = deal_damage_to_enemy(s, extra, false)
    s = add_log(s, "Echo Mark: resonated for " + extra.to_string() + " bonus dmg!")
  }
  s
}
