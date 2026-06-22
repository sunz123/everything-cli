# Everything Search Syntax Reference

Complete reference for Everything's search query language. These operators and functions go directly into the search text argument, not as CLI flags.

## Boolean Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| ` ` (space) | AND | `report 2024` — files containing both "report" and "2024" |
| `\|` | OR | `report\|invoice` — files containing "report" or "invoice" |
| `!` | NOT | `report !temp` — files with "report" but not "temp" |
| `< >` | Grouping | `<a\|b> !c` — (a or b) and not c |
| `" "` | Exact phrase | `"annual report"` — exact match |

### Grouping Examples

```
# Files containing (report OR invoice) AND NOT temp
<report|invoice> !temp

# PDF or DOCX files modified today
<ext:pdf|ext:docx> dm:today
```

## Wildcards

| Wildcard | Meaning |
|----------|---------|
| `*` | Zero or more characters |
| `?` | Single character |

```
*.mp3               # All MP3 files
report??.docx       # report01.docx, reportAB.docx, etc.
```

> By default, wildcards match the **entire** filename. Toggle with `wfn:` / `nowfn:` modifier.

## Regular Expressions

Enable with `-regex` flag or `regex:` prefix. When regex is active, all other search syntax is disabled.

| Syntax | Meaning |
|--------|---------|
| `a\|b` | a or b |
| `.` | Any single character |
| `[abc]` | Any of a, b, c |
| `[^abc]` | None of a, b, c |
| `[a-z]` | Range a to z |
| `^` | Start of filename |
| `$` | End of filename |
| `*` | Zero or more of preceding |
| `+` | One or more of preceding |
| `?` | Zero or one of preceding |
| `{n}` | Exactly n times |
| `{n,}` | n or more times |
| `{n,m}` | n to m times |
| `\` | Escape next character |

### Regex Examples

```
regex:^[A-C]         # Filename starts with A, B, or C
regex:\d{4}          # Filename contains 4 consecutive digits
regex:[^\x00-\x7f]   # Filename contains non-ASCII characters
```

## Search Functions

### Comparison Operators (for functions)

All functions support these comparison styles:

| Syntax | Meaning |
|--------|---------|
| `function:value` | Equal to value |
| `function:=value` | Equal to value |
| `function:>value` | Greater than value |
| `function:>=value` | Greater than or equal |
| `function:<value` | Less than value |
| `function:<=value` | Less than or equal |
| `function:start..end` | Between start and end |
| `function:start-end` | Between start and end |

---

### Date Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `datemodified:<date>` | `dm:<date>` | Last modified date |
| `datecreated:<date>` | `dc:<date>` | Creation date |
| `dateaccessed:<date>` | `da:<date>` | Last access date |
| `daterun:<date>` | `dr:<date>` | Last run date |
| `recentchange:<date>` | `rc:<date>` | Recent change date |

#### Date Constants

| Constant | Meaning |
|----------|---------|
| `today` | Today |
| `yesterday` | Yesterday |
| `thisweek` | This week |
| `lastweek` | Last week |
| `thismonth` | This month |
| `lastmonth` | Last month |
| `thisyear` | This year |
| `lastyear` | Last year |
| `last2weeks` | Last 2 weeks |
| `last3months` | Last 3 months |
| `last5hours` | Last 5 hours |
| `last10minutes` | Last 10 minutes |

**Full pattern**: `<last\|past\|prev\|coming\|next><N><hours\|minutes\|weeks\|months\|years>`

#### Month/Day Names

`january` through `december` (or `jan` through `dec`), `monday` through `sunday` (or `mon` through `sun`).

#### Date Formats

| Format | Example |
|--------|---------|
| ISO | `2024-08-15` or `2024-08-15T14:30` |
| Compact | `20240815` |
| Locale-dependent | `8/15/2024` or `15/8/2024` |
| Year only | `2024` |
| Range | `2024-01-01..2024-12-31` |

### Size Function

| Function | Description |
|----------|-------------|
| `size:<size>` | File size in bytes |

#### Size Units

| Unit | Meaning |
|------|---------|
| (none) | Bytes |
| `kb` | Kilobytes |
| `mb` | Megabytes |
| `gb` | Gigabytes |
| `tb` | Terabytes |

#### Size Constants

| Constant | Range |
|----------|-------|
| `empty` | 0 bytes |
| `tiny` | 0 KB < s <= 10 KB |
| `small` | 10 KB < s <= 100 KB |
| `medium` | 100 KB < s <= 1 MB |
| `large` | 1 MB < s <= 16 MB |
| `huge` | 16 MB < s <= 128 MB |
| `gigantic` | s > 128 MB |
| `unknown` | Unknown size |

### Path and Folder Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `parent:<path>` | `infolder:<path>` | Search in specified folder (no subfolders) |
| `depth:<n>` | `parents:<n>` | Files at specified folder depth |
| `root:` | | Files/folders with no parent |
| `empty:` | | Empty folders |
| `child:<filename>` | | Folders containing matching child |
| `childcount:<n>` | | Folders with n children |
| `childfilecount:<n>` | | Folders with n files |
| `childfoldercount:<n>` | | Folders with n subfolders |
| `shell:<name>` | | Known shell folder (e.g. `shell:desktop`) |

### Extension and Type Functions

| Function | Description |
|----------|-------------|
| `ext:<list>` | Match extensions (semicolon-separated) |
| `type:<type>` | Match file type description |
| `filelist:<list>` | Match pipe-separated filename list |
| `file:` / `files:` | Files only |
| `folder:` / `folders:` | Folders only |

### Attribute Function

| Function | Description |
|----------|-------------|
| `attrib:<attrs>` | Match file attributes |

**Attribute constants**: `R` (readonly), `H` (hidden), `S` (system), `D` (directory), `A` (archive), `V` (device), `N` (normal), `T` (temporary), `P` (sparse), `L` (reparse point), `C` (compressed), `O` (offline), `I` (not indexed), `E` (encrypted)

Prefix with `-` to exclude: `attrib:-H` (not hidden)

### Filename Functions

| Function | Description |
|----------|-------------|
| `len:<n>` | Filename length equals n |
| `startwith:<text>` | Filename starts with text |
| `endwith:<text>` | Filename (with ext) ends with text |

### Content Search Functions

> **WARNING**: Content search is very slow. Files are not content-indexed. Always combine with other filters.

| Function | Description |
|----------|-------------|
| `content:<text>` | Search file content (auto-detect encoding) |
| `ansicontent:<text>` | Treat content as ANSI |
| `utf8content:<text>` | Treat content as UTF-8 |
| `utf16content:<text>` | Treat content as UTF-16 LE |
| `utf16becontent:<text>` | Treat content as UTF-16 BE |

### Duplicate Functions

| Function | Description |
|----------|-------------|
| `dupe:` | Same filename |
| `namepartdupe:` | Same name (without extension) |
| `sizedupe:` | Same size |
| `attribdupe:` | Same attributes |
| `dmdupe:` | Same modified date |
| `dcdupe:` | Same created date |
| `dadupe:` | Same accessed date |

> Duplicates are found across the **entire index**, not just current results.

### Run Count Functions

| Function | Description |
|----------|-------------|
| `runcount:<n>` | Files run n times from Everything |
| `daterun:<date>` | Files last run on date |

### Other Functions

| Function | Description |
|----------|-------------|
| `count:<max>` | Limit results to max |
| `frn:<list>` | File reference numbers |

### ID3/FLAC Tag Functions

> Not indexed. Slow. Only works on MP3 files.

| Function | Description |
|----------|-------------|
| `track:<n>` | Track number |
| `year:<n>` | Year |
| `title:<text>` | Song title |
| `artist:<text>` | Artist |
| `album:<text>` | Album |
| `genre:<text>` | Genre |

### Image Functions

> Not indexed. Slow. Works on JPG, PNG, GIF, BMP.

| Function | Description |
|----------|-------------|
| `width:<n>` | Image width in pixels |
| `height:<n>` | Image height in pixels |
| `dimensions:<WxH>` | Width x Height |
| `orientation:<type>` | `landscape` or `portrait` |
| `bitdepth:<n>` | Bits per pixel |

---

## Modifiers

Apply to individual search terms:

| Modifier | Description |
|----------|-------------|
| `case:` / `nocase:` | Match / ignore case |
| `wholeword:` / `ww:` / `nowholeword:` | Match / don't match whole word |
| `path:` / `nopath:` | Match / don't match full path |
| `regex:` / `noregex:` | Enable / disable regex |
| `wfn:` / `wholefilename:` / `nowfn:` | Match whole filename |
| `wildcards:` / `nowildcards:` | Enable / disable wildcards |
| `ascii:` / `noascii:` | Fast ASCII comparison |
| `diacritics:` / `nodiacritics:` | Match / ignore accents |
| `file:` / `folder:` | Files only / folders only |

```
# Case-sensitive search for "ABC" only
case:ABC

# Match path, not just filename
path:Documents
```

---

## Macros (Built-in)

| Macro | Description |
|-------|-------------|
| `audio:` | Audio files (mp3, wav, flac, etc.) |
| `zip:` | Archive files (zip, 7z, rar, tar, etc.) |
| `doc:` | Document files (doc, docx, pdf, txt, etc.) |
| `exe:` | Executable files (exe, msi, bat, etc.) |
| `pic:` | Image files (jpg, png, gif, bmp, etc.) |
| `video:` | Video files (mp4, avi, mkv, mov, etc.) |
| `quot:` | Literal `"` |
| `apos:` | Literal `'` |
| `amp:` | Literal `&` |
| `lt:` | Literal `<` |
| `gt:` | Literal `>` |

---

## Drive and Path Prefixes

```
d:                    # Limit to D: drive
d:\music\             # Limit to D:\music\ folder (note trailing backslash)
c:\windows\ *.log     # Logs in C:\windows\
d:\|e:\ *.mp4         # MP4 files on D: or E: drive
```

> Paths with spaces must be quoted: `"c:\program files\"`
