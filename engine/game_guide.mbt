///|
/// 游戏攻略与数据手册 - Abyssal Chord 完整参考文档

// ─── 流派指南 ───
pub struct ArchetypeGuide {
  name : String
  description : String
  key_cards : Array[String]
  playstyle : String
  strengths : String
  weaknesses : String
  recommended_relic : String
}

pub fn fortress_guide() -> ArchetypeGuide {
  {
    name: "低频堡垒流",
    description: "通过大量堆叠护甲与共振护盾机制，形成以守为攻的滚雪球体系。",
    key_cards: ["共振壁垒", "谐波叠加", "次声崩塌", "频率锚定"],
    playstyle: "前期叠甲建立防线，中期用次声崩塌转化护甲为伤害，后期配合低频共振自动输出。",
    strengths: "极高生存能力；护甲溢出可转化为伤害；持久战优势明显",
    weaknesses: "启动慢（需要2-3回合建立护甲）；对穿透伤害无力；惧怕护甲清除效果",
    recommended_relic: "过载音叉"
  }
}

pub fn overload_guide() -> ArchetypeGuide {
  {
    name: "过载冲击流",
    description: "利用自我伤害换取超高倍率的攻击牌，形成血线换杀线的极限输出。",
    key_cards: ["过载轰鸣", "反馈回路", "断弦极限", "终末定音"],
    playstyle: "用自伤卡牌换取高额AP和伤害加成，通过Combo链在1-2回合内爆发击杀。",
    strengths: "爆发伤害极高；Combo上限高；配合遗物可实现单回合超高输出",
    weaknesses: "血线压力大；需要精确计算；怕Debuff干扰；容错率低",
    recommended_relic: "过载音叉"
  }
}

pub fn assassin_guide() -> ArchetypeGuide {
  {
    name: "高频刺客流",
    description: "通过低费高频率的攻击牌密集输出，叠加声爆层数形成持续消耗。",
    key_cards: ["声纹连斩", "共振穿刺", "高频切割", "超频驱动"],
    playstyle: "每回合打出多张低费攻击牌，快速叠加声爆，利用断裂琴弦遗物额外附加声爆。",
    strengths: "输出频率极高；声爆叠加速度快；灵活走位；费用效率高",
    weaknesses: "单张牌伤害低；对高护甲敌人效果差；手牌消耗快；需要稳定抽牌",
    recommended_relic: "断裂琴弦"
  }
}

pub fn echo_guide() -> ArchetypeGuide {
  {
    name: "回声幻影流",
    description: "利用回声标记机制将每张牌的收益翻倍，实现一牌双响的精密连招。",
    key_cards: ["回声标记", "相位镜像", "残响追击", "全频共振"],
    playstyle: "先激活回声标记，然后通过相位镜像复制关键牌，用残响追击收割。",
    strengths: "资源效率极致；单牌收益翻倍；Combo链上限极高；中期发力",
    weaknesses: "需要前置准备；回声标记启动需要2AP；节奏控制要求高；手牌管理复杂",
    recommended_relic: "断裂琴弦"
  }
}

pub fn all_guides() -> Array[ArchetypeGuide] {
  [ fortress_guide(), overload_guide(), assassin_guide(), echo_guide() ]
}

// ─── 敌人对策指南 ───
pub struct EnemyStrategy {
  enemy_name : String
  threat_level : String  // Low/Medium/High/Boss
  recommended_approach : String
  dangerous_moves : Array[String]
  tips : Array[String]
}

pub fn howling_drifter_strategy() -> EnemyStrategy {
  {
    enemy_name: "嘶鸣游荡者",
    threat_level: "Low",
    recommended_approach: "直接攻击即可，注意躲避骰子5的共振增幅（伤害+3后的连击）。",
    dangerous_moves: ["共振增幅(骰子5)", "低频感染(骰子6)"],
    tips: ["单独一只不可怕，优先击杀避免互相增幅", "低血量时用稳频调谐控制污染度", "注意积累声爆后使用高伤害牌"],
  }
}

pub fn silent_mimic_strategy() -> EnemyStrategy {
  {
    enemy_name: "静默拟态体",
    threat_level: "Medium",
    recommended_approach: "在它开启拟态伪装（骰子5）时避免使用高伤害牌，用低频攻击磨血。",
    dangerous_moves: ["拟态伪装(骰子5)-反弹50%伤害", "绝对寂静(骰子6)-污染+10"],
    tips: ["拟态伪装期间用技能牌叠甲/过牌", "声波吞噬会弃牌，注意保留关键卡牌", "消音力场后攻击-3，可以用能力牌过渡"],
  }
}

pub fn mutos_strategy() -> EnemyStrategy {
  {
    enemy_name: "深渊颂歌·穆托斯",
    threat_level: "Boss",
    recommended_approach: "一阶段稳定输出保存资源，HP50%触发二阶段时确保有足够护甲应对清空。",
    dangerous_moves: ["共鸣压制(骰子6)-声爆引爆", "深渊呼唤(骰子5)-召唤", "末日和弦(二阶段骰子6)-穿透伤害"],
    tips: ["二阶段前尽量保持低污染度", "共鸣压制会引爆声爆造成巨额伤害", "召唤的游荡者会额外施加声爆和污染", "终末和弦状态下穿透伤害无法格挡，需要足够HP储备"],
  }
}

pub fn harmonic_construct_strategy() -> EnemyStrategy {
  {
    enemy_name: "谐波构造体",
    threat_level: "Boss",
    recommended_approach: "交替使用不同类型伤害避免触发自适应抗性，优先清除污染度。",
    dangerous_moves: ["频率复制(骰子4)-复制上回合伤害", "终末谐振(二阶段骰子6)-污染度/5穿透伤害", "结构重组(骰子6)-回血+叠甲"],
    tips: ["自适应谐振会降低重复类型伤害，交替使用攻击和技能牌", "频率复制可反弹巨额伤害，上回合避免使用高伤害牌", "结构重组恢复10HP，需要持续输出压力"],
  }
}

pub fn all_strategies() -> Array[EnemyStrategy] {
  [ howling_drifter_strategy(), silent_mimic_strategy(), mutos_strategy(), harmonic_construct_strategy() ]
}

// ─── 污染度管理指南 ───
pub struct PollutionGuide {
  tier_name : String
  threshold : String
  what_to_do : String
  danger_warning : String
}

pub fn pollution_guides() -> Array[PollutionGuide] {
  [
    {
      tier_name: "寂静期 (0-15)",
      threshold: "安全区域",
      what_to_do: "正常输出，可以承受一些增加污染度的操作。",
      danger_warning: "无危险。",
    },
    {
      tier_name: "低鸣期 (16-40)",
      threshold: "轻度威胁",
      what_to_do: "开始使用稳频调谐等净化牌控制污染度。",
      danger_warning: "敌人伤害+2，需要开始关注污染度增长。",
    },
    {
      tier_name: "共振期 (41-70)",
      threshold: "中度威胁",
      what_to_do: "优先使用净化牌。敌人每回合获得3护甲。",
      danger_warning: "敌人伤害+4，护甲每回合增长。需要加大输出力度。",
    },
    {
      tier_name: "咆哮期 (71-90)",
      threshold: "高度威胁",
      what_to_do: "全力输出，不要吝啬高费牌。净化牌优先保留。",
      danger_warning: "玩家每回合受3穿透伤害。敌人伤害+6，护甲+5/回合。",
    },
    {
      tier_name: "终焉和弦 (91-100)",
      threshold: "致命区域",
      what_to_do: "必须在2-3回合内结束战斗！使用一切可用的高伤害牌。",
      danger_warning: "玩家每回合受5穿透伤害。敌人伤害+10。污染度100时游戏失败！",
    },
  ]
}

// ─── 角色对比 ───
pub struct CharacterComparison {
  aspect : String
  zhong_lv_value : String
  xian_yin_value : String
}

pub fn character_comparisons() -> Array[CharacterComparison] {
  [
    { aspect: "最大HP", zhong_lv_value: "80", xian_yin_value: "55" },
    { aspect: "遗物效果", zhong_lv_value: "打出Cost>=2卡牌+1AP", xian_yin_value: "攻击牌未格挡+2声爆" },
    { aspect: "推荐流派", zhong_lv_value: "低频堡垒/过载冲击", xian_yin_value: "高频刺客/回声幻影" },
    { aspect: "上手难度", zhong_lv_value: "中等", xian_yin_value: "困难" },
    { aspect: "生存能力", zhong_lv_value: "高", xian_yin_value: "低" },
    { aspect: "爆发能力", zhong_lv_value: "高（过载流）", xian_yin_value: "极高（Combo）" },
    { aspect: "持续输出", zhong_lv_value: "中等", xian_yin_value: "极高" },
    { aspect: "污染管理", zhong_lv_value: "依赖稳频调谐", xian_yin_value: "依赖谐波感知" },
  ]
}

// ─── 快速开始指南 ───
pub fn quick_start_guide() -> String {
  "=== 深渊协奏 · 快速开始指南 ===\n" +
  "\n" +
  "【基础操作】\n" +
  "1. 选择角色：钟律（坦克/爆发）或弦音（刺客/连招）\n" +
  "2. 每回合有3点AP，卡牌消耗0-3AP\n" +
  "3. 打出牌后点击'结束回合'，敌人会行动\n" +
  "4. 敌人HP归零=胜利 / 自己HP归零或污染度100=失败\n" +
  "\n" +
  "【核心机制】\n" +
  "- 声爆：每层在回合结束时造成2点穿透伤害，然后清除\n" +
  "- 污染度：5个等级，越高敌人越强\n" +
  "- 护甲：吸收非穿透伤害\n" +
  "- 永久能力：打出后整场战斗生效\n" +
  "\n" +
  "【给新手的建议】\n" +
  "1. 用钟律+低频堡垒流开荒\n" +
  "2. 优先打出永久能力牌建立优势\n" +
  "3. 污染度超过40立刻开始净化\n" +
  "4. 保留1-2张防御牌应对敌人高伤害回合\n" +
  "5. Cost=0的卡牌是最佳资源牌\n" +
  "\n" +
  "祝你好运，调音师！"
}

// ─── 统计信息 ───
pub fn game_statistics_summary() -> String {
  "=== Abyssal Chord Statistics ===\n" +
  "Game Engine: MoonBit v0.1.0\n" +
  "Total Cards: " + total_card_count().to_string() + "\n" +
  "Total Enemies: " + total_enemy_count().to_string() + "\n" +
  "Characters: 2 (Zhong Lu, Xian Yin)\n" +
  "Archetypes: 4 (Fortress, Overload, Assassin, Echo)\n" +
  "Difficulty Levels: 4 (Easy, Normal, Hard, Nightmare)\n" +
  "Formations: 5\n" +
  "Game Modes: Single Battle, Survival\n" +
  "License: Apache-2.0"
}
