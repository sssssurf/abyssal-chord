///|
/// 生存模式 - 无尽波次挑战

// ─── 生存模式状态 ───
pub struct SurvivalState {
  battle : BattleState
  wave : Int
  score : Int
  enemies_defeated : Int
  is_active : Bool
  difficulty_multiplier : Double
}

// ─── 创建生存模式 ───
pub fn init_survival(char : Character) -> SurvivalState {
  let first_enemy = howling_drifter()
  let battle = init_battle(char, first_enemy)
  {
    battle: battle,
    wave: 1,
    score: 0,
    enemies_defeated: 0,
    is_active: true,
    difficulty_multiplier: 1.0,
  }
}

// ─── 生成下一波敌人 ───
pub fn spawn_next_wave(state : SurvivalState) -> SurvivalState {
  let wave = state.wave + 1
  let mult = 1.0 + wave.to_double() * 0.2 // 每波+20%难度
  // 选择敌人
  let enemy = pick_enemy_for_wave(wave)
  // 按难度倍率缩放HP
  let scaled_hp = (enemy.hp_1p.to_double() * mult).to_int()
  let scaled_enemy = { ..enemy, hp_1p: scaled_hp }
  let battle = init_battle(state.battle.player_char, scaled_enemy)
  // 保留玩家状态（HP、护甲、能力）
  let continued_battle = {
    ..battle,
    player: { ..state.battle.player,
      ap: state.battle.player.max_ap,
      cards_played_this_turn: 0,
      has_taken_self_damage: false,
      next_attack_bonus: 0,
      harmonic_active: false,
      free_second_attack: false,
    },
  }
  {
    battle: continued_battle,
    wave: wave,
    score: state.score + (state.enemies_defeated * 10),
    enemies_defeated: 0,
    is_active: true,
    difficulty_multiplier: mult,
  }
}

// ─── 处理敌人击杀 ───
pub fn on_enemy_defeated(state : SurvivalState) -> SurvivalState {
  let score_gain = (100.0 * state.difficulty_multiplier).to_int()
  {
    ..state,
    score: state.score + score_gain,
    enemies_defeated: state.enemies_defeated + 1,
  }
}

// ─── 波次间恢复 ───
pub fn intermission_heal(state : SurvivalState) -> SurvivalState {
  let heal = (state.battle.player.max_hp.to_double() * 0.25).to_int()
  let nh = if state.battle.player.hp + heal > state.battle.player.max_hp {
    state.battle.player.max_hp
  } else {
    state.battle.player.hp + heal
  }
  let new_pollution = if state.battle.pollution - 15 < 0 { 0 } else { state.battle.pollution - 15 }
  {
    ..state,
    battle: { ..state.battle,
      player: { ..state.battle.player, hp: nh },
      pollution: new_pollution,
    },
  }
}

// ─── 根据波次选择敌人 ───
fn pick_enemy_for_wave(wave : Int) -> Enemy {
  if wave <= 3 {
    pick_random_normal_enemy()
  } else if wave <= 6 {
    if wave % 3 == 0 { mutos() } else { pick_random_normal_enemy() }
  } else if wave % 5 == 0 {
    // Boss wave
    if wave % 10 == 0 { harmonic_construct() } else { mutos() }
  } else {
    pick_random_normal_enemy()
  }
}

// ─── 随机普通敌人 ───
fn pick_random_normal_enemy() -> Enemy {
  let enemies = [ howling_drifter(), silent_mimic(), echo_remnant(), resonance_crystal(), abyssal_shrieker() ]
  let idx = 2 // 简化：用固定种子
  enemies[idx]
}

// ─── 生存模式游戏结束 ───
pub fn is_survival_over(state : SurvivalState) -> Bool {
  !state.is_active || is_pollution_max(state.battle.pollution) || state.battle.player.hp <= 0
}

// ─── 获取生存模式摘要 ───
pub fn get_survival_summary(state : SurvivalState) -> String {
  "Wave " + state.wave.to_string() +
  " | Score: " + state.score.to_string() +
  " | Kills: " + state.enemies_defeated.to_string() +
  " | Mult: " + state.difficulty_multiplier.to_string()
}

// ─── 生存模式高分榜 ───
pub struct HighScore {
  name : String
  score : Int
  wave : Int
  date : String
}

pub fn default_high_scores() -> Array[HighScore] {
  [
    { name: "钟律(默认)", score: 0, wave: 0, date: "---" },
    { name: "钟律(默认)", score: 0, wave: 0, date: "---" },
    { name: "钟律(默认)", score: 0, wave: 0, date: "---" },
  ]
}

pub fn update_high_scores(scores : Array[HighScore], new_score : HighScore) -> Array[HighScore] {
  let result : Array[HighScore] = []
  let mut inserted = false
  let mut i = 0
  while i < scores.length() {
    if !inserted && new_score.score > scores[i].score {
      result.push(new_score)
      inserted = true
    }
    result.push(scores[i])
    i = i + 1
  }
  if !inserted { result.push(new_score) }
  // 只保留前3
  let top3 : Array[HighScore] = []
  let mut j = 0
  while j < 3 && j < result.length() {
    top3.push(result[j])
    j = j + 1
  }
  top3
}
