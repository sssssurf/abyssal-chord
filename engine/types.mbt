///|
/// 核心类型定义 - 卡牌、角色、敌人、污染系统的基础数据类型

// ─── 卡牌类型枚举 ───
pub enum CardType {
  Attack   // 攻击牌
  Skill    // 技能牌
  Ability  // 能力牌（永久效果）
} derive(Eq)

pub enum CardArchetype {
  Basic     // 基础流派
  Fortress  // 低频堡垒流
  Overload  // 过载冲击流
} derive(Eq)

pub enum CardTarget {
  Single  // 单体
  Self    // 自身
  Aoe     // 群体
} derive(Eq)

// ─── 卡牌数据结构 ───
pub struct Card {
  id : String
  name : String
  name_en : String
  card_type : CardType
  archetype : CardArchetype
  cost : Int
  target : CardTarget
  effect : String
  design_note : String
  base_damage : Int
  base_armor : Int
  self_damage : Int
  sonic_boom : Int
  pollution_modifier : Int
  exhaust : Bool
  retain : Bool
}

// ─── 敌人行为类型 ───
pub enum EnemyActionType {
  Attack_
  AttackDebuff
  Buff_
  Aoe_
  Special_
  Summon_
} derive(Eq)

// ─── 敌人行为 ───
pub struct EnemyAction {
  dice_min : Int
  dice_max : Int
  name : String
  name_en : String
  action_type : EnemyActionType
  effect : String
  damage : Int
  armor : Int
  sonic_boom : Int
  pollution_increase : Int
  piercing : Bool
  special : String
}

// ─── 敌人数据结构 ───
pub struct Enemy {
  id : String
  name : String
  name_en : String
  lore : String
  hp_1p : Int
  hp_2p : Int
  hp_3p : Int
  hp_4p : Int
  actions : Array[EnemyAction]
  is_boss : Bool
  has_phase2 : Bool
  phase2_actions : Array[EnemyAction]
  phase2_trigger : String
  phase2_effect : String
}

// ─── 污染度等级 ───
pub struct PollutionLevel {
  min_val : Int
  max_val : Int
  name : String
  name_en : String
  damage_bonus : Int
  armor_per_turn : Int
  player_piercing_dmg : Int
}

// ─── 角色数据结构 ───
pub struct Character {
  id : String
  name : String
  name_en : String
  title : String
  title_en : String
  max_hp : Int
  relic : String
  relic_en : String
  relic_effect : String
  lore : String
}

// ─── 永久能力 ───
pub struct ActiveAbility {
  id : String
  card_id : String
  name : String
  effect : String
}

// ─── Debuff ───
pub enum DebuffType {
  SonicBoom
  Vulnerable
  Weak
  Poison
  Strength
  Thorn
} derive(Eq)

pub struct Debuff {
  debuff_type : DebuffType
  stacks : Int
}

// ─── 玩家战斗状态 ───
pub struct PlayerState {
  id : String
  name : String
  hp : Int
  max_hp : Int
  armor : Int
  ap : Int
  max_ap : Int
  hand : Array[Card]
  deck : Array[Card]
  discard : Array[Card]
  exiled : Array[Card]
  permanent_abilities : Array[ActiveAbility]
  damage_bonus : Int
  armor_per_turn : Int
  extra_damage_per_armor : Double
  cards_played_this_turn : Int
  has_taken_self_damage : Bool
  next_attack_bonus : Int
  harmonic_active : Bool
  free_second_attack : Bool
  debuffs : Array[Debuff]
}

// ─── 敌人战斗状态 ───
pub struct EnemyState {
  id : String
  name : String
  hp : Int
  max_hp : Int
  armor : Int
  is_boss : Bool
  is_phase2 : Bool
  phase2_triggered : Bool
  summoned_minion : Bool
  reflect_active : Bool
  debuffs : Array[Debuff]
}

// ─── 战斗阶段 ───
pub enum BattlePhase {
  PlayerTurn
  EnemyTurn
  Victory_
  Defeat_
} derive(Eq, Show)

// ─── 战斗状态 ───
pub struct BattleState {
  player : PlayerState
  enemy : EnemyState
  player_char : Character
  enemy_data : Enemy
  phase : BattlePhase
  turn_number : Int
  pollution : Int
  log : Array[String]
}
