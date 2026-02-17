# 🚀 Dotfiles - NVIM ZEN + OPENCODE Workflow

Configuración minimalista y zen para desarrollo con Neovim, Tmux, y Oh My Posh.

## 📦 Contenido

- **Neovim** - Setup completo con LSP, autocompletado, y plugins esenciales
- **Tmux** - Configuración para workflow con Neovim + OpenCode
- **Zsh** - Shell configuration con Oh My Posh
- **Oh My Posh** - Terminal prompt personalizado

## ✨ Features

### Neovim
- 🎨 LSP configurado para TypeScript/JavaScript (typescript-tools)
- 🔍 Fuzzy finding con fzf
- 📁 Exploradores de archivos (mini.files + oil.nvim)
- ✍️ Autocompletado con nvim-cmp
- 🎯 Treesitter para syntax highlighting
- 🔧 Formateo con conform.nvim y linting con nvim-lint
- 🌿 Git integration con gitsigns
- 🧘 Zen mode para concentración

### Tmux
- ⌨️ Navegación con Ctrl+H/J/K/L (igual que Neovim)
- 🖱️ Mouse support habilitado
- 🎨 Status bar minimalista
- ⚡ Prefix key: Ctrl+A (en lugar de Ctrl+B)

## 🛠️ Prerequisitos

### macOS
```bash
# Instalar Homebrew si no lo tienes
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar dependencias
brew install neovim tmux fzf ripgrep node
brew install --cask font-hack-nerd-font  # O tu Nerd Font favorita

# Instalar Oh My Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

## 📥 Instalación

### 1. Clonar el repositorio

```bash
cd ~/dev
git clone https://github.com/TU-USUARIO/dotfiles.git
cd dotfiles
```

### 2. Hacer backup de tu configuración actual (opcional pero recomendado)

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/ohmyposh ~/.config/ohmyposh.backup
```

### 3. Crear symlinks

```bash
# Neovim
ln -sf ~/dev/dotfiles/nvim ~/.config/nvim

# Tmux
ln -sf ~/dev/dotfiles/.tmux.conf ~/.tmux.conf

# Zsh
ln -sf ~/dev/dotfiles/.zshrc ~/.zshrc

# Oh My Posh
ln -sf ~/dev/dotfiles/ohmyposh ~/.config/ohmyposh
```

### 4. Instalar plugins de Neovim

```bash
nvim
# Lazy.nvim instalará automáticamente todos los plugins al abrir Neovim
# Espera a que termine y luego ejecuta:
# :checkhealth
```

### 5. Recargar Zsh

```bash
source ~/.zshrc
```

### 6. Instalar TypeScript globalmente (para LSP)

```bash
npm install -g typescript
```

## ⌨️ Keybindings Principales

### Neovim

#### General
- `<Space>` - Leader key
- `<Space>w` - Guardar
- `<Space>q` - Salir
- `<Space>x` - Guardar y salir

#### Navegación
- `<Space>e` - Toggle file explorer (mini.files)
- `-` - Oil explorer
- `<Space>f` - Buscar archivos (fzf)
- `<Space>g` - Buscar texto (ripgrep)
- `<Space>/` - Buscar en archivo actual

#### LSP (en archivos TS/JS)
- `gd` - Go to definition
- `K` - Hover documentation
- `<Space>rn` - Rename
- `<Space>ca` - Code actions
- `Ctrl+o` - Volver atrás (después de gd)

#### Splits
- `Ctrl+h/j/k/l` - Navegar entre splits

### Tmux

#### Prefix: `Ctrl+A`

#### Paneles
- `Ctrl+A |` - Split vertical
- `Ctrl+A -` - Split horizontal
- `Ctrl+H/J/K/L` - Navegar entre paneles (sin prefix!)
- `Ctrl+A x` - Cerrar panel
- `Alt+←/→/↑/↓` - Redimensionar paneles

#### Otras
- `Ctrl+A r` - Recargar configuración
- `Ctrl+D` - Cerrar shell/panel (alternativa)

## 🎨 Personalización

### Cambiar tema de Oh My Posh

Edita `~/.zshrc` y cambia la línea:
```bash
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.json)"
```

Puedes elegir otros temas de: https://ohmyposh.dev/docs/themes

### Agregar más plugins a Neovim

Edita `~/.config/nvim/init.lua` en la sección de plugins:
```lua
require("lazy").setup({
    -- Agrega tus plugins aquí
    { "usuario/plugin" },
})
```

## 🔧 Troubleshooting

### Neovim: LSP de TypeScript no inicia

```bash
# Verificar que TypeScript esté instalado
which tsserver

# Si no está, instalar:
npm install -g typescript

# Luego reiniciar Neovim
```

### Tmux: Los colores no se ven bien

Agrega a tu `~/.zshrc`:
```bash
export TERM=xterm-256color
```

### Nerd Fonts no se ven

Asegúrate de que tu terminal esté usando una Nerd Font:
- Ghostty: Edita `~/.config/ghostty/config`
- iTerm2: Preferences → Profiles → Text → Font

## 📚 Estructura del Proyecto

```
dotfiles/
├── nvim/                 # Configuración de Neovim
│   ├── init.lua         # Archivo principal
│   └── lua/
│       └── config/      # Configuraciones modulares
├── ohmyposh/            # Oh My Posh config
├── .tmux.conf           # Configuración de Tmux
├── .zshrc               # Configuración de Zsh
├── .gitignore           # Archivos ignorados por git
└── README.md            # Este archivo
```

## 🤝 Contribuir

Si encuentras mejoras o bugs, siéntete libre de:
1. Fork el repo
2. Crear una branch (`git checkout -b feature/mejora`)
3. Commit tus cambios (`git commit -m 'Add mejora'`)
4. Push a la branch (`git push origin feature/mejora`)
5. Abrir un Pull Request

## 📝 Licencia

MIT License - siéntete libre de usar y modificar como quieras.

## 🙏 Créditos

- [Neovim](https://neovim.io/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Oh My Posh](https://ohmyposh.dev/)
- [Tmux](https://github.com/tmux/tmux)

---

**Hecho con ❤️ para un workflow zen y productivo**
