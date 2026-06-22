# Everything CLI Options Reference

Complete reference for all `es.exe` command-line options.

## Usage

```
es.exe [options] <search text>
```

## Search Options

| Option | Description |
|--------|-------------|
| `-r`, `-regex` | Use regular expressions |
| `-i`, `-case` | Match case |
| `-w`, `-ww`, `-whole-word`, `-whole-words` | Match whole words |
| `-p`, `-match-path` | Match full path and filename |
| `-a`, `-diacritics` | Match diacritical marks |
| `-o <offset>`, `-offset <offset>` | Skip first N results |
| `-n <num>`, `-max-results <num>` | Limit to N results |
| `-path <path>` | Search in path (includes subfolders) |
| `-parent-path <path>` | Search in path (no subfolders) |
| `-parent <path>` | Search files with specified parent path |

### DIR-style Attribute Filters

| Option | Description |
|--------|-------------|
| `/ad` | Directories only |
| `/a-d` | Files only |
| `/a[RHSDAVNTPLCOIE]` | Filter by attributes |
| `/a-[RHSAD...]` | Exclude attributes |

**Attribute flags:**

| Flag | Meaning |
|------|---------|
| `R` | Read-only |
| `H` | Hidden |
| `S` | System |
| `D` | Directory |
| `A` | Archive |
| `V` | Device |
| `N` | Normal |
| `T` | Temporary |
| `P` | Sparse file |
| `L` | Reparse point |
| `C` | Compressed |
| `O` | Offline |
| `I` | Not content indexed |
| `E` | Encrypted |

## Sorting Options

### Named Sort

| Option | Description |
|--------|-------------|
| `-s` | Sort by full path |
| `-sort <name>[-ascending\|-descending]` | Set sort field and direction |
| `-sort-<name>[-ascending\|-descending]` | Alternative syntax |
| `-sort-ascending` | Ascending (applies to current sort) |
| `-sort-descending` | Descending (applies to current sort) |

**Sort fields:** `name`, `path`, `size`, `extension`, `date-created`, `date-modified`, `date-accessed`, `attributes`, `file-list-file-name`, `run-count`, `date-recently-changed`, `date-run`

```bash
# Sort by size, largest first
es.exe -sort-size-descending -size "*.mp4"

# Sort by date modified, newest first
es.exe -sort-date-modified-descending -date-modified "*"
```

### DIR-style Sort

| Option | Description |
|--------|-------------|
| `/on`, `/o-n` | By name (asc/desc) |
| `/os`, `/o-s` | By size (asc/desc) |
| `/oe`, `/o-e` | By extension (asc/desc) |
| `/od`, `/o-d` | By date modified (asc/desc) |

## Display Options

### Column Controls

| Option | Description |
|--------|-------------|
| `-name` | Show name column |
| `-path-column` | Show path column |
| `-full-path-and-name`, `-filename-column` | Show full path + name |
| `-extension`, `-ext` | Show extension column |
| `-size` | Show size column |
| `-date-created`, `-dc` | Show creation date |
| `-date-modified`, `-dm` | Show modification date |
| `-date-accessed`, `-da` | Show access date |
| `-attributes`, `-attribs`, `-attrib` | Show attributes |
| `-file-list-file-name` | Show file list filename |
| `-run-count` | Show run count |
| `-date-run` | Show run date |
| `-date-recently-changed`, `-rc` | Show recent change date |

> Use `no-` prefix to disable a column: `-no-size`, `-no-name`, etc.

### Highlighting

| Option | Description |
|--------|-------------|
| `-highlight` | Highlight matched text |
| `-highlight-color <color>` | Set highlight color (0x00-0xFF) |

### Output Format

| Option | Description |
|--------|-------------|
| `-csv` | CSV format |
| `-efu` | EFU format (Everything file list) |
| `-json` | JSON format |
| `-m3u` | M3U playlist format |
| `-m3u8` | M3U8 playlist format |
| `-tsv` | TSV format |
| `-txt` | Plain text format |

### Number/Date Formatting

| Option | Description |
|--------|-------------|
| `-size-format <n>` | 0=auto, 1=bytes, 2=KB, 3=MB |
| `-date-format <n>` | 0=auto, 1=ISO-8601, 2=FILETIME, 3=ISO-8601 UTC |
| `-no-digit-grouping` | No comma separators in numbers |
| `-size-leading-zero` | Pad size with leading zeros |
| `-run-count-leading-zero` | Pad run count with leading zeros |
| `-double-quote` | Wrap paths in double quotes |

### Color Settings

Each column has its own color option (value: 0x00-0xFF):

```
-filename-color <color>
-name-color <color>
-path-color <color>
-extension-color <color>
-size-color <color>
-dc-color <color>
-dm-color <color>
-da-color <color>
-attributes-color <color>
-file-list-filename-color <color>
-run-count-color <color>
-date-run-color <color>
-rc-color <color>
```

### Column Width Settings

Each column has a width option (value: 0-200):

```
-filename-width <width>
-name-width <width>
-path-width <width>
-extension-width <width>
-size-width <width>
-dc-width <width>
-dm-width <width>
-da-width <width>
-attributes-width <width>
-file-list-filename-width <width>
-run-count-width <width>
-date-run-width <width>
-rc-width <width>
```

## Export Options

| Option | Description |
|--------|-------------|
| `-export-csv <file>` | Export results to CSV |
| `-export-efu <file>` | Export to EFU format |
| `-export-json <file>` | Export to JSON |
| `-export-m3u <file>` | Export to M3U playlist |
| `-export-m3u8 <file>` | Export to M3U8 playlist |
| `-export-tsv <file>` | Export to TSV |
| `-export-txt <file>` | Export to plain text |
| `-no-header` | Omit header row (CSV, EFU, TSV) |
| `-utf8-bom` | Prepend UTF-8 BOM to export file |

```bash
# Export with metadata to CSV
es.exe -export-csv "results.csv" -size -date-modified -extension "report"

# Export JSON with no limit
es.exe -export-json "all_files.json" -size -date-modified -date-created "ext:py"

# Export plain text (one path per line, no header)
es.exe -no-header -export-txt "file_list.txt" "*.jpg"
```

## General Options

| Option | Description |
|--------|-------------|
| `-h`, `-help` | Show help |
| `-instance <name>` | Connect to specific Everything instance |
| `-ipc1`, `-ipc2` | Use IPC version 1 or 2 |
| `-argv` | Use CommandLineToArgvW parser (for PowerShell 7+) |
| `-pause`, `-more` | Pause after each page |
| `-hide-empty-search-results` | Hide output when no results |
| `-empty-search-help` | Show help when no search text |
| `-timeout <ms>` | Timeout waiting for Everything database |
| `-no-result-error` | Set error level 9 when no results |

### Run Count Management

| Option | Description |
|--------|-------------|
| `-set-run-count <file> <count>` | Set run count for a file |
| `-inc-run-count <file>` | Increment run count for a file |
| `-get-run-count <file>` | Get run count for a file |

### Information Queries

| Option | Description |
|--------|-------------|
| `-get-result-count` | Print only the result count |
| `-get-total-size` | Print only total size of results |
| `-version` | Show ES version |
| `-get-everything-version` | Show Everything version |

### Settings and Database

| Option | Description |
|--------|-------------|
| `-save-settings` | Save current settings to ES config |
| `-clear-settings` | Clear saved settings |
| `-reindex` | Force reindex of Everything |
| `-save-db` | Save Everything database to disk |
| `-exit` | Exit Everything process |

## Option Format Notes

1. **Dash flexibility**: Internal dashes in option names are optional. `-nodigitgrouping` = `-no-digit-grouping`.
2. **Slash prefix**: Options work with `/` prefix too: `/ad`, `/on`.
3. **Disabling**: Prefix with `no-` to turn off: `-no-size`, `-no-highlight`.
4. **Quoting**: Wrap search text containing spaces or special chars in double quotes.
5. **Special chars in CMD**: Use `^` prefix or double quotes to escape `& | > < ^`.

## Error Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Register window class failed |
| 2 | Create listener window failed |
| 3 | Out of memory |
| 4 | Expected additional argument |
| 5 | Failed to create export output file |
| 6 | Unknown switch |
| 7 | Failed to send Everything IPC query |
| 8 | Everything not running — start Everything first |
| 9 | No results found (only with `-no-result-error`) |
