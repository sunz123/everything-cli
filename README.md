# Everything CLI Skill

> 基于 [voidtools Everything](https://www.voidtools.com/) 的 `es.exe` 命令行工具，为 AI 编码助手提供极速文件搜索能力。

[English](./README_EN.md) | 中文

## 这是什么

Everything 是 Windows 上最快的文件搜索工具，索引全盘文件后搜索只需毫秒。本仓库将其命令行工具 `es.exe` 封装为 **Skill**，让各类 AI 编码助手（Claude Code、OpenCode、Cursor、Cline 等）能直接调用，实现：

- 🔍 **毫秒级文件搜索** — 全盘索引，即时返回
- 📁 **多维度过滤** — 按扩展名、大小、日期、路径、属性、内容筛选
- 📊 **排序与导出** — 按大小/日期/名称排序，支持 JSON/CSV/TXT 导出
- 🔁 **重复文件检测** — 按文件名或大小查找重复
- 🤖 **多平台适配** — 一套内容，适配 5+ AI 编码助手

## 快速开始

### 前置条件

1. **安装 Everything** — 从 [voidtools.com](https://www.voidtools.com/downloads/) 下载并运行
2. **下载 es.exe** — 从 [GitHub Releases](https://github.com/voidtools/ES/releases) 下载 x64 版本，解压到 PATH 目录（如 `C:\Users\<用户名>\AppData\Local\Microsoft\WindowsApps\`）

验证安装：

```bash
es.exe -version
# 输出示例: 1.1.0.37
```

### 一键安装到所有 AI 平台

```bash
bash install.sh all
```

### 分别安装

| 平台 | 命令 | 安装位置 |
|------|------|---------|
| Claude Code | `bash install.sh claude-code` | `~/.claude/skills/everything-cli/` |
| OpenCode | `bash install.sh opencode` | `~/.config/opencode/commands/` |
| Cursor | `bash install.sh cursor` | `.cursor/rules/` |
| Cline | `bash install.sh cline` | `.clinerules/` |
| 通用 (AGENTS.md) | `bash install.sh agents-md` | 项目根目录 |

### 手动安装

参考 [INSTALL-GUIDE.md](./INSTALL-GUIDE.md) 获取各平台详细安装步骤。

## 使用示例

安装后，直接用自然语言告诉 AI 助手你要找什么：

```
帮我找一下所有大于 1GB 的视频文件
找出本周修改过的 Python 文件
搜索 C:\Projects 下所有 .env 文件
查找重复的 MP4 文件
```

AI 会自动调用 `es.exe` 执行搜索。

### 手动调用（Claude Code / OpenCode）

```bash
# Claude Code
/everything-cli 找大于 100MB 的日志文件

# OpenCode
/everything-search report ext:pdf
```

### 直接命令行使用

```bash
# 基本搜索
es.exe "report"

# 限制结果数量
es.exe -n 20 "report"

# JSON 输出（适合程序处理）
es.exe -json -size -date-modified "ext:py"

# 按大小过滤
es.exe "size:>1gb"

# 按日期过滤
es.exe "dm:today"

# 搜索指定目录
es.exe -path "C:\Projects" "*.py"

# 查找重复文件
es.exe "dupe: sizedupe: size:>10mb"

# 查找空文件夹
es.exe "empty:"

# 正则搜索
es.exe -regex "report[0-9]+"

# 导出结果到文件
es.exe -export-json "results.json" "ext:pdf"
```

## 仓库结构

```
everything-cli/
├── skills/everything-cli/       # Claude Code 原生 Skill（含完整 references）
│   ├── SKILL.md                  # 主文件
│   └── references/
│       ├── search-syntax.md      # 完整搜索语法参考
│       ├── options-reference.md  # 所有 CLI 选项
│       └── practical-examples.md  # 实用示例集
├── opencode/                     # OpenCode 适配
│   └── everything-search.md
├── cursor/                       # Cursor 适配
│   └── everything-cli.mdc
├── cline/                        # Cline 适配
│   └── everything-cli.md
├── aider/                        # Aider 适配
│   └── CONVENTIONS.md
├── continue/                     # Continue (VSCode) 适配
│   └── everything-cli.md
├── AGENTS.md                     # 通用 AGENTS.md（OpenCode/Aider 等自动读取）
├── install.sh                    # 一键安装脚本
├── INSTALL-GUIDE.md              # 详细安装指南
├── everything-cli.zip            # Skill 打包文件
├── README.md                     # 中文说明
└── README_EN.md                  # English README
```

## 搜索语法速查

### 布尔运算

| 运算符 | 含义 | 示例 |
|--------|------|------|
| 空格 | AND | `report 2024` |
| `\|` | OR | `report\|invoice` |
| `!` | NOT | `report !temp` |
| `< >` | 分组 | `<a\|b> !c` |
| `" "` | 精确短语 | `"annual report"` |

### 常用搜索函数

| 函数 | 说明 | 示例 |
|------|------|------|
| `ext:` | 扩展名 | `ext:pdf;docx` |
| `size:` | 文件大小 | `size:>100mb` |
| `dm:` | 修改日期 | `dm:today` |
| `dc:` | 创建日期 | `dc:thisweek` |
| `path:` | 匹配路径 | `path:Documents` |
| `content:` | 内容搜索 | `content:ERROR`（慢） |
| `dupe:` | 重复文件名 | `dupe: ext:mp4` |
| `sizedupe:` | 重复大小 | `sizedupe: size:>100mb` |
| `empty:` | 空文件夹 | `empty:` |

### 文件类型宏

| 宏 | 类型 |
|----|------|
| `pic:` | 图片 |
| `video:` | 视频 |
| `audio:` | 音频 |
| `doc:` | 文档 |
| `exe:` | 可执行文件 |
| `zip:` | 压缩包 |

### 大小常量

| 常量 | 范围 |
|------|------|
| `tiny` | 0 - 10 KB |
| `small` | 10 KB - 100 KB |
| `medium` | 100 KB - 1 MB |
| `large` | 1 MB - 16 MB |
| `huge` | 16 MB - 128 MB |
| `gigantic` | > 128 MB |

完整语法参考：[skills/everything-cli/references/search-syntax.md](./skills/everything-cli/references/search-syntax.md)

## 支持的 AI 平台

| 平台 | 格式 | 自动触发 | 手动触发 | 渐进式加载 |
|------|------|---------|---------|-----------|
| **Claude Code** | SKILL.md | ✅ | `/everything-cli` | ✅ references/ |
| **OpenCode** | commands/*.md | ❌ | `/everything-search` | ❌ |
| **Cursor** | .cursor/rules/*.mdc | ✅ | — | ❌ |
| **Cline** | .clinerules/*.md | ✅ | — | ❌ |
| **Aider** | CONVENTIONS.md | ✅ | — | ❌ |
| **Continue** | .continue/rules/*.md | ✅ | — | ❌ |
| **通用** | AGENTS.md | ✅ | — | ❌ |

## 系统要求

- **操作系统**: Windows 10/11
- **Everything**: 需在后台运行（[下载](https://www.voidtools.com/downloads/)）
- **es.exe**: v1.1.0+（[下载](https://github.com/voidtools/ES/releases)）

## 致谢

- [voidtools Everything](https://www.voidtools.com/) — 最快的 Windows 文件搜索工具
- [Everything CLI (es.exe)](https://github.com/voidtools/ES) — 命令行接口

## License

MIT
