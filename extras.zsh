source ~/dotfiles/.aliases

bindkey \^U backward-kill-line  # delete from cursor, not whole line

# | Up/down prefix search |---------------------
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# | ls |----------------------------------------
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# | yazi |--------------------------------------
if command -v yazi >/dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# | zoxide |------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# | zsh-syntax-highlighting |-------------------
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
