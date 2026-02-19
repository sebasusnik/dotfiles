# 🤖 AI Integration Guide

This setup provides a **dual AI architecture** for different use cases:

1. **External AI** (Claude Code/OpenCode in tmux) - Deep reasoning, complex tasks
2. **Inline AI** (CodeCompanion in Neovim) - Quick completions, refactoring, explanations

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│  Carril A: External AI (Deep Reasoning)                 │
│  └── tmux right pane + OpenCode/Claude                  │
│  └── <leader>a* bindings                                │
│  └── Best for: Complex tasks, architecture, debugging   │
│                                                         │
│  Carril B: Inline AI (Quick Tasks)                      │
│  └── CodeCompanion inside Neovim                        │
│  └── <leader>c* bindings                                │
│  └── Best for: Completions, refactoring, quick fixes    │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 Configuration

### Credentials (in `~/.zshenv` - NOT tracked by git)

Create `~/.zshenv` with your AI provider credentials:

```bash
# AI Provider Configuration (OpenAI-compatible)
# You can use different API keys for terminal vs Neovim

# For terminal tools (llm, mods) - uses lite models
export AI_LITE_API_KEY="your-api-key-for-terminal"

# For Neovim (CodeCompanion) - uses plus models
export AI_PLUS_API_KEY="your-api-key-for-neovim"

# Common settings
export AI_BASE_URL="https://api.moonshot.ai/v1"
export AI_MODEL_LITE="kimi-lite"      # Fast/cheap for simple tasks
export AI_MODEL_PLUS="kimi-plus"      # Strong for code/complex tasks

# Backwards compatibility
export OPENAI_API_KEY="$AI_LITE_API_KEY"
export OPENAI_BASE_URL="$AI_BASE_URL"
```

**Note:** You can use the same API key for both by setting them to the same value, or use different keys/providers for terminal tools vs Neovim.

**Note:** The install script can create this file for you with `./install.sh`

---

## 🤖 Carril A: External AI (OpenCode/Claude)

Full AI integration via tmux using file references `@file#L10-20`.

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

---

## 🧠 Carril B: Inline AI (CodeCompanion)

Copilot-like AI directly inside Neovim using CodeCompanion.

### Keybindings
```
<leader>cc      → AI Actions menu
<leader>ct      → Toggle AI Chat panel
<leader>ce      → Explain selected code (visual mode)
<leader>cf      → Fix selected code (visual mode)
<leader>cr      → Refactor selected code (visual mode)
<C-l>           → Trigger inline completion (insert mode)
```

### Usage Examples

**Get inline completions:**
```
1. Start typing code
2. Press <C-l> when you want AI suggestions
3. Accept with <C-a>, reject with <C-r>
```

**Explain code:**
```
1. Select code in visual mode (V)
2. Press <leader>ce
3. AI explains the code in the chat panel
```

**Fix code:**
```
1. Select problematic code
2. Press <leader>cf
3. AI suggests fixes
```

**Refactor code:**
```
1. Select code to refactor
2. Press <leader>cr
3. AI provides refactored version
```

---

## 💻 Terminal AI Tools

### llm - Quick command lookup

```bash
# Get shell commands
$ cmd? "extract a tar.zst file"
tar --zstd -xvf filename.tar.zst

# Get explanations
$ ai? "what is docker compose"
```

### mods - Analyze command output

```bash
# Analyze logs
$ cat error.log | mods "summarize the error in 3 lines"

# Analyze history
$ history | tail -n 100 | mods "find the docker command I used"

# Use plus model for complex analysis
$ MODS_MODEL="$AI_MODEL_PLUS" cat stacktrace.log | mods "explain the root cause"
```

---

## ✅ Textobjects (Useful for both)

Treesitter text objects work for selecting code before sending to AI:

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

---

## 🎯 Summary: When to use what?

| Task | Tool | Binding | API Key | Model |
|------|------|---------|---------|-------|
| Complex architecture | OpenCode/Claude | `<leader>a*` | - | - |
| Debug complex issues | OpenCode/Claude | `<leader>a*` | - | - |
| Send large code blocks | OpenCode/Claude | `<leader>a*` | - | - |
| Quick completions | CodeCompanion | `<C-l>` | AI_PLUS_API_KEY | AI_MODEL_PLUS |
| Explain code | CodeCompanion | `<leader>ce` | AI_PLUS_API_KEY | AI_MODEL_PLUS |
| Fix code | CodeCompanion | `<leader>cf` | AI_PLUS_API_KEY | AI_MODEL_PLUS |
| Refactor | CodeCompanion | `<leader>cr` | AI_PLUS_API_KEY | AI_MODEL_PLUS |
| Remember commands | llm | `cmd?` | AI_LITE_API_KEY | AI_MODEL_LITE |
| Analyze logs | mods | `mods` | AI_LITE_API_KEY | AI_MODEL_LITE |

**Cost optimization:**
- Use **lite** models for quick lookups (cmd?, simple mods queries) - uses `AI_LITE_API_KEY`
- Use **plus** models for code generation (CodeCompanion, complex analysis) - uses `AI_PLUS_API_KEY`
- **Pro tip:** You can use different providers/accounts for each key to track costs separately

---

## 🚀 Complete workflow

1. **For deep work:**
   ```
   dev                     # Start tmux + nvim + OpenCode
   <leader>af              # Send function to AI (external)
   ```

2. **For quick fixes:**
   ```
   nvim file.ts            # Open file
   Select code + <leader>cf   # Fix with CodeCompanion (inline)
   ```

3. **For command help:**
   ```
   cmd? "convert mp4 to gif with ffmpeg"
   ```

4. **For log analysis:**
   ```
   cat error.log | mods "what's the error?"
   ```
