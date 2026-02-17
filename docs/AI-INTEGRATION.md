# 🤖 AI Integration (Claude Code + OpenCode)

Unified AI integration via tmux using file references `@file#L10-20`.

### Send code to AI
```
<leader>ac  → Send visual selection (most useful!)
<leader>aa  → Send complete file
<leader>af  → Send function where cursor is located
<leader>at  → Send type/interface where cursor is located
<leader>al  → Send specific lines (asks you for the range)
<leader>ad  → Send git diff
<leader>ao  → Send project structure (tree)
```

### Recommended workflow

**Option 1: Manual visual selection**
```
1. Place cursor at the start of the code
2. Press V for visual line mode
3. Select the lines you want (with j/k or numbers)
4. Press <leader>ac
5. AI receives: @src/file.ts#L10-25
6. Write your question in the AI
```

**Option 2: Send function/type automatically**
```
<leader>af → Sends the function where the cursor is located
<leader>at → Sends the type/interface where the cursor is located
```

**Option 3: Complete file**
```
<leader>aa → Sends the entire current file
```

**Option 4: Specific range**
```
<leader>al → Asks you for start/end
```

## Useful helpers
```
<leader>*   → Search word under cursor in project (Telescope)
```

**Note:** To select code use the textobjects directly:
- `vaf` / `vif` → Select function
- `vac` / `vic` → Select class
- `V` → Visual line selection

## ✅ Textobjects

Treesitter text objects are configured with manual keymaps:

**Selection:**
- `vaf` / `vif` → Select function (outer/inner)
- `vac` / `vic` → Select class (outer/inner)
- `vaa` / `via` → Select parameter (outer/inner)
- `vab` / `vib` → Select block (outer/inner)
- `va/` → Select comment

**Navigation:**
- `]m` / `[m` → Next/previous function
- `]c` / `[c` → Next/previous class
- `]a` / `[a` → Next/previous parameter

## 🎯 Summary

**What DOES work and is very useful:**
- Visual selection + `<leader>ac` → Perfect for any code
- `<leader>af` → Current function (with Treesitter)
- `<leader>at` → Current Type/Interface (with Treesitter)
- `<leader>aa` → Complete file
- `<leader>al` → Specific lines
- **Textobjects:** `vaf`, `]m`, `[m` → Now working!

**Complete workflow:**
1. Navigate with `]m` / `[m` between functions
2. Select with `vaf` the complete function (or use `<leader>af`)
3. Send to AI with `<leader>ac` (or directly `<leader>af`)
4. Write your question in the AI 🚀
