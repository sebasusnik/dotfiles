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
# Instalar dependencias (solo Linux)
# ============================================
if [ "$OS" = "linux" ]; then
    echo "📦 Detectando dependencias faltantes..."
    echo ""

    # Lista de dependencias a verificar
    DEPS_TO_CHECK=("nvim:neovim" "tmux:tmux" "rg:ripgrep" "node:nodejs" "npm:npm" "git:git" "curl:curl")
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

    # Si hay dependencias faltantes, instalar
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo ""
        echo -e "${BLUE}ℹ️  Dependencias faltantes: ${MISSING_DEPS[*]}${NC}"
        echo ""
        read -p "¿Instalar dependencias faltantes? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v apt &> /dev/null; then
                echo "📥 Instalando con apt..."
                sudo apt update
                sudo apt install -y "${MISSING_DEPS[@]}" build-essential
                echo -e "${GREEN}✓${NC} Dependencias instaladas"
            elif command -v dnf &> /dev/null; then
                echo "📥 Instalando con dnf..."
                sudo dnf install -y "${MISSING_DEPS[@]}" gcc gcc-c++ make
                echo -e "${GREEN}✓${NC} Dependencias instaladas"
            elif command -v pacman &> /dev/null; then
                echo "📥 Instalando con pacman..."
                sudo pacman -S --needed --noconfirm "${MISSING_DEPS[@]}" base-devel
                echo -e "${GREEN}✓${NC} Dependencias instaladas"
            else
                echo -e "${YELLOW}⚠️  Gestor de paquetes no detectado${NC}"
                echo "Instala manualmente: ${MISSING_DEPS[*]}"
            fi
        fi
    else
        echo -e "${GREEN}✓${NC} Todas las dependencias ya están instaladas"
    fi
    echo ""
fi

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
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Zsh
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Oh My Posh
create_symlink "$DOTFILES_DIR/ohmyposh" "$HOME/.config/ohmyposh"

# Ghostty (solo macOS por ahora)
if [ "$OS" = "macos" ]; then
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    create_symlink "$DOTFILES_DIR/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
elif [ "$OS" = "linux" ]; then
    # En Linux, Ghostty usa XDG_CONFIG_HOME
    mkdir -p "$HOME/.config/ghostty"
    create_symlink "$DOTFILES_DIR/ghostty.conf" "$HOME/.config/ghostty/config"
fi

# ============================================
# Configuración de Git
# ============================================
echo ""
echo "🔧 Configurando Git..."
echo ""

# Symlink para .gitconfig
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

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
check_command "ghostty"

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
if command -v claude &> /dev/null; then
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
