# everything-cli Skill 跨平台安装指南

已开发的 everything-cli Skill 原始文件位于 `everything-cli/skills/everything-cli/`，包含：
- `SKILL.md` — 主文件
- `references/search-syntax.md` — 搜索语法参考
- `references/options-reference.md` — CLI 选项参考
- `references/practical-examples.md` — 实用示例

以下是各 AI 编码 Agent 的安装方法。

---

## 1. Claude Code

Claude Code 原生支持 Skills 格式，直接复制即可。

### 安装

```bash
# 个人级（所有项目可用）
cp -r everything-cli/skills/everything-cli ~/.claude/skills/everything-cli

# 或项目级（仅当前项目）
cp -r everything-cli/skills/everything-cli .claude/skills/everything-cli
```

### 验证

```bash
# 启动 Claude Code 后，输入：
/skills    # 应该能看到 everything-cli
/everything-cli   # 手动触发
```

### 兼容性说明

Claude Code 的 SKILL.md 格式与我们现有的完全兼容：
- `name` ✓ (kebab-case)
- `description` ✓ (无尖括号)
- `allowed-tools` ✓ (`Bash(everything-cli:*)` — 限制只允许运行 es.exe)
- `references/` 目录 ✓ (Claude Code 支持渐进式加载)

Claude Code 额外支持但我们未使用的字段：
- `disable-model-invocation: true` — 禁止 AI 自动触发（如果你想手动调用才加这个）
- `user-invocable: false` — 从 / 菜单隐藏
- `context: fork` — 在子代理中运行
- `argument-hint` — 参数提示

---

## 2. OpenCode

OpenCode 使用 "commands" 而非 "skills"，格式是 Markdown + YAML frontmatter，概念类似但更简单。

### 安装

```bash
# 全局命令（所有项目可用）
mkdir -p ~/.config/opencode/commands
cp everything-cli/opencode/everything-search.md ~/.config/opencode/commands/everything-search.md

# 或项目级
mkdir -p .opencode/commands
cp everything-cli/opencode/everything-search.md .opencode/commands/everything-search.md
```

### 使用

在 OpenCode TUI 中输入：

```
/everything-search report ext:pdf
/everything-search size:>1gb
```

### 差异

| 特性 | Claude Code Skills | OpenCode Commands |
|------|-------------------|-------------------|
| 文件名 | `SKILL.md`（固定） | `<command-name>.md`（文件名即命令名） |
| 目录 | `~/.claude/skills/<name>/` | `~/.config/opencode/commands/` |
| 引用文件 | `references/` 子目录 | 无（内容全写在单个文件里） |
| 参数 | `$ARGUMENTS` | `$ARGUMENTS` / `$1` `$2` |
| 自动触发 | 支持（description 匹配） | 不支持（仅手动 `/command`） |
| allowed-tools | 支持 | 不支持（在 opencode.json 配置权限） |

OpenCode 不支持 `references/` 子目录的渐进式加载。适配文件已将核心内容内联，搜索语法和选项参考的完整版放在文件末尾。

---

## 3. Cursor

Cursor 使用 `.cursor/rules/` 目录下的 `.mdc` 文件定义规则，2026 年起也支持 Skills。

### 安装（作为 Rules）

```bash
mkdir -p .cursor/rules
cp everything-cli/cursor/everything-cli.mdc .cursor/rules/everything-cli.mdc
```

### 安装（作为 Skills，Cursor 2026+）

```bash
mkdir -p .cursor/skills/everything-cli
cp -r everything-cli/skills/everything-cli/* .cursor/skills/everything-cli/
```

### 使用

Cursor 的 rules 是自动注入的（基于 `description` 中的 globs 匹配），不需要手动调用。当你在对话中提到搜索文件时，Cursor 会自动加载这条规则。

---

## 4. Cline / Roo Code (VSCode)

Cline 使用 `.clinerules` 文件或目录提供上下文。

### 安装

```bash
# 方式 1：单文件（简单）
cp everything-cli/cline/.clinerules .clinerules

# 方式 2：目录（推荐，支持多个规则文件）
mkdir -p .clinerules
cp everything-cli/cline/everything-cli.md .clinerules/everything-cli.md
```

### 使用

Cline 会自动读取 `.clinerules` 文件作为系统提示的一部分。不需要手动触发。

---

## 5. 通用方案：项目根目录 INSTRUCTIONS / AGENTS.md

如果你用的是其他不支持 skill/command 系统的 Agent（如 Aider、Continue 等），最通用的方式是在项目根目录放一个说明文件。

### Aider

```bash
# Aider 会自动读取项目根目录的约定文件
cp everything-cli/aider/.aider.conf.yml .aider.conf.yml
# 或在 CONVENTIONS.md 中引用
```

### Continue (VSCode)

```bash
# Continue 使用 .continue/config.json 和规则文件
mkdir -p .continue/rules
cp everything-cli/continue/everything-cli.md .continue/rules/everything-cli.md
```

### 通用 AGENTS.md

```bash
# OpenCode、很多 Agent 都会读取 AGENTS.md
cat everything-cli/AGENTS.md >> AGENTS.md
```

---

## 快速对照表

| Agent | 安装路径 | 格式 | 自动触发 | 手动触发 |
|-------|---------|------|---------|---------|
| **Claude Code** | `~/.claude/skills/<name>/SKILL.md` | SKILL.md + frontmatter | ✅ description 匹配 | `/name` |
| **OpenCode** | `~/.config/opencode/commands/<name>.md` | MD + frontmatter | ❌ | `/name` |
| **Cursor** | `.cursor/rules/<name>.mdc` | MDC + frontmatter | ✅ globs 匹配 | N/A |
| **Cline** | `.clinerules/<name>.md` | MD | ✅ 自动注入 | N/A |
| **通用** | `AGENTS.md` 或 `CONVENTIONS.md` | MD | ✅ 自动读取 | N/A |

---

## es.exe 前置条件（所有平台通用）

所有方案都依赖 `es.exe` 在 PATH 中可用。确保：

```bash
# 检查
es.exe -version

# 如果没装，从 GitHub 下载：
# https://github.com/voidtools/ES/releases
# 下载 ES-x.x.x.x64.zip，解压 es.exe 到：
# C:\Users\<你>\AppData\Local\Microsoft\WindowsApps\（已在 PATH 中）
```

同时 Everything 桌面程序必须在后台运行（es.exe 通过 IPC 与它通信）。
