#!/bin/bash

# Comprehensive Neovim Setup Script

# Function to print messages
print_message() {
    echo "===> $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get the correct home directory
get_home_dir() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "$HOME"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "$HOME"
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
        echo "$USERPROFILE"
    else
        echo "Unsupported OS" >&2
        exit 1
    fi
}

# Function to install packages based on OS
install_packages() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists brew; then
            print_message "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install neovim tree ripgrep fd fzf
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y neovim tree ripgrep fd-find fzf
        elif command_exists pacman; then
            sudo pacman -Syu neovim tree ripgrep fd fzf
        else
            print_message "Unsupported package manager. Please install Neovim, tree, ripgrep, fd, and fzf manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
        if ! command_exists choco; then
            print_message "Installing Chocolatey..."
            powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
        fi
        choco install neovim tree ripgrep fd fzf -y
    else
        print_message "Unsupported OS"
        exit 1
    fi
}

# Function to create Neovim configuration files
create_nvim_config() {
    cat > "$NVIM_CONFIG_DIR/init.vim" << EOL
" Load plugins
source ~/.config/nvim/plugins.vim

" Load general settings
source ~/.config/nvim/settings.vim

" Load key mappings
source ~/.config/nvim/keymaps.vim

" Load theme configuration
source ~/.config/nvim/theme.vim
EOL

    cat > "$NVIM_CONFIG_DIR/plugins.vim" << EOL
call plug#begin('~/.local/share/nvim/plugged')

" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

" File explorer
Plug 'scrooloose/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" PowerShell support
Plug 'pprovost/vim-ps1'

call plug#end()
EOL

    cat > "$NVIM_CONFIG_DIR/settings.vim" << EOL
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set hidden
set ignorecase
set smartcase
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set termguicolors
EOL

    cat > "$NVIM_CONFIG_DIR/keymaps.vim" << EOL
" Set leader key to space
let mapleader = " "

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>b :Buffers<CR>

" CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Markdown preview
nmap <leader>m <Plug>MarkdownPreviewToggle
EOL

    cat > "$NVIM_CONFIG_DIR/theme.vim" << EOL
" Enable Dracula theme
colorscheme dracula

" Enable transparency
hi Normal guibg=NONE ctermbg=NONE

" Customize airline theme
let g:airline_theme='dracula'
EOL
}

# Function to update Zsh configuration
update_zshrc() {
    ZSHRC="$HOME_DIR/.zshrc"
    
    if [ -f "$ZSHRC" ]; then
        if ! grep -q "alias vim='nvim'" "$ZSHRC"; then
            echo "# Use Neovim as the default editor" >> "$ZSHRC"
            echo "export EDITOR='nvim'" >> "$ZSHRC"
            echo "alias vim='nvim'" >> "$ZSHRC"
            echo "alias vi='nvim'" >> "$ZSHRC"
            print_message "Updated .zshrc with Neovim aliases"
        else
            print_message "Neovim aliases already exist in .zshrc"
        fi
    else
        print_message ".zshrc not found. Please add Neovim aliases manually."
    fi
}

# Main installation process
HOME_DIR=$(get_home_dir)
NVIM_CONFIG_DIR="$HOME_DIR/.config/nvim"

print_message "Starting Neovim setup"

# Install required packages
print_message "Installing required packages"
install_packages

# Create Neovim config directory
print_message "Creating Neovim configuration directory"
mkdir -p "$NVIM_CONFIG_DIR"

# Download and install vim-plug
print_message "Installing vim-plug"
sh -c "curl -fLo ${HOME_DIR}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Create Neovim configuration files
print_message "Creating Neovim configuration files"
create_nvim_config

# Update Zsh configuration
print_message "Updating Zsh configuration"
update_zshrc

print_message "Neovim configuration completed. Please restart your terminal and run 'nvim' to finish plugin installation."
print_message "After opening Neovim, run :PlugInstall to install all plugins."
