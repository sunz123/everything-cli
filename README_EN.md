# Everything CLI Skill

> Empower AI coding agents with instant file search via [voidtools Everything's](https://www.voidtools.com/) `es.exe` command-line tool.

English | [中文](./README.md)

## What Is This

Everything is the fastest file search tool on Windows — it indexes every file on your drives and returns search results in milliseconds. This repo wraps its CLI tool `es.exe` into a **Skill** that AI coding assistants (Claude Code, OpenCode, Cursor, Cline, etc.) can use directly to:

- 🔍 **Instant file search** — Full-disk index, millisecond results
- 📁 **Multi-dimensional filtering** — By extension, size, date, path, attributes, content
- 📊 **Sort & export** — Sort by size/date/name, export to JSON/CSV/TXT
- 🔁 **Duplicate detection** — Find duplicates by filename or size
- 🤖 **Multi-platform** — One skill, 5+ AI coding agents supported

## Quick Start

### Prerequisites

1. **Install Everything** — Download and run from [voidtools.com](https://www.voidtools.com/downloads/)
2. **Download es.exe** — Get the x64 version from [GitHub Releases](https://github.com/voidtools/ES/releases), extract to a PATH directory (e.g., `C:\Users\<username>\AppData\Local\Microsoft\WindowsApps\`)

Verify installation:

```bash
es.exe -version
# Example output: 1.1.0.37
```

### Install to All AI Platforms at Once

```bash
bash install.sh all
```

### Install Individually

| Platform | Command | Location |
|----------|---------|----------|
| Claude Code | `bash install.sh claude-code` | `~/.claude/skills/everything-cli/` |
| OpenCode | `bash install.sh opencode` | `~/.config/opencode/commands/` |
| Cursor | `bash install.sh cursor` | `.cursor/rules/` |
| Cline | `bash install.sh cline` | `.clinerules/` |
| Generic (AGENTS.md) | `bash install.sh agents-md` | Project root |

### Manual Installation

See [INSTALL-GUIDE.md](./INSTALL-GUIDE.md) for detailed per-platform instructions.

## Usage Examples

After installation, just tell your AI assistant what you're looking for in natural language:

```
Find all video files larger than 1GB
Find Python files modified this week
Search for all .env files under C:\Projects
Find duplicate MP4 files
```

The AI will automatically invoke `es.exe` to perform the search.

### Manual Invocation (Claude Code / OpenCode)

```bash
# Claude Code
/everything-cli Find log files larger than 100MB

# OpenCode
/everything-search report ext:pdf
```

### Direct Command-Line Usage

```bash
# Basic search
es.exe "report"

# Limit results
es.exe -n 20 "report"

# JSON output (best for programmatic use)
es.exe -json -size -date-modified "ext:py"

# Filter by size
es.exe "size:>1gb"

# Filter by date
es.exe "dm:today"

# Search in specific directory
es.exe -path "C:\Projects" "*.py"

# Find duplicate files
es.exe "dupe: sizedupe: size:>10mb"

# Find empty folders
es.exe "empty:"

# Regex search
es.exe -regex "report[0-9]+"

# Export results to file
es.exe -export-json "results.json" "ext:pdf"
```

## Repository Structure

```
everything-cli/
├── skills/everything-cli/       # Claude Code native Skill (with full references)
│   ├── SKILL.md                  # Main skill file
│   └── references/
│       ├── search-syntax.md      # Complete search syntax reference
│       ├── options-reference.md  # All CLI options
│       └── practical-examples.md  # Practical examples
├── opencode/                     # OpenCode adaptation
│   └── everything-search.md
├── cursor/                       # Cursor adaptation
│   └── everything-cli.mdc
├── cline/                        # Cline adaptation
│   └── everything-cli.md
├── aider/                        # Aider adaptation
│   └── CONVENTIONS.md
├── continue/                     # Continue (VSCode) adaptation
│   └── everything-cli.md
├── AGENTS.md                     # Generic AGENTS.md (auto-read by OpenCode/Aider)
├── install.sh                    # One-click installer script
├── INSTALL-GUIDE.md              # Detailed installation guide
├── everything-cli.zip            # Packaged skill
├── README.md                     # Chinese README
└── README_EN.md                  # English README
```

## Search Syntax Cheat Sheet

### Boolean Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| space | AND | `report 2024` |
| `\|` | OR | `report\|invoice` |
| `!` | NOT | `report !temp` |
| `< >` | Grouping | `<a\|b> !c` |
| `" "` | Exact phrase | `"annual report"` |

### Common Search Functions

| Function | Description | Example |
|----------|-------------|---------|
| `ext:` | File extension | `ext:pdf;docx` |
| `size:` | File size | `size:>100mb` |
| `dm:` | Date modified | `dm:today` |
| `dc:` | Date created | `dc:thisweek` |
| `path:` | Match path | `path:Documents` |
| `content:` | Search content | `content:ERROR` (slow) |
| `dupe:` | Duplicate filenames | `dupe: ext:mp4` |
| `sizedupe:` | Duplicate sizes | `sizedupe: size:>100mb` |
| `empty:` | Empty folders | `empty:` |

### File Type Macros

| Macro | Type |
|-------|------|
| `pic:` | Images |
| `video:` | Videos |
| `audio:` | Audio |
| `doc:` | Documents |
| `exe:` | Executables |
| `zip:` | Archives |

### Size Constants

| Constant | Range |
|----------|-------|
| `tiny` | 0 - 10 KB |
| `small` | 10 KB - 100 KB |
| `medium` | 100 KB - 1 MB |
| `large` | 1 MB - 16 MB |
| `huge` | 16 MB - 128 MB |
| `gigantic` | > 128 MB |

Full syntax reference: [skills/everything-cli/references/search-syntax.md](./skills/everything-cli/references/search-syntax.md)

## Supported AI Platforms

| Platform | Format | Auto-trigger | Manual trigger | Progressive loading |
|----------|--------|-------------|---------------|-------------------|
| **Claude Code** | SKILL.md | ✅ | `/everything-cli` | ✅ references/ |
| **OpenCode** | commands/*.md | ❌ | `/everything-search` | ❌ |
| **Cursor** | .cursor/rules/*.mdc | ✅ | — | ❌ |
| **Cline** | .clinerules/*.md | ✅ | — | ❌ |
| **Aider** | CONVENTIONS.md | ✅ | — | ❌ |
| **Continue** | .continue/rules/*.md | ✅ | — | ❌ |
| **Generic** | AGENTS.md | ✅ | — | ❌ |

## System Requirements

- **OS**: Windows 10/11
- **Everything**: Must be running in the background ([Download](https://www.voidtools.com/downloads/))
- **es.exe**: v1.1.0+ ([Download](https://github.com/voidtools/ES/releases))

## Acknowledgments

- [voidtools Everything](https://www.voidtools.com/) — The fastest Windows file search tool
- [Everything CLI (es.exe)](https://github.com/voidtools/ES) — Command-line interface

## License

MIT
