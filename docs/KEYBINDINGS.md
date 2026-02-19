# ⌨️ Keybindings Cheatsheet - NVIM ZEN

> All keyboard shortcuts for my Neovim configuration

## 📁 Navigation and Files

### Neo-tree (File Explorer)
```
<leader>e       Toggle Neo-tree
<leader>o       Focus Neo-tree
-               Reveal current file in Neo-tree

Inside Neo-tree:
<CR>            Open file (on file) / Set as root (on directory)
o               Toggle folder expand/collapse
-               Go up one level
```

### Telescope (Fuzzy Search)
```
<leader>f       Find files
<leader>g       Search text in project (live grep)
<leader>/       Search in current file
<leader>b       Search open buffers
<leader>*       Search word under cursor in project

Inside Telescope:
<Esc>           Close
<C-j>           Next result
<C-k>           Previous result
```

## ✏️ Editing Enhancements

### Autopairs
```
( [ { " '    Auto-closes the pair as you type
```

### Surround (nvim-surround)
```
cs"'         Change surrounding " to '  →  "text" → 'text'
cs({         Change surrounding ( to {  →  (text) → { text }
ds"          Delete surrounding "       →  "text" → text
ysiw"        Surround word with "       →  text → "text"
yss"         Surround entire line with "
S"           Surround visual selection with " (visual mode)
```

### Comments (gcc / gc)
```
gcc          Toggle comment on current line
gc           Toggle comment on selection (visual mode)
gcap         Toggle comment on paragraph
```
Note: JSX/TSX-aware — uses `{/* */}` inside JSX, `//` elsewhere.

### Sessions (persistence.nvim)
```
<leader>xr   Restore session for current directory
<leader>xq   Stop saving session
```

## 💾 Basics

### File (native Vim commands)
```
:w              Save
:q              Quit
:q!             Quit without saving
:x / :wq        Save and quit
```

### Buffers (open files)
```
<Space><Space>  Toggle between last 2 files (fastest)
<leader>b       List all open files (Telescope)
<leader>q       Close current file
```

### Splits (view two files side by side)
```
<Space>wv       Open vertical split
<Space>ws       Open horizontal split
<Space>wh       Go to left split
<Space>wl       Go to right split
<Space>wj       Go to split below
<Space>wk       Go to split above
<Space>wq       Close current split

From Neo-tree:
<C-v>           Open file in vertical split
<C-x>           Open file in horizontal split
```

**Workflow - two files side by side:**
```
1. Open first file normally (<Space>f or <CR> in Neo-tree)
2. <Space>wv    Open vertical split
3. <Space>f     Find and open second file in the new split
4. <Space>wh/wl Switch between the two sides
```

## 🤖 AI Integration (Dual Architecture)

### External AI: OpenCode/Claude (in tmux right pane)
Send code to AI tool running in the right tmux pane:
```
<leader>ac      Send visual selection
<leader>aa      Send entire file
<leader>af      Send function/type/enum where cursor is ⭐
<leader>at      Send type/interface where cursor is (obsolete, use af)
<leader>al      Send specific lines (prompts for range)
<leader>ad      Send git diff of file
<leader>ao      Send project structure
```

**Note:** `<leader>af` is now smart - automatically detects if you're in a function, type, interface or enum!

### Inline AI: Minuet (ghost text completions)
Ghost text suggestions while you type, powered by AI:
```
<Tab>           Accept full suggestion (insert mode)
<S-Tab>         Dismiss suggestion
<A-a>           Accept one line only
<A-[>           Previous suggestion
<A-]>           Next suggestion

<leader>ae      Enable Minuet
<leader>at      Toggle Minuet on/off
<leader>am      Change AI model interactively
```

## 🖥️ Terminal AI Commands

### llm - AI for terminal commands (uses AI_LITE_API_KEY)
```
cmd? "description"    Get shell command from description
ai? "question"        Get quick AI answer
```

**Examples:**
```bash
cmd? "extract tar.zst file"           → tar --zstd -xvf file.tar.zst
cmd? "find files modified today"      → find . -type f -mtime -1
ai? "what is docker compose"          → Docker Compose is a tool...
```

### mods - AI for pipeline analysis (uses AI_LITE_API_KEY)
```
cat file | mods "prompt"              Analyze command output with AI
MODS_MODEL="$AI_MODEL_PLUS" cat file | mods "prompt"   Use strong model
```

**Examples:**
```bash
history | tail -n 50 | mods "find the git rebase command"
cat error.log | mods "summarize this error"
MODS_MODEL="$AI_MODEL_PLUS" cat stacktrace.log | mods "explain root cause"
```

**Note:** Terminal tools use `AI_LITE_API_KEY`. For CodeCompanion in Neovim, use `AI_PLUS_API_KEY`.

## 🎯 Textobjects (Treesitter)

### Selection
```
vaf / vif       Select function/type/enum/interface (outer/inner) ⭐
vac / vic       Select class (outer/inner)
vaa / via       Select parameter (outer/inner)
vai / vii       Select conditional (outer/inner)
val / vil       Select loop (outer/inner)
vab / vib       Select block (outer/inner)
va/             Select comment
```

**Note:** `vaf` is smart - works for both functions and types, interfaces and enums in TypeScript!

### Navigation between declarations (Sticky Mode 🔥)
```
<leader>n + ] / [   Navigate declarations: functions, types, variables, etc.
<Esc>               Exit sticky mode
```

**Sticky Mode 🔥:** Press `Space + n` once, then `j` or `k` repeatedly to jump between any declaration (functions, types, interfaces, enums, variables)!

### Standard navigation (without sticky)
```
]m / [m         Next/previous declaration (functions, types, variables, etc.)
]c / [c         Next/previous class
]l / [l         Next/previous loop
]i / [i         Next/previous conditional
]b / [b         Next/previous block
]a / [a         Next/previous parameter
```

### Swap (Exchange)
```
<leader>sn      Swap with next parameter
<leader>sp      Swap with previous parameter
```

## 📝 LSP (Language Server)

### Code navigation
```
gd              Go to definition
K               Hover (documentation)
<leader>rn      Rename symbol
<leader>ca      Code actions
```

## 🔍 Visual Selection

### Incremental (Treesitter)
```
<CR>            Start/expand selection
<BS>            Shrink selection
```

### Useful
```
V               Visual line mode
v               Visual character mode
<C-v>           Visual block mode
gv              Restore last visual selection
<Esc>           Exit visual mode (saves marks)
```

## 🎨 Workflow: Select and send to AI

### Option 1: Manual selection
```
1. V            Start visual selection
2. jjj          Select lines
3. <leader>ac   Send to AI
```

### Option 2: With textobjects
```
1. vaf          Select function
2. <Esc>        Exit (marks persist 3 sec)
3. Scroll to review
4. gv           Restore selection
5. <leader>ac   Send to AI
```

### Option 3: Direct
```
<leader>af      Send function directly (without selecting)
<leader>at      Send type/interface directly
```

## 🎨 Visual Feedback

- **Active selection**: Gray color `#4a4a4a`
- **Marks after exiting**: Subtle gray color `#3a3a3a` (lasts 3 seconds)
- Allows scrolling and reviewing before sending to AI

## 🔧 Git (useful commands)

### In Neovim (Gitsigns)
```
]h / [h         Next/previous change (hunk)
<leader>hp      Preview change
<leader>hs      Stage change
<leader>hr      Reset change (discard)
```

### In terminal (native git)
```
git status      View repo status
git add .       Add all changes
git commit -m   Commit with message
git push        Push changes
git pull        Pull changes
git log         View history
git diff        View unstaged changes
git diff --cached  View staged changes
```

## 📦 Tmux (Terminal multiplexer)

**Note:** Your prefix key is `Ctrl+a` (not the default `Ctrl+b`)

### Copy mode (selection and copying)
```
Ctrl+a [        Enter copy mode
Ctrl+a PgUp     Enter copy mode (alternative)

Inside copy mode (vi-mode):
h j k l         Move (vim keys)
w / b           Next/previous word
0 / $           Start/end of line
g / G           Start/end of buffer
/text           Search forward
?text           Search backward
n / N           Next/previous result

v               Start selection (vi-style)
y / Enter       Copy selection and exit
q / Esc         Exit without copying

Ctrl+a ]        Paste copied text
```

### Workflow: Copy from tmux
```
1. Ctrl+a [     Enter copy mode
2. Navigate with vim keys (h j k l)
3. v            Start selection (vi-style)
4. Select with movement
5. y or Enter   Copy to clipboard
6. Cmd+V        Paste in any application
```

### Splits and panes
```
Ctrl+a |        Vertical split (left/right)
Ctrl+a -        Horizontal split (top/bottom)
Ctrl+h/j/k/l    Navigate between panes (no prefix!)
Ctrl+a x        Close current pane
```

### Other useful
```
Ctrl+a c        Create new window
Ctrl+a n        Next window
Ctrl+a p        Previous window
Ctrl+a d        Detach from session
Ctrl+a r        Reload tmux.conf
```

## 🎯 Movement (Native Vim)

### Basic movement
```
h j k l         Left, Down, Up, Right
w / b           Next/previous word
e               End of word
0 / $           Start/end of line
gg / G          Start/end of file
{ / }           Previous/next paragraph
<C-d> / <C-u>   Half page down/up
<C-f> / <C-b>   Full page down/up
zz              Center cursor on screen
```

### Search and jump
```
/text           Search forward
?text           Search backward
n / N           Next/previous result
*               Search word under cursor
f{char}         Jump to character in line
t{char}         Jump before character
; / ,           Repeat f/t forward/backward
```

### Marks
```
m{a-z}          Create local mark
m{A-Z}          Create global mark
'{a-z}          Jump to mark
''              Jump to previous position
`.              Jump to last change
```

## ✏️ Editing (Native Vim)

### Change/Delete
```
c               Change (change + insert)
d               Delete
y               Yank (copy)
p / P           Paste after/before
x               Delete character
r{char}         Replace character
u               Undo
<C-r>           Redo
.               Repeat last command
```

### Operator + Motion
```
ciw             Change inner word
di"             Delete inside quotes
ya{             Yank around brackets
cit             Change inside tag
```

### Search and replace
```
:s/old/new      Replace in current line
:s/old/new/g    Replace all in line
:%s/old/new/g   Replace in entire file
:%s/old/new/gc  Replace with confirmation
```

### Multiple lines
```
V               Visual line
<C-v>           Visual block
J               Join lines
>               Indent
<               Un-indent
```

### Move lines (<leader>m + j/k - Sticky Mode)
```
<leader>m       Enter "move" mode (sticky)
j               Move line/selection down (repeat without Space)
k               Move line/selection up (repeat without Space)
<Esc>           Exit sticky mode
```

**Note:** "Sticky" mode = press `Space + m` once, then just `j j j` or `k k k` repeatedly.

**Workflow:**
```
1. vaf           Select function
2. <leader>m     Enter move mode (exits visual, saves positions)
3. j j j j       Move down several times (without pressing Space)
4. <Esc>         Exit sticky mode
```

## 📋 Tips

- `<leader>` = `Space`
- Textobjects work in visual mode (`v`) and operator-pending (`d`, `y`, `c`)
- Examples: `daf` (delete function), `yaf` (yank function), `cif` (change inner function)
- Visual marks (`'<` and `'>`) are saved when exiting visual mode
- **Vim philosophy:** operator + motion (e.g., `d` + `iw` = delete inner word)
- Combine textobjects with operators: `daf` (delete a function), `yip` (yank inner paragraph)
