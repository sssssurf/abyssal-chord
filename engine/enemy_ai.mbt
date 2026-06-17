/// Enemy AI - dice-driven action selection

fn roll_dice() -> Int { 3 }

fn pick_action(actions : Array[EnemyAction], dice : Int) -> EnemyAction {
  let mut i = 0
  while i < actions.length() {
    let a = actions[i]
    if dice >= a.dice_min && dice <= a.dice_max { return a }
    i = i + 1
  }
  actions[0]
}

pub fn execute_enemy_turn(state : BattleState) -> BattleState {
  let mut s = state

  // Boss P2 trigger
  if s.enemy.is_boss && !s.enemy.phase2_triggered {
    let threshold = s.enemy.max_hp / 2
    if s.enemy.hp <= threshold && s.enemy_data.has_phase2 {
      s = { ..s, enemy: { ..s.enemy, is_phase2: true, phase2_triggered: true } }
      s = { ..s, player: { ..s.player, armor: 0 } }
      let np2 = s.pollution + 25
      s = { ..s, pollution: if np2 > 100 { 100 } else { np2 } }
      s = add_log(s, "!!! MUTOS PHASE 2 !!!")
    }
  }

  // Select action table
  let act_table = if s.enemy.is_phase2 && s.enemy_data.phase2_actions.length() > 0 {
    s.enemy_data.phase2_actions
  } else {
    s.enemy_data.actions
  }

  let dice = roll_dice()
  let act = pick_action(act_table, dice)
  s = add_log(s, "Enemy: " + act.name)

  let lv = get_pollution_level(s.pollution)

  match act.action_type {
    Attack_ => {
      let phase2_bonus = if s.enemy.is_phase2 { 5 } else { 0 }
      let dmg = act.damage + phase2_bonus + lv.damage_bonus
      if lv.player_piercing_dmg > 0 {
        s = deal_damage_to_player(s, lv.player_piercing_dmg, true)
      }
      s = deal_damage_to_player(s, dmg, act.piercing)
    }
    AttackDebuff => {
      s = deal_damage_to_player(s, act.damage, act.piercing)
      if act.sonic_boom > 0 { s = add_sonic_boom(s, act.sonic_boom) }
    }
    Buff_ => {
      if act.armor > 0 { s = add_enemy_armor(s, act.armor) }
      if act.pollution_increase > 0 {
        let phase2_bonus = if s.enemy.is_phase2 { 5 } else { 0 }
        let amt = act.pollution_increase + phase2_bonus
        s = increase_pollution(s, amt)
      }
    }
    Aoe_ => {
      s = deal_damage_to_player(s, act.damage, act.piercing)
      if act.sonic_boom > 0 { s = add_sonic_boom(s, act.sonic_boom) }
      if act.pollution_increase > 0 { s = increase_pollution(s, act.pollution_increase) }
    }
    Special_ => {
      if act.pollution_increase > 0 {
        let phase2_bonus = if s.enemy.is_phase2 { 5 } else { 0 }
        s = increase_pollution(s, act.pollution_increase + phase2_bonus)
      }
      if act.special == "reflect_50_percent" {
        s = { ..s, enemy: { ..s.enemy, reflect_active: true } }
      }
      if act.special == "discard_1_card" && s.player.hand.length() > 0 {
        let nh : Array[Card] = []
        let mut j = 1
        while j < s.player.hand.length() { nh.push(s.player.hand[j]); j = j + 1 }
        s = { ..s, player: { ..s.player, hand: nh } }
      }
    }
    Summon_ => {
      if act.pollution_increase > 0 { s = increase_pollution(s, act.pollution_increase) }
      s = deal_damage_to_player(s, 4, false)
    }
  }

  if lv.armor_per_turn > 0 { s = add_enemy_armor(s, lv.armor_per_turn) }
  if s.enemy.is_phase2 { s = add_enemy_armor(s, 8) }

  s = { ..s, phase: PlayerTurn }
  s = start_new_turn(s)
  check_defeat(s)
}
