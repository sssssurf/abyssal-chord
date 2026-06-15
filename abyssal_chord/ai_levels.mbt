///|
/// AI 难度等级 - 简单/普通/困难/噩梦

// ─── 难度枚举 ───
pub enum AIDifficulty {
  Easy_
  Normal_
  Hard_
  Nightmare_
} derive(Eq)

// ─── 难度配置 ───
pub struct DifficultyConfig {
  level : AIDifficulty
  label : String
  enemy_hp_mult : Double
  enemy_dmg_bonus : Int
  dice_bias : Int       // 骰子修正(+N变大更难)
  pollution_rate_bonus : Int // 额外污染率
  player_ap_penalty : Int  // 玩家AP惩罚
}

// ─── 获取难度配置 ───
pub fn get_difficulty_config(diff : AIDifficulty) -> DifficultyConfig {
  match diff {
    Easy_ => {
      { level: Easy_, label: "简单", enemy_hp_mult: 0.8, enemy_dmg_bonus: -2, dice_bias: -1, pollution_rate_bonus: -3, player_ap_penalty: 0 }
    }
    Normal_ => {
      { level: Normal_, label: "普通", enemy_hp_mult: 1.0, enemy_dmg_bonus: 0, dice_bias: 0, pollution_rate_bonus: 0, player_ap_penalty: 0 }
    }
    Hard_ => {
      { level: Hard_, label: "困难", enemy_hp_mult: 1.3, enemy_dmg_bonus: 3, dice_bias: 1, pollution_rate_bonus: 3, player_ap_penalty: 0 }
    }
    Nightmare_ => {
      { level: Nightmare_, label: "噩梦", enemy_hp_mult: 1.6, enemy_dmg_bonus: 6, dice_bias: 2, pollution_rate_bonus: 5, player_ap_penalty: 1 }
    }
  }
}

// ─── 带难度的掷骰子 ───
pub fn roll_dice_with_difficulty(config : DifficultyConfig) -> Int {
  let base = 3 // 默认为3
  let roll = base + config.dice_bias
  if roll < 1 { 1 } else { if roll > 6 { 6 } else { roll } }
}

// ─── 应用难度到敌人 ───
fn scale_hp(hp : Int, mult : Double) -> Int {
  (hp.to_double() * mult).to_int()
}

pub fn scale_enemy_for_difficulty(enemy : Enemy, config : DifficultyConfig) -> Enemy {
  let m = config.enemy_hp_mult
  {
    ..enemy,
    hp_1p: scale_hp(enemy.hp_1p, m),
    hp_2p: scale_hp(enemy.hp_2p, m),
    hp_3p: scale_hp(enemy.hp_3p, m),
    hp_4p: scale_hp(enemy.hp_4p, m),
  }
}

// ─── 应用难度到战斗 ───
pub fn scale_battle_for_difficulty(battle : BattleState, config : DifficultyConfig) -> BattleState {
  let scaled_enemy = {
    ..battle.enemy,
    max_hp: (battle.enemy.max_hp.to_double() * config.enemy_hp_mult).to_int(),
    hp: (battle.enemy.max_hp.to_double() * config.enemy_hp_mult).to_int(),
  }
  let player_ap = if battle.player.max_ap - config.player_ap_penalty < 1 {
    1
  } else {
    battle.player.max_ap - config.player_ap_penalty
  }
  {
    ..battle,
    enemy: scaled_enemy,
    player: { ..battle.player,
      max_ap: player_ap,
      ap: player_ap,
    },
  }
}

// ─── 带有AI难度的敌人回合 ───
pub fn execute_enemy_turn_with_ai(state : BattleState, config : DifficultyConfig) -> BattleState {
  let mut s = state

  // Boss二阶段触发（与普通AI相同）
  if s.enemy.is_boss && !s.enemy.phase2_triggered {
    let threshold = s.enemy.max_hp / 2
    if s.enemy.hp <= threshold && s.enemy_data.has_phase2 {
      s = { ..s, enemy: { ..s.enemy, is_phase2: true, phase2_triggered: true } }
      s = { ..s, player: { ..s.player, armor: 0 } }
      let np = s.pollution + 25
      s = { ..s, pollution: if np > 100 { 100 } else { np } }
      s = add_log(s, "!!! ENEMY PHASE 2 !!! (" + config.label + ")")
    }
  }

  let act_table = if s.enemy.is_phase2 && s.enemy_data.phase2_actions.length() > 0 {
    s.enemy_data.phase2_actions
  } else {
    s.enemy_data.actions
  }

  let dice = roll_dice_with_difficulty(config)
  let act = pick_action(act_table, dice)
  s = add_log(s, "Enemy(" + config.label + "): " + act.name)

  let lv = get_pollution_level(s.pollution)
  let phase2_bonus = if s.enemy.is_phase2 { 5 } else { 0 }
  let ai_bonus = config.enemy_dmg_bonus
  let extra_pollution = config.pollution_rate_bonus

  match act.action_type {
    Attack_ => {
      let dmg = act.damage + phase2_bonus + ai_bonus + lv.damage_bonus
      if lv.player_piercing_dmg > 0 { s = deal_damage_to_player(s, lv.player_piercing_dmg, true) }
      s = deal_damage_to_player(s, dmg, act.piercing)
    }
    AttackDebuff => {
      let dmg = act.damage + ai_bonus
      s = deal_damage_to_player(s, dmg, act.piercing)
      if act.sonic_boom > 0 { s = add_sonic_boom(s, act.sonic_boom) }
    }
    Buff_ => {
      if act.armor > 0 { s = add_enemy_armor(s, act.armor + ai_bonus) }
      let amt = act.pollution_increase + phase2_bonus + extra_pollution
      if amt > 0 { s = increase_pollution(s, amt) }
    }
    Aoe_ => {
      let dmg = act.damage + ai_bonus
      s = deal_damage_to_player(s, dmg, act.piercing)
      if act.sonic_boom > 0 { s = add_sonic_boom(s, act.sonic_boom) }
      if act.pollution_increase + extra_pollution > 0 { s = increase_pollution(s, act.pollution_increase + extra_pollution) }
    }
    Special_ => {
      let amt = act.pollution_increase + phase2_bonus + extra_pollution
      if amt > 0 { s = increase_pollution(s, amt) }
      if act.special == "reflect_50_percent" { s = { ..s, enemy: { ..s.enemy, reflect_active: true } } }
      if act.special == "discard_1_card" && s.player.hand.length() > 0 {
        let nh : Array[Card] = []
        let mut di = 1
        while di < s.player.hand.length() { nh.push(s.player.hand[di]); di = di + 1 }
        s = { ..s, player: { ..s.player, hand: nh } }
      }
    }
    Summon_ => {
      let amt = act.pollution_increase + extra_pollution
      if amt > 0 { s = increase_pollution(s, amt) }
      s = deal_damage_to_player(s, 4 + ai_bonus, false)
    }
  }

  if lv.armor_per_turn > 0 { s = add_enemy_armor(s, lv.armor_per_turn + ai_bonus) }
  if s.enemy.is_phase2 { s = add_enemy_armor(s, 8 + ai_bonus) }

  s = { ..s, phase: PlayerTurn }
  s = start_new_turn(s)
  check_defeat(s)
}

// ─── 获取所有难度标签 ───
pub fn all_difficulty_labels() -> Array[String] {
  [ "简单", "普通", "困难", "噩梦" ]
}

// ─── 难度ID到枚举 ───
pub fn difficulty_from_id(id : Int) -> AIDifficulty {
  match id {
    0 => Easy_
    1 => Normal_
    2 => Hard_
    3 => Nightmare_
    _ => Normal_
  }
}
