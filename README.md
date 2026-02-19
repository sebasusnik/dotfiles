# 🚀 Dotfiles - NVIM ZEN + AI Workflow

Minimalist and zen configuration for development with Neovim, Tmux, Claude Code/OpenCode, and Oh My Posh.

## 📦 Contents

- **Neovim** - Complete setup with LSP, autocompletion, and essential plugins
- **Tmux** - Configuration for workflow with Neovim + OpenCode
- **Zsh** - Shell configuration with Oh My Posh
- **Oh My Posh** - Custom terminal prompt
- **AI Tools** - llm, mods, and CodeCompanion for AI-powered workflow

## ✨ Features

### Neovim
- 🎨 LSP configured for TypeScript/JavaScript (typescript-tools)
- 🔍 Fuzzy finding with Telescope
- 📁 File explorer with native git colors (neo-tree)
- ✍️ Autocompletion with nvim-cmp
- 🎯 Treesitter for syntax highlighting
- 🔧 Formatting with conform.nvim and linting with nvim-lint
- 🌿 Git integration with gitsigns
- 🧘 Zen mode for focus

### Tmux
- ⌨️ Navigation with Ctrl+H/J/K/L (same as Neovim)
- 🖱️ Mouse support enabled
- 🎨 Minimalist status bar
- ⚡ Prefix key: Ctrl+A (instead of Ctrl+B)
- 📋 Copy mode with vi-keys and clipboard integration

### AI Workflow (Dual Architecture)

**Carril A - External AI (Deep Reasoning):**
- 🤖 Full integration with **Claude Code** and **OpenCode** in tmux right pane
- 🚀 `dev` command to start tmux workspace with Neovim + AI tool
- 📤 Shortcuts to send code from Neovim to AI (`<leader>a*`)
- 🎯 Optimized for complex tasks and deep reasoning
- ⚡ Quick switch between Claude Code and OpenCode (`dev claude` / `dev opencode`)

**Carril B - Lightweight AI (Quick Tasks):**
- 💻 **llm** - Terminal AI for quick command lookup (`cmd?`)
- 📝 **mods** - Pipeline AI for analyzing command output
- 🧠 **CodeCompanion** - Copilot-like inline completions in Neovim (`<leader>c*`)
- 🔧 Model-agnostic: Works with any OpenAI-compatible API (Kimi, OpenAI, etc.)
- 💰 Cost-optimized: Uses lite models for simple tasks, plus models for code

## 🛠️ Prerequisites

> **Note:** The installation script can handle most of these dependencies automatically. Go directly to [Installation](#-installation) if you prefer the script to do it for you.

### macOS
```bash
# Install Homebrew if you don't have it (or let the script do it)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies (or let the script do it)
brew install neovim tmux ripgrep node
brew install --cask font-hack-nerd-font  # Or your favorite Nerd Font

# Install Oh My Posh (or let the script do it)
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Install AI tools (optional but recommended)
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
npm install -g opencode                   # OpenCode (alternative)

# AI tools for lightweight tasks (optional)
pipx install llm                          # Terminal AI for commands
brew install charmbracelet/tap/mods       # Pipeline AI for output analysis
```

### Linux (Debian/Ubuntu/Raspberry Pi)

> **Note:** The installation script can install these dependencies automatically.

```bash
# Update repositories
sudo apt update

# Install basic dependencies (or let the script do it)
sudo apt install -y neovim tmux ripgrep nodejs npm git curl build-essential

# Install Ghostty (optional - modern terminal)
# See: https://ghostty.org/docs/install/build
# Or use your current terminal (alacritty, kitty, etc)

# Install Oh My Posh (custom prompt - optional)
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install AI tools (optional but recommended)
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
npm install -g opencode                   # OpenCode (alternative)

# AI tools for lightweight tasks (optional)
pipx install llm                          # Terminal AI for commands
# mods: install via Go - go install github.com/charmbracelet/mods@latest

# Optional: Install Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Hack Bold Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf
fc-cache -fv
```

### Linux (Fedora/RHEL)
```bash
# Install dependencies
sudo dnf install -y neovim tmux ripgrep nodejs npm git curl gcc gcc-c++ make

# Install Oh My Posh (optional)
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install AI tools
npm install -g @anthropic-ai/claude-code
npm install -g opencode
```

### Linux (Arch)
```bash
# Install dependencies
sudo pacman -S neovim tmux ripgrep nodejs npm git curl base-devel

# Install Oh My Posh (optional - also available in AUR)
curl -s https://ohmyposh.dev/install.sh | bash -s
# Or from AUR: yay -S oh-my-posh

# Install AI tools
npm install -g @anthropic-ai/claude-code
npm install -g opencode
```

## 📥 Installation

### Option 1: Automatic Installation (Recommended) ⚡

**Compatible with macOS and Linux (Debian/Ubuntu/Fedora/Arch/Raspberry Pi)**

1. **Clone the repository**
```bash
mkdir -p ~/dev
cd ~/dev
git clone https://github.com/sebasusnik/dotfiles.git
cd dotfiles
```

2. **Run the installation script**
```bash
chmod +x install.sh  # Only the first time
./install.sh
```

The script automatically:
- 🔍 Detects your operating system (macOS/Linux)
- 📦 Offers to install missing dependencies (macOS with Homebrew, Linux with apt/dnf/pacman)
- 🍺 Installs Homebrew on macOS if not present
- 🎨 Offers to install optional dependencies (oh-my-posh, ghostty)
- 🤖 Offers to install AI tools (llm, mods) and configure credentials in `~/.zshenv`
- 🔧 Configures Git with your credentials (personal and work)
- ✅ Backs up your current configurations
- ✅ Creates all necessary symlinks
- ✅ Verifies installed dependencies
- ✅ Offers to install Neovim plugins
- 🤖 Offers to migrate Claude Code to local installation

3. **Configure Git** (during installation)

The script will ask you:
- Your full name
- Your personal email
- If you have work projects with a different email
- If so, your work email and the path to your projects (e.g., `~/work/`)

This will configure Git to automatically use the correct email based on the directory.

4. **Restart your terminal**
```bash
# Or run:
source ~/.zshrc
```

5. **Configure AI credentials** (optional but recommended)

Create `~/.zshenv` with your AI provider credentials (this file is NOT tracked by git):

```bash
# Create the file
cat > ~/.zshenv << 'EOF'
# AI Provider Configuration (OpenAI-compatible API)
# You can use different API keys for terminal tools vs Neovim

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
EOF
```

**Note:** You can use the same API key for both, or different ones. The install script will guide you through this.

**Note:** You can also run `./install.sh` and it will guide you through this setup interactively.

**Supported providers:**
- **Kimi** (default): `https://api.moonshot.ai/v1`
- **OpenAI**: `https://api.openai.com/v1`
- **Any OpenAI-compatible API**

6. **Install TypeScript globally** (if you didn't before)
```bash
npm install -g typescript
```

7. **Migrate Claude Code to local installation** (recommended)
```bash
# This avoids permission issues and facilitates updates
sudo claude migrate-installer

# The script already added the necessary alias to ~/.zshrc
# Verify it works:
claude --version
```

---

### Option 2: Manual Installation 🔧

<details>
<summary>Click to see manual steps</summary>

#### 1. Clone the repository

```bash
cd ~/dev
git clone https://github.com/sebasusnik/dotfiles.git
cd dotfiles
```

#### 2. Backup your current configuration (optional but recommended)

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/ohmyposh ~/.config/ohmyposh.backup
```

#### 3. Create symlinks

```bash
# Neovim
ln -sf ~/dev/dotfiles/nvim ~/.config/nvim

# Tmux
ln -sf ~/dev/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Zsh
ln -sf ~/dev/dotfiles/shell/.zshrc ~/.zshrc

# Oh My Posh
ln -sf ~/dev/dotfiles/ohmyposh ~/.config/ohmyposh
```

#### 4. Install Neovim plugins

```bash
nvim
# Lazy.nvim will automatically install all plugins when opening Neovim
# Wait for it to finish and then run:
# :checkhealth
```

#### 5. Reload Zsh

```bash
source ~/.zshrc
```

#### 6. Install TypeScript globally (for LSP)

```bash
npm install -g typescript
```

</details>

## ⌨️ Main Keybindings

### Neovim

#### General
- `<Space>` - Leader key
- `<Space>w` - Save
- `<Space>q` - Quit
- `<Space>x` - Save and quit

#### Navigation
- `<Space>e` - Toggle Neo-tree (native git colors)
- `-` - Navigate to parent directory in Neo-tree
- `<Space>f` - Find files (Telescope)
- `<Space>g` - Search text (Telescope live grep)
- `<Space>/` - Search in current file (Telescope)
- `<Space>b` - Search open buffers (Telescope)

#### Neo-tree
- `hjkl` - Navigate through the tree
- `Enter` or `l` - Open file/expand folder
- `-` - Go up to parent directory
- `h` - Close folder
- `q` - Close Neo-tree

#### LSP (in TS/JS files)
- `gd` - Go to definition
- `K` - Hover documentation
- `<Space>rn` - Rename
- `<Space>ca` - Code actions
- `Ctrl+o` - Go back (after gd)

#### Splits
- `Ctrl+h/j/k/l` - Navigate between splits

### Tmux

#### Prefix: `Ctrl+A`

#### Panes
- `Ctrl+A |` - Vertical split
- `Ctrl+A -` - Horizontal split
- `Ctrl+H/J/K/L` - Navigate between panes (no prefix!)
- `Ctrl+A x` - Close pane
- `Alt+←/→/↑/↓` - Resize panes

#### Other
- `Ctrl+A r` - Reload configuration
- `Ctrl+D` - Close shell/pane (alternative)

## 🎨 Customization

### Change Oh My Posh theme

Edit `~/.zshrc` and change the line:
```bash
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.json)"
```

You can choose other themes from: https://ohmyposh.dev/docs/themes

### Add more plugins to Neovim

Edit `~/.config/nvim/init.lua` in the plugins section:
```lua
require("lazy").setup({
    -- Add your plugins here
    { "user/plugin" },
})
```

## 🔧 Troubleshooting

### Neovim: TypeScript LSP doesn't start

```bash
# Verify TypeScript is installed
which tsserver

# If not, install:
npm install -g typescript

# Then restart Neovim
```

### Tmux: Colors don't look right

Add to your `~/.zshrc`:
```bash
export TERM=xterm-256color
```

### Nerd Fonts don't display

Make sure your terminal is using a Nerd Font:
- Ghostty: Edit `~/.config/ghostty/config`
- iTerm2: Preferences → Profiles → Text → Font

### Claude Code: "command not found"

If you installed Claude Code with npm but it doesn't work:
```bash
# Migrate to local installation (recommended)
sudo claude migrate-installer

# Add alias if it doesn't exist
echo 'alias claude="$HOME/.claude/local/claude"' >> ~/.zshrc
source ~/.zshrc
```

### AI Tools: "AI_LITE_API_KEY not configured"

If you see this warning when running `cmd?` or `ai?`:

```bash
# 1. Verify ~/.zshenv exists and has your API keys
cat ~/.zshenv

# 2. If it doesn't exist, create it:
cat > ~/.zshenv << 'EOF'
# Terminal tools (llm, mods)
export AI_LITE_API_KEY="your-api-key-here"

# Neovim (CodeCompanion)
export AI_PLUS_API_KEY="your-api-key-here"

# Common settings
export AI_BASE_URL="https://api.moonshot.ai/v1"
export AI_MODEL_LITE="kimi-lite"
export AI_MODEL_PLUS="kimi-plus"
EOF

# 3. Reload your shell
source ~/.zshrc

# 4. Verify it's working
echo $AI_LITE_API_KEY
echo $AI_PLUS_API_KEY
```

**Note:** `~/.zshenv` is NOT tracked by git, so it's safe to store your API keys there.

### AI Tools: llm or mods not found

If the AI commands don't work after installation:

```bash
# For llm (installed via pipx)
pipx install llm
pipx ensurepath

# For mods (macOS)
brew install charmbracelet/tap/mods

# For mods (Linux - requires Go)
go install github.com/charmbracelet/mods@latest

# Then reload your shell
source ~/.zshrc
```

## 🤖 Dev Workflow with AI

This setup includes a `dev` command that starts a complete workspace with tmux + nvim + AI tool (Claude Code or OpenCode):

### Using the `dev` command

```bash
# Start with opencode (default)
dev

# Start with Claude Code
dev claude
# or
dev cc

# Start with opencode explicitly
dev opencode
# or
dev oc
```

**Note:** The `dev` command is defined in [shell/.zshrc](shell/.zshrc) and is fully customizable.

### Reconnect to an existing session

```bash
dev-attach  # Useful if you closed the window but the session is still active
```

### Workspace layout:
```
┌─────────────────────┬──────────────┐
│                     │              │
│                     │   AI Tool    │
│      Neovim         │  (Claude/    │
│                     │   OpenCode)  │
│                     │              │
├─────────────────────┤              │
│   Terminal/Shell    │              │
└─────────────────────┴──────────────┘
```

The command automatically:
- ✅ Creates or recreates the tmux session named `dev`
- ✅ Starts Neovim in the main pane
- ✅ Opens Claude Code or OpenCode in the right pane (40% width)
- ✅ Creates a shell terminal in the bottom pane (30% height)

### Send code to AI from Neovim:

See [docs/KEYBINDINGS.md](docs/KEYBINDINGS.md) for all shortcuts, but the most useful:
- `<Space>ac` - Send visual selection to AI
- `<Space>af` - Send current function to AI
- `<Space>aa` - Send entire file to AI
- `<Space>ad` - Send git diff to AI

### Tmux copy mode:

Copy text from tmux to clipboard (see [docs/KEYBINDINGS.md](docs/KEYBINDINGS.md)):
```
1. Ctrl+a [     → Enter copy mode
2. hjkl         → Navigate
3. v            → Start selection
4. hjkl         → Select
5. y or Enter   → Copy to clipboard
6. Cmd+V        → Paste in any app
```

## 📚 Project Structure

```
dotfiles/
├── nvim/                 # Neovim configuration
│   ├── init.lua         # Main file
│   └── lua/
│       └── config/      # Modular configurations
├── ohmyposh/            # Oh My Posh configuration
├── git/                 # Git configuration
│   └── .gitconfig
├── shell/               # Shell configuration
│   └── .zshrc
├── tmux/                # Tmux configuration
│   └── .tmux.conf
├── terminal/            # Terminal configuration
│   └── ghostty.conf
├── docs/                # Additional documentation
│   └── KEYBINDINGS.md
├── install.sh           # Installation script
├── .gitignore           # Files ignored by git
└── README.md            # This file
```

## 🤝 Contributing

If you find improvements or bugs, feel free to:
1. Fork the repo
2. Create a branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'Add improvement'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📝 License

MIT License - feel free to use and modify as you wish.

## 🙏 Credits

- [Neovim](https://neovim.io/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Oh My Posh](https://ohmyposh.dev/)
- [Tmux](https://github.com/tmux/tmux)

---

**Made with ❤️ for a zen and productive workflow**
