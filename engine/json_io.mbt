///|
/// JSON 序列化 - 战斗状态导入/导出

// ─── 将卡牌转为JSON字符串 ───
pub fn card_to_json(card : Card) -> String {
  let type_str = match card.card_type {
    Attack => "\"attack\""
    Skill => "\"skill\""
    Ability => "\"ability\""
  }
  let arch_str = match card.archetype {
    Basic => "\"basic\""
    Fortress => "\"fortress\""
    Overload => "\"overload\""
  }
  let target_str = match card.target {
    Single => "\"single\""
    Self => "\"self\""
    Aoe => "\"aoe\""
  }
  "{" +
    "\"id\":\"" + card.id + "\"," +
    "\"name\":\"" + card.name + "\"," +
    "\"name_en\":\"" + card.name_en + "\"," +
    "\"type\":" + type_str + "," +
    "\"archetype\":" + arch_str + "," +
    "\"cost\":" + card.cost.to_string() + "," +
    "\"target\":" + target_str + "," +
    "\"effect\":\"" + card.effect + "\"," +
    "\"base_damage\":" + card.base_damage.to_string() + "," +
    "\"base_armor\":" + card.base_armor.to_string() + "," +
    "\"self_damage\":" + card.self_damage.to_string() + "," +
    "\"sonic_boom\":" + card.sonic_boom.to_string() + "," +
    "\"pollution_modifier\":" + card.pollution_modifier.to_string() + "," +
    "\"exhaust\":" + card.exhaust.to_string() + "," +
    "\"retain\":" + card.retain.to_string() +
  "}"
}

// ─── 卡牌数组转JSON ───
pub fn cards_to_json(cards : Array[Card]) -> String {
  if cards.length() == 0 { return "[]" }
  let mut s = "["
  let mut i = 0
  while i < cards.length() {
    s = s + card_to_json(cards[i])
    if i < cards.length() - 1 { s = s + "," }
    i = i + 1
  }
  s + "]"
}

// ─── 战斗状态转JSON（摘要） ───
pub fn battle_summary_to_json(state : BattleState) -> String {
  "{" +
    "\"turn\":" + state.turn_number.to_string() + "," +
    "\"player_hp\":" + state.player.hp.to_string() + "," +
    "\"player_max_hp\":" + state.player.max_hp.to_string() + "," +
    "\"player_armor\":" + state.player.armor.to_string() + "," +
    "\"player_ap\":" + state.player.ap.to_string() + "," +
    "\"enemy_hp\":" + state.enemy.hp.to_string() + "," +
    "\"enemy_max_hp\":" + state.enemy.max_hp.to_string() + "," +
    "\"enemy_armor\":" + state.enemy.armor.to_string() + "," +
    "\"enemy_name\":\"" + state.enemy.name + "\"," +
    "\"enemy_is_boss\":" + state.enemy.is_boss.to_string() + "," +
    "\"pollution\":" + state.pollution.to_string() + "," +
    "\"pollution_level\":\"" + get_pollution_level(state.pollution).name + "\"," +
    "\"phase\":\"" + phase_to_string(state.phase) + "\"," +
    "\"hand_size\":" + state.player.hand.length().to_string() + "," +
    "\"deck_size\":" + state.player.deck.length().to_string() + "," +
    "\"discard_size\":" + state.player.discard.length().to_string() + "," +
    "\"sonic_boom_stacks\":" + get_sonic_boom_stacks(state.enemy).to_string() + "," +
    "\"abilities_count\":" + state.player.permanent_abilities.length().to_string() +
  "}"
}

// ─── 阶段转字符串 ───
fn phase_to_string(phase : BattlePhase) -> String {
  match phase {
    PlayerTurn => "\"player_turn\""
    EnemyTurn => "\"enemy_turn\""
    Victory_ => "\"victory\""
    Defeat_ => "\"defeat\""
  }
}

// ─── 获取声爆层数 ───
fn get_sonic_boom_stacks(enemy : EnemyState) -> Int {
  let mut stacks = 0
  let mut i = 0
  while i < enemy.debuffs.length() {
    if enemy.debuffs[i].debuff_type == SonicBoom { stacks = stacks + enemy.debuffs[i].stacks }
    i = i + 1
  }
  stacks
}

// ─── 角色转JSON ───
pub fn character_to_json(char : Character) -> String {
  "{" +
    "\"id\":\"" + char.id + "\"," +
    "\"name\":\"" + char.name + "\"," +
    "\"name_en\":\"" + char.name_en + "\"," +
    "\"title\":\"" + char.title + "\"," +
    "\"max_hp\":" + char.max_hp.to_string() + "," +
    "\"relic\":\"" + char.relic + "\"," +
    "\"relic_effect\":\"" + char.relic_effect + "\"," +
    "\"lore\":\"" + char.lore + "\"" +
  "}"
}

// ─── 敌人转JSON ───
pub fn enemy_to_json(enemy : Enemy) -> String {
  "{" +
    "\"id\":\"" + enemy.id + "\"," +
    "\"name\":\"" + enemy.name + "\"," +
    "\"name_en\":\"" + enemy.name_en + "\"," +
    "\"lore\":\"" + enemy.lore + "\"," +
    "\"hp_1p\":" + enemy.hp_1p.to_string() + "," +
    "\"hp_2p\":" + enemy.hp_2p.to_string() + "," +
    "\"is_boss\":" + enemy.is_boss.to_string() + "," +
    "\"has_phase2\":" + enemy.has_phase2.to_string() + "," +
    "\"actions_count\":" + enemy.actions.length().to_string() +
  "}"
}

// ─── 生成完整战斗报告JSON ───
pub fn full_battle_report(state : BattleState) -> String {
  "{" +
    "\"game\":\"Abyssal Chord\"," +
    "\"engine\":\"MoonBit\"," +
    "\"character\":" + character_to_json(state.player_char) + "," +
    "\"enemy\":" + enemy_to_json(state.enemy_data) + "," +
    "\"battle_state\":" + battle_summary_to_json(state) + "," +
    "\"log_count\":" + state.log.length().to_string() +
  "}"
}

// ─── 验证JSON字符串基本格式 ───
pub fn is_valid_json_summary(json_str : String) -> Bool {
  // 基本检查：以{开头，以}结尾
  let len = json_str.length()
  if len < 2 { return false }
  json_str[0] == '{' && json_str[len - 1] == '}'
}

// ─── 获取卡牌统计 ───
pub fn card_statistics() -> String {
  let total = total_card_count()
  let zl = zhong_lv_cards().length()
  let xy = xian_yin_cards().length()
  let neutral = 4
  "{" +
    "\"total_cards\":" + total.to_string() + "," +
    "\"zhong_lv\":" + zl.to_string() + "," +
    "\"xian_yin\":" + xy.to_string() + "," +
    "\"neutral\":" + neutral.to_string() +
  "}"
}

// ─── 获取敌人统计 ───
pub fn enemy_statistics() -> String {
  let total = total_enemy_count()
  let normal = 5
  let bosses = 2
  "{" +
    "\"total_enemies\":" + total.to_string() + "," +
    "\"normal\":" + normal.to_string() + "," +
    "\"bosses\":" + bosses.to_string() +
  "}"
}
