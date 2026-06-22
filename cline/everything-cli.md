# Everything CLI (es.exe) — Fast File Search

When the user needs to find files, folders, or search by name/size/date/extension on Windows, use the `es.exe` command-line tool from voidtools Everything. Everything maintains a real-time index of all files — searches return in milliseconds.

## Prerequisites

Everything must be running in the background. es.exe communicates with it via IPC.

Check if running:

```bash
tasklist | grep -i everything
es.exe -version
```

If `es.exe` is not found, download from https://github.com/voidtools/ES/releases (get the x64 zip), extract `es.exe` to a PATH location.

**Do NOT hardcode** the Everything install path. Different machines install to different locations.

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

## Search Syntax (in the search text argument)

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
| `ext:pdf;docx` | By extension (semicolon-separated) |
| `size:>100mb` | Larger than 100MB |
| `size:1mb..10mb` | Between 1MB and 10MB |
| `dm:today` | Modified today |
| `dm:thisweek` | Modified this week |
| `dc:2024-01-01..2024-12-31` | Created in date range |
| `da:yesterday` | Accessed yesterday |
| `dupe:` | Duplicate filenames |
| `sizedupe:` | Same size |
| `empty:` | Empty folders |
| `content:ERROR` | File content contains text (VERY SLOW) |
| `len:>200` | Filename length > 200 |

### Size Constants

`tiny` (0-10KB) `small` (10-100KB) `medium` (100KB-1MB) `large` (1-16MB) `huge` (16-128MB) `gigantic` (>128MB)

### File Type Macros

`pic:` (images) `video:` (videos) `audio:` (music) `doc:` (documents) `exe:` (executables) `zip:` (archives)

## CLI Flags

| Flag | Description |
|------|-------------|
| `-n <num>` | Limit results to N |
| `-json` | JSON output format |
| `-size` | Show file size column |
| `-date-modified` | Show modification date |
| `-date-created` | Show creation date |
| `-extension` | Show file extension |
| `-path <path>` | Search within path (includes subfolders) |
| `-parent-path <path>` | Search in path (no subfolders) |
| `-sort-size-descending` | Sort by size (largest first) |
| `-sort-date-modified-descending` | Sort by date (newest first) |
| `-sort-name-ascending` | Sort by name (A-Z) |
| `-regex` | Enable regex mode |
| `-i` | Case sensitive |
| `-w` | Whole word match |
| `-p` | Match full path |
| `-get-result-count` | Print only result count |
| `-get-total-size` | Print only total size |
| `-export-json <file>` | Export results to JSON file |
| `-export-csv <file>` | Export to CSV |
| `-export-txt <file>` | Export to plain text |
| `-highlight` | Highlight matched text |
| `-no-header` | Omit header row (CSV/TSV) |

## JSON Output

```bash
# With metadata
es.exe -json -size -date-modified -date-created -extension "report"
# [{"filename":"C:\\path\\file.txt","size":12345,"date_modified":133572776652382586,...}]
```

> `date_modified` is Windows FILETIME (100-nanosecond intervals since 1601-01-01). Convert: `datetime(1601,1,1) + timedelta(microseconds=filetime/10)`

## Common Patterns

```bash
# Large files eating disk space
es.exe -n 50 -sort-size-descending -size "size:>100mb"

# Recently modified in project
es.exe -path "C:\Projects\myapp" -date-modified -sort-date-modified-descending -n 20 "ext:py;js;ts"

# Duplicate large files (wasted space)
es.exe "dupe: sizedupe: size:>100mb"

# Empty folders
es.exe "empty:"

# Find .env files (security check)
es.exe -path "C:\Projects" ".env ext:env"

# Content search (ALWAYS combine with filters first — content search is very slow)
es.exe "ext:log dm:today content:ERROR"

# Find files with non-ASCII names
es.exe -regex "[^\x00-\x7f]"

# Count results before full output
es.exe -get-result-count "*.py"

# Export full listing to CSV
es.exe -export-csv "files.csv" -size -date-modified -no-header "ext:py"
```

## Best Practices

1. Always use `-n` to limit results for broad searches
2. Use `-json` for programmatic processing (avoids encoding issues)
3. Quote paths with spaces: `es.exe -path "C:\Program Files" "*.exe"`
4. Use `-get-result-count` to check result volume before full output
5. For large exports, use `-export-json` to write directly to file
6. Combine filters before `content:` searches — content is not indexed

## Error Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 4 | Missing expected argument |
| 5 | Failed to create export file |
| 6 | Unknown switch |
| 7 | Failed to send IPC query |
| 8 | Everything not running — start Everything.exe first |
| 9 | No results found (only with `-no-result-error`) |
