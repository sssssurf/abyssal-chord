/// 自定义牌组构建器 — 赛前配置30张出战卡牌

pub struct DeckConfig {
  name : String
  character_id : String
  card_ids : Array[String]
  max_cards : Int
  min_cards : Int
  description : String
  total_cost : Int
}

pub fn new_deck(name : String, character_id : String) -> DeckConfig {
  { name: name, character_id: character_id, card_ids: [], max_cards: 30, min_cards: 15, description: "", total_cost: 0 }
}

pub fn add_card_to_deck(config : DeckConfig, card_id : String) -> DeckConfig {
  if config.card_ids.length() >= config.max_cards { return config }
  let card = find_card_by_id(card_id)
  let new_ids : Array[String] = []
  let mut i = 0
  while i < config.card_ids.length() { new_ids.push(config.card_ids[i]); i = i + 1 }
  new_ids.push(card_id)
  { ..config, card_ids: new_ids, total_cost: config.total_cost + card.cost }
}

pub fn remove_card_from_deck(config : DeckConfig, index : Int) -> DeckConfig {
  if index < 0 || index >= config.card_ids.length() { return config }
  let removed_id = config.card_ids[index]
  let card = find_card_by_id(removed_id)
  let new_ids : Array[String] = []
  let mut i = 0
  while i < config.card_ids.length() {
    if i != index { new_ids.push(config.card_ids[i]) }
    i = i + 1
  }
  { ..config, card_ids: new_ids, total_cost: config.total_cost - card.cost }
}

pub fn validate_deck(config : DeckConfig) -> String {
  if config.card_ids.length() < config.min_cards {
    return "Need at least " + config.min_cards.to_string() + " cards (currently " + config.card_ids.length().to_string() + ")"
  }
  if config.card_ids.length() > config.max_cards {
    return "Max " + config.max_cards.to_string() + " cards allowed"
  }

  let cards = resolve_deck_cards(config)
  let mut has_attack = false
  let mut has_skill = false
  let mut i = 0
  while i < cards.length() {
    if cards[i].card_type == Attack { has_attack = true }
    if cards[i].card_type == Skill { has_skill = true }
    i = i + 1
  }
  if !has_attack { return "Deck must contain at least 1 attack card" }
  if !has_skill { return "Deck must contain at least 1 skill card" }
  "Valid"
}

pub fn resolve_deck_cards(config : DeckConfig) -> Array[Card] {
  let result : Array[Card] = []
  let mut i = 0
  while i < config.card_ids.length() {
    let card = find_card_by_id(config.card_ids[i])
    result.push(card)
    i = i + 1
  }
  result
}

pub fn deck_average_cost(config : DeckConfig) -> Double {
  if config.card_ids.length() == 0 { return 0.0 }
  config.total_cost.to_double() / config.card_ids.length().to_double()
}

pub fn deck_type_distribution(config : DeckConfig) -> String {
  let cards = resolve_deck_cards(config)
  let mut atk = 0
  let mut skl = 0
  let mut abl = 0
  let mut i = 0
  while i < cards.length() {
    match cards[i].card_type {
      Attack => { atk = atk + 1 }
      Skill => { skl = skl + 1 }
      Ability => { abl = abl + 1 }
    }
    i = i + 1
  }
  "Attack:" + atk.to_string() + " Skill:" + skl.to_string() + " Ability:" + abl.to_string()
}

pub fn deck_cost_distribution(config : DeckConfig) -> String {
  let cards = resolve_deck_cards(config)
  let mut c0 = 0; let mut c1 = 0; let mut c2 = 0; let mut c3 = 0
  let mut i = 0
  while i < cards.length() {
    match cards[i].cost {
      0 => { c0 = c0 + 1 }
      1 => { c1 = c1 + 1 }
      2 => { c2 = c2 + 1 }
      _ => { c3 = c3 + 1 }
    }
    i = i + 1
  }
  "Cost 0:" + c0.to_string() + " Cost 1:" + c1.to_string() + " Cost 2:" + c2.to_string() + " Cost 3:" + c3.to_string()
}

pub fn recommend_deck(character_id : String, archetype : String) -> DeckConfig {
  let mut config = new_deck("Recommended", character_id)
  let all = all_cards_with_expansion()
  let mut added = 0
  let mut i = 0
  while i < all.length() && added < 20 {
    let c = all[i]
    let is_match = match character_id {
      "zhong-lv" => c.id.starts_with("zl")
      "xian-yin" => c.id.starts_with("xy")
      _ => true
    }
    let is_arch = match archetype {
      "fortress" => c.archetype == Fortress || c.archetype == Basic
      "overload" => c.archetype == Overload || c.archetype == Basic
      _ => true
    }
    if is_match && is_arch && c.base_damage + c.base_armor > 0 {
      config = add_card_to_deck(config, c.id)
      added = added + 1
    }
    i = i + 1
  }
  config = { ..config, description: "Recommended " + archetype + " deck for " + character_id }
  config
}

pub fn deck_statistics(config : DeckConfig) -> String {
  "Deck: " + config.name + "\n" +
  "Cards: " + config.card_ids.length().to_string() + "\n" +
  "Avg Cost: " + deck_average_cost(config).to_string() + "\n" +
  deck_type_distribution(config) + "\n" +
  deck_cost_distribution(config) + "\n" +
  "Total Cost: " + config.total_cost.to_string() + "\n" +
  "Status: " + validate_deck(config)
}

pub fn rename_deck(config : DeckConfig, new_name : String) -> DeckConfig {
  { ..config, name: new_name }
}

pub fn export_deck(config : DeckConfig) -> String {
  let mut s = config.name + "\n"
  let mut i = 0
  while i < config.card_ids.length() {
    s = s + config.card_ids[i] + "\n"
    i = i + 1
  }
  s
}

pub fn import_deck(data : String, name : String, character_id : String) -> DeckConfig {
  let mut config = new_deck(name, character_id)
  let lines = split_by_newline(data)
  let mut i = 0
  while i < lines.length() {
    if lines[i].length() > 0 { config = add_card_to_deck(config, lines[i]) }
    i = i + 1
  }
  config
}

fn split_by_newline(s : String) -> Array[String] {
  let result : Array[String] = []
  let mut current = ""
  let mut i = 0
  while i < s.length() {
    if s[i] == '\n' {
      result.push(current)
      current = ""
    } else {
      current = current + s[i].to_string()
    }
    i = i + 1
  }
  if current.length() > 0 { result.push(current) }
  result
}

pub fn compare_decks(deck_a : DeckConfig, deck_b : DeckConfig) -> String {
  let a_avg = deck_average_cost(deck_a)
  let b_avg = deck_average_cost(deck_b)
  let winner = if deck_a.card_ids.length() > deck_b.card_ids.length() { deck_a.name }
    else if deck_b.card_ids.length() > deck_a.card_ids.length() { deck_b.name }
    else if a_avg < b_avg { deck_a.name }
    else { deck_b.name }
  deck_a.name + ": " + deck_a.card_ids.length().to_string() + " cards (avg " + a_avg.to_string() + ")\n" +
  deck_b.name + ": " + deck_b.card_ids.length().to_string() + " cards (avg " + b_avg.to_string() + ")\n" +
  "Better: " + winner
}
