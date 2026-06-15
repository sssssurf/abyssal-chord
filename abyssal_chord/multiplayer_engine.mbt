///|
/// 多人对战引擎 - 支持2-4人本地/网络对战

// ─── 多人游戏状态 ───
pub struct MultiplayerState {
  room_id : String
  players : Array[MultiplayerSlot]
  current_player_index : Int
  turn_number : Int
  pollution : Int
  is_active : Bool
  winner_id : String
  log : Array[String]
}

pub struct MultiplayerSlot {
  player_id : String
  name : String
  character : Character
  player_state : PlayerState
  is_connected : Bool
  is_ready : Bool
  is_eliminated : Bool
}

// ─── 创建多人房间 ───
pub fn create_room(room_id : String, host_name : String, char_id : String) -> MultiplayerState {
  let char = get_character_by_id(char_id)
  let host_slot = {
    player_id: "p1",
    name: host_name,
    character: char,
    player_state: init_player(char),
    is_connected: true,
    is_ready: true,
    is_eliminated: false,
  }
  {
    room_id: room_id,
    players: [ host_slot ],
    current_player_index: 0,
    turn_number: 1,
    pollution: 0,
    is_active: false,
    winner_id: "",
    log: [],
  }
}

// ─── 加入房间 ───
pub fn join_room(state : MultiplayerState, name : String, char_id : String) -> MultiplayerState {
  if state.players.length() >= 4 { return state }
  let char = get_character_by_id(char_id)
  let pid = "p" + (state.players.length() + 1).to_string()
  let slot = {
    player_id: pid,
    name: name,
    character: char,
    player_state: init_player(char),
    is_connected: true,
    is_ready: false,
    is_eliminated: false,
  }
  let new_players : Array[MultiplayerSlot] = []
  let mut i = 0
  while i < state.players.length() { new_players.push(state.players[i]); i = i + 1 }
  new_players.push(slot)
  { ..state, players: new_players }
}

// ─── 玩家准备 ───
pub fn player_ready(state : MultiplayerState, player_id : String) -> MultiplayerState {
  let new_players : Array[MultiplayerSlot] = []
  let mut i = 0
  while i < state.players.length() {
    let slot = state.players[i]
    if slot.player_id == player_id {
      new_players.push({ ..slot, is_ready: true })
    } else {
      new_players.push(slot)
    }
    i = i + 1
  }
  { ..state, players: new_players }
}

// ─── 检查是否可以开始 ───
pub fn can_start_game(state : MultiplayerState) -> Bool {
  if state.players.length() < 2 { return false }
  let mut i = 0
  while i < state.players.length() {
    if !state.players[i].is_ready { return false }
    i = i + 1
  }
  true
}

// ─── 开始游戏 ───
pub fn start_game(state : MultiplayerState) -> MultiplayerState {
  { ..state, is_active: true, turn_number: 1, pollution: 0 }
}

// ─── 获取当前玩家 ───
pub fn get_current_player(state : MultiplayerState) -> MultiplayerSlot {
  let idx = state.current_player_index
  state.players[idx]
}

// ─── 获取当前玩家的对手 ───
pub fn get_opponents(state : MultiplayerState) -> Array[MultiplayerSlot] {
  let current = state.current_player_index
  let opponents : Array[MultiplayerSlot] = []
  let mut i = 0
  while i < state.players.length() {
    if i != current && !state.players[i].is_eliminated {
      opponents.push(state.players[i])
    }
    i = i + 1
  }
  opponents
}

// ─── 多人打牌（对随机敌人） ───
pub fn multiplayer_play_card(state : MultiplayerState, card_idx : Int) -> MultiplayerState {
  if !state.is_active { return state }
  let current = state.current_player_index
  let player_slot = state.players[current]
  let hand = player_slot.player_state.hand
  if card_idx < 0 || card_idx >= hand.length() { return state }
  let card = hand[card_idx]
  if card.cost > player_slot.player_state.ap { return state }
  // 随机选择一个活着的对手
  let opponents = get_opponents(state)
  if opponents.length() == 0 { return state }
  let target_idx = current % opponents.length()
  // 简化：对对手造成伤害
  let dmg = card.base_damage
  let new_players : Array[MultiplayerSlot] = []
  let mut i = 0
  while i < state.players.length() {
    let slot = state.players[i]
    if slot.player_id == opponents[target_idx].player_id {
      let new_hp = if slot.player_state.hp - dmg < 0 { 0 } else { slot.player_state.hp - dmg }
      let new_slot = {
        ..slot,
        player_state: { ..slot.player_state, hp: new_hp },
        is_eliminated: new_hp <= 0,
      }
      new_players.push(new_slot)
    } else if i == current {
      // 从手牌移除
      let new_hand : Array[Card] = []
      let mut j = 0
      while j < player_slot.player_state.hand.length() {
        if j != card_idx { new_hand.push(player_slot.player_state.hand[j]) }
        j = j + 1
      }
      let new_slot = {
        ..player_slot,
        player_state: { ..player_slot.player_state,
          hand: new_hand,
          ap: player_slot.player_state.ap - card.cost,
        },
      }
      new_players.push(new_slot)
    } else {
      new_players.push(slot)
    }
    i = i + 1
  }
  { ..state, players: new_players }
}

// ─── 多人回合结束 ───
pub fn multiplayer_end_turn(state : MultiplayerState) -> MultiplayerState {
  if !state.is_active { return state }
  // 跳过已淘汰玩家
  let players = state.players.length()
  let mut next_idx = state.current_player_index + 1
  while next_idx < players {
    if !state.players[next_idx].is_eliminated { break }
    next_idx = next_idx + 1
  }
  if next_idx >= players { next_idx = 0 }
  while next_idx < state.current_player_index {
    if !state.players[next_idx].is_eliminated { break }
    next_idx = next_idx + 1
    if next_idx >= players { next_idx = 0; break }
  }
  // 如果只有一人存活，游戏结束
  let alive = count_alive(state)
  if alive <= 1 {
    let winner = find_winner_id(state.players)
    { ..state, is_active: false, winner_id: winner }
  } else {
    // 更新当前玩家状态
    let new_players : Array[MultiplayerSlot] = []
    let mut i = 0
    while i < state.players.length() {
      let slot = state.players[i]
      if i == state.current_player_index {
        new_players.push({ ..slot, player_state: { ..slot.player_state, ap: slot.player_state.max_ap } })
      } else {
        new_players.push(slot)
      }
      i = i + 1
    }
    { ..state, players: new_players, current_player_index: next_idx, turn_number: state.turn_number + 1, pollution: if state.pollution + 3 > 100 { 100 } else { state.pollution + 3 } }
  }
}

// ─── 统计存活玩家 ───
fn count_alive(state : MultiplayerState) -> Int {
  let mut count = 0
  let mut i = 0
  while i < state.players.length() {
    if !state.players[i].is_eliminated { count = count + 1 }
    i = i + 1
  }
  count
}

// ─── 找到胜利者 ───
fn find_winner_id(players : Array[MultiplayerSlot]) -> String {
  let mut i = 0
  while i < players.length() {
    if !players[i].is_eliminated { return players[i].player_id }
    i = i + 1
  }
  ""
}

// ─── 多人战局摘要 ───
pub fn multiplayer_summary(state : MultiplayerState) -> String {
  let mut s = "Room: " + state.room_id + "\n"
  s = s + "Turn: " + state.turn_number.to_string() + "\n"
  s = s + "Pollution: " + state.pollution.to_string() + "/100\n"
  s = s + "Players:\n"
  let mut i = 0
  while i < state.players.length() {
    let p = state.players[i]
    let status = if p.is_eliminated { "💀" } else if i == state.current_player_index { "▶" } else { "⏸" }
    s = s + "  " + status + " " + p.name + " HP:" + p.player_state.hp.to_string() + "/" + p.player_state.max_hp.to_string() + "\n"
    i = i + 1
  }
  s
}

// ─── 多人语音聊天消息 ───
pub struct ChatMessage {
  sender_id : String
  sender_name : String
  content : String
  turn : Int
  is_emote : Bool
}

// ─── 预设表情 ───
pub fn preset_emotes() -> Array[String] {
  [
    "⚔️ 决一死战！",
    "🛡️ 接受挑战！",
    "🔮 准备好了吗？",
    "💪 不会输的！",
    "🤝 合作才是出路",
    "😈 你死定了",
    "🎯 精准打击！",
    "🔥 燃起来了！",
    "❄️ 冷静一下",
    "🌟 全力以赴！",
  ]
}

// ─── 创建聊天消息 ───
pub fn create_message(sender_id : String, sender_name : String, content : String, turn : Int, is_emote : Bool) -> ChatMessage {
  { sender_id: sender_id, sender_name: sender_name, content: content, turn: turn, is_emote: is_emote }
}

// ─── 网络同步包 ───
pub struct NetworkPacket {
  packet_type : String   // "game_state" / "card_play" / "turn_end" / "chat" / "surrender"
  room_id : String
  player_id : String
  data : String          // JSON payload
  sequence : Int
}

// ─── 创建网络包 ───
pub fn create_packet(packet_type : String, room_id : String, player_id : String, data : String, seq : Int) -> NetworkPacket {
  { packet_type: packet_type, room_id: room_id, player_id: player_id, data: data, sequence: seq }
}

// ─── 投降处理 ───
pub fn surrender_player(state : MultiplayerState, player_id : String) -> MultiplayerState {
  let new_players : Array[MultiplayerSlot] = []
  let mut i = 0
  while i < state.players.length() {
    let slot = state.players[i]
    if slot.player_id == player_id {
      new_players.push({ ..slot, is_eliminated: true })
    } else {
      new_players.push(slot)
    }
    i = i + 1
  }
  let alive = count_alive({ ..state, players: new_players })
  if alive <= 1 {
    let winner = find_winner_id(new_players)
    { ..state, players: new_players, is_active: false, winner_id: winner }
  } else {
    { ..state, players: new_players }
  }
}

// ─── 多人游戏结束检查 ───
pub fn check_multiplayer_game_over(state : MultiplayerState) -> Bool {
  if !state.is_active { return true }
  if state.pollution >= 100 { return true }
  let alive = count_alive(state)
  alive <= 1
}

// ─── 获取多人战绩 ───
pub struct MatchResult {
  room_id : String
  winner_name : String
  loser_names : Array[String]
  total_turns : Int
  final_pollution : Int
  mvp_player : String
}

// ─── 生成战绩 ───
pub fn generate_match_result(state : MultiplayerState) -> MatchResult {
  let winner = find_winner_id(state.players)
  let winner_name = get_player_name(state.players, winner)
  let losers : Array[String] = []
  let mut i = 0
  while i < state.players.length() {
    if state.players[i].player_id != winner && state.players[i].is_eliminated {
      losers.push(state.players[i].name)
    }
    i = i + 1
  }
  {
    room_id: state.room_id,
    winner_name: winner_name,
    loser_names: losers,
    total_turns: state.turn_number,
    final_pollution: state.pollution,
    mvp_player: winner_name,
  }
}

fn get_player_name(players : Array[MultiplayerSlot], id : String) -> String {
  let mut i = 0
  while i < players.length() {
    if players[i].player_id == id { return players[i].name }
    i = i + 1
  }
  "Unknown"
}

// ─── 观战模式 ───
pub struct SpectatorSlot {
  spectator_id : String
  name : String
  joined_at_turn : Int
}

// ─── 添加观众 ───
pub fn add_spectator(spectators : Array[SpectatorSlot], name : String, turn : Int) -> Array[SpectatorSlot] {
  let id = "spec" + (spectators.length() + 1).to_string()
  let new_list : Array[SpectatorSlot] = []
  let mut i = 0
  while i < spectators.length() { new_list.push(spectators[i]); i = i + 1 }
  new_list.push({ spectator_id: id, name: name, joined_at_turn: turn })
  new_list
}
