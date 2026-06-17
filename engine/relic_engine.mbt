///|
/// 遗物系统 - 角色专属遗物效果引擎

// ─── 遗物类型 ───
pub enum RelicType {
  OverloadFork
  SnappedString
  AnchorShard
  ResonanceCore
} derive(Eq)

// ─── 遗物数据 ───
pub struct Relic {
  id : String
  relic_type : RelicType
  name : String
  name_en : String
  effect : String
  owner_id : String
}

// ─── 预置遗物 ───
pub fn overload_tuning_fork() -> Relic {
  { id: "overload-fork", relic_type: OverloadFork, name: "过载音叉", name_en: "Overload Tuning Fork", effect: "每回合第一次打出 Cost >= 2 的卡牌时，获得 1 点临时行动力", owner_id: "zhong-lv" }
}

pub fn snapped_string() -> Relic {
  { id: "snapped-string", relic_type: SnappedString, name: "断裂琴弦", name_en: "Snapped String", effect: "每回合打出的前 2 张攻击牌，若造成未被格挡的伤害，额外附加 2 点声爆", owner_id: "xian-yin" }
}

pub fn anchor_shard() -> Relic {
  { id: "anchor-shard", relic_type: AnchorShard, name: "锚点碎片", name_en: "Anchor Shard", effect: "战斗开始时获得 10 点护甲。每回合结束若护甲 > 5，恢复 2 点生命", owner_id: "neutral" }
}

pub fn resonance_core() -> Relic {
  { id: "resonance-core", relic_type: ResonanceCore, name: "共鸣核心", name_en: "Resonance Core", effect: "每当你造成声爆伤害时，额外造成 1 点穿透伤害", owner_id: "neutral" }
}

// ─── 应用遗物效果 ───
pub fn apply_relic_turn_start(state : BattleState, relic : Relic) -> BattleState {
  if relic.relic_type == OverloadFork {
    state
  } else if relic.relic_type == SnappedString {
    state
  } else if relic.relic_type == AnchorShard {
    let s = add_player_armor(state, 2)
    if s.player.armor > 5 {
      let nh = if s.player.hp + 2 > s.player.max_hp { s.player.max_hp } else { s.player.hp + 2 }
      { ..s, player: { ..s.player, hp: nh } }
    } else {
      s
    }
  } else {
    state
  }
}

// ─── 检查并应用遗物：过载音叉（打出cost>=2卡牌时额外+1AP） ───
pub fn check_overload_fork(state : BattleState, card_cost : Int) -> BattleState {
  if card_cost >= 2 {
    let new_ap = state.player.ap + 1
    let s = add_log(state, "Overload Fork: +1 AP!")
    { ..s, player: { ..s.player, ap: new_ap } }
  } else {
    state
  }
}

// ─── 检查并应用遗物：断裂琴弦（攻击牌+2声爆） ───
pub fn check_snapped_string(state : BattleState, card_type : CardType, cards_played : Int) -> BattleState {
  match card_type {
    Attack => {
      if cards_played < 2 {
        add_sonic_boom(state, 2)
      } else {
        state
      }
    }
    _ => state
  }
}

// ─── 检查并应用遗物：共鸣核心（声爆伤害+1穿透） ───
pub fn check_resonance_core(state : BattleState, sonic_boom_stacks : Int) -> BattleState {
  if sonic_boom_stacks > 0 {
    deal_damage_to_enemy(state, sonic_boom_stacks, true)
  } else {
    state
  }
}

// ─── 获取角色对应遗物 ───
pub fn get_relic_for_character(char_id : String) -> Relic {
  match char_id {
    "zhong-lv" => overload_tuning_fork()
    "xian-yin" => snapped_string()
    _ => anchor_shard()
  }
}

// ─── 所有遗物列表 ───
pub fn all_relics() -> Array[Relic] {
  [ overload_tuning_fork(), snapped_string(), anchor_shard(), resonance_core() ]
}
