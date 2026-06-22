---
name: everything-cli
description: Fast file search on Windows using Everything's es.exe command-line interface. Use when the user needs to find files, folders, duplicates, or filter by size/date/extension/path. Requires Everything (voidtools) running in the background.
allowed-tools: Bash(everything-cli:*)
---

# File Search with Everything CLI (es.exe)

## What This Skill Does

Wraps the `es.exe` command-line tool from [voidtools Everything](https://www.voidtools.com/) to perform instant file searches across all indexed drives on Windows. Everything maintains a real-time index of every file and folder — searches return in milliseconds.

## Prerequisites

**Everything must be running.** es.exe communicates with the Everything process via IPC.

### Check if Everything is running

```bash
tasklist | grep -i everything
```

If not running, start it:

```bash
# Try common install locations
"/c/Program Files/Everything/Everything.exe" &
# or
"/d/Everything/Everything.exe" &
# or find it:
find /c /d -name "Everything.exe" -maxdepth 4 2>/dev/null | head -5
```

### Check if es.exe is available

```bash
es.exe -version
```

**If es.exe is not found**, download and install it:

```bash
# Download latest release (x64)
mkdir -p /tmp/es-dl
curl -sL "https://github.com/voidtools/ES/releases/latest" -o /dev/null -w "%{redirect_url}\n"
# Get the actual download URL:
curl -sL "https://api.github.com/repos/voidtools/es/releases/latest" | grep "browser_download_url" | grep "x64"
# Download, extract, and copy to a PATH location:
curl -sL "<url_from_above>" -o /tmp/es-dl/es.zip
cd /tmp/es-dl && unzip -o es.zip
cp es.exe "/c/Users/$USER/AppData/Local/Microsoft/WindowsApps/es.exe"
```

> **Do NOT hardcode** the Everything install path. Different machines install to different locations (`D:\Everything\`, `C:\Program Files\Everything\`, scoop, etc.). Always detect dynamically.

## Quick Start

```bash
# Basic search — find files containing "report"
es.exe "report"

# Limit results
es.exe -n 20 "report"

# JSON output (best for programmatic use)
es.exe -json "report"

# Search by extension
es.exe "ext:pdf"

# Search in a specific folder
es.exe -path "C:\Users\SunZ\Documents" "*.docx"
```

## Core Commands

### Basic Search

```bash
# Simple text search (matches filename)
es.exe "keyword"

# Multiple keywords (AND)
es.exe "report 2024"

# OR search
es.exe "report|invoice"

# Exclude
es.exe "report !temp"
```

### Search Modifiers

```bash
# Case sensitive
es.exe -i "ABC"

# Whole word match
es.exe -w "report"

# Match full path (not just filename)
es.exe -p "documents\report"

# Regex mode
es.exe -regex "report[0-9]+"
```

### Filtering by Type

```bash
# Folders only
es.exe /ad "project"

# Files only
es.exe /a-d "config"

# By extension (search syntax)
es.exe "ext:py;js;ts"

# By file type macro
es.exe "pic:"           # images
es.exe "video:"         # videos
es.exe "audio:"         # audio files
es.exe "doc:"           # documents
es.exe "exe:"           # executables
es.exe "zip:"           # archives
```

### Filtering by Size

```bash
# Using search syntax
es.exe "size:>100mb"
es.exe "size:1mb..10mb"
es.exe "size:>1gb sizedupe:"

# Using search syntax constants
es.exe "size:huge"       # 16MB - 128MB
es.exe "size:gigantic"   # > 128MB
```

### Filtering by Date

```bash
# Modified today
es.exe "dm:today"

# Modified this week
es.exe "dm:thisweek"

# Created in a date range
es.exe "dc:2024-01-01..2024-12-31"

# Accessed yesterday
es.exe "da:yesterday"
```

### Display Options

```bash
# Show size
es.exe -size "largefile"

# Show modification date
es.exe -date-modified "report"

# Show all columns
es.exe -size -date-modified -date-created -extension "report"

# Highlight matches
es.exe -highlight "report"
```

### Sorting

```bash
# Sort by size (largest first)
es.exe -sort-size-descending -size "*.mp4"

# Sort by date modified (newest first)
es.exe -sort-date-modified-descending -date-modified "*"

# Sort by name (ascending)
es.exe -sort-name-ascending "report"
```

### Path-based Search

```bash
# Search within a specific path (includes subfolders)
es.exe -path "C:\Projects" "*.py"

# Search in parent path only (no subfolders)
es.exe -parent-path "C:\Projects" "*.py"

# Search by parent folder
es.exe -parent "C:\Projects\myapp" "*"
```

### Count and Size

```bash
# Get result count only
es.exe -get-result-count "report"

# Get total size of all matching files
es.exe -get-total-size "*.log"
```

### Export Results

```bash
# Export to JSON
es.exe -export-json "results.json" "report"

# Export to CSV
es.exe -export-csv "results.csv" -size -date-modified "report"

# Export to TXT (one path per line)
es.exe -export-txt "results.txt" "report"

# Export without header row
es.exe -no-header -export-csv "results.csv" "report"
```

## JSON Output Format

When using `-json`, add display flags to include extra fields:

```bash
# Basic JSON (filename only)
es.exe -json "report"
# [{"filename":"C:\\path\\to\\file.txt"}]

# Full JSON with metadata
es.exe -json -size -date-modified -date-created -extension "report"
# [{"filename":"C:\\path\\file.txt","size":12345,"date_modified":133572776652382586,"date_created":...,"extension":".txt"}]
```

> **Note:** `date_modified` and `date_created` are Windows FILETIME values (100-nanosecond intervals since 1601-01-01). Convert with: `datetime(1601,1,1) + timedelta(microseconds=filetime/10)`

## Common Patterns

### Find large files eating disk space

```bash
es.exe -n 50 -sort-size-descending -size "size:>100mb"
```

### Find recently modified files in a project

```bash
es.exe -path "C:\Projects\myapp" -date-modified -sort-date-modified-descending -n 20 "ext:py;js;ts;vue"
```

### Find duplicate files

```bash
# Duplicate by name
es.exe "dupe: ext:mp4"

# Duplicate by name AND size
es.exe "dupe: sizedupe: size:>10mb"
```

### Find empty folders

```bash
es.exe "empty:"
```

### Find files by content

```bash
# WARNING: content search is slow — combine with other filters first
es.exe "ext:log dm:today content:ERROR"
```

### Find files with non-ASCII names

```bash
es.exe -regex "[^\x00-\x7f]"
```

## Error Levels

| Code | Meaning |
|------|---------|
| 0 | Success |
| 4 | Missing expected argument |
| 5 | Failed to create export file |
| 6 | Unknown switch |
| 7 | Failed to send IPC query to Everything |
| 8 | Everything not running |
| 9 | No results found (with `-no-result-error`) |

**If error code is 8**: Everything is not running. Start it first.

## Best Practices

1. **Always limit results** with `-n` when searching broad terms. Everything indexes millions of files.
2. **Use JSON for programmatic processing** — `-json` output is clean and parseable.
3. **Combine filters** — put size/date/path filters before content searches.
4. **Quote paths with spaces** — `es.exe -path "C:\Program Files" "*.exe"`.
5. **Use `-get-result-count` first** to gauge result volume before full output.
6. **For large exports**, use `-export-json` or `-export-csv` to write directly to file instead of stdout.

## References

* **Search syntax** — [references/search-syntax.md](references/search-syntax.md)
* **All CLI options** — [references/options-reference.md](references/options-reference.md)
* **Practical examples** — [references/practical-examples.md](references/practical-examples.md)
