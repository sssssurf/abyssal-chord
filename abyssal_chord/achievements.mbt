///|
/// 成就系统 - 40个可解锁的成就

// ─── 成就类型 ───
pub enum AchievementCategory {
  Combat
  Collection
  Mastery
  Challenge
  Secret
} derive(Eq)

pub struct Achievement {
  id : String
  name : String
  description : String
  category : AchievementCategory
  is_secret : Bool
  points : Int
}

pub struct PlayerAchievement {
  achievement_id : String
  unlocked : Bool
  unlocked_at : String
  progress : Int
  target : Int
}

// ─── 战斗成就 ───
pub fn combat_achievements() -> Array[Achievement] {
  [
    { id: "first-blood", name: "初战告捷", description: "赢得第一场战斗", category: Combat, is_secret: false, points: 10 },
    { id: "flawless", name: "无伤通关", description: "以满HP赢得一场战斗", category: Combat, is_secret: false, points: 30 },
    { id: "speed-demon", name: "速战速决", description: "在3回合内赢得战斗", category: Combat, is_secret: false, points: 20 },
    { id: "survivor", name: "极限生存", description: "以1HP赢得战斗", category: Combat, is_secret: false, points: 40 },
    { id: "sonic-master", name: "声爆大师", description: "单次声爆造成超过20点伤害", category: Combat, is_secret: false, points: 30 },
    { id: "armor-king", name: "护甲之王", description: "单回合获得超过30点护甲", category: Combat, is_secret: false, points: 25 },
    { id: "overkill", name: "火力全开", description: "单次攻击造成超过50点伤害", category: Combat, is_secret: false, points: 35 },
    { id: "purifier", name: "净化使者", description: "单场战斗降低超过50点污染", category: Combat, is_secret: false, points: 20 },
    { id: "last-stand", name: "背水一战", description: "在HP<10时触发终末定音并赢得战斗", category: Combat, is_secret: true, points: 50 },
    { id: "boss-slayer", name: "弑君者", description: "击败深渊颂歌·穆托斯", category: Combat, is_secret: false, points: 50 },
    { id: "nightmare-clear", name: "噩梦终结者", description: "在噩梦难度下击败任意Boss", category: Combat, is_secret: false, points: 100 },
    { id: "no-cards-left", name: "弹尽粮绝", description: "牌库和弃牌堆均为空时赢得战斗", category: Combat, is_secret: true, points: 40 },
    { id: "ability-collector", name: "能力收集者", description: "单场战斗激活4个永久能力", category: Combat, is_secret: false, points: 25 },
  ]
}

// ─── 收集成就 ───
pub fn collection_achievements() -> Array[Achievement] {
  [
    { id: "card-hoarder", name: "卡牌收藏家", description: "收集全部40张卡牌", category: Collection, is_secret: false, points: 30 },
    { id: "enemy-scholar", name: "敌人学者", description: "击败过全部7种敌人", category: Collection, is_secret: false, points: 40 },
    { id: "zhong-master", name: "钟律大师", description: "用钟律赢得10场战斗", category: Collection, is_secret: false, points: 20 },
    { id: "xian-master", name: "弦音大师", description: "用弦音赢得10场战斗", category: Collection, is_secret: false, points: 20 },
    { id: "relic-hunter", name: "遗物猎人", description: "使用过全部4种遗物", category: Collection, is_secret: false, points: 25 },
    { id: "formation-expert", name: "战术专家", description: "使用过全部5种阵型", category: Collection, is_secret: false, points: 20 },
  ]
}

// ─── 精通成就 ───
pub fn mastery_achievements() -> Array[Achievement] {
  [
    { id: "fortress-master", name: "堡垒大师", description: "用低频堡垒流赢得20场战斗", category: Mastery, is_secret: false, points: 40 },
    { id: "overload-master", name: "过载大师", description: "用过载冲击流赢得20场战斗", category: Mastery, is_secret: false, points: 40 },
    { id: "assassin-master", name: "刺客大师", description: "用高频刺客流赢得20场战斗", category: Mastery, is_secret: false, points: 40 },
    { id: "echo-master", name: "回声大师", description: "用回声幻影流赢得20场战斗", category: Mastery, is_secret: false, points: 40 },
    { id: "combo-king", name: "连击之王", description: "单回合打出5张牌", category: Mastery, is_secret: false, points: 35 },
    { id: "perfectionist", name: "完美主义者", description: "在所有难度下都获得过胜利", category: Mastery, is_secret: false, points: 60 },
  ]
}

// ─── 挑战成就 ───
pub fn challenge_achievements() -> Array[Achievement] {
  [
    { id: "survival-10", name: "生存达人", description: "生存模式达到第10波", category: Challenge, is_secret: false, points: 50 },
    { id: "survival-20", name: "生存精英", description: "生存模式达到第20波", category: Challenge, is_secret: false, points: 100 },
    { id: "boss-rush-clear", name: "连斩", description: "一次通过Boss Rush", category: Challenge, is_secret: false, points: 80 },
    { id: "zen-master", name: "无牌胜", description: "不使用任何攻击牌赢得战斗", category: Challenge, is_secret: true, points: 100 },
    { id: "speed-runner", name: "速通者", description: "10回合内完成Boss Rush", category: Challenge, is_secret: false, points: 120 },
    { id: "iron-man", name: "铁人", description: "连续赢得10场战斗不失败", category: Challenge, is_secret: false, points: 80 },
    { id: "jackpot", name: "头奖", description: "单次攻击造成100+伤害", category: Challenge, is_secret: true, points: 150 },
    { id: "dice-master", name: "赌徒", description: "战斗中连续5次骰出相同数字", category: Challenge, is_secret: true, points: 50 },
  ]
}

// ─── 隐藏成就 ───
pub fn secret_achievements() -> Array[Achievement] {
  [
    { id: "pacifist", name: "和平主义者", description: "让污染度达到100结束游戏", category: Secret, is_secret: true, points: 10 },
    { id: "welcome", name: "欢迎来到深渊", description: "输掉第一场战斗", category: Secret, is_secret: true, points: 5 },
    { id: "lucky-seven", name: "幸运7", description: "单回合内HP恰好为7，AP为7", category: Secret, is_secret: true, points: 50 },
    { id: "all-seeing", name: "全知", description: "查看全部攻略指南", category: Secret, is_secret: false, points: 15 },
    { id: "true-ending", name: "真结局", description: "用弦音在噩梦难度击败穆托斯", category: Secret, is_secret: true, points: 200 },
  ]
}

// ─── 获取所有成就 ───
pub fn all_achievements() -> Array[Achievement] {
  let combat = combat_achievements()
  let collection = collection_achievements()
  let mastery = mastery_achievements()
  let challenge = challenge_achievements()
  let secret = secret_achievements()
  let result : Array[Achievement] = []
  let mut i = 0
  while i < combat.length() { result.push(combat[i]); i = i + 1 }
  let mut j = 0
  while j < collection.length() { result.push(collection[j]); j = j + 1 }
  let mut k = 0
  while k < mastery.length() { result.push(mastery[k]); k = k + 1 }
  let mut l = 0
  while l < challenge.length() { result.push(challenge[l]); l = l + 1 }
  let mut m = 0
  while m < secret.length() { result.push(secret[m]); m = m + 1 }
  result
}

// ─── 成就总数 ───
pub fn total_achievement_count() -> Int { 40 }

// ─── 总计成就点数 ───
pub fn total_achievement_points() -> Int {
  let all = all_achievements()
  let mut total = 0
  let mut i = 0
  while i < all.length() { total = total + all[i].points; i = i + 1 }
  total
}

// ─── 初始化玩家成就 ───
pub fn init_player_achievements() -> Array[PlayerAchievement] {
  let all = all_achievements()
  let result : Array[PlayerAchievement] = []
  let mut i = 0
  while i < all.length() {
    result.push({ achievement_id: all[i].id, unlocked: false, unlocked_at: "", progress: 0, target: 1 })
    i = i + 1
  }
  result
}

// ─── 检查成就进度 ───
pub fn check_achievement_progress(achievements : Array[PlayerAchievement], achievement_id : String, progress : Int, target : Int) -> Array[PlayerAchievement] {
  let new_list : Array[PlayerAchievement] = []
  let mut i = 0
  while i < achievements.length() {
    let a = achievements[i]
    if a.achievement_id == achievement_id {
      let new_progress = a.progress + progress
      let unlocked = new_progress >= target
      new_list.push({
        ..a,
        progress: new_progress,
        target: target,
        unlocked: unlocked,
        unlocked_at: if unlocked && !a.unlocked { "now" } else { a.unlocked_at },
      })
    } else {
      new_list.push(a)
    }
    i = i + 1
  }
  new_list
}

// ─── 获取已解锁成就数 ───
pub fn unlocked_count(achievements : Array[PlayerAchievement]) -> Int {
  let mut count = 0
  let mut i = 0
  while i < achievements.length() {
    if achievements[i].unlocked { count = count + 1 }
    i = i + 1
  }
  count
}

// ─── 获取成就点数 ───
pub fn achievement_score(achievements : Array[PlayerAchievement]) -> Int {
  let all = all_achievements()
  let mut score = 0
  let mut i = 0
  while i < achievements.length() {
    if achievements[i].unlocked {
      let mut j = 0
      while j < all.length() {
        if all[j].id == achievements[i].achievement_id { score = score + all[j].points; break }
        j = j + 1
      }
    }
    i = i + 1
  }
  score
}
