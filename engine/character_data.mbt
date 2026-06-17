///|
/// 角色数据

pub fn zhong_lv() -> Character {
  {
    id: "zhong-lv", name: "钟律", name_en: "Zhong Lu",
    title: "重装和弦师", title_en: "Heavy Chordist",
    max_hp: 80,
    relic: "过载音叉", relic_en: "Overload Tuning Fork",
    relic_effect: "每回合第一次打出 Cost >= 2 的卡牌时，获得 1 点临时行动力",
    lore: "前锚点塔声学工程师，在一次锚点塔过载事故中被超低频共振波直接冲击全身。"
  }
}

pub fn xian_yin() -> Character {
  {
    id: "xian-yin", name: "弦音", name_en: "Xian Yin",
    title: "频率猎手", title_en: "Frequency Hunter",
    max_hp: 55,
    relic: "断裂琴弦", relic_en: "Snapped String",
    relic_effect: "每回合打出的前2张攻击牌，若造成未被格挡的伤害，额外附加 2 点声爆",
    lore: "旧日回音爆发时年仅12岁的孤儿，在畸变体群中独自存活了三年。"
  }
}

pub fn all_characters() -> Array[Character] {
  [ zhong_lv(), xian_yin() ]
}
