/// Card effect resolution engine

pub fn deal_damage_to_enemy(state : BattleState, raw_damage : Int, piercing : Bool) -> BattleState {
  if raw_damage <= 0 { return state }
  let mut actual = raw_damage
  let mut ea = state.enemy.armor
  if !piercing && ea > 0 {
    if ea >= actual { ea = ea - actual; actual = 0 }
    else { actual = actual - ea; ea = 0 }
  }
  let nh = if actual > 0 { if state.enemy.hp - actual < 0 { 0 } else { state.enemy.hp - actual } } else { state.enemy.hp }
  { ..state, enemy: { ..state.enemy, hp: nh, armor: ea } }
}

pub fn deal_damage_to_player(state : BattleState, damage : Int, piercing : Bool) -> BattleState {
  if piercing {
    let nh = if state.player.hp - damage < 0 { 0 } else { state.player.hp - damage }
    return { ..state, player: { ..state.player, hp: nh } }
  }
  let mut actual = damage
  let mut pa = state.player.armor
  if pa > 0 {
    if pa >= actual { pa = pa - actual; actual = 0 }
    else { actual = actual - pa; pa = 0 }
  }
  let nh = if actual > 0 { if state.player.hp - actual < 0 { 0 } else { state.player.hp - actual } } else { state.player.hp }
  { ..state, player: { ..state.player, hp: nh, armor: pa } }
}

pub fn add_player_armor(state : BattleState, amount : Int) -> BattleState {
  { ..state, player: { ..state.player, armor: state.player.armor + amount } }
}

pub fn add_enemy_armor(state : BattleState, amount : Int) -> BattleState {
  { ..state, enemy: { ..state.enemy, armor: state.enemy.armor + amount } }
}

pub fn add_sonic_boom(state : BattleState, stacks : Int) -> BattleState {
  let nd : Array[Debuff] = []
  let mut found = false
  let mut i = 0
  while i < state.enemy.debuffs.length() {
    let d = state.enemy.debuffs[i]
    if d.debuff_type == SonicBoom {
      nd.push({ ..d, stacks: d.stacks + stacks })
      found = true
    } else { nd.push(d) }
    i = i + 1
  }
  if !found { nd.push({ debuff_type: SonicBoom, stacks: stacks }) }
  { ..state, enemy: { ..state.enemy, debuffs: nd } }
}

pub fn check_victory(state : BattleState) -> BattleState {
  if state.enemy.hp <= 0 { { ..state, phase: Victory_ } } else { state }
}

pub fn check_defeat(state : BattleState) -> BattleState {
  if state.player.hp <= 0 { { ..state, phase: Defeat_ } }
  else { if is_pollution_max(state.pollution) { { ..state, phase: Defeat_ } } else { state } }
}

pub fn play_card(state : BattleState, card_index : Int) -> BattleState {
  if card_index < 0 || card_index >= state.player.hand.length() { return add_log(state, "Invalid card") }
  let card = state.player.hand[card_index]
  let free = state.player.free_second_attack
  if !free && card.cost > state.player.ap { return add_log(state, "Not enough AP") }
  let mut s = state

  // Remove from hand
  let nh : Array[Card] = []
  let mut i = 0
  while i < s.player.hand.length() {
    if i != card_index { nh.push(s.player.hand[i]) }
    i = i + 1
  }
  s = { ..s, player: { ..s.player, hand: nh } }

  // Discard or exile
  if card.exhaust {
    let ne : Array[Card] = []
    let mut j = 0
    while j < s.player.exiled.length() { ne.push(s.player.exiled[j]); j = j + 1 }
    ne.push(card)
    s = { ..s, player: { ..s.player, exiled: ne } }
  } else {
    let nd : Array[Card] = []
    let mut k = 0
    while k < s.player.discard.length() { nd.push(s.player.discard[k]); k = k + 1 }
    nd.push(card)
    s = { ..s, player: { ..s.player, discard: nd } }
  }

  // Pay AP
  if free { s = { ..s, player: { ..s.player, free_second_attack: false } } }
  else { s = { ..s, player: { ..s.player, ap: s.player.ap - card.cost } } }

  // Apply effect
  s = apply_card_effect(s, card)

  // Count and harmonic
  s = { ..s, player: { ..s.player, cards_played_this_turn: s.player.cards_played_this_turn + 1 } }
  if s.player.harmonic_active && card.id != "zl-fortress-02" { s = add_player_armor(s, 2) }
  if card.card_type == Attack && card.id != "zl-overload-03" {
    s = { ..s, player: { ..s.player, next_attack_bonus: 0 } }
  }

  s = check_victory(s)
  s = check_defeat(s)
  add_log(s, "Play: " + card.name)
}

fn apply_card_effect(state : BattleState, card : Card) -> BattleState {
  let mut s = state
  let lv = get_pollution_level(s.pollution)
  let ed = lv.damage_bonus
  match card.id {
    "zl-fortress-01" => {
      s = add_player_armor(s, 14)
      if s.player.armor > 20 { s = deal_damage_to_enemy(s, s.player.armor - 20, false) }
      s
    }
    "zl-fortress-02" => {
      s = add_player_armor(s, 3)
      { ..s, player: { ..s.player, harmonic_active: true } }
    }
    "zl-fortress-03" => {
      let hd = s.player.armor / 2
      if hd > 0 { s = deal_damage_to_enemy(s, hd, false) }
      { ..s, player: { ..s.player, armor: s.player.armor / 2 } }
    }
    "zl-overload-01" => {
      let total = 16 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      s = deal_damage_to_enemy(s, total, false)
      s = deal_damage_to_player(s, 5, true)
      { ..s, player: { ..s.player, has_taken_self_damage: true } }
    }
    "zl-overload-02" => {
      let mut base = 4 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      if s.player.has_taken_self_damage {
        base = base * 2
        s = { ..s, player: { ..s.player, free_second_attack: true } }
      }
      deal_damage_to_enemy(s, base, false)
    }
    "zl-overload-03" => {
      s = deal_damage_to_player(s, 10, true)
      let nap = s.player.ap + 2
      let nbonus = s.player.next_attack_bonus + 10
      { ..s, player: { ..s.player, ap: nap, next_attack_bonus: nbonus } }
    }
    "zl-basic-09" => {
      s = add_player_armor(s, 3)
      s = draw_cards(s, 1)
      let np = if s.pollution - 10 < 0 { 0 } else { s.pollution - 10 }
      { ..s, pollution: np }
    }
    "zl-basic-10" => {
      let dmg = 3 + s.player.damage_bonus + ed + s.player.next_attack_bonus
      s = deal_damage_to_enemy(s, dmg, false)
      add_sonic_boom(s, 1)
    }
    "zl-ability-01" => {
      let ab = { id: "FREQ_ANCHOR", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut a = 0
      while a < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[a]); a = a + 1 }
      abs.push(ab)
      { ..s, player: { ..s.player, permanent_abilities: abs, armor_per_turn: s.player.armor_per_turn + 3 } }
    }
    "zl-ability-02" => {
      let ab = { id: "LOW_FREQ_RES", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut a = 0
      while a < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[a]); a = a + 1 }
      abs.push(ab)
      { ..s, player: { ..s.player, permanent_abilities: abs, extra_damage_per_armor: s.player.extra_damage_per_armor + 0.6 } }
    }
    "zl-ability-03" => {
      let ab = { id: "PAIN_ECHO", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut a = 0
      while a < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[a]); a = a + 1 }
      abs.push(ab)
      { ..s, player: { ..s.player, permanent_abilities: abs } }
    }
    "zl-ability-04" => {
      let ab = { id: "FINAL_NOTE", card_id: card.id, name: card.name, effect: card.effect }
      let abs : Array[ActiveAbility] = []
      let mut a = 0
      while a < s.player.permanent_abilities.length() { abs.push(s.player.permanent_abilities[a]); a = a + 1 }
      abs.push(ab)
      let bonus = if s.player.hp < 20 { 5 } else { 0 }
      { ..s, player: { ..s.player, permanent_abilities: abs, damage_bonus: s.player.damage_bonus + bonus } }
    }
    _ => {
      if card.base_damage > 0 {
        let mut dmg = card.base_damage + s.player.damage_bonus + ed + s.player.next_attack_bonus
        if s.player.extra_damage_per_armor > 0.0 {
          let extra = (s.player.armor.to_double() * s.player.extra_damage_per_armor).to_int()
          dmg = dmg + extra
        }
        s = deal_damage_to_enemy(s, dmg, false)
      }
      if card.self_damage > 0 {
        s = deal_damage_to_player(s, card.self_damage, true)
        let pb = if card.self_damage <= 8 { card.self_damage } else { 8 }
        s = { ..s, player: { ..s.player, has_taken_self_damage: true, next_attack_bonus: s.player.next_attack_bonus + pb } }
      }
      if card.base_armor > 0 { s = add_player_armor(s, card.base_armor) }
      if card.sonic_boom > 0 { s = add_sonic_boom(s, card.sonic_boom) }
      if card.pollution_modifier != 0 {
        let np = s.pollution + card.pollution_modifier
        let cl = if np < 0 { 0 } else { if np > 100 { 100 } else { np } }
        s = { ..s, pollution: cl }
      }
      s
    }
  }
}

pub fn end_player_turn(state : BattleState) -> BattleState {
  let mut s = state
  let mut i = 0
  while i < s.player.permanent_abilities.length() {
    if s.player.permanent_abilities[i].id == "FINAL_NOTE" {
      if s.player.hp < 20 { s = deal_damage_to_player(s, 2, true) }
      break
    }
    i = i + 1
  }
  { ..s, phase: EnemyTurn }
}

pub fn settle_sonic_boom(state : BattleState) -> BattleState {
  let mut s = state
  let rest : Array[Debuff] = []
  let mut i = 0
  while i < s.enemy.debuffs.length() {
    let d = s.enemy.debuffs[i]
    if d.debuff_type == SonicBoom && d.stacks > 0 {
      let dmg = d.stacks * 2
      let nh = if s.enemy.hp - dmg < 0 { 0 } else { s.enemy.hp - dmg }
      s = { ..s, enemy: { ..s.enemy, hp: nh } }
    } else { rest.push(d) }
    i = i + 1
  }
  s = { ..s, enemy: { ..s.enemy, debuffs: rest } }
  check_victory(s)
}

pub fn increase_pollution(state : BattleState, amount : Int) -> BattleState {
  let np = state.pollution + amount
  { ..state, pollution: if np > 100 { 100 } else { np } }
}
