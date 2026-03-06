# Claude BMAD Skills

BMAD (Breakthrough Method of Agile AI Driven Development) 方法论的 Claude Code Skills 集合。

[English](README.md)

## 安装

### 方式 1: Claude Code 插件市场（推荐）

```bash
/plugin marketplace add terryso/claude-bmad-skills
/plugin install bmad-skills
```

### 方式 2: npx skills

```bash
npx skills add terryso/claude-bmad-skills
```

### 方式 3: Git Submodule

```bash
git submodule add https://github.com/terryso/claude-bmad-skills.git .agents/bmad-skills
```

### 方式 4: Clone & Copy

```bash
git clone https://github.com/terryso/claude-bmad-skills.git
cp -r claude-bmad-skills/skills/* ~/.claude/skills/
```

## 可用 Skills

### 技能总览

| 技能 | 执行模式 | 管道 | 隔离 |
|------|---------|------|------|
| bmad-story-pipeline | 子代理 | 可配置 | 无 |
| bmad-story-pipeline-worktree | 子代理 | 可配置 | Worktree |
| bmad-epic-pipeline-worktree | 批量 | 可配置 | Worktree |

> 💡 **推荐**：使用 `bmad-story-pipeline` 或 `bmad-story-pipeline-worktree`，支持可配置工作流。

---

### bmad-story-pipeline

使用子代理运行可配置的 BMAD 管道交付用户故事。

```bash
/bmad-story-pipeline 1-1
# 或不传参数，自动选择
/bmad-story-pipeline
```

**特性：**
- 通过 `references/workflow-steps.md` 配置工作流
- 每个步骤在独立子代理中运行（全新上下文）
- 可自定义管道步骤

**默认管道：**
1. 创建用户故事
2. 生成 ATDD 测试
3. 开发实现
4. 代码审查
5. 追踪测试覆盖

---

### bmad-story-pipeline-worktree

在独立 worktree 中运行可配置的 BMAD 管道，测试通过后才合并。

```bash
/bmad-story-pipeline-worktree 1-1
# 或不传参数，自动选择
/bmad-story-pipeline-worktree
```

**特性：**
- 包含 `bmad-story-pipeline` 的所有特性
- 额外的 worktree 隔离
- 条件合并（测试通过 + 无 HIGH/MEDIUM 问题）

**与 bmad-story-pipeline 的区别：**
| 特性 | pipeline | pipeline-worktree |
|------|----------|-------------------|
| 工作方式 | 当前分支 | 独立 worktree |
| 代码隔离 | 无 | 完全隔离 |
| 合并条件 | 无强制要求 | 测试通过才合并 |
| 安全性 | 中 | 高 |

---

### bmad-epic-pipeline-worktree

使用可配置管道在独立 worktree 中交付整个 Epic。

```bash
/bmad-epic-pipeline-worktree 3
# 或不传参数，自动选择
/bmad-epic-pipeline-worktree
```

**特性：**
- 使用 `bmad-story-pipeline-worktree` 处理每个故事
- 通过 workflow-steps.md 配置管道
- 每个故事独立 worktree 隔离

**执行逻辑：**
1. 收集 Epic 下所有未完成的故事
2. 按 Story 编号升序排序
3. 逐个调用 `/bmad-story-pipeline-worktree` 交付
4. 前一个故事完成才开始下一个
5. 任一失败则停止，保留状态

**适用场景：**
- 批量交付整个 Epic
- 自动化多故事顺序开发
- 确保每个故事独立测试通过

---

## 目录结构

```
claude-bmad-skills/
├── README.md
├── README_CN.md
├── LICENSE
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
└── skills/
    ├── bmad-story-pipeline/
    │   ├── SKILL.md
    │   └── references/workflow-steps.md
    ├── bmad-story-pipeline-worktree/
    │   ├── SKILL.md
    │   └── references/workflow-steps.md
    └── bmad-epic-pipeline-worktree/
        └── SKILL.md
```

## 如何选择合适的 Skill

**单个故事交付：**
- 🌟 **推荐**：`bmad-story-pipeline` 或 `bmad-story-pipeline-worktree`（可配置工作流）
- 需要 worktree 隔离？ → `bmad-story-pipeline-worktree`

**整个 Epic 交付：**
- 🌟 **推荐**：`bmad-epic-pipeline-worktree`（可配置工作流）

## 贡献

欢迎提交 Issue 和 Pull Request 添加新的 BMAD skills。

## License

MIT
