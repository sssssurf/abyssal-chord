/// 战斗回放系统 - 录制与回放完整的战斗历史

pub struct ReplayFrame {
  frame_id : Int
  action_type : String   // "play_card" / "enemy_action" / "turn_start" / "turn_end" / "sonic_boom" / "victory" / "defeat"
  player_hp : Int
  player_armor : Int
  player_ap : Int
  enemy_hp : Int
  enemy_armor : Int
  pollution : Int
  card_id : String
  card_name : String
  enemy_action_name : String
  damage_dealt : Int
  damage_taken : Int
  armor_gained : Int
}

pub struct BattleReplay {
  character_id : String
  enemy_id : String
  frames : Array[ReplayFrame]
  total_frames : Int
  result : String
  duration : Int
  version : String
}

pub fn new_replay(character_id : String, enemy_id : String) -> BattleReplay {
  {
    character_id: character_id,
    enemy_id: enemy_id,
    frames: [],
    total_frames: 0,
    result: "in_progress",
    duration: 0,
    version: "1.0",
  }
}

pub fn record_frame(replay : BattleReplay, state : BattleState, action_type : String, card_id : String, card_name : String) -> BattleReplay {
  let frame = {
    frame_id: replay.total_frames,
    action_type: action_type,
    player_hp: state.player.hp,
    player_armor: state.player.armor,
    player_ap: state.player.ap,
    enemy_hp: state.enemy.hp,
    enemy_armor: state.enemy.armor,
    pollution: state.pollution,
    card_id: card_id,
    card_name: card_name,
    enemy_action_name: "",
    damage_dealt: 0,
    damage_taken: 0,
    armor_gained: 0,
  }
  let new_frames : Array[ReplayFrame] = []
  let mut i = 0
  while i < replay.frames.length() { new_frames.push(replay.frames[i]); i = i + 1 }
  new_frames.push(frame)
  { ..replay, frames: new_frames, total_frames: replay.total_frames + 1 }
}

pub fn record_enemy_frame(replay : BattleReplay, state : BattleState, action_name : String) -> BattleReplay {
  let frame = {
    frame_id: replay.total_frames,
    action_type: "enemy_action",
    player_hp: state.player.hp,
    player_armor: state.player.armor,
    player_ap: state.player.ap,
    enemy_hp: state.enemy.hp,
    enemy_armor: state.enemy.armor,
    pollution: state.pollution,
    card_id: "",
    card_name: "",
    enemy_action_name: action_name,
    damage_dealt: 0,
    damage_taken: 0,
    armor_gained: 0,
  }
  let new_frames : Array[ReplayFrame] = []
  let mut i = 0
  while i < replay.frames.length() { new_frames.push(replay.frames[i]); i = i + 1 }
  new_frames.push(frame)
  { ..replay, frames: new_frames, total_frames: replay.total_frames + 1 }
}

pub fn mark_replay_end(replay : BattleReplay, result : String) -> BattleReplay {
  { ..replay, result: result, duration: replay.total_frames }
}

pub fn replay_summary(replay : BattleReplay) -> String {
  "Replay: " + replay.character_id + " vs " + replay.enemy_id + "\n" +
  "Frames: " + replay.total_frames.to_string() + "\n" +
  "Result: " + replay.result + "\n" +
  "Version: " + replay.version
}

pub fn export_replay_json(replay : BattleReplay) -> String {
  let mut s = "{\"character\":\"" + replay.character_id + "\",\"enemy\":\"" + replay.enemy_id + "\",\"frames\":["
  let mut i = 0
  while i < replay.frames.length() {
    let f = replay.frames[i]
    s = s + "{\"id\":" + f.frame_id.to_string() + ",\"type\":\"" + f.action_type + "\",\"php\":" + f.player_hp.to_string() + ",\"ehp\":" + f.enemy_hp.to_string() + ",\"pol\":" + f.pollution.to_string() + "}"
    if i < replay.frames.length() - 1 { s = s + "," }
    i = i + 1
  }
  s + "],\"result\":\"" + replay.result + "\"}"
}

pub fn replay_frame_count(replay : BattleReplay) -> Int { replay.total_frames }

pub fn validate_replay(replay : BattleReplay) -> Bool {
  replay.total_frames > 0 && replay.frames.length() == replay.total_frames
}

pub fn get_frame_at(replay : BattleReplay, index : Int) -> ReplayFrame {
  if index < 0 || index >= replay.frames.length() { replay.frames[0] } else { replay.frames[index] }
}

pub fn search_frames_by_type(replay : BattleReplay, action_type : String) -> Array[Int] {
  let indices : Array[Int] = []
  let mut i = 0
  while i < replay.frames.length() {
    if replay.frames[i].action_type == action_type { indices.push(i) }
    i = i + 1
  }
  indices
}

pub fn count_player_cards(replay : BattleReplay) -> Int {
  let mut count = 0
  let mut i = 0
  while i < replay.frames.length() {
    if replay.frames[i].action_type == "play_card" { count = count + 1 }
    i = i + 1
  }
  count
}

pub fn count_enemy_actions(replay : BattleReplay) -> Int {
  let mut count = 0
  let mut i = 0
  while i < replay.frames.length() {
    if replay.frames[i].action_type == "enemy_action" { count = count + 1 }
    i = i + 1
  }
  count
}

pub fn replay_timeline(replay : BattleReplay) -> Array[String] {
  let timeline : Array[String] = []
  let mut i = 0
  while i < replay.frames.length() {
    let f = replay.frames[i]
    let desc = match f.action_type {
      "play_card" => "Turn " + f.frame_id.to_string() + ": played " + f.card_name
      "enemy_action" => "Turn " + f.frame_id.to_string() + ": enemy used " + f.enemy_action_name
      _ => "Frame " + f.frame_id.to_string() + ": " + f.action_type
    }
    timeline.push(desc)
    i = i + 1
  }
  timeline
}

pub fn merge_replays(replay_a : BattleReplay, replay_b : BattleReplay) -> BattleReplay {
  let mut merged = replay_a
  let mut i = 0
  while i < replay_b.frames.length() {
    merged = record_frame(merged, init_battle(zhong_lv(), howling_drifter()), replay_b.frames[i].action_type, replay_b.frames[i].card_id, replay_b.frames[i].card_name)
    i = i + 1
  }
  merged
}

pub fn analyze_efficiency(replay : BattleReplay) -> String {
  let cards = count_player_cards(replay)
  let enemy = count_enemy_actions(replay)
  let divisor = if enemy == 0 { 1.0 } else { enemy.to_double() }
  "Cards played: " + cards.to_string() + "\nEnemy actions: " + enemy.to_string() + "\nCard/Action ratio: " + (cards.to_double() / divisor).to_string()
}
