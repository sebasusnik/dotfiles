#!/bin/bash

# ============================================
# DOTFILES INSTALLER - macOS & Linux
# ============================================

set -e  # Exit on error

echo "🚀 Instalando dotfiles..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Obtener el directorio donde está el script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detectar OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo -e "${BLUE}ℹ️  Detectado: macOS${NC}"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo -e "${BLUE}ℹ️  Detectado: Linux${NC}"
else
    echo -e "${YELLOW}⚠️  OS no soportado: $OSTYPE${NC}"
    exit 1
fi

# Detectar si es headless (sin pantalla)
IS_HEADLESS=false
if [ "$OS" = "linux" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
    IS_HEADLESS=true
    echo -e "${BLUE}ℹ️  Headless Linux detectado — herramientas GUI serán omitidas${NC}"
fi
echo ""

# ============================================
# Función para crear symlinks
# ============================================
create_symlink() {
    local source=$1
    local target=$2

    # Si el target existe y no es un symlink, hacer backup
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}⚠️  Backup: $target -> $target.backup${NC}"
        mv "$target" "$target.backup"
    fi

    # Si ya existe el symlink, eliminarlo
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Crear symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked: $source -> $target"
}

# ============================================
# Instalar dependencias
# ============================================
echo "📦 Detectando dependencias faltantes..."
echo ""

# Lista de dependencias a verificar (node se llama nodejs en apt)
if [ "$OS" = "macos" ]; then
    DEPS_TO_CHECK=("nvim:neovim" "tmux:tmux" "rg:ripgrep" "node:node" "git:git")
else
    DEPS_TO_CHECK=("nvim:neovim" "tmux:tmux" "rg:ripgrep" "node:nodejs" "git:git")
fi
MISSING_DEPS=()

for dep in "${DEPS_TO_CHECK[@]}"; do
    CMD="${dep%%:*}"
    PKG="${dep##*:}"
    if ! command -v "$CMD" &> /dev/null; then
        MISSING_DEPS+=("$PKG")
        echo -e "${YELLOW}✗${NC} $CMD no encontrado"
    else
        echo -e "${GREEN}✓${NC} $CMD ya instalado"
    fi
done

# Función para instalar neovim en Linux (apt tiene versión 0.7 obsoleta)
install_neovim_linux() {
    echo "📦 Instalando Neovim via snap (versión actual)..."
    if ! command -v snap &>/dev/null; then
        echo "Instalando snapd primero..."
        sudo apt install -y snapd
    fi
    sudo snap install nvim --classic
}

# Verificar dependencias opcionales de macOS
if [ "$OS" = "macos" ]; then
    OPTIONAL_DEPS=("oh-my-posh:oh-my-posh")
    MISSING_OPTIONAL=()

    for dep in "${OPTIONAL_DEPS[@]}"; do
        CMD="${dep%%:*}"
        PKG="${dep##*:}"
        if ! command -v "$CMD" &> /dev/null; then
            MISSING_OPTIONAL+=("$PKG")
            echo -e "${YELLOW}✗${NC} $CMD no encontrado (opcional)"
        else
            echo -e "${GREEN}✓${NC} $CMD ya instalado"
        fi
    done
    
    # Check Ghostty separately (app bundle, not CLI)
    if [ -d "/Applications/Ghostty.app" ]; then
        echo -e "${GREEN}✓${NC} Ghostty ya instalado"
    else
        MISSING_OPTIONAL+=("ghostty")
        echo -e "${YELLOW}✗${NC} Ghostty no encontrado (opcional)"
    fi
fi

# Dependencias opcionales de Linux
if [ "$OS" = "linux" ]; then
    MISSING_OPTIONAL=()

    # oh-my-posh (funciona por SSH con Nerd Fonts en el cliente)
    if ! command -v oh-my-posh &>/dev/null; then
        MISSING_OPTIONAL+=("oh-my-posh")
        echo -e "${YELLOW}✗${NC} oh-my-posh no encontrado (opcional)"
    else
        echo -e "${GREEN}✓${NC} oh-my-posh ya instalado"
    fi

    # Ghostty (solo si hay display — GUI app)
    if [ "$IS_HEADLESS" = false ]; then
        if command -v ghostty &>/dev/null; then
            echo -e "${GREEN}✓${NC} Ghostty ya instalado"
        else
            MISSING_OPTIONAL+=("ghostty")
            echo -e "${YELLOW}✗${NC} Ghostty no encontrado (opcional)"
        fi
    fi
fi

# Si hay dependencias faltantes, instalar
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    echo -e "${BLUE}ℹ️  Dependencias faltantes: ${MISSING_DEPS[*]}${NC}"
    echo ""
    read -p "¿Instalar dependencias faltantes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$OS" = "macos" ]; then
            # Verificar si Homebrew está instalado
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}⚠️  Homebrew no está instalado${NC}"
                echo "Instalando Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            echo "📥 Instalando con Homebrew..."
            brew install "${MISSING_DEPS[@]}"
            echo -e "${GREEN}✓${NC} Dependencias instaladas"
        elif [ "$OS" = "linux" ]; then
            # Separar neovim del resto (apt instala versión obsoleta)
            REMAINING_DEPS=()
            for pkg in "${MISSING_DEPS[@]}"; do
                if [ "$pkg" = "neovim" ]; then
                    install_neovim_linux
                else
                    REMAINING_DEPS+=("$pkg")
                fi
            done

            if [ ${#REMAINING_DEPS[@]} -gt 0 ]; then
                if command -v apt &> /dev/null; then
                    echo "📥 Instalando con apt..."
                    sudo apt update
                    sudo apt install -y "${REMAINING_DEPS[@]}" build-essential
                    echo -e "${GREEN}✓${NC} Dependencias instaladas"
                elif command -v dnf &> /dev/null; then
                    echo "📥 Instalando con dnf..."
                    sudo dnf install -y "${REMAINING_DEPS[@]}" gcc gcc-c++ make
                    echo -e "${GREEN}✓${NC} Dependencias instaladas"
                elif command -v pacman &> /dev/null; then
                    echo "📥 Instalando con pacman..."
                    sudo pacman -S --needed --noconfirm "${REMAINING_DEPS[@]}" base-devel
                    echo -e "${GREEN}✓${NC} Dependencias instaladas"
                else
                    echo -e "${YELLOW}⚠️  Gestor de paquetes no detectado${NC}"
                    echo "Instala manualmente: ${REMAINING_DEPS[*]}"
                fi
            fi
        fi
    fi
else
    echo -e "${GREEN}✓${NC} Todas las dependencias ya están instaladas"
fi

# Instalar dependencias opcionales de macOS
if [ "$OS" = "macos" ] && [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    echo ""
    echo -e "${BLUE}ℹ️  Dependencias opcionales faltantes: ${MISSING_OPTIONAL[*]}${NC}"
    read -p "¿Instalar dependencias opcionales? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📥 Instalando con Homebrew..."
        for pkg in "${MISSING_OPTIONAL[@]}"; do
            if [ "$pkg" = "oh-my-posh" ]; then
                brew install jandedobbeleer/oh-my-posh/oh-my-posh
            else
                brew install --cask "$pkg" 2>/dev/null || brew install "$pkg"
            fi
        done
        echo -e "${GREEN}✓${NC} Dependencias opcionales instaladas"
    fi
fi

# Instalar dependencias opcionales de Linux
if [ "$OS" = "linux" ] && [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    echo ""
    echo -e "${BLUE}ℹ️  Dependencias opcionales faltantes: ${MISSING_OPTIONAL[*]}${NC}"
    read -p "¿Instalar dependencias opcionales? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for pkg in "${MISSING_OPTIONAL[@]}"; do
            if [ "$pkg" = "oh-my-posh" ]; then
                echo "📥 Instalando oh-my-posh..."
                curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
                echo -e "${GREEN}✓${NC} oh-my-posh instalado en ~/.local/bin"
            elif [ "$pkg" = "ghostty" ]; then
                echo "📥 Instalando Ghostty via flatpak..."
                if ! command -v flatpak &>/dev/null; then
                    sudo apt install -y flatpak 2>/dev/null || echo -e "${YELLOW}⚠️  Instala flatpak manualmente y luego: flatpak install flathub com.mitchellh.ghostty${NC}"
                else
                    flatpak install flathub com.mitchellh.ghostty -y
                fi
                echo -e "${GREEN}✓${NC} Ghostty instalado"
            fi
        done
    fi
fi
echo ""

# ============================================
# Nerd Font (JetBrainsMono)
# ============================================
install_nerd_font() {
    if [ "$OS" = "macos" ]; then
        if ls ~/Library/Fonts/JetBrainsMonoNerd* &>/dev/null || \
           ls /Library/Fonts/JetBrainsMonoNerd* &>/dev/null; then
            echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font ya instalada"
            return
        fi
        echo "📥 Instalando JetBrainsMono Nerd Font via Homebrew..."
        brew install --cask font-jetbrains-mono-nerd-font
        echo -e "${GREEN}✓${NC} Fuente instalada"

    elif [ "$OS" = "linux" ] && [ "$IS_HEADLESS" = false ]; then
        if fc-list | grep -qi "JetBrainsMono"; then
            echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font ya instalada"
            return
        fi
        echo "📥 Descargando JetBrainsMono Nerd Font..."
        mkdir -p ~/.local/share/fonts/JetBrainsMono
        curl -Lo /tmp/JetBrainsMono.zip \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono "*.ttf" "*.otf"
        fc-cache -fv
        rm /tmp/JetBrainsMono.zip
        echo -e "${GREEN}✓${NC} Fuente instalada"

    elif [ "$IS_HEADLESS" = true ]; then
        echo -e "${BLUE}ℹ️  Headless — fuente omitida (no hay display)${NC}"
    fi
}

echo ""
echo "🔤 Verificando Nerd Font..."
install_nerd_font

# ============================================
# Crear directorios necesarios
# ============================================
echo "📁 Creando directorios necesarios..."
mkdir -p ~/.config

# ============================================
# Crear symlinks
# ============================================
echo ""
echo "🔗 Creando symlinks..."
echo ""

# Neovim
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Zsh
create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Oh My Posh
create_symlink "$DOTFILES_DIR/ohmyposh" "$HOME/.config/ohmyposh"

# Ghostty (only if installed)
if [ "$OS" = "macos" ] && [ -d "/Applications/Ghostty.app" ]; then
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    create_symlink "$DOTFILES_DIR/terminal/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
elif [ "$OS" = "linux" ] && command -v ghostty &> /dev/null; then
    # En Linux, Ghostty usa XDG_CONFIG_HOME
    mkdir -p "$HOME/.config/ghostty"
    create_symlink "$DOTFILES_DIR/terminal/ghostty.conf" "$HOME/.config/ghostty/config"
else
    echo -e "${YELLOW}⚠️${NC} Ghostty no instalado, omitiendo configuración"
fi

# ============================================
# Configuración de Git
# ============================================
echo ""
echo "🔧 Configurando Git..."
echo ""

# Symlink para .gitconfig
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Configurar credenciales de git
if [ -f "$HOME/.gitconfig-local" ]; then
    echo -e "${GREEN}✓${NC} .gitconfig-local ya existe (omitiendo configuración)"
else
    echo -e "${BLUE}ℹ️  Configurando credenciales de Git${NC}"
    echo ""

    # Preguntar nombre
    read -p "Tu nombre completo: " git_name

    # Preguntar email personal
    read -p "Tu email personal: " git_email

    # Preguntar si tiene proyectos de trabajo
    echo ""
    read -p "¿Tienes proyectos de trabajo con email diferente? (y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Preguntar email de trabajo
        read -p "Tu email de trabajo: " git_work_email

        # Preguntar directorio de trabajo
        read -p "Ruta de tus proyectos de trabajo (ej: ~/work/): " work_dir

        # Expandir ~ a $HOME si está presente
        work_dir="${work_dir/#\~/$HOME}"

        # Crear .gitconfig-work
        cat > "$HOME/.gitconfig-work" << EOF
[user]
	name = $git_name
	email = $git_work_email
EOF
        echo -e "${GREEN}✓${NC} .gitconfig-work creado"

        # Crear .gitconfig-local con includeIf
        cat > "$HOME/.gitconfig-local" << EOF
[user]
	name = $git_name
	email = $git_email

# Configuración condicional para proyectos de trabajo
[includeIf "gitdir:$work_dir"]
	path = ~/.gitconfig-work
EOF
    else
        # Crear .gitconfig-local sin includeIf
        cat > "$HOME/.gitconfig-local" << EOF
[user]
	name = $git_name
	email = $git_email
EOF
    fi

    echo -e "${GREEN}✓${NC} .gitconfig-local creado"
    echo ""
fi

# ============================================
# Verificar dependencias
# ============================================
echo ""
echo "🔍 Verificando dependencias..."
echo ""

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 instalado"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1 no encontrado"
        return 1
    fi
}

check_command "nvim"
check_command "tmux"
check_command "rg"
check_command "node"
# Check Ghostty (app bundle, not CLI command)
if [ "$OS" = "macos" ] && [ -d "/Applications/Ghostty.app" ]; then
    echo -e "${GREEN}✓${NC} Ghostty instalado"
else
    echo -e "${YELLOW}✗${NC} Ghostty no encontrado (opcional)"
fi

# macOS specific tools
if [ "$OS" = "macos" ]; then
    check_command "oh-my-posh"
fi

# TypeScript
if command -v tsserver &> /dev/null; then
    echo -e "${GREEN}✓${NC} tsserver instalado"
else
    echo -e "${YELLOW}✗${NC} tsserver no encontrado"
    read -p "¿Instalar TypeScript globalmente? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g typescript
        echo -e "${GREEN}✓${NC} TypeScript instalado"
    fi
fi

# Claude Code
if command -v claude &> /dev/null || [ -f "$HOME/.claude/local/claude" ]; then
    echo -e "${GREEN}✓${NC} claude instalado"
else
    echo -e "${YELLOW}✗${NC} claude no encontrado"
    read -p "¿Instalar Claude Code? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @anthropic-ai/claude-code
        echo -e "${GREEN}✓${NC} Claude Code instalado"
    fi
fi

# OpenCode
if command -v opencode &> /dev/null; then
    echo -e "${GREEN}✓${NC} opencode instalado"
else
    echo -e "${YELLOW}✗${NC} opencode no encontrado (opcional)"
fi

# ============================================
# AI Tools (llm, mods)
# ============================================
echo ""
echo "🤖 Configurando herramientas AI..."
echo ""

# Check pipx
if ! command -v pipx &> /dev/null; then
    echo -e "${YELLOW}✗${NC} pipx no encontrado"
    read -p "¿Instalar pipx? (requerido para llm) (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$OS" = "macos" ]; then
            brew install pipx
            pipx ensurepath
        elif [ "$OS" = "linux" ]; then
            if command -v apt &> /dev/null; then
                sudo apt install -y pipx
                pipx ensurepath
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y pipx
                pipx ensurepath
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --needed --noconfirm python-pipx
                pipx ensurepath
            fi
        fi
        echo -e "${GREEN}✓${NC} pipx instalado"
    fi
else
    echo -e "${GREEN}✓${NC} pipx ya instalado"
fi

# Install llm
if ! command -v llm &> /dev/null; then
    echo -e "${YELLOW}✗${NC} llm no encontrado"
    read -p "¿Instalar llm? (AI para terminal) (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pipx install llm
        echo -e "${GREEN}✓${NC} llm instalado"
    fi
else
    echo -e "${GREEN}✓${NC} llm ya instalado"
fi

# Install mods
if ! command -v mods &> /dev/null; then
    echo -e "${YELLOW}✗${NC} mods no encontrado"
    read -p "¿Instalar mods? (AI para pipelines) (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$OS" = "macos" ]; then
            brew install charmbracelet/tap/mods
        elif [ "$OS" = "linux" ]; then
            # Install via go or direct download
            if command -v go &> /dev/null; then
                go install github.com/charmbracelet/mods@latest
            else
                echo "mods requiere Go. Instala Go o descarga manualmente desde:"
                echo "https://github.com/charmbracelet/mods/releases"
            fi
        fi
        echo -e "${GREEN}✓${NC} mods instalado"
    fi
else
    echo -e "${GREEN}✓${NC} mods ya instalado"
fi

# Configure AI credentials
echo ""
read -p "¿Configurar credenciales de AI? (API keys, modelos, etc.) (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}Configuración de AI:${NC}"
    echo ""
    echo "Puedes usar la misma API key para ambos o diferentes."
    echo ""
    
    # Lite API Key (for terminal tools: llm, mods)
    read -p "API Key para terminal (llm/mods) [misma que Neovim]: " ai_lite_api_key
    
    # Plus API Key (for CodeCompanion in Neovim)
    read -p "API Key para Neovim (CodeCompanion) [misma que terminal]: " ai_plus_api_key
    
    # If plus key is empty, use lite key
    if [ -z "$ai_plus_api_key" ]; then
        ai_plus_api_key="${ai_lite_api_key:-}"
    fi
    
    # If lite key is empty, use plus key
    if [ -z "$ai_lite_api_key" ]; then
        ai_lite_api_key="${ai_plus_api_key:-}"
    fi
    
    # At least one must be set
    while [ -z "$ai_lite_api_key" ] && [ -z "$ai_plus_api_key" ]; do
        echo -e "${YELLOW}⚠️  Al menos una API Key es requerida${NC}"
        read -p "API Key: " ai_key
        ai_lite_api_key="$ai_key"
        ai_plus_api_key="$ai_key"
    done
    
    # Base URL
    read -p "Base URL [https://api.moonshot.ai/v1]: " ai_base_url
    ai_base_url="${ai_base_url:-https://api.moonshot.ai/v1}"
    
    # Models
    echo ""
    echo "Modelos disponibles (sin prefijos):"
    echo "  - moonshot-v1-8k (rápido/barato)"
    echo "  - moonshot-v1-32k (balanceado, recomendado)"
    echo "  - moonshot-v1-128k (contexto grande)"
    echo "  - kimi-k2-turbo-preview (rápido, sin reasoning)"
    echo ""

    read -p "Modelo lite (terminal) [moonshot-v1-8k]: " ai_model_lite
    ai_model_lite="${ai_model_lite:-moonshot-v1-8k}"

    read -p "Modelo plus (neovim) [moonshot-v1-32k]: " ai_model_plus
    ai_model_plus="${ai_model_plus:-moonshot-v1-32k}"

    # Create ~/.zshenv with AI credentials (not tracked by git)
    cat > "$HOME/.zshenv" << EOF
# ============================================
# AI Provider Configuration (Moonshot/Kimi)
# ============================================
# This file is NOT tracked by git - safe for API keys

# API Keys
export AI_API_KEY_LITE="$ai_lite_api_key"
export AI_API_KEY_PLUS="$ai_plus_api_key"

# API Endpoint
export AI_BASE_URL="$ai_base_url"

# Model names (as used by the Moonshot API - NO prefixes)
# Options: moonshot-v1-8k (cheap), moonshot-v1-32k (balanced), moonshot-v1-128k, kimi-k2-turbo-preview (fast/expensive)
export AI_MODEL_LITE="$ai_model_lite"
export AI_MODEL_PLUS="$ai_model_plus"  # Good balance for autocompletion

# ============================================
# Tool-specific configurations
# ============================================

# llm CLI tool (requires "moonshot/" prefix)
export LLM_MODEL_LITE="moonshot/\$AI_MODEL_LITE"
export LLM_MODEL_PLUS="moonshot/\$AI_MODEL_PLUS"
export LLM_MODEL="\$LLM_MODEL_LITE"  # Default model
export LLM_KEY="\$AI_API_KEY_LITE"

# mods CLI tool (uses API model names directly)
export MODS_API="moonshot"
export MODS_MODEL_LITE="\$AI_MODEL_LITE"
export MODS_MODEL_PLUS="\$AI_MODEL_PLUS"
export MODS_MODEL="\$MODS_MODEL_LITE"  # Default model
export MODS_OPENAI_API_KEY="\$AI_API_KEY_LITE"
EOF
    
    echo -e "${GREEN}✓${NC} Configuración AI guardada en ~/.zshenv"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
    echo "   Las credenciales se guardaron en ~/.zshenv (fuera del repo)"
    echo "   Reinicia tu terminal para cargar la configuración"
fi

# ============================================
# Instalación de plugins de Neovim
# ============================================
echo ""
read -p "¿Instalar plugins de Neovim ahora? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Instalando plugins de Neovim..."
    nvim --headless "+Lazy! sync" +qa
    echo -e "${GREEN}✓${NC} Plugins instalados"
fi

# ============================================
# Configuración de Claude Code (opcional)
# ============================================
if command -v claude &> /dev/null; then
    echo ""
    read -p "¿Migrar Claude Code a instalación local? (recomendado, y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🤖 Migrando Claude Code..."
        echo ""
        echo "IMPORTANTE: Después de migrar, agrega esto a tu ~/.zshrc:"
        echo '  alias claude="/Users/$USER/.claude/local/claude"'
        echo ""
        echo "Presiona Enter para continuar..."
        read
        sudo claude migrate-installer

        # Agregar alias si no existe
        if ! grep -q 'alias claude="/Users/' ~/.zshrc; then
            echo "" >> ~/.zshrc
            echo '# Claude Code local installation' >> ~/.zshrc
            echo "alias claude=\"$HOME/.claude/local/claude\"" >> ~/.zshrc
            echo -e "${GREEN}✓${NC} Alias agregado a ~/.zshrc"
        fi
    fi
fi

# ============================================
# Finalización
# ============================================
echo ""
echo -e "${GREEN}🎉 ¡Instalación completada!${NC}"
echo ""
echo "Pasos siguientes:"
echo "  1. Reinicia tu terminal o ejecuta: source ~/.zshrc"
echo "  2. Abre Neovim y verifica la configuración: :checkhealth"
echo "  3. Si no instalaste TypeScript: npm install -g typescript"
echo "  4. Si no tienes Claude Code: npm install -g @anthropic-ai/claude-code"
echo ""
echo "Comandos útiles:"
echo "  - nvim: Abrir Neovim"
echo "  - tmux: Iniciar Tmux"
echo "  - dev: Iniciar workspace con nvim + opencode"
echo "  - dev claude: Iniciar workspace con nvim + claude"
echo ""
echo "Comandos AI (requieren AI_API_KEY_LITE en ~/.zshenv):"
echo "  - cmd 'descripción': Obtener comando de shell"
echo "  - run 'descripción': Obtener y ejecutar comando"
echo "  - cat archivo.log | mods 'resumir': Analizar output"
echo ""
echo "Atajos Neovim — Minuet (ghost text AI):"
echo "  - Tab:        Aceptar sugerencia"
echo "  - Shift-Tab:  Descartar sugerencia"
echo "  - Alt-a:      Aceptar solo una línea"
echo "  - <leader>ae: Habilitar Minuet"
echo "  - <leader>am: Cambiar modelo AI"
echo ""
echo "Atajos Neovim — OpenCode/Claude (tmux):"
echo "  - <leader>aa: Enviar archivo a AI"
echo "  - <leader>af: Enviar función a AI"
echo "  - <leader>ac: Enviar selección visual a AI"
echo "  - <leader>ad: Enviar git diff a AI"
echo ""
