# Everything CLI — Practical Examples

Real-world usage patterns organized by scenario.

## Disk Space Analysis

### Find largest files on the system

```bash
es.exe -n 50 -sort-size-descending -size "size:>100mb"
```

### Find largest files of specific type

```bash
es.exe -n 30 -sort-size-descending -size "ext:mp4;mkv;avi size:>500mb"
```

### Find gigantically large files

```bash
es.exe -size "size:gigantic"
```

### Find duplicate large files (waste)

```bash
es.exe -size "dupe: sizedupe: size:>100mb"
```

## Recent File Discovery

### Files modified today

```bash
es.exe -date-modified -sort-date-modified-descending "dm:today"
```

### Recently created files in a project

```bash
es.exe -path "C:\Projects\myapp" -date-created -sort-date-created-descending -n 20 ""
```

### Python files modified this week

```bash
es.exe -date-modified "ext:py dm:thisweek"
```

### Config files changed in the last 3 hours

```bash
es.exe -date-modified "ext:json;yaml;yml;ini;env dm:last3hours"
```

## Project & Development

### Find all Python files in a project

```bash
es.exe -path "C:\Projects\myapp" "ext:py"
```

### Find all test files

```bash
es.exe -path "C:\Projects\myapp" "test* ext:py;js;ts"
```

### Find node_modules folders (disk hogs)

```bash
es.exe /ad "node_modules"
```

### Find .git directories

```bash
es.exe /ad -path "C:\Projects" ".git"
```

### Find all package.json files

```bash
es.exe "package.json ext:json" -path "C:\Projects"
```

### Find .env files (security check)

```bash
es.exe -path "C:\Projects" ".env ext:env"
```

### Find large git repos

```bash
es.exe /ad -size "node_modules size:>500mb"
```

## File Cleanup

### Find old log files

```bash
es.exe -size "ext:log dm:lastyear size:>10mb"
```

### Find temp files

```bash
es.exe "ext:tmp;temp *.tmp"
```

### Find empty folders

```bash
es.exe "empty:"
```

### Find files with no extension

```bash
es.exe "!."
```

### Find thumbnails/cache files

```bash
es.exe "thumbs.db ext:db"
es.exe "ext:cache"
```

## Content Search

> WARNING: Content search is slow. Always narrow with other filters first.

### Find error messages in today's logs

```bash
es.exe -n 50 "ext:log dm:today content:ERROR"
```

### Find a function definition across a project

```bash
es.exe -path "C:\Projects\myapp" "ext:py content:def main"
```

### Find a string in config files

```bash
es.exe -path "C:\Projects\myapp" "ext:json;yaml;yml;ini content:database_url"
```

## Media Management

### Find all video files over 1GB

```bash
es.exe -size -sort-size-descending "video: size:>1gb"
```

### Find all music files

```bash
es.exe "audio:"
```

### Find duplicate music files

```bash
es.exe "dupe: ext:mp3;flac;wav"
```

### Find large images

```bash
es.exe -size -sort-size-descending "pic: size:>10mb"
```

### Find screenshots

```bash
es.exe "Screenshot* ext:png"
```

## System Administration

### Find all .exe files in Downloads

```bash
es.exe -path "C:\Users\SunZ\Downloads" "ext:exe"
```

### Find all DLL files in System32 modified recently

```bash
es.exe -path "C:\Windows\System32" -date-modified "ext:dll dm:thismonth"
```

### Find hidden files in user profile

```bash
es.exe /aH -path "C:\Users\SunZ" ""
```

### Find system files

```bash
es.exe /aS ""
```

### Find all shortcuts (.lnk)

```bash
es.exe "ext:lnk"
```

## Batch Operations

### Export full file listing to CSV

```bash
es.exe -export-csv "all_py_files.csv" -size -date-modified -extension -no-header "ext:py"
```

### Export to JSON for processing

```bash
es.exe -export-json "results.json" -size -date-modified -date-created "report ext:pdf;docx"
```

### Get just the count

```bash
es.exe -get-result-count "ext:py"
```

### Get total size of all log files

```bash
es.exe -get-total-size "ext:log"
```

### Create a playlist from music files

```bash
es.exe -export-m3u "playlist.m3u" -sort-name-ascending "ext:mp3 path:C:\Music"
```

## Advanced Search Patterns

### Regex: find files with version numbers

```bash
es.exe -regex "[a-z]+[-_]?v?\d+\.\d+\.\d+"
```

### Regex: find files with dates in filename

```bash
es.exe -regex "\d{4}-\d{2}-\d{2}"
```

### Regex: find files with non-ASCII characters

```bash
es.exe -regex "[^\x00-\x7f]"
```

### Find files with long names

```bash
es.exe "len:>200"
```

### Find files created between specific dates

```bash
es.exe -date-created "dc:2024-01-01..2024-06-30"
```

### Nested folder search with depth

```bash
# Files exactly 3 levels deep in C:\Projects
es.exe -path "C:\Projects" "depth:3"
```

### Find files by multiple extensions

```bash
es.exe "ext:py;js;ts;vue;jsx;tsx"
```

### Complex boolean search

```bash
# Python or JS test files, but not in node_modules or .git
es.exe "<ext:py|ext:js> test !node_modules !.git"
```

## Tips for AI Assistants

### When searching for a user's file

1. Start broad, then narrow:
   ```bash
   es.exe -n 10 "report"           # See what's out there
   es.exe -n 10 "report ext:pdf"   # Narrow by type
   es.exe -n 10 "report ext:pdf dm:thismonth"  # Narrow by date
   ```

2. Use JSON when you need to parse results:
   ```bash
   es.exe -json -n 5 -size -date-modified "config ext:json"
   ```

3. Check result count before full output:
   ```bash
   es.exe -get-result-count "*.py"  # 5000? Maybe add filters
   ```

4. When path has spaces, always quote:
   ```bash
   es.exe -path "C:\Program Files" "*.exe"
   es.exe -path "C:\Users\SunZ\My Documents" "*.docx"
   ```

5. For PowerShell 7+, add `-argv` flag for better argument parsing:
   ```bash
   es.exe -argv -n 10 "report"
   ```

### Common pitfalls

- **Everything not running** → Error code 8. Start `Everything.exe` first.
- **No results** → Check if the drive is indexed in Everything settings.
- **Slow content search** → Always combine `content:` with `ext:`, `dm:`, or `path:` filters.
- **Non-ASCII garbled output** → Use `-json` or `-export-json` for clean encoding.
- **PowerShell pipe conflicts** → The `|` operator needs quoting or use `-argv`.
