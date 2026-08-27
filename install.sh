#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OMZ_DIR="$DIR/zsh/oh-my-zsh"
ZSH_CUSTOM="$OMZ_DIR/custom"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"

# Install oh-my-zsh (vendored inside the dotfiles repo, not $HOME) if missing.
# Reuse an existing ~/.oh-my-zsh from an older version of this script instead
# of re-cloning, if present.
if [ ! -d "$OMZ_DIR" ]; then
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Moving existing ~/.oh-my-zsh into dotfiles repo..."
    mv "$HOME/.oh-my-zsh" "$OMZ_DIR"
  else
    echo "Installing oh-my-zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
  fi
fi

# Install powerlevel10k as an oh-my-zsh custom theme (the officially
# supported integration) if missing.
if [ ! -d "$P10K_DIR" ]; then
  if [ -d "$HOME/.powerlevel10k" ]; then
    echo "Moving existing ~/.powerlevel10k into dotfiles repo..."
    mkdir -p "$ZSH_CUSTOM/themes"
    mv "$HOME/.powerlevel10k" "$P10K_DIR"
  else
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  fi
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

# Symlink dotfiles. Only ~/.zshenv has to live directly in $HOME (zsh always
# reads it from there); it just points ZDOTDIR at ~/.config/zsh, so the real
# zshrc lives under XDG_CONFIG_HOME like everything else.
mkdir -p "$HOME/.config/zsh" "$HOME/.config/tmux"
ln -sf "$DIR/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$DIR/zsh/zshrc" "$HOME/.config/zsh/.zshrc"
ln -sf "$DIR/zsh/zprofile" "$HOME/.config/zsh/.zprofile"
ln -sf "$DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Clean up symlinks left by older versions of this script that pointed
# straight into $HOME.
for f in "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.tmux.conf"; do
  [ -L "$f" ] && rm -f "$f"
done

# Symlink personal scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$DIR/bin/git-install-local-guard" "$HOME/.local/bin/git-install-local-guard"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)" "$(whoami)" < /dev/null 2>/dev/null ||
    sudo chsh -s "$(which zsh)" "$(whoami)" < /dev/null 2>/dev/null ||
    echo "Warning: could not set zsh as default shell; do it manually."
fi

echo "Done. Open a new terminal to see changes."
