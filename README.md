# 深渊协奏 (Abyssal Chord) — MoonBit 卡牌对战游戏

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)

回合制卡牌对战游戏引擎，MoonBit 实现核心逻辑，Next.js 提供可视化前端。

## 项目结构

```
├── engine/   # MoonBit 核心引擎（~5,300 行，30 个模块）
│   ├── types.mbt           # 核心类型定义
│   ├── battle_effect.mbt   # 卡牌效果引擎
│   ├── battle_state.mbt    # 战斗状态管理
│   ├── enemy_ai.mbt        # 敌人 AI
│   ├── card_data.mbt       # 卡牌数据
│   └── ...                 # 全部 30 个 .mbt 源文件
│
├── web/        # Next.js 可视化前端
│   └── src/
│       ├── app/            # 页面路由（battle/lobby/multiplayer/cards）
│       ├── lib/            # 游戏逻辑
│       └── components/     # UI 组件
│
├── LICENSE           # Apache 2.0
└── README.md
```

## 快速开始

### MoonBit 引擎
```bash
cd engine
moon build              # 编译（0 errors）
moon test               # 运行测试（108 passed）
moon run cmd/main       # CLI 对战演示
```

### Web 前端
```bash
cd web
pnpm install
pnpm dev                # 启动 http://localhost:5000
```

## 许可证

Apache-2.0 — 详见 [LICENSE](LICENSE)
