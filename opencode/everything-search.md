---
description: Fast file search using Everything es.exe. Pass search query as argument.
agent: build
---

# Everything CLI File Search

Search for files using the `es.exe` command-line tool from voidtools Everything.

**Search query:** $ARGUMENTS

## Prerequisites

Everything must be running in the background (es.exe communicates via IPC).

```bash
# Check if running
tasklist | grep -i everything

# Check es.exe version
es.exe -version
```

If es.exe is not found, download from https://github.com/voidtools/ES/releases and place in PATH.

## Instructions

Run the search using `es.exe`. Use the query provided above.

### Quick Reference

```bash
# Basic search
es.exe "keyword"

# Limit results
es.exe -n 20 "keyword"

# JSON output
es.exe -json "keyword"

# By extension
es.exe "ext:pdf;docx;txt"

# In specific folder
es.exe -path "C:\Users\Documents" "*.docx"

# Folders only
es.exe /ad "project"

# Files only
es.exe /a-d "config"

# Size filter
es.exe "size:>100mb"
es.exe "size:1mb..10mb"

# Date filter
es.exe "dm:today"
es.exe "dm:thisweek"
es.exe "dc:2024-01-01..2024-12-31"

# Sort by size (largest first)
es.exe -sort-size-descending -size "size:>1gb"

# Regex mode
es.exe -regex "report[0-9]+"

# Get count only
es.exe -get-result-count "*.py"

# Get total size
es.exe -get-total-size "*.log"

# Export to JSON file
es.exe -export-json "results.json" "report"

# Show size and date columns
es.exe -size -date-modified "report"
```

### Boolean Operators (in search text)

| Operator | Meaning |
|----------|---------|
| space | AND |
| \| | OR |
| ! | NOT |
| < > | Grouping |
| " " | Exact phrase |

### File Type Macros

`pic:` `video:` `audio:` `doc:` `exe:` `zip:`

### Size Constants

`tiny` (0-10KB) `small` (10-100KB) `medium` (100KB-1MB) `large` (1-16MB) `huge` (16-128MB) `gigantic` (>128MB)

### Common Patterns

```bash
# Find large files
es.exe -n 50 -sort-size-descending -size "size:>100mb"

# Recently modified in project
es.exe -path "C:\Projects\myapp" -date-modified -sort-date-modified-descending -n 20 "ext:py;js;ts"

# Duplicate files
es.exe "dupe: sizedupe: size:>10mb"

# Empty folders
es.exe "empty:"

# Content search (slow - combine with filters!)
es.exe "ext:log dm:today content:ERROR"
```

### Best Practices

1. Always use `-n` to limit results for broad searches
2. Use `-json` for programmatic processing
3. Quote paths with spaces
4. Combine filters before content search
5. Use `-get-result-count` to check volume first

### Error Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 4 | Missing argument |
| 7 | IPC query failed |
| 8 | Everything not running |
| 9 | No results (with -no-result-error) |
