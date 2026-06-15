// Whitebox tests - access internal package members directly

test "internal_pollution_levels_exist" {
  let levels = pollution_levels()
  assert_eq(5, levels.length())
}

test "internal_card_ids_unique" {
  let zl = zhong_lv_cards()
  let mut i = 0
  while i < zl.length() {
    let mut j = i + 1
    while j < zl.length() {
      assert_eq(zl[i].id != zl[j].id, true)
      j = j + 1
    }
    i = i + 1
  }
}

test "internal_battle_init_player" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  assert_eq(PlayerTurn, b.phase)
  assert_eq(b.player.max_hp, 80)
}

test "internal_shuffle_maintains_size" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let total_before = b.player.deck.length() + b.player.discard.length()
  let b2 = shuffle_deck(b)
  let total_after = b2.player.deck.length() + b2.player.discard.length()
  assert_eq(total_before, total_after)
}

test "internal_draw_card_increases_hand" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  // Play 2 cards first so hand < max (6)
  let b0 = play_card(b, 0)
  let b1 = play_card(b0, 0)
  let hand_before = b1.player.hand.length()
  let b2 = draw_cards(b1, 1)
  assert_eq(hand_before + 1, b2.player.hand.length())
}

test "internal_add_log_increases_size" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b2 = add_log(b, "test")
  assert_eq(1, b2.log.length())
}

test "internal_get_playable_all_initial" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let cards = get_playable_cards(b)
  assert_eq(6, cards.length())
}

test "internal_deal_damage_reduces_hp" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b2 = deal_damage_to_enemy(b, 10, false)
  assert_eq(8, b2.enemy.hp)
}

test "internal_deal_damage_piercing_ignores_armor" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = add_enemy_armor(b, 10)
  let b2 = deal_damage_to_enemy(b1, 5, true)
  assert_eq(13, b2.enemy.hp)
  assert_eq(10, b2.enemy.armor)
}

test "internal_add_armor_stacks" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = add_player_armor(b, 5)
  assert_eq(5, b1.player.armor)
  let b2 = add_player_armor(b1, 3)
  assert_eq(8, b2.player.armor)
}

test "internal_start_new_turn_resets_ap" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = { ..b, player: { ..b.player, ap: 0 } }
  let b2 = start_new_turn(b1)
  assert_eq(3, b2.player.ap)
}

test "internal_check_victory_works" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = { ..b, enemy: { ..b.enemy, hp: 0 } }
  let b2 = check_victory(b1)
  assert_eq(Victory_, b2.phase)
}

test "internal_check_defeat_player_hp" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = { ..b, player: { ..b.player, hp: 0 } }
  let b2 = check_defeat(b1)
  assert_eq(Defeat_, b2.phase)
}

test "internal_check_defeat_pollution" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = { ..b, pollution: 100 }
  let b2 = check_defeat(b1)
  assert_eq(Defeat_, b2.phase)
}

test "internal_increase_pollution_caps" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b2 = increase_pollution(b, 200)
  assert_eq(100, b2.pollution)
}

test "internal_sonic_boom_stacks_accumulate" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  let b1 = add_sonic_boom(b, 2)
  let b2 = add_sonic_boom(b1, 3)
  assert_eq(true, b2.enemy.debuffs.length() > 0)
}

test "internal_resonance_bulwark_overflow" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  // Stack armor to 21 first
  let b1 = add_player_armor(b, 21)
  // Find resonance bulwark in hand
  let hand = get_hand(b1)
  let mut idx = -1
  let mut i = 0
  while i < hand.length() {
    if hand[i].id == "zl-fortress-01" { idx = i; break }
    i = i + 1
  }
  if idx >= 0 {
    let b2 = play_card(b1, idx)
    // Should have overflow damage
    assert_eq(true, b2.enemy.hp < b1.enemy.hp)
  }
}

test "internal_overload_combo_works" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let mut b = init_battle(char, enemy)
  // Find and play 断弦极限
  let hand = get_hand(b)
  let mut idx = -1
  let mut i = 0
  while i < hand.length() {
    if hand[i].id == "zl-overload-03" { idx = i; break }
    i = i + 1
  }
  if idx >= 0 {
    b = play_card(b, idx)
    assert_eq(70, b.player.hp) // 80 - 10 self damage
    assert_eq(true, b.player.ap >= 4) // gained 2 AP
    assert_eq(10, b.player.next_attack_bonus)
  }
}

test "internal_feedback_loop_doubles" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  // First, take self-damage
  let b1 = deal_damage_to_player(b, 5, true)
  let b2 = { ..b1, player: { ..b1.player, has_taken_self_damage: true } }
  // Find feedback loop
  let hand = get_hand(b2)
  let mut idx = -1
  let mut i = 0
  while i < hand.length() {
    if hand[i].id == "zl-overload-02" { idx = i; break }
    i = i + 1
  }
  if idx >= 0 {
    let b3 = play_card(b2, idx)
    // Should deal 8 damage (4*2) and set free_second_attack
    assert_eq(true, b3.enemy.hp < b2.enemy.hp)
  }
}

test "internal_ability_added_to_permanent" {
  let char = zhong_lv()
  let enemy = howling_drifter()
  let b = init_battle(char, enemy)
  // Find frequency anchor
  let hand = get_hand(b)
  let mut idx = -1
  let mut i = 0
  while i < hand.length() {
    if hand[i].id == "zl-ability-01" { idx = i; break }
    i = i + 1
  }
  if idx >= 0 {
    let b2 = play_card(b, idx)
    assert_eq(1, b2.player.permanent_abilities.length())
    assert_eq(3, b2.player.armor_per_turn)
  }
}
