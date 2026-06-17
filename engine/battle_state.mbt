/// Battle state management

let initial_ap : Int = 3
let turn_draw_count : Int = 3

pub fn init_player(character : Character) -> PlayerState {
  let all = zhong_lv_cards()
  let init_hand = initial_hand()
  let deck : Array[Card] = []
  let mut i = 6
  while i < all.length() {
    deck.push(all[i])
    i = i + 1
  }
  {
    id: character.id, name: character.name, hp: character.max_hp, max_hp: character.max_hp,
    armor: 0, ap: initial_ap, max_ap: initial_ap,
    hand: init_hand, deck: deck, discard: [], exiled: [],
    permanent_abilities: [], damage_bonus: 0, armor_per_turn: 0,
    extra_damage_per_armor: 0.0, cards_played_this_turn: 0,
    has_taken_self_damage: false, next_attack_bonus: 0,
    harmonic_active: false, free_second_attack: false, debuffs: [],
  }
}

pub fn init_enemy(enemy_data : Enemy) -> EnemyState {
  {
    id: enemy_data.id, name: enemy_data.name,
    hp: enemy_data.hp_1p, max_hp: enemy_data.hp_1p, armor: 0,
    is_boss: enemy_data.is_boss, is_phase2: false,
    phase2_triggered: false, summoned_minion: false,
    reflect_active: false, debuffs: [],
  }
}

pub fn init_battle(player_char : Character, enemy_data : Enemy) -> BattleState {
  {
    player: init_player(player_char), enemy: init_enemy(enemy_data),
    player_char: player_char, enemy_data: enemy_data,
    phase: PlayerTurn, turn_number: 1,
    pollution: initial_pollution(), log: [],
  }
}

pub fn shuffle_deck(state : BattleState) -> BattleState {
  if state.player.deck.length() > 0 { return state }
  if state.player.discard.length() == 0 { return state }
  {
    ..state,
    player: { ..state.player, deck: state.player.discard, discard: [] }
  }
}

pub fn draw_cards(state : BattleState, count : Int) -> BattleState {
  let mut s = state
  let mut drawn = 0
  while drawn < count {
    if s.player.hand.length() >= 6 { break }
    s = shuffle_deck(s)
    if s.player.deck.length() == 0 { break }
    let card = s.player.deck[0]
    let nd : Array[Card] = []
    let mut j = 1
    while j < s.player.deck.length() {
      nd.push(s.player.deck[j])
      j = j + 1
    }
    let nh : Array[Card] = []
    let mut k = 0
    while k < s.player.hand.length() {
      nh.push(s.player.hand[k])
      k = k + 1
    }
    nh.push(card)
    s = { ..s, player: { ..s.player, deck: nd, hand: nh } }
    drawn = drawn + 1
  }
  s
}

pub fn start_new_turn(state : BattleState) -> BattleState {
  let s1 = { ..state, player: { ..state.player,
    ap: state.player.max_ap, cards_played_this_turn: 0,
    has_taken_self_damage: false, next_attack_bonus: 0,
    harmonic_active: false, free_second_attack: false,
    armor: state.player.armor + state.player.armor_per_turn,
  }}
  let s2 = draw_cards(s1, turn_draw_count)
  { ..s2, turn_number: s2.turn_number + 1 }
}

pub fn add_log(state : BattleState, msg : String) -> BattleState {
  let nl : Array[String] = []
  let mut i = 0
  while i < state.log.length() {
    nl.push(state.log[i])
    i = i + 1
  }
  nl.push(msg)
  { ..state, log: nl }
}

pub fn get_playable_cards(state : BattleState) -> Array[Card] {
  let r : Array[Card] = []
  let mut i = 0
  while i < state.player.hand.length() {
    let c = state.player.hand[i]
    if state.player.free_second_attack || c.cost <= state.player.ap {
      r.push(c)
    }
    i = i + 1
  }
  r
}

pub fn get_hand(state : BattleState) -> Array[Card] { state.player.hand }

// Phase helpers for use from other packages
pub fn phase_is_player_turn(state : BattleState) -> Bool { match state.phase { PlayerTurn => true; _ => false } }
pub fn phase_is_enemy_turn(state : BattleState) -> Bool { match state.phase { EnemyTurn => true; _ => false } }
pub fn phase_is_victory(state : BattleState) -> Bool { match state.phase { Victory_ => true; _ => false } }
pub fn phase_is_defeat(state : BattleState) -> Bool { match state.phase { Defeat_ => true; _ => false } }
pub fn is_sonic_boom(d : Debuff) -> Bool { match d.debuff_type { SonicBoom => true; _ => false } }
pub fn ability_name(a : ActiveAbility) -> String { a.name }
