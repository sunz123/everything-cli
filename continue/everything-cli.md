# Everything CLI (es.exe) — Fast File Search

When the user needs to find files, folders, or search by name/size/date/extension on Windows, use the `es.exe` command-line tool from voidtools Everything. Everything maintains a real-time index of all files — searches return in milliseconds.

## Prerequisites

Everything must be running in the background. es.exe communicates with it via IPC.

```bash
tasklist | grep -i everything
es.exe -version
```

If `es.exe` is not found, download from https://github.com/voidtools/ES/releases (get the x64 zip), extract `es.exe` to a PATH location.

## Quick Start

```bash
es.exe "keyword"                        # Basic search
es.exe -n 20 "keyword"                  # Limit results
es.exe -json "keyword"                  # JSON output
es.exe "ext:pdf"                        # By extension
es.exe -path "C:\Docs" "*.docx"        # In specific folder
es.exe /ad "project"                    # Folders only
es.exe /a-d "config"                    # Files only
```

## Search Syntax

### Boolean Operators

| Operator | Meaning |
|----------|---------|
| ` ` (space) | AND |
| `\|` | OR |
| `!` | NOT |
| `< >` | Grouping |
| `" "` | Exact phrase |

### Search Functions

| Syntax | Meaning |
|--------|---------|
| `ext:pdf;docx` | By extension |
| `size:>100mb` | Larger than 100MB |
| `size:1mb..10mb` | Size range |
| `dm:today` | Modified today |
| `dm:thisweek` | Modified this week |
| `dc:2024-01-01..2024-12-31` | Created in date range |
| `dupe:` | Duplicate filenames |
| `sizedupe:` | Same size |
| `empty:` | Empty folders |
| `content:ERROR` | Content contains text (SLOW) |

### File Type Macros

`pic:` `video:` `audio:` `doc:` `exe:` `zip:`

### Size Constants

`tiny` `small` `medium` `large` `huge` (16-128MB) `gigantic` (>128MB)

## CLI Flags

| Flag | Description |
|------|-------------|
| `-n <num>` | Limit results |
| `-json` | JSON output |
| `-size` | Show size column |
| `-date-modified` | Show mod date |
| `-path <path>` | Search in path |
| `-sort-size-descending` | Sort by size (large first) |
| `-sort-date-modified-descending` | Sort by date (new first) |
| `-regex` | Regex mode |
| `-get-result-count` | Count only |
| `-get-total-size` | Total size only |
| `-export-json <file>` | Export to JSON file |
| `-highlight` | Highlight matches |

## Common Patterns

```bash
# Large files eating disk space
es.exe -n 50 -sort-size-descending -size "size:>100mb"

# Recently modified in project
es.exe -path "C:\Projects\myapp" -date-modified -sort-date-modified-descending -n 20 "ext:py;js;ts"

# Duplicate large files
es.exe "dupe: sizedupe: size:>100mb"

# Empty folders
es.exe "empty:"

# Content search (combine with filters first!)
es.exe "ext:log dm:today content:ERROR"
```

## Best Practices

1. Always use `-n` for broad searches
2. Use `-json` for programmatic processing
3. Quote paths with spaces
4. Use `-get-result-count` before full output
5. For large exports, use `-export-json` to file

## Error Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 4 | Missing argument |
| 7 | IPC query failed |
| 8 | Everything not running |
| 9 | No results (with `-no-result-error`) |
