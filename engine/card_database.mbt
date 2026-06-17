/// 卡牌数据库 — 查询、过滤、搜索全部55张卡牌

pub struct CardQuery {
  card_type : String
  archetype : String
  min_cost : Int
  max_cost : Int
  target : String
  keyword : String
  has_special : Bool
  character : String
}

pub fn new_query() -> CardQuery {
  { card_type: "", archetype: "", min_cost: 0, max_cost: 9, target: "", keyword: "", has_special: false, character: "" }
}

pub fn query_by_type(query : CardQuery, card_type : String) -> CardQuery {
  { ..query, card_type: card_type }
}

pub fn query_by_archetype(query : CardQuery, archetype : String) -> CardQuery {
  { ..query, archetype: archetype }
}

pub fn query_by_cost(query : CardQuery, min : Int, max : Int) -> CardQuery {
  { ..query, min_cost: min, max_cost: max }
}

pub fn query_by_target(query : CardQuery, target : String) -> CardQuery {
  { ..query, target: target }
}

pub fn query_by_keyword(query : CardQuery, keyword : String) -> CardQuery {
  { ..query, keyword: keyword }
}

pub fn execute_query(query : CardQuery) -> Array[Card] {
  let all = all_cards_with_expansion()
  let result : Array[Card] = []
  let mut i = 0
  while i < all.length() {
    let card = all[i]
    let mut matches = true

    if query.card_type != "" {
      let expected = match query.card_type {
        "attack" => Attack
        "skill" => Skill
        "ability" => Ability
        _ => Attack
      }
      if card.card_type != expected { matches = false }
    }

    if query.archetype != "" && matches {
      let expected2 = match query.archetype {
        "basic" => Basic
        "fortress" => Fortress
        "overload" => Overload
        _ => Basic
      }
      if card.archetype != expected2 { matches = false }
    }

    if query.min_cost > 0 && matches {
      if card.cost < query.min_cost { matches = false }
    }
    if query.max_cost < 9 && matches {
      if card.cost > query.max_cost { matches = false }
    }

    if query.target != "" && matches {
      let expected3 = match query.target {
        "single" => Single
        "self" => Self
        "aoe" => Aoe
        _ => Single
      }
      if card.target != expected3 { matches = false }
    }

    if query.keyword != "" && matches {
      let mut found = false
      let mut ki = 0
      while ki < card.name.length() + card.effect.length() {
        let search_range = card.name + card.effect
        // Simple substring search
        if ki + query.keyword.length() <= search_range.length() {
          let mut match_kw = true
          let mut kj = 0
          while kj < query.keyword.length() {
            if search_range[ki + kj] != query.keyword[kj] { match_kw = false; break }
            kj = kj + 1
          }
          if match_kw { found = true; break }
        }
        ki = ki + 1
      }
      if !found { matches = false }
    }

    if matches { result.push(card) }
    i = i + 1
  }
  result
}

pub fn search_cards(search_term : String) -> Array[Card] {
  let q = query_by_keyword(new_query(), search_term)
  execute_query(q)
}

pub fn get_attack_cards() -> Array[Card] {
  execute_query(query_by_type(new_query(), "attack"))
}

pub fn get_skill_cards() -> Array[Card] {
  execute_query(query_by_type(new_query(), "skill"))
}

pub fn get_ability_cards() -> Array[Card] {
  execute_query(query_by_type(new_query(), "ability"))
}

pub fn get_cards_by_cost(cost : Int) -> Array[Card] {
  execute_query(query_by_cost(new_query(), cost, cost))
}

pub fn get_fortress_cards() -> Array[Card] {
  execute_query(query_by_archetype(new_query(), "fortress"))
}

pub fn get_overload_cards() -> Array[Card] {
  execute_query(query_by_archetype(new_query(), "overload"))
}

pub fn get_aoe_cards() -> Array[Card] {
  execute_query(query_by_target(new_query(), "aoe"))
}

pub fn count_cards_by_type() -> String {
  let atk = get_attack_cards().length()
  let skl = get_skill_cards().length()
  let abl = get_ability_cards().length()
  "Attack: " + atk.to_string() + " | Skill: " + skl.to_string() + " | Ability: " + abl.to_string()
}

pub fn list_all_card_names() -> Array[String] {
  let all = all_cards_with_expansion()
  let names : Array[String] = []
  let mut i = 0
  while i < all.length() { names.push(all[i].name); i = i + 1 }
  names
}

pub fn unique_card_names() -> Array[String] {
  let all_names = list_all_card_names()
  let unique : Array[String] = []
  let mut i = 0
  while i < all_names.length() {
    let mut found = false
    let mut j = 0
    while j < unique.length() {
      if unique[j] == all_names[i] { found = true; break }
      j = j + 1
    }
    if !found { unique.push(all_names[i]) }
    i = i + 1
  }
  unique
}

pub fn find_card_by_id(card_id : String) -> Card {
  let all = all_cards_with_expansion()
  let mut i = 0
  while i < all.length() {
    if all[i].id == card_id { return all[i] }
    i = i + 1
  }
  all[0]
}

pub fn find_cards_by_name(name : String) -> Array[Card] {
  let all = all_cards_with_expansion()
  let result : Array[Card] = []
  let mut i = 0
  while i < all.length() {
    if all[i].name == name { result.push(all[i]) }
    i = i + 1
  }
  result
}

pub fn get_highest_cost_card() -> Card {
  let all = all_cards_with_expansion()
  let mut best = all[0]
  let mut i = 1
  while i < all.length() {
    if all[i].cost > best.cost { best = all[i] }
    i = i + 1
  }
  best
}

pub fn get_lowest_cost_card() -> Card {
  let all = all_cards_with_expansion()
  let mut best = all[0]
  let mut i = 1
  while i < all.length() {
    if all[i].cost < best.cost { best = all[i] }
    i = i + 1
  }
  best
}

pub fn get_most_damage_card() -> Card {
  let all = all_cards_with_expansion()
  let mut best = all[0]
  let mut i = 1
  while i < all.length() {
    if all[i].base_damage > best.base_damage { best = all[i] }
    i = i + 1
  }
  best
}

pub fn get_most_armor_card() -> Card {
  let all = all_cards_with_expansion()
  let mut best = all[0]
  let mut i = 1
  while i < all.length() {
    if all[i].base_armor > best.base_armor { best = all[i] }
    i = i + 1
  }
  best
}

pub fn database_summary() -> String {
  "Card Database Summary:\n" +
  "Total: " + updated_total_card_count().to_string() + " cards\n" +
  count_cards_by_type() + "\n" +
  "Unique names: " + unique_card_names().length().to_string() + "\n" +
  "Highest cost: " + get_highest_cost_card().name + " (" + get_highest_cost_card().cost.to_string() + "AP)\n" +
  "Most damage: " + get_most_damage_card().name + " (" + get_most_damage_card().base_damage.to_string() + "dmg)\n" +
  "Most armor: " + get_most_armor_card().name + " (" + get_most_armor_card().base_armor.to_string() + "armor)"
}
