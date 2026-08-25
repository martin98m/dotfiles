# Symlinked to ~/.zshenv. zsh always reads this file from $HOME first, so it's
# the only dotfile that has to live directly in $HOME — it just points zsh at
# the real config directory.
export ZDOTDIR="$HOME/.config/zsh"
