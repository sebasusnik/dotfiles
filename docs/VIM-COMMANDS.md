# Vim Commands Cheatsheet

> Commands you type after pressing `:` in normal mode.
> `<leader>` = Space

---

## 💾 Save & Quit

| Command | What it does |
|---------|-------------|
| `:w` | Save current file |
| `:w filename` | Save as new file |
| `:q` | Quit (fails if unsaved changes) |
| `:q!` | Quit and **discard** changes |
| `:wq` | Save and quit |
| `:x` | Save and quit (only writes if changed) |
| `:wqa` | Save all open files and quit |
| `:qa` | Quit all (fails if any unsaved) |
| `:qa!` | Quit all and discard all changes |

**Recommendation:** use `:x` instead of `:wq` — same thing but smarter (doesn't touch the file if nothing changed).

---

## 📂 Files & Buffers

| Command | What it does |
|---------|-------------|
| `:e filename` | Open file |
| `:e!` | Reload current file from disk |
| `:e .` | Open file explorer (netrw) |
| `:ls` | List all open buffers |
| `:b filename` | Switch to buffer by name |
| `:b2` | Switch to buffer #2 |
| `:bd` | Close current buffer |
| `:bd!` | Close buffer discarding changes |
| `:%bd` | Close all buffers |

---

## 🪟 Splits & Windows

| Command | What it does |
|---------|-------------|
| `:split` / `:sp` | Horizontal split |
| `:vsplit` / `:vs` | Vertical split |
| `:split filename` | Open file in horizontal split |
| `:vsplit filename` | Open file in vertical split |
| `:only` | Close all splits except current |
| `:resize 20` | Set current split height to 20 lines |
| `:vertical resize 80` | Set current split width to 80 cols |

---

## 🔍 Search & Replace

| Command | What it does |
|---------|-------------|
| `:s/old/new` | Replace first match in current line |
| `:s/old/new/g` | Replace all in current line |
| `:%s/old/new/g` | Replace all in entire file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:%s/old/new/gi` | Replace all case-insensitive |
| `:%s/\<word\>/new/g` | Replace whole word only |
| `:%s/old/new/gI` | Replace all case-sensitive |

**Visual range replace:** select lines with `V`, then `:s/old/new/g` applies only to selection.

---

## 📋 Marks

| Command | What it does |
|---------|-------------|
| `:marks` | List all marks |
| `:delmarks a` | Delete mark `a` |
| `:delmarks!` | Delete all lowercase marks |

---

## 🔢 Registers

| Command | What it does |
|---------|-------------|
| `:reg` | Show all registers |
| `:reg a` | Show register `a` |

**Paste from register in insert mode:** `<C-r>a` pastes register `a`.
**Yank to named register:** `"ayy` yanks current line to register `a`.

---

## 📼 Macros

| Command | What it does |
|---------|-------------|
| `qa` | Start recording macro into register `a` |
| `q` | Stop recording |
| `@a` | Run macro `a` |
| `@@` | Repeat last macro |
| `5@a` | Run macro `a` 5 times |
| `:reg a` | Inspect what's recorded in macro `a` |

---

## 🔧 Useful Misc

| Command | What it does |
|---------|-------------|
| `:noh` | Clear search highlight |
| `:set wrap` | Enable line wrap |
| `:set nowrap` | Disable line wrap |
| `:set number` | Show line numbers |
| `:sort` | Sort selected lines |
| `:sort!` | Sort in reverse |
| `:sort u` | Sort and remove duplicates |
| `:%y` | Yank (copy) entire file to clipboard |
| `:earlier 5m` | Undo all changes from last 5 minutes |
| `:later 5m` | Redo forward 5 minutes |

---

## 📡 LSP Commands

| Command | What it does |
|---------|-------------|
| `:LspInfo` | Show active LSP servers |
| `:LspRestart` | Restart LSP server |
| `:Mason` | Open Mason (install LSP servers) |

---

## 🌲 Treesitter

| Command | What it does |
|---------|-------------|
| `:TSInstall lua` | Install parser for language |
| `:TSUpdate` | Update all parsers |

---

## 💡 Tips

- **Repeat last `:` command** → press `@:` in normal mode
- **Command history** → press `:` then `<Up>/<Down>` to browse previous commands
- **Autocomplete commands** → press `<Tab>` after `:` to autocomplete
- **Run shell command** → `:!ls` runs `ls` in the shell
- **Pipe into buffer** → `:r !ls` inserts output of `ls` below cursor
