# ⌨️ Keybindings Cheatsheet - NVIM ZEN

> All keyboard shortcuts for my Neovim configuration

## 📁 Navigation and Files

### Neo-tree (File Explorer)
```
<leader>e       Toggle Neo-tree
<leader>o       Focus Neo-tree
-               Reveal current file in Neo-tree

Inside Neo-tree:
<CR>            Open file / Enter folder
o               Toggle folder expand/collapse (without moving)
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

## 💾 Basics

### File (native Vim commands)
```
:w              Save
:q              Quit
:q!             Quit without saving
:x / :wq        Save and quit
```

### Windows (Splits)
```
<C-h>           Go to left panel
<C-l>           Go to right panel
<C-j>           Go to panel below
<C-k>           Go to panel above
```

## 🤖 AI Integration (Claude Code + OpenCode)

### Send code to AI
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
<TAB>           Expand by scope
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
