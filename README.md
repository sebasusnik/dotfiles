# 🚀 Dotfiles - NVIM ZEN + AI Workflow

Configuración minimalista y zen para desarrollo con Neovim, Tmux, Claude Code/OpenCode, y Oh My Posh.

## 📦 Contenido

- **Neovim** - Setup completo con LSP, autocompletado, y plugins esenciales
- **Tmux** - Configuración para workflow con Neovim + OpenCode
- **Zsh** - Shell configuration con Oh My Posh
- **Oh My Posh** - Terminal prompt personalizado

## ✨ Features

### Neovim
- 🎨 LSP configurado para TypeScript/JavaScript (typescript-tools)
- 🔍 Fuzzy finding con Telescope
- 📁 Explorador de archivos con git colors nativos (neo-tree)
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
- 📋 Copy mode con vi-keys y clipboard integration

### AI Workflow
- 🤖 Integración completa con **Claude Code** y **OpenCode**
- 🚀 Comando `dev` para iniciar workspace tmux con Neovim + AI tool
- 📤 Shortcuts para enviar código desde Neovim al AI (selecciones, funciones, archivos)
- 🎯 Workflow optimizado para pair programming con Claude o OpenCode
- ⚡ Cambio rápido entre Claude Code y OpenCode (`dev claude` / `dev opencode`)

## 🛠️ Prerequisitos

> **Nota:** El script de instalación puede manejar la mayoría de estas dependencias automáticamente. Ve directamente a [Instalación](#-instalación) si prefieres que el script lo haga por ti.

### macOS
```bash
# Instalar Homebrew si no lo tienes (o deja que el script lo haga)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar dependencias (o deja que el script lo haga)
brew install neovim tmux ripgrep node
brew install --cask font-hack-nerd-font  # O tu Nerd Font favorita

# Instalar Oh My Posh (o deja que el script lo haga)
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Instalar AI tools (opcional pero recomendado)
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
npm install -g opencode                   # OpenCode (alternativa)
```

### Linux (Debian/Ubuntu/Raspberry Pi)

> **Nota:** El script de instalación puede instalar estas dependencias automáticamente.

```bash
# Actualizar repositorios
sudo apt update

# Instalar dependencias básicas (o deja que el script lo haga)
sudo apt install -y neovim tmux ripgrep nodejs npm git curl build-essential

# Instalar Ghostty (opcional - terminal moderno)
# Ver: https://ghostty.org/docs/install/build
# O usar tu terminal actual (alacritty, kitty, etc)

# Instalar Oh My Posh (prompt personalizado - opcional)
curl -s https://ohmyposh.dev/install.sh | bash -s

# Instalar AI tools (opcional pero recomendado)
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
npm install -g opencode                   # OpenCode (alternativa)

# Opcional: Instalar Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Hack Bold Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf
fc-cache -fv
```

### Linux (Fedora/RHEL)
```bash
# Instalar dependencias
sudo dnf install -y neovim tmux ripgrep nodejs npm git curl gcc gcc-c++ make

# Instalar Oh My Posh (opcional)
curl -s https://ohmyposh.dev/install.sh | bash -s

# Instalar AI tools
npm install -g @anthropic-ai/claude-code
npm install -g opencode
```

### Linux (Arch)
```bash
# Instalar dependencias
sudo pacman -S neovim tmux ripgrep nodejs npm git curl base-devel

# Instalar Oh My Posh (opcional - también está en AUR)
curl -s https://ohmyposh.dev/install.sh | bash -s
# O desde AUR: yay -S oh-my-posh

# Instalar AI tools
npm install -g @anthropic-ai/claude-code
npm install -g opencode
```

## 📥 Instalación

### Opción 1: Instalación Automática (Recomendado) ⚡

**Compatible con macOS y Linux (Debian/Ubuntu/Fedora/Arch/Raspberry Pi)**

1. **Clonar el repositorio**
```bash
mkdir -p ~/dev
cd ~/dev
git clone https://github.com/sebasusnik/dotfiles.git
cd dotfiles
```

2. **Ejecutar el script de instalación**
```bash
chmod +x install.sh  # Solo la primera vez
./install.sh
```

El script automáticamente:
- 🔍 Detecta tu sistema operativo (macOS/Linux)
- 📦 Ofrece instalar dependencias faltantes (macOS con Homebrew, Linux con apt/dnf/pacman)
- 🍺 Instala Homebrew en macOS si no está presente
- 🎨 Ofrece instalar dependencias opcionales (oh-my-posh, ghostty)
- 🔧 Configura Git con tus credenciales (personal y trabajo)
- ✅ Hace backup de tus configuraciones actuales
- ✅ Crea todos los symlinks necesarios
- ✅ Verifica dependencias instaladas
- ✅ Ofrece instalar plugins de Neovim
- 🤖 Ofrece migrar Claude Code a instalación local

3. **Configurar Git** (durante la instalación)

El script te preguntará:
- Tu nombre completo
- Tu email personal
- Si tienes proyectos de trabajo con email diferente
- Si es así, tu email de trabajo y la ruta de tus proyectos (ej: `~/work/`)

Esto configurará Git para usar automáticamente el email correcto según el directorio.

4. **Reiniciar tu terminal**
```bash
# O ejecutar:
source ~/.zshrc
```

5. **Instalar TypeScript globalmente** (si no lo hiciste antes)
```bash
npm install -g typescript
```

6. **Migrar Claude Code a instalación local** (recomendado)
```bash
# Esto evita problemas de permisos y facilita actualizaciones
sudo claude migrate-installer

# El script ya agregó el alias necesario a ~/.zshrc
# Verifica que funcione:
claude --version
```

---

### Opción 2: Instalación Manual 🔧

<details>
<summary>Click para ver pasos manuales</summary>

#### 1. Clonar el repositorio

```bash
cd ~/dev
git clone https://github.com/sebasusnik/dotfiles.git
cd dotfiles
```

#### 2. Hacer backup de tu configuración actual (opcional pero recomendado)

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/ohmyposh ~/.config/ohmyposh.backup
```

#### 3. Crear symlinks

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

#### 4. Instalar plugins de Neovim

```bash
nvim
# Lazy.nvim instalará automáticamente todos los plugins al abrir Neovim
# Espera a que termine y luego ejecuta:
# :checkhealth
```

#### 5. Recargar Zsh

```bash
source ~/.zshrc
```

#### 6. Instalar TypeScript globalmente (para LSP)

```bash
npm install -g typescript
```

</details>

## ⌨️ Keybindings Principales

### Neovim

#### General
- `<Space>` - Leader key
- `<Space>w` - Guardar
- `<Space>q` - Salir
- `<Space>x` - Guardar y salir

#### Navegación
- `<Space>e` - Toggle Neo-tree (git colors nativos)
- `-` - Navegar al directorio padre en Neo-tree
- `<Space>f` - Buscar archivos (Telescope)
- `<Space>g` - Buscar texto (Telescope live grep)
- `<Space>/` - Buscar en archivo actual (Telescope)
- `<Space>b` - Buscar buffers abiertos (Telescope)

#### Neo-tree
- `hjkl` - Navegar por el árbol
- `Enter` o `l` - Abrir archivo/expandir carpeta
- `-` - Subir al directorio padre
- `h` - Cerrar carpeta
- `q` - Cerrar Neo-tree

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

### Claude Code: "command not found"

Si instalaste Claude Code con npm pero no funciona:
```bash
# Migrar a instalación local (recomendado)
sudo claude migrate-installer

# Agregar alias si no existe
echo 'alias claude="$HOME/.claude/local/claude"' >> ~/.zshrc
source ~/.zshrc
```

## 🤖 Dev Workflow con AI

Este setup incluye un comando `dev` que inicia un workspace completo con tmux + nvim + AI tool (Claude Code u OpenCode):

### Uso del comando `dev`

```bash
# Iniciar con opencode (default)
dev

# Iniciar con Claude Code
dev claude
# o
dev cc

# Iniciar con opencode explícitamente
dev opencode
# o
dev oc
```

**Nota:** El comando `dev` está definido en [shell/.zshrc](shell/.zshrc) y es completamente personalizable.

### Re-conectar a una sesión existente

```bash
dev-attach  # Útil si cerraste la ventana pero la sesión sigue activa
```

### Layout del workspace:
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

El comando automáticamente:
- ✅ Crea o recrea la sesión tmux llamada `dev`
- ✅ Inicia Neovim en el panel principal
- ✅ Abre Claude Code u OpenCode en el panel derecho (40% de ancho)
- ✅ Crea un terminal shell en el panel inferior (30% de alto)

### Enviar código al AI desde Neovim:

Ver [KEYBINDINGS.md](KEYBINDINGS.md) para todos los shortcuts, pero los más útiles:
- `<Space>ac` - Enviar selección visual al AI
- `<Space>af` - Enviar función actual al AI
- `<Space>aa` - Enviar archivo completo al AI
- `<Space>ad` - Enviar git diff al AI

### Tmux copy mode:

Copiar texto desde tmux al clipboard (ver [KEYBINDINGS.md](KEYBINDINGS.md)):
```
1. Ctrl+a [     → Entrar en copy mode
2. hjkl         → Navegar
3. v            → Iniciar selección
4. hjkl         → Seleccionar
5. y o Enter    → Copiar al clipboard
6. Cmd+V        → Pegar en cualquier app
```

## 📚 Estructura del Proyecto

```
dotfiles/
├── nvim/                 # Configuración de Neovim
│   ├── init.lua         # Archivo principal
│   └── lua/
│       └── config/      # Configuraciones modulares
├── ohmyposh/            # Configuración de Oh My Posh
├── git/                 # Configuración de Git
│   └── .gitconfig
├── shell/               # Configuración de shell
│   └── .zshrc
├── tmux/                # Configuración de Tmux
│   └── .tmux.conf
├── terminal/            # Configuración de terminal
│   └── ghostty.conf
├── docs/                # Documentación adicional
│   └── KEYBINDINGS.md
├── install.sh           # Script de instalación
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
