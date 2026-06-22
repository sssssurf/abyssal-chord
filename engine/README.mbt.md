# 深渊协奏 (Abyssal Chord)

MoonBit 回合制卡牌对战游戏引擎，已发布到 [mooncakes.io](https://mooncakes.io/packages/sssssurf/abyssal_chord)。

## 项目信息

| 项目 | 详情 |
|------|------|
| **项目名称** | 深渊协奏 (Abyssal Chord) |
| **方向** | 游戏引擎 / 卡牌策略 |
| **实现语言** | MoonBit（核心引擎）+ TypeScript（Web 可视化前端） |
| **许可证** | Apache-2.0 |
| **原创性** | 原创项目，卡牌体系与机制均为自主设计 |
| **GitHub** | https://github.com/sssssurf/abyssal-chord |
| **Gitlink** | https://gitlink.org.cn/surf3/abyssal-chord |

---

## 安装与使用

### 环境要求
- MoonBit 工具链（最新版）
- pnpm（前端依赖管理，可选）

### 安装

```bash
# 从 mooncakes.io 安装
moon add sssssurf/abyssal_chord

# 或克隆仓库
git clone https://github.com/sssssurf/abyssal-chord.git
```

### 编译与运行

```bash
# 编译引擎
cd engine
moon build              # 0 errors
moon test               # 运行 88 个测试（全部通过）
moon run cmd/main       # CLI 对战演示

# Web 前端（可选）
cd ../web
pnpm install
pnpm dev                # 启动 http://localhost:5000
```

### 可运行示例

CLI 演示 `moon run cmd/main` 启动一场钟律 vs 嘶鸣游荡者的自动对战。

Web 前端支持的路由：
- `/` — 主菜单
- `/battle` — 单人突围
- `/lobby` → `/multiplayer` — 局域网联机
- `/cards` — 卡牌图鉴

---

## 项目简介

深渊协奏是一款回合制卡牌对战游戏引擎。玩家扮演"调音师"，利用声波武器、护甲系统和永久能力与畸变体战斗。

项目包含 29 个 MoonBit 源文件（5,215 行），覆盖卡牌战斗、敌人 AI、状态管理、多人对战等完整游戏系统。前端使用 Next.js + React 提供可视化界面，支持单机对战与局域网联机。

### 为什么选择 MoonBit？

MoonBit 的类型系统、模式匹配和代数数据类型非常适合表达复杂的卡牌游戏逻辑。项目展示了 MoonBit 在实际工程中的表现力——36 张卡牌、4 种流派、7 种敌人的完整交互，编译为 0 错误、88 个测试全部通过。

### 关于前端技术选型

当前前端使用 TypeScript（Next.js + React + Framer Motion）提供动画和交互体验。MoonBit 生态中已有成熟的 Web UI 框架（如 [Rabbita](https://github.com/moonbit-community/rabbita)、[Respo](https://github.com/Respo/respo.mbt)、[Luna](https://github.com/luna-ui/luna)），后续可以考虑将前端迁移到 MoonBit。

---

## 核心功能

### 卡牌系统（36 张卡牌）
- **钟律牌库**（20 张）：低频堡垒流、过载冲击流
- **弦音牌库**（16 张）：高频刺客流、回声幻影流

### 战斗引擎
- HP / 护甲 / AP 资源管理
- 5 级污染度系统（全局战斗参数动态调整）
- 声爆 Debuff 叠加与引爆
- 11 种状态效果（易伤、虚弱、中毒、力量、荆棘、声爆等）
- 永久能力牌（6 种：频率锚定、低频共振、痛觉回响、终末定音、回声标记、全频共振）
- 遗物系统（4 个角色专属遗物）
- 阵型系统（5 种战术阵型）

### 敌人 AI
- 7 种敌人（含 2 个 Boss，支持二阶段形态转换）
- 骰子驱动的行动选择算法
- 4 级难度（简单 / 普通 / 困难 / 噩梦）

### 游戏模式
- 快速对战（10 种预设对局）
- 生存模式（无尽波次 + 难度递增）
- Boss Rush（连续挑战 Boss）
- 训练模式（流派专项练习）
- 局域网多人对战（WebSocket 实时同步）

### 辅助系统
- 卡牌数据库查询（按类型/费用/目标/关键词过滤）
- 自定义套牌构建器
- AI vs AI 战斗模拟器（平衡性测试）
- 战斗回放系统
- 卡牌协同分析（16 种 Combo）
- 平衡性计算器
- JSON 序列化

---

## 项目结构

```
abyssal-chord/
├── engine/                    # MoonBit 核心引擎
│   ├── types.mbt              # 核心类型
│   ├── battle_effect.mbt      # 卡牌效果引擎
│   ├── battle_state.mbt       # 战斗状态管理
│   ├── enemy_ai.mbt           # 敌人 AI
│   ├── card_data.mbt          # 卡牌数据
│   ├── character_data.mbt     # 角色数据
│   ├── enemy_data.mbt         # 敌人数据
│   ├── pollution.mbt          # 污染度系统
│   ├── abyssal_chord_test.mbt # 88 个自动化测试
│   ├── cmd/main/main.mbt      # CLI 演示入口
│   ├── .github/workflows/     # CI/CD 配置
│   └── moon.mod               # 包配置
│
├── web/                       # Web 可视化前端
│   ├── src/app/battle/        # 单人突围页面
│   ├── src/app/lobby/         # 联机大厅
│   ├── src/app/multiplayer/   # 多人对战
│   ├── src/lib/               # TypeScript 游戏逻辑
│   └── src/components/        # UI 组件
│
├── LICENSE                    # Apache 2.0
├── README.md
├── .gitattributes
└── .gitignore
```

---

## 游戏机制

### 污染度系统

| 等级 | 范围 | 敌人伤害加成 | 其他效果 |
|------|------|:----------:|------|
| 寂静期 | 0-15 | 0 | — |
| 低鸣期 | 16-40 | +2 | — |
| 共振期 | 41-70 | +4 | 敌人每回合 +3 护甲 |
| 咆哮期 | 71-90 | +6 | 敌人每回合 +5 护甲，玩家穿透 -3 |
| 终焉和弦 | 91-100 | +10 | 玩家穿透 -5，污染 100 即失败 |

### 流派体系

| 流派 | 角色 | 核心策略 |
|------|------|------|
| 低频堡垒 | 钟律 | 叠甲 → 护甲溢出转伤害，以守为攻 |
| 过载冲击 | 钟律 | 自伤换超高爆发，血线换杀线 |
| 高频刺客 | 弦音 | 高频率低费攻击，声爆快速叠加 |
| 回声幻影 | 弦音 | 牌效翻倍，资源效率极致 |

### 数值平衡

- **基准**：1AP = 5 伤害 = 5 护甲
- 超模设计通过副作用平衡（自伤 / 污染代价 / 消耗）
- 能力牌按投资回收期评估（1-3 回合回本）

---

## 工程质量

| 指标 | 数值 |
|------|------|
| MoonBit 源文件 | 29 个 |
| MoonBit 代码行数 | 5,215 行 |
| 自动化测试 | 88 个（全部通过） |
| CI/CD | GitHub Actions（moon check + fmt + build + test） |
| 包管理 | mooncakes.io（sssssurf/abyssal_chord） |
| 许可证 | Apache-2.0 |

## 开发历程

本项目在 Claude Code 协助下开发，AI 工具负责代码生成、Bug 修复、测试用例编写和卡牌平衡性分析。人类开发者负责游戏机制设计、架构决策和 UI/UX 实现。

## 许可证

Apache-2.0 License — 详见 [LICENSE](../LICENSE)
