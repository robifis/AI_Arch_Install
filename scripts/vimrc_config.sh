#!/bin/bash

# install_vim_config.sh

# Check if Vim is installed
if ! command -v vim &> /dev/null; then
    echo "Vim is not installed. Installing Vim..."
    sudo apt update && sudo apt install vim -y
fi

# Install curl if not present
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing curl..."
    sudo apt update && sudo apt install curl -y
fi

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "git is not installed. Installing git..."
    sudo apt update && sudo apt install git -y
fi

# Install nodejs and npm for CoC
if ! command -v node &> /dev/null; then
    echo "nodejs is not installed. Installing nodejs and npm..."
    sudo apt update && sudo apt install nodejs npm -y
fi

# Backup existing .vimrc if it exists
if [ -f ~/.vimrc ]; then
    echo "Backing up existing .vimrc to .vimrc.backup"
    mv ~/.vimrc ~/.vimrc.backup
fi

# Install Vim-Plug
echo "Installing Vim-Plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
echo "Installing Vim plugins..."
vim +PlugInstall +qall

# Install CoC extensions
echo "Installing CoC extensions..."
vim "+CocInstall coc-json coc-tsserver coc-html coc-css" +qall

echo "Vim configuration completed successfully!"
