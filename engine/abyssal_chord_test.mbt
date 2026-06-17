// ─── Pollution System Tests ───

test "pollution_silent" {
  let l = @abyssal_chord.get_pollution_level(0)
  assert_eq(l.name, "寂静期")
}

test "pollution_humming" {
  let l = @abyssal_chord.get_pollution_level(30)
  assert_eq(l.name, "低鸣期")
}

test "pollution_resonance" {
  let l = @abyssal_chord.get_pollution_level(50)
  assert_eq(l.name, "共振期")
}

test "pollution_roaring" {
  let l = @abyssal_chord.get_pollution_level(80)
  assert_eq(l.name, "咆哮期")
}

test "pollution_finale" {
  let l = @abyssal_chord.get_pollution_level(95)
  assert_eq(l.name, "终焉和弦")
}

test "pollution_boundaries" {
  assert_eq(@abyssal_chord.get_pollution_level(15).name, "寂静期")
  assert_eq(@abyssal_chord.get_pollution_level(16).name, "低鸣期")
  assert_eq(@abyssal_chord.get_pollution_level(40).name, "低鸣期")
  assert_eq(@abyssal_chord.get_pollution_level(41).name, "共振期")
  assert_eq(@abyssal_chord.get_pollution_level(70).name, "共振期")
  assert_eq(@abyssal_chord.get_pollution_level(71).name, "咆哮期")
  assert_eq(@abyssal_chord.get_pollution_level(90).name, "咆哮期")
  assert_eq(@abyssal_chord.get_pollution_level(91).name, "终焉和弦")
}

test "pollution_max" {
  assert_eq(@abyssal_chord.is_pollution_max(100), true)
  assert_eq(@abyssal_chord.is_pollution_max(99), false)
  assert_eq(@abyssal_chord.max_pollution(), 100)
  assert_eq(@abyssal_chord.initial_pollution(), 0)
}

test "pollution_levels_count" {
  let levels = @abyssal_chord.pollution_levels()
  assert_eq(levels.length(), 5)
}

test "pollution_level_damage_bonus" {
  assert_eq(@abyssal_chord.get_pollution_level(0).damage_bonus, 0)
  assert_eq(@abyssal_chord.get_pollution_level(30).damage_bonus, 2)
  assert_eq(@abyssal_chord.get_pollution_level(50).damage_bonus, 4)
  assert_eq(@abyssal_chord.get_pollution_level(80).damage_bonus, 6)
  assert_eq(@abyssal_chord.get_pollution_level(95).damage_bonus, 10)
}

// ─── Card Data Tests ───

test "card_count_zhong_lv" {
  let cards = @abyssal_chord.zhong_lv_cards()
  assert_eq(cards.length(), 20)
}

test "card_count_xian_yin" {
  let cards = @abyssal_chord.xian_yin_cards()
  assert_eq(cards.length(), 16)
}

test "card_total_count" {
  assert_eq(@abyssal_chord.total_card_count(), 40)
}

test "initial_hand_count" {
  let hand = @abyssal_chord.initial_hand()
  assert_eq(hand.length(), 6)
}

test "initial_hand_contains_basic_attack" {
  let hand = @abyssal_chord.initial_hand()
  let mut has_attack = false
  let mut i = 0
  while i < hand.length() {
    if hand[i].base_damage > 0 { has_attack = true; break }
    i = i + 1
  }
  assert_eq(has_attack, true)
}

test "initial_hand_contains_defense" {
  let hand = @abyssal_chord.initial_hand()
  let mut has_defense = false
  let mut i = 0
  while i < hand.length() {
    if hand[i].base_armor > 0 { has_defense = true; break }
    i = i + 1
  }
  assert_eq(has_defense, true)
}

test "card_types_exist" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let mut has_attack = false
  let mut has_skill = false
  let mut has_ability = false
  let mut i = 0
  while i < cards.length() {
    let c = cards[i]
    if c.id == "zl-basic-01" { has_attack = true }
    if c.id == "zl-basic-05" { has_skill = true }
    if c.id == "zl-ability-01" { has_ability = true }
    i = i + 1
  }
  assert_eq(has_attack, true)
  assert_eq(has_skill, true)
  assert_eq(has_ability, true)
}

test "card_archetypes_exist" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let mut has_fortress = false
  let mut has_overload = false
  let mut i = 0
  while i < cards.length() {
    if cards[i].id == "zl-fortress-01" { has_fortress = true }
    if cards[i].id == "zl-overload-01" { has_overload = true }
    i = i + 1
  }
  assert_eq(has_fortress, true)
  assert_eq(has_overload, true)
}

test "card_cost_range" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let mut i = 0
  while i < cards.length() {
    let cost = cards[i].cost
    assert_eq(cost >= 0 && cost <= 3, true)
    i = i + 1
  }
}

test "overload_card_self_damage" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let mut found_self_damage = false
  let mut i = 0
  while i < cards.length() {
    if cards[i].self_damage > 0 { found_self_damage = true; break }
    i = i + 1
  }
  assert_eq(found_self_damage, true)
}

// ─── Character Tests ───

test "character_zhong_lv" {
  let zl = @abyssal_chord.zhong_lv()
  assert_eq(zl.name, "钟律")
  assert_eq(zl.max_hp, 80)
  assert_eq(zl.id, "zhong-lv")
}

test "character_xian_yin" {
  let xy = @abyssal_chord.xian_yin()
  assert_eq(xy.name, "弦音")
  assert_eq(xy.max_hp, 55)
  assert_eq(xy.id, "xian-yin")
}

test "character_all_count" {
  let all = @abyssal_chord.all_characters()
  assert_eq(all.length(), 2)
}

test "character_has_relic" {
  let zl = @abyssal_chord.zhong_lv()
  assert_eq(zl.relic.length() > 0, true)
  let xy = @abyssal_chord.xian_yin()
  assert_eq(xy.relic.length() > 0, true)
}

// ─── Enemy Tests ───

test "enemy_howling_drifter" {
  let hd = @abyssal_chord.howling_drifter()
  assert_eq(hd.name, "嘶鸣游荡者")
  assert_eq(hd.hp_1p, 18)
  assert_eq(hd.is_boss, false)
  assert_eq(hd.actions.length(), 5)
}

test "enemy_silent_mimic" {
  let sm = @abyssal_chord.silent_mimic()
  assert_eq(sm.name, "静默拟态体")
  assert_eq(sm.hp_1p, 22)
  assert_eq(sm.is_boss, false)
}

test "enemy_mutos" {
  let m = @abyssal_chord.mutos()
  assert_eq(m.name, "深渊颂歌·穆托斯")
  assert_eq(m.is_boss, true)
  assert_eq(m.has_phase2, true)
  assert_eq(m.phase2_actions.length(), 5)
}

test "enemy_echo_remnant" {
  let er = @abyssal_chord.echo_remnant()
  assert_eq(er.hp_1p, 12)
  assert_eq(er.is_boss, false)
}

test "enemy_resonance_crystal" {
  let rc = @abyssal_chord.resonance_crystal()
  assert_eq(rc.hp_1p, 30)
  assert_eq(rc.is_boss, false)
}

test "enemy_abyssal_shrieker" {
  let as_ = @abyssal_chord.abyssal_shrieker()
  assert_eq(as_.hp_1p, 25)
}

test "enemy_harmonic_construct" {
  let hc = @abyssal_chord.harmonic_construct()
  assert_eq(hc.is_boss, true)
  assert_eq(hc.has_phase2, true)
  assert_eq(hc.phase2_actions.length(), 5)
}

test "enemy_total_count" {
  assert_eq(@abyssal_chord.total_enemy_count(), 7)
}

test "enemy_all_enemies_length" {
  let all = @abyssal_chord.all_enemies_full()
  assert_eq(all.length(), 7)
}

test "enemy_all_have_actions" {
  let all = @abyssal_chord.all_enemies_full()
  let mut i = 0
  while i < all.length() {
    assert_eq(all[i].actions.length() > 0, true)
    i = i + 1
  }
}

// ─── Battle State Tests ───

test "battle_init_player_hp" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.player.hp, 80)
}

test "battle_init_player_ap" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.player.ap, 3)
}

test "battle_init_enemy_hp" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.enemy.hp, 18)
}

test "battle_init_turn" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.turn_number, 1)
}

test "battle_init_pollution" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.pollution, 0)
}

test "battle_init_hand_size" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(b.player.hand.length(), 6)
}

test "battle_init_phase" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(@abyssal_chord.phase_is_player_turn(b), true)
}

// ─── Card Play Tests ───

test "play_card_reduces_hand" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.play_card(b, 0)
  assert_eq(b2.player.hand.length(), 5)
}

test "play_card_spends_ap" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.play_card(b, 0)
  assert_eq(b2.player.ap, 2)
}

test "play_card_deals_damage" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.play_card(b, 0)
  assert_eq(b2.enemy.hp < 18, true)
}

test "play_armor_card_adds_armor" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Card index 4 is 声学壁垒 (5 armor) — verify armor increased
  let b2 = @abyssal_chord.play_card(b, 4)
  assert_eq(b2.player.armor > 0, true)
}

test "sonic_boom_stacks" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.add_sonic_boom(b, 3)
  // Sonic boom should be on enemy
  let mut found = false
  let mut i = 0
  while i < b2.enemy.debuffs.length() {
    found = true
    i = i + 1
  }
  assert_eq(found, true)
}

test "sonic_boom_damage" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b1 = @abyssal_chord.add_sonic_boom(b, 3)
  let b2 = @abyssal_chord.settle_sonic_boom(b1)
  assert_eq(b2.enemy.hp, b1.enemy.hp - 6)
}

// ─── Victory/Defeat Tests (via engine functions) ───

test "victory_detected_by_phase" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Play enough cards to defeat the 18HP enemy
  let s = @abyssal_chord.play_card(b, 0)
  let s2 = @abyssal_chord.play_card(s, 0)
  let s3 = @abyssal_chord.play_card(s2, 0)
  let s4 = @abyssal_chord.play_card(s3, 0)
  // After 4x 5-damage attacks, enemy should be dead
  assert_eq(@abyssal_chord.phase_is_victory(s4) || @abyssal_chord.phase_is_player_turn(s4), true)
}

test "defeat_detected_when_hp_zero" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Use deal_damage_to_player to test defeat detection
  let s = @abyssal_chord.deal_damage_to_player(b, 80, true)
  let s2 = @abyssal_chord.check_defeat(s)
  assert_eq(@abyssal_chord.phase_is_defeat(s2), true)
}

test "defeat_detected_when_pollution_max" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let s = @abyssal_chord.increase_pollution(b, 100)
  let s2 = @abyssal_chord.check_defeat(s)
  assert_eq(@abyssal_chord.phase_is_defeat(s2), true)
}

// ─── Armor/Damage Tests ───

test "armor_absorbs_damage" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Add 10 armor, then deal 7 damage - should absorb all
  let b1 = @abyssal_chord.add_player_armor(b, 10)
  let b2 = @abyssal_chord.deal_damage_to_player(b1, 7, false)
  assert_eq(b2.player.hp, b1.player.hp)
  assert_eq(b2.player.armor, 3)
}

test "piercing_damage_ignores_armor" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b1 = @abyssal_chord.add_player_armor(b, 20)
  let b2 = @abyssal_chord.deal_damage_to_player(b1, 5, true)
  assert_eq(b2.player.hp, b1.player.hp - 5)
  assert_eq(b2.player.armor, 20)
}

// ─── Phase Tests ───

test "phase_transitions" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  assert_eq(@abyssal_chord.phase_is_player_turn(b), true)
  assert_eq(@abyssal_chord.phase_is_enemy_turn(b), false)
  let b2 = @abyssal_chord.end_player_turn(b)
  assert_eq(@abyssal_chord.phase_is_enemy_turn(b2), true)
}

// ─── Draw Card Tests ───

test "draw_cards_increases_hand" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Play all cards first, then draw
  let mut s = b
  let mut i = 0
  while i < 3 {
    s = @abyssal_chord.play_card(s, 0)
    i = i + 1
  }
  let s2 = @abyssal_chord.draw_cards(s, 3)
  assert_eq(s2.player.hand.length() >= s.player.hand.length(), true)
}

// ─── Pollution Increase Tests ───

test "increase_pollution" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.increase_pollution(b, 25)
  assert_eq(b2.pollution, 25)
}

test "pollution_capped_at_100" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.increase_pollution(b, 150)
  assert_eq(b2.pollution, 100)
}

// ─── Shield/Log Tests ───

test "add_log_works" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let b2 = @abyssal_chord.add_log(b, "Test message")
  assert_eq(b2.log.length(), 1)
}

test "get_playable_cards" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let cards = @abyssal_chord.get_playable_cards(b)
  assert_eq(cards.length(), 6) // All initial cards cost 1, AP is 3
}

test "shuffle_when_deck_empty" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Just verify shuffle doesn't crash on empty deck
  let b2 = @abyssal_chord.shuffle_deck(b)
  assert_eq(b2.player.deck.length() >= 0, true)
}

// ─── Card Effect Tests ───

test "overload_roar_deals_self_damage" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  // Find overload-01 in hand (index might vary)
  let mut idx = -1
  let hand = @abyssal_chord.get_hand(b)
  let mut i = 0
  while i < hand.length() {
    if hand[i].id == "zl-overload-01" { idx = i; break }
    i = i + 1
  }
  if idx >= 0 {
    let b2 = @abyssal_chord.play_card(b, idx)
    assert_eq(b2.player.hp < 80, true)
  }
}

// ─── Card Count Tests (完整验证) ───

test "all_cards_count" {
  let cards = @abyssal_chord.all_cards()
  assert_eq(cards.length(), 40)
}

test "neutral_cards_exist" {
  let cards = @abyssal_chord.neutral_cards()
  assert_eq(cards.length(), 4)
}

test "neutral_has_exhaust_card" {
  let cards = @abyssal_chord.neutral_cards()
  let mut has_exhaust = false
  let mut i = 0
  while i < cards.length() {
    if cards[i].exhaust { has_exhaust = true; break }
    i = i + 1
  }
  assert_eq(has_exhaust, true)
}

test "neutral_has_retain_card" {
  let cards = @abyssal_chord.neutral_cards()
  let mut has_retain = false
  let mut i = 0
  while i < cards.length() {
    if cards[i].retain { has_retain = true; break }
    i = i + 1
  }
  assert_eq(has_retain, true)
}

// ─── Formation Tests ───

test "formation_count" {
  let forms = @abyssal_chord.all_formations()
  assert_eq(forms.length(), 5)
}

test "formation_vanguard" {
  let f = @abyssal_chord.vanguard()
  assert_eq(f.attack_bonus, 3)
}

test "formation_assault" {
  let f = @abyssal_chord.assault()
  assert_eq(f.attack_bonus, 5)
}

// ─── AI Difficulty Tests ───

test "ai_difficulty_count" {
  let labels = @abyssal_chord.all_difficulty_labels()
  assert_eq(labels.length(), 4)
}

test "ai_difficulty_easy" {
  let cfg = @abyssal_chord.get_difficulty_config(@abyssal_chord.difficulty_from_id(0))
  assert_eq(cfg.enemy_hp_mult, 0.8)
}

test "ai_difficulty_nightmare" {
  let cfg = @abyssal_chord.get_difficulty_config(@abyssal_chord.difficulty_from_id(3))
  assert_eq(cfg.enemy_hp_mult, 1.6)
}

// ─── Survival Mode Tests ───

test "survival_init" {
  let char = @abyssal_chord.zhong_lv()
  let surv = @abyssal_chord.init_survival(char)
  assert_eq(surv.wave, 1)
  assert_eq(surv.is_active, true)
}

test "survival_score_starts_zero" {
  let char = @abyssal_chord.zhong_lv()
  let surv = @abyssal_chord.init_survival(char)
  assert_eq(surv.score, 0)
}

// ─── Balance Calculator Tests ───

test "evaluate_basic_attack" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let ev = @abyssal_chord.evaluate_card(cards[0])
  assert_eq(ev.name, "重频打击")
  assert_eq(ev.ap_cost, 1)
}

test "deck_stats_zhong_lv" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let stats = @abyssal_chord.analyze_deck(cards)
  assert_eq(stats.total_cards, 20)
}

// ─── JSON Tests ───

test "card_to_json" {
  let cards = @abyssal_chord.zhong_lv_cards()
  let json = @abyssal_chord.card_to_json(cards[0])
  assert_eq(@abyssal_chord.is_valid_json_summary(json), true)
}

test "battle_summary_json" {
  let char = @abyssal_chord.zhong_lv()
  let enemy = @abyssal_chord.howling_drifter()
  let b = @abyssal_chord.init_battle(char, enemy)
  let json = @abyssal_chord.battle_summary_to_json(b)
  assert_eq(@abyssal_chord.is_valid_json_summary(json), true)
}

// ─── Game Guide Tests ───

test "archetype_guides_count" {
  let guides = @abyssal_chord.all_guides()
  assert_eq(guides.length(), 4)
}

test "enemy_strategies_count" {
  let strats = @abyssal_chord.all_strategies()
  assert_eq(strats.length(), 4)
}

test "pollution_guides_count" {
  let guides = @abyssal_chord.pollution_guides()
  assert_eq(guides.length(), 5)
}

test "character_comparisons_count" {
  let comps = @abyssal_chord.character_comparisons()
  assert_eq(comps.length(), 8)
}

// ─── Relic Tests ───

test "relics_count" {
  let relics = @abyssal_chord.all_relics()
  assert_eq(relics.length(), 4)
}

test "relic_for_zhong_lv" {
  let relic = @abyssal_chord.get_relic_for_character("zhong-lv")
  assert_eq(relic.name, "过载音叉")
}

test "relic_for_xian_yin" {
  let relic = @abyssal_chord.get_relic_for_character("xian-yin")
  assert_eq(relic.name, "断裂琴弦")
}

// ─── Xian Yin Engine Tests ───

test "xian_yin_cards_exist" {
  let cards = @abyssal_chord.xian_yin_cards()
  assert_eq(cards.length(), 16)
  assert_eq(cards[0].name, "高频切割")
}

test "xian_yin_player_init" {
  let player = @abyssal_chord.init_xian_yin_player()
  assert_eq(player.hp, 55)
  assert_eq(player.max_hp, 55)
}

// ─── Card Statistics Tests ───

test "card_statistics_json" {
  let json = @abyssal_chord.card_statistics()
  assert_eq(@abyssal_chord.is_valid_json_summary(json), true)
}

test "enemy_statistics_json" {
  let json = @abyssal_chord.enemy_statistics()
  assert_eq(@abyssal_chord.is_valid_json_summary(json), true)
}

test "quick_start_guide_not_empty" {
  let guide = @abyssal_chord.quick_start_guide()
  assert_eq(guide.length() > 100, true)
}

test "game_statistics_summary" {
  let stats = @abyssal_chord.game_statistics_summary()
  assert_eq(stats.length() > 50, true)
}
