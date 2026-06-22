#!/usr/bin/env bash
# everything-cli Skill 一键安装脚本
# 用法: bash install.sh [target]
# target: claude-code | opencode | cursor | cline | all (默认 all)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-all}"

echo "================================"
echo " everything-cli Skill 安装器"
echo " 目标: $TARGET"
echo "================================"
echo ""

# --- Claude Code ---
install_claude_code() {
    local dest="$HOME/.claude/skills/everything-cli"
    echo "[Claude Code] 安装到 $dest"
    mkdir -p "$dest"
    cp -r "$SCRIPT_DIR/skills/everything-cli/"* "$dest/"
    echo "[Claude Code] 完成。重启 Claude Code 后输入 /skills 验证。"
    echo ""
}

# --- OpenCode ---
install_opencode() {
    local dest="$HOME/.config/opencode/commands"
    echo "[OpenCode] 安装到 $dest"
    mkdir -p "$dest"
    cp "$SCRIPT_DIR/opencode/everything-search.md" "$dest/everything-search.md"
    echo "[OpenCode] 完成。在 TUI 中输入 /everything-search 使用。"
    echo ""
}

# --- Cursor ---
install_cursor() {
    # Cursor 项目级安装
    local dest=".cursor/rules"
    echo "[Cursor] 安装到 $dest (当前项目)"
    mkdir -p "$dest"
    cp "$SCRIPT_DIR/cursor/everything-cli.mdc" "$dest/everything-cli.mdc"
    echo "[Cursor] 完成。Cursor 会根据 description 中的 globs 自动加载。"
    echo ""
}

# --- Cline ---
install_cline() {
    local dest=".clinerules"
    echo "[Cline] 安装到 $dest (当前项目)"
    mkdir -p "$dest"
    cp "$SCRIPT_DIR/cline/everything-cli.md" "$dest/everything-cli.md"
    echo "[Cline] 完成。Cline 会自动读取 .clinerules 目录。"
    echo ""
}

# --- AGENTS.md (通用) ---
install_agents_md() {
    local dest="AGENTS.md"
    echo "[AGENTS.md] 追加到 $dest (当前项目)"
    if [ -f "$dest" ]; then
        echo "" >> "$dest"
        echo "---" >> "$dest"
        echo "" >> "$dest"
        cat "$SCRIPT_DIR/AGENTS.md" >> "$dest"
    else
        cp "$SCRIPT_DIR/AGENTS.md" "$dest"
    fi
    echo "[AGENTS.md] 完成。OpenCode/Aider 等会自动读取此文件。"
    echo ""
}

# --- 前置检查 ---
check_prerequisites() {
    echo "[检查] Everything 进程状态..."
    if tasklist 2>/dev/null | grep -qi everything; then
        echo "[检查] Everything 正在运行 ✓"
    else
        echo "[警告] Everything 未运行！es.exe 将无法工作。"
        echo "        请先启动 Everything.exe"
    fi

    echo "[检查] es.exe..."
    if es.exe -version 2>/dev/null; then
        echo "[检查] es.exe 可用 ✓"
    else
        echo "[警告] es.exe 不在 PATH 中！"
        echo "        下载: https://github.com/voidtools/ES/releases"
        echo "        解压 es.exe 到 C:\\Users\\<user>\\AppData\\Local\\Microsoft\\WindowsApps\\"
    fi
    echo ""
}

# --- 主逻辑 ---
check_prerequisites

case "$TARGET" in
    claude-code)
        install_claude_code
        ;;
    opencode)
        install_opencode
        ;;
    cursor)
        install_cursor
        ;;
    cline)
        install_cline
        ;;
    agents-md)
        install_agents_md
        ;;
    all)
        install_claude_code
        install_opencode
        install_cursor
        install_cline
        install_agents_md
        ;;
    *)
        echo "用法: bash install.sh [claude-code|opencode|cursor|cline|agents-md|all]"
        echo ""
        echo "  claude-code  安装到 ~/.claude/skills/ (个人级，所有项目)"
        echo "  opencode     安装到 ~/.config/opencode/commands/ (个人级)"
        echo "  cursor       安装到 .cursor/rules/ (当前项目)"
        echo "  cline        安装到 .clinerules/ (当前项目)"
        echo "  agents-md    追加到 AGENTS.md (当前项目)"
        echo "  all          安装到所有平台 (默认)"
        exit 1
        ;;
esac

echo "================================"
echo " 安装完成！"
echo "================================"
echo ""
echo "es.exe 前置条件: Everything 必须在后台运行。"
echo "Skill 文档参考: $SCRIPT_DIR/skills/everything-cli/SKILL.md"
