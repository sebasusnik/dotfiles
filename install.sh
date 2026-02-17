#!/bin/bash

# ============================================
# DOTFILES INSTALLER
# ============================================

set -e  # Exit on error

echo "🚀 Instalando dotfiles..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Obtener el directorio donde está el script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

# Ghostty
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
create_symlink "$DOTFILES_DIR/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

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
check_command "oh-my-posh"
check_command "ghostty"

# TypeScript
if command -v tsserver &> /dev/null; then
    echo -e "${GREEN}✓${NC} tsserver instalado"
else
    echo -e "${YELLOW}✗${NC} tsserver no encontrado - ejecuta: npm install -g typescript"
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
# Finalización
# ============================================
echo ""
echo -e "${GREEN}🎉 ¡Instalación completada!${NC}"
echo ""
echo "Pasos siguientes:"
echo "  1. Reinicia tu terminal o ejecuta: source ~/.zshrc"
echo "  2. Abre Neovim y verifica la configuración: :checkhealth"
echo "  3. Si no instalaste TypeScript: npm install -g typescript"
echo ""
echo "Comandos útiles:"
echo "  - nvim: Abrir Neovim"
echo "  - tmux: Iniciar Tmux"
echo "  - dev: Iniciar workspace con tmux (si configuraste el alias)"
echo ""
