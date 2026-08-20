#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install oh-my-zsh if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install powerlevel10k theme if missing (matches ~/.zshrc source path)
if [ ! -d "$HOME/.powerlevel10k" ]; then
  echo "Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
fi

# Install zsh-autosuggestions plugin if missing
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install tmux if missing
if ! command -v tmux >/dev/null 2>&1; then
  echo "Installing tmux..."
  if [ "$(uname)" = "Darwin" ]; then
    brew install tmux
  else
    sudo apt-get update && sudo apt-get install -y tmux
  fi
fi

# Symlink dotfiles
ln -sf "$DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DIR/p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DIR/tmux.conf" "$HOME/.tmux.conf"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)" "$(whoami)" 2>/dev/null || sudo chsh -s "$(which zsh)" "$(whoami)"
fi

echo "Done. Open a new terminal to see changes."
