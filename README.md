# 深渊协奏 (Abyssal Chord)

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-5%2C215%20lines-purple)](https://www.moonbitlang.com/)
[![mooncakes.io](https://img.shields.io/badge/mooncakes.io-sssssurf%2Fabyssal__chord-blue)](https://mooncakes.io/packages/sssssurf/abyssal_chord)

MoonBit 回合制卡牌对战游戏引擎。**29 个源文件，5,215 行 MoonBit，88 个自动化测试，已发布到 mooncakes.io。**

## 项目结构

```
├── engine/              # MoonBit 核心引擎（29 个 .mbt 源文件，5,215 行）
│   ├── types.mbt, battle_effect.mbt, enemy_ai.mbt ...
│   ├── abyssal_chord_test.mbt   # 88 个测试
│   ├── cmd/main/main.mbt        # CLI 演示
│   └── .github/workflows/       # CI/CD
│
├── web/                 # Next.js 可视化前端
│   └── src/app/         # battle / lobby / multiplayer / cards
│
└── LICENSE              # Apache 2.0
```

## 快速开始

```bash
# 安装
moon add sssssurf/abyssal_chord

# 或克隆
git clone https://github.com/sssssurf/abyssal-chord.git

# 编译 & 运行
cd engine
moon build              # 0 errors
moon test               # 88/88 passed
moon run cmd/main       # CLI 对战演示

# Web 前端
cd web && pnpm install && pnpm dev
```

## 链接

- **引擎文档**: [engine/README.mbt.md](engine/README.mbt.md)
- **GitHub**: https://github.com/sssssurf/abyssal-chord
- **Gitlink**: https://gitlink.org.cn/surf3/abyssal-chord
- **mooncakes.io**: https://mooncakes.io/packages/sssssurf/abyssal_chord

## 许可证

Apache-2.0
