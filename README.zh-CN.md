# growth-retrospective · 成长复盘 skill

[English](README.md) · 简体中文

跨 agent 平台的个人成长复盘 skill —— 在你边写边发布一个项目时，捕获、组织、并跟进那些被暴露出来的能力 gap。同一份 SKILL.md 在 **Claude Code · OpenAI Codex CLI · Google Antigravity** 三家都能直接读，遵循 [agensi.io SKILL.md 开放标准](https://www.agensi.io/learn/skill-md-specification-open-standard)。

> **北极星指标**：在每个被追踪的 domain 上，让你的 **决策速度 × 决策质量 (decision velocity × decision quality)** 随时间提升。光快不行，是鲁莽；光好不快，是瘫痪；两个一起增长才是真的 *"我现在做的判断比三个月前更快、更好"*。

---

## 一句话定位

每个项目都会留下一串证据 —— 慢的决策、多轮 review、反复追问的概念、被推翻的 ADR、反复出现的同一类 bug —— 标出你在哪里还在 stretch、哪里已经在 apply。**没有刻意捕获，这些证据就消散了，同样的 gap 会在下一个项目重新出现。**

这个 skill 跑一个闭环：

```
扫描信号 → 5 个维度归类 → 按决策速度排优先级
  → 生成带毕业标记 (graduation marker) 的学习路径 → 验证 gap 是否真的在收敛
```

它**不是** inspirational coach。它把证据摆出来、排优先级、然后告诉你下一个能 close 这个 gap 的具体 artifact (产出物) 是什么。如果一个 gap 在 Tier 1 待了 6 周但 level-up 动作还没动手，它会平静地指出来。

---

## 五类成长 (5 categories)

大多数 "学习笔记" 只追第 1 类。这个 skill 追全五类 —— 因为它们会复合：一个卡住的工作习惯能掩盖一个 domain gap；一个没被识别的 meta 模式能持续制造同一种 productivity drag。

| # | 类别 | 信号来源 | 典型 level-up 动作 |
|---|---|---|---|
| 1 | **Domain knowledge** · 技术领域知识 | ADR、多轮 review 文档 | 写一页 cheatsheet (速查表) |
| 2 | **Human skills** · 人的技能（判断、抽象、提问精度、沟通清晰度） | 几周维度的 chat pattern | 跟 sparring partner 做结构化练习 |
| 3 | **Work habits** · 工作习惯（ADR 纪律、PR review 节奏、commit 卫生） | git history | 自动化这个习惯（hook、template） |
| 4 | **Meta-cognition** · 元认知（你怎么学 / 怎么决策 / 怎么失败的模式） | 跨 domain 的重复模式 | 给模式命名、装上 guardrail (护栏) |
| 5 | **Productivity / focus / energy** · 何时何处状态最好 | commit 时间戳、session 长度 | 按这个模式重构日程 |

第 4、5 类是工程师最容易跳过的 —— 因为最难量化。bundle 进来的两个脚本 (`scan_git_signals.sh`、`scan_chat_signals.py`) 帮你把全五类的数据都抽出来。

---

## 三层存储 (3 storage layers)

| 层 | 路径 | 何时加载 | 用途 |
|---|---|---|---|
| **Short index** · 短索引 | `~/.claude/projects/<id>/memory/learning_domains.md`（Claude Code；其他 agent 路径不同） | 每个 chat 自动加载 | "现在每个项目处于什么 tier" —— 一行一条 |
| **Detailed reference** · 详细参考 | `<repo>/docs/learning-domains.md` | 按需 grep | 每个 item 五字段：**Signal · Concepts · Status · Level-up · Graduation marker** |
| **Operational logbook** · 操作日志（可选，sprint 节奏项目用） | `<repo>/growth/` 下面 `daily-signals/` `weekly-retros/` `decisions/` `learnings/` 4 个子目录 | 按需 | 每日 / 每周捕获，信号往上喂到 tier 系统 |

短索引有 token 预算（~80 行 / ~4 KB），因为每个 chat 都要加载。详细参考和操作日志没预算上限。

---

## Tier 体系 + 信号分类法

| Tier | 含义 | 升 / 降级判定 |
|---|---|---|
| **Tier 1** · 高挑战 | 决策慢，仍在迭代 | 多轮 review、决策反转、被证据 falsify (推翻) 的挑战 |
| **Tier 2** · 中挑战 | 已决定但被现实测试过 | 事故驱动、反转后再决、等待未来触发条件 |
| **Tier 3** · 已稳定 | 在应用，不在学 | 达到毕业标记（比如 "连续 3 个 PR 不用 /codex consult 就定下统计判断"） |

**决策速度就是挑战度的代理变量 (proxy)。** 决策慢说明你在 stretch。完整 taxonomy 区分：

- **强信号** (Tier 1 触发)：决策反转、3+ 轮 review、多版本 research 文档、被证据推翻的挑战
- **中信号** (Tier 2 触发)：`wedge-blocker` 标签的 open issue、`needs-human` 标签密度、同一 domain 上的 stacked PR、`code-review fixes (max-effort pass)` 跟进 commit
- **弱信号**（只做 tie-breaker）：PR 从开到 merge 时间、文件 churn、长 PR 描述
- **反信号**（绝不能算 growth gap）：用户反复指令 AI agent（这是工具/加载问题，不是用户的 gap）、`nice-to-have` 标签、只输入不产出

完整 taxonomy 见 [`references/signal_taxonomy.md`](references/signal_taxonomy.md)。

---

## Level-up 动作的三条原则

每个 Tier 1 和 Tier 2 item 都配 2-3 条 **level-up 动作** + 一个 **graduation marker (毕业标记)**。原则来自 [`references/learning_journey.md`](references/learning_journey.md)：

1. **专注做完 ≤ 4 小时**。"提升我的统计能力" 不行；"写 `backend/evals/STATS-CHEATSHEET.md` —— 3 个概念 × 1 个真实例子" 行。
2. **产出 artifact，不是 "再读点资料"**。读不会缩 gap，产出才会。cheatsheet (速查表)、probe script (探活脚本)、telemetry alert (遥测告警)、ERD 图。
3. **外化 (externalize) 实践**。让对的行为更容易做，而不是靠意志力。装 hook、加 template、设 alert。

Graduation marker 必须 **可观测 + 有上下界 + 可逆**："连续 3 个 PR 不用 /codex consult 就定下统计判断" 优于 "感觉对统计有信心了"。

---

## 工作流 —— skill 真正做的事

任何方式触发后（slash command `/retrospective`、`/reflect`、`/growth-review`，或者关键词 "我最大的 gap 在哪"、"review my growth"、"回顾我的成长"），skill 跑 5 步：

1. **扫描信号源** —— 跑 `scripts/scan_git_signals.sh` + `scripts/scan_chat_signals.py`，或者用 `git log` / `gh issue list` 手工等价做。
2. **按 [类别 × tier] 归类** —— v2 强制显式 sweep 全 5 类（v1 evals 发现默认偏见是只考虑第 1 类）。
3. **更新两层存储** —— 含 **强制 demotion check**：每个现有 Tier 1/2 item 都问一次 "毕业标记是不是已经悄悄达到了？"。**Incremental 纪律 (incremental discipline)**：如果文件自上次 retro 后被改过，优先用 append-only 而不是 in-place edit。
4. **生成学习路径** —— 每个 Tier 1/2 item 写 2-3 条动作 + 毕业标记。
5. **surface gap-shrinking 信号** —— 哪些毕业了 / 哪些卡住了 / 哪些是新的 / 速度 delta。**一段就够，不是 dissertation**。

两种 mode：
- **Incremental** (milestone / session-end 默认)：只扫 delta，≤ 5 分钟。
- **Full** (显式 slash command / 首次 setup 默认)：全量扫，≤ 20 分钟。

---

## 跨 agent 兼容

三家 agent，一份文件布局：

```
~/.claude/skills/growth-retrospective/       ← canonical (Claude Code)
~/.agents/skills/growth-retrospective        → symlink (agent-neutral)
~/.codex/skills/growth-retrospective         → symlink (OpenAI Codex CLI)
~/.gemini/antigravity/skills/growth-retrospective  → symlink (Google Antigravity)
```

三家都读同样的 `SKILL.md` —— YAML frontmatter + Markdown body，[agensi.io 开放标准](https://www.agensi.io/learn/skill-md-specification-open-standard) 三家都遵循。

**每个 agent 的短索引存储路径不同**（每家有自己的 auto-load 约定），skill 会检测当前 host 并写到正确的路径。详见 `SKILL.md` 里的 "Where the short index lives — pick by host agent" 段。

---

## 快速开始

### Claude Code

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git \
  ~/.claude/skills/growth-retrospective
```

下次启动 session 时 skill 会被自动发现。触发方式：`/retrospective` / `/reflect` / `/growth-review`，或关键词触发。

### OpenAI Codex CLI

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git \
  ~/.codex/skills/growth-retrospective
```

### Google Antigravity

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git \
  ~/.gemini/antigravity/skills/growth-retrospective
```

### 一键三家（推荐）

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git \
  ~/.claude/skills/growth-retrospective
ln -s ~/.claude/skills/growth-retrospective ~/.codex/skills/growth-retrospective
mkdir -p ~/.gemini/antigravity/skills
ln -s ~/.claude/skills/growth-retrospective ~/.gemini/antigravity/skills/growth-retrospective
ln -s ~/.claude/skills/growth-retrospective ~/.agents/skills/growth-retrospective
```

一份内容，三家都能读到。

---

## 真实案例

详见 [`references/examples.md`](references/examples.md) —— `squishy-platypus` 项目（语音优先的记忆 companion，iOS + Node.js + Supabase）跑了一个月后的成长地图：5 个 Tier 1/2 item、2 个 Tier 3 item，每个决策速度信号都引用了具体的 PR / ADR 编号。

---

## 设计哲学（为什么这么设计）

> 这部分是这个 skill 跟普通 "学习 tracker" 最大的区别 —— 它的每个设计选择背后都有一个具体的 failure mode 在防范。

### 为什么是三层存储，不是一个大文件

短索引每个 chat 都加载，**token 成本不能忽视**。详细参考可以做到 ~12 KB 都没问题，因为只在 grep 时才读。可选的 `growth/` 操作日志层是给 sprint 节奏项目用的 —— 每周 retro 太慢，日级 / 决策级捕获更敏感。

三层意味着 **token 纪律 / epistemic 纪律 / 操作纪律** 可以各自独立优化。

### 为什么用决策速度，不用自我评估的 "信心值"

自我评估噪声大。一个用户说 "我对 eval methodology 已经熟了"，但花了 5 轮 review 写完那个 framework —— 那他在学习区，不在应用区。**5 轮 review 这个数比自我评估难造假**。所以 skill 把 tier 分配锚定在 **可观察 artifact** 上：ADR 数、review 轮数、反转事件、side-chat 追问的频率。

### 为什么是 5 类，不是只追 "domain knowledge"

iteration-1 的 eval 暴露了一个偏见：**没有显式 5 类 sweep 的时候，subagent 只会浮出技术概念**，而漏掉那些杠杆更高的工作习惯、元认知模式、productivity 节奏。v2 在 Step 2 加了强制 sweep —— 每次必须 actively 考虑全 5 类。

### 为什么反信号 (anti-signals) 这么重要

"用户反复让 Claude 用中文" **不是** growth gap —— 这是工具 / memory 加载问题。没有明确的反信号分类，skill 会兴高采烈地把 "用户在学如何用中文沟通" 加进 growth log，把信号源给污染掉。反信号 taxonomy 让 log 保持诚实。

### 为什么 graduation marker 必须可观测 + 有界

如果 Tier 1 item 永远不毕业，skill 就只是个吐槽板。Graduation marker 创造一个 check：满足条件时 item 降到 Tier 3 不再占注意力；如果将来又失败了，item 还能回升。**marker 就是 "gap 应该缩小而不是反复出现" 这个承诺的实现机制。**

### 为什么认知诚实 > production-ready 脚手架

Fresh-project eval 揭示了一个关键权衡。没有 skill 引导时，LLM agent 会非常乐意从一个 project spec 推断出一整套 retro 脚手架 —— 但那套脚手架是**从 ambition 发明出来的，不是从证据来的**。Skill 的首次运行模式 produces 一个更小、更诚实的产物：5 个类别下 8 个候选 domain 组成的 watchlist，每个写明 "watch 什么" 和 "什么条件升到 tier"。前期产出少，但幻觉风险也小得多。

---

## 迭代历程

用 Anthropic [skill-creator](https://github.com/anthropics/anthropic-skills) workflow 做的。

**v1 (iteration-1)** —— baseline。在真实项目 (`squishy-platypus`) 上跑 4 个 eval × 2 个 config（有 skill / 无 skill）。skill 通过核心断言，但暴露 3 个 defect：

1. 生成 chat reply 时忘记 user 的语言规则（4 字中文 gloss 规则没做）
2. 5 类覆盖是隐式的、不强制 —— baseline 也漏
3. Demotion 全靠运气，不是 deliberate

**v2 (iteration-2)** —— 修复落地。4 个重跑 + 1 个新的 fresh-project eval × 2 个 config。3 个 v1 defect **全部 PASS**。意外发现：**v2 比 v1 便宜 19% 快 31%** —— 更清晰的指令让 subagent 收敛更快。

iteration-2 期间收集到 6 个 v3 候选改进 —— 都不阻塞 ship。原始测试用例见 `evals/`。

---

## 这个 skill 不做什么

明确避免的事：

- **不追踪你已经熟练的领域** —— 只追 gap。流利的东西不进 log。
- **不收录模糊条目** —— "做一个更好的工程师" 不是 item；"连续 3 个统计 PR 不用 /codex consult" 是。
- **不写鼓舞性内容** —— 没有 "你可以的！" 标语，没有 "千里之行" 的框架。简洁、信号密集。
- **不每个 session 都跑** —— 主动触发最多每 session 一次，且只在 ≥ 30 turn 实质工作后。
- **不从 spec ambition 凑数** —— Day-1 / 首次运行产出的是 *候选 watchlist*，不是发明出来的 tier entry。
- **不违反 user 的沟通规则** —— 如果你有 `feedback_complete_sentences.md` 或 `user_language_preference.md` 这类 memory，skill 的 chat 输出必须满足它们。**skill 的价值绝不能以 user 训练好的语言纪律为代价**。

---

## 目录结构

```
.
├── SKILL.md                    # 主体（先读这个）
├── README.md                   # 英文版
├── README.zh-CN.md             # 本文件
├── LICENSE                     # MIT
├── references/
│   ├── signal_taxonomy.md      # 强 / 中 / 弱 / 反信号分类
│   ├── growth_categories.md    # 5 类详解 + 跨类交互
│   ├── learning_journey.md     # level-up 动作 + graduation marker 怎么写
│   └── examples.md             # 真实案例（squishy-platypus）
├── assets/templates/
│   ├── short_index.md          # memory 短索引模板
│   └── detailed_reference.md   # 仓库侧详细参考模板
├── scripts/
│   ├── scan_git_signals.sh     # 自动抽 ADR / review 轮 / 反转 / stacked PR
│   └── scan_chat_signals.py    # 自动抽 chat 追问 / topic 频率
└── evals/evals.json            # 测试用例
```

---

## License

MIT —— 见 [LICENSE](LICENSE)。

---

## 贡献 (Contributing)

欢迎 PR。如果你在真实项目上用过这个 skill，最有用的贡献是在 `references/examples.md` 加一个 worked example —— 哪些 category 浮出来了、动了哪些 level-up 动作、毕业了什么、反转了什么。

如果你给某个新的 agent 平台（Cursor、Aider 等）做了支持，开 issue 给我 symlink 路径约定，我们更新安装说明。
