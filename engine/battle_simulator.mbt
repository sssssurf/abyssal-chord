/// AI vs AI 战斗模拟器 — 用于自动测试平衡性

pub struct SimulationResult {
  battles_run : Int
  player_wins : Int
  enemy_wins : Int
  avg_turns : Double
  avg_player_hp : Double
  avg_pollution : Double
  fastest_win : Int
  slowest_win : Int
  total_cards_played : Int
  total_damage_dealt : Int
  total_armor_gained : Int
}

pub fn new_simulation() -> SimulationResult {
  { battles_run: 0, player_wins: 0, enemy_wins: 0, avg_turns: 0.0, avg_player_hp: 0.0, avg_pollution: 0.0, fastest_win: 999, slowest_win: 0, total_cards_played: 0, total_damage_dealt: 0, total_armor_gained: 0 }
}

pub fn run_single_simulation(char_id : String, enemy_id : String) -> (BattleState, Int) {
  let char = get_character_by_id(char_id)
  let enemy = get_enemy_by_id(enemy_id)
  let mut state = init_battle(char, enemy)
  let mut turn = 0
  let max_turns = 100
  while turn < max_turns {
    if state.enemy.hp <= 0 || state.player.hp <= 0 || state.pollution >= 100 { break }
    // Player turn: play first available card
    let cards = get_playable_cards(state)
    if cards.length() > 0 {
      let hand = get_hand(state)
      let mut idx = -1
      let mut i = 0
      while i < hand.length() {
        if hand[i].id == cards[0].id { idx = i; break }
        i = i + 1
      }
      if idx >= 0 {
        state = play_card(state, idx)
      }
    }
    // Sonic boom
    state = settle_sonic_boom(state)
    if state.enemy.hp <= 0 || state.player.hp <= 0 { break }
    // End turn + enemy
    state = end_player_turn(state)
    state = execute_enemy_turn(state)
    turn = turn + 1
  }
  (state, turn)
}

pub fn simulate_n_battles(n : Int, char_id : String, enemy_id : String) -> SimulationResult {
  let mut result = new_simulation()
  let mut total_turns = 0
  let mut total_hp = 0
  let mut total_pollution = 0
  let mut i = 0
  while i < n {
    let (final_state, turns) = run_single_simulation(char_id, enemy_id)
    result = { ..result, battles_run: result.battles_run + 1 }
    if final_state.enemy.hp <= 0 {
      result = { ..result, player_wins: result.player_wins + 1 }
    } else {
      result = { ..result, enemy_wins: result.enemy_wins + 1 }
    }
    total_turns = total_turns + turns
    total_hp = total_hp + final_state.player.hp
    total_pollution = total_pollution + final_state.pollution
    if turns < result.fastest_win { result = { ..result, fastest_win: turns } }
    if turns > result.slowest_win { result = { ..result, slowest_win: turns } }
    i = i + 1
  }
  if n > 0 {
    result = { ..result,
      avg_turns: total_turns.to_double() / n.to_double(),
      avg_player_hp: total_hp.to_double() / n.to_double(),
      avg_pollution: total_pollution.to_double() / n.to_double(),
    }
  }
  result
}

pub fn simulation_report(result : SimulationResult) -> String {
  let win_rate = if result.battles_run > 0 { result.player_wins.to_double() / result.battles_run.to_double() * 100.0 } else { 0.0 }
  "=== Simulation Results ===\n" +
  "Battles: " + result.battles_run.to_string() + "\n" +
  "Wins: " + result.player_wins.to_string() + " / Losses: " + result.enemy_wins.to_string() + "\n" +
  "Win Rate: " + win_rate.to_string() + "%\n" +
  "Avg Turns: " + result.avg_turns.to_string() + "\n" +
  "Avg HP Left: " + result.avg_player_hp.to_string() + "\n" +
  "Avg Pollution: " + result.avg_pollution.to_string() + "\n" +
  "Fastest Win: " + result.fastest_win.to_string() + " turns\n" +
  "Slowest Win: " + result.slowest_win.to_string() + " turns"
}

pub fn simulate_all_enemies(n : Int, char_id : String) -> Array[SimulationResult] {
  let enemies = all_enemy_names()
  let results : Array[SimulationResult] = []
  let mut i = 0
  while i < enemies.length() {
    results.push(simulate_n_battles(n, char_id, enemies[i]))
    i = i + 1
  }
  results
}

pub fn balance_check(char_id : String, enemy_id : String) -> String {
  let result = simulate_n_battles(10, char_id, enemy_id)
  let win_rate = result.player_wins.to_double() / 10.0 * 100.0
  if win_rate > 90.0 {
    "Too easy: " + win_rate.to_string() + "% — consider buffing " + enemy_id
  } else if win_rate < 10.0 {
    "Too hard: " + win_rate.to_string() + "% — consider nerfing " + enemy_id
  } else if win_rate < 30.0 {
    "Hard: " + win_rate.to_string() + "% — " + enemy_id + " may need tweaking"
  } else if win_rate > 70.0 {
    "Easy: " + win_rate.to_string() + "% — " + enemy_id + " could use a buff"
  } else {
    "Balanced: " + win_rate.to_string() + "%"
  }
}

pub fn compare_characters(enemy_id : String) -> String {
  let zl = simulate_n_battles(10, "zhong-lv", enemy_id)
  let xy = simulate_n_battles(10, "xian-yin", enemy_id)
  "Zhong Lv vs " + enemy_id + ": " + (zl.player_wins.to_double() / 10.0 * 100.0).to_string() + "%\n" +
  "Xian Yin vs " + enemy_id + ": " + (xy.player_wins.to_double() / 10.0 * 100.0).to_string() + "%"
}

pub fn benchmark_speed() -> String {
  let start_cards = total_card_count()
  let start_enemies = total_enemy_count()
  "Engine Benchmarks:\n" +
  "Total cards loaded: " + start_cards.to_string() + "\n" +
  "Total enemies loaded: " + start_enemies.to_string() + "\n" +
  "Game modes: Quick, Survival, BossRush, Training, Tournament, Daily\n" +
  "AI levels: Easy, Normal, Hard, Nightmare"
}
