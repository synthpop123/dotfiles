### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Environment Variables
export PATH="/Users/lkw123/Library/Python/3.9/bin:$HOME/.cargo/bin:$PATH"
export BAT_THEME="Monokai Extended Origin"
export STARSHIP_CONFIG="/Users/lkw123/.config/starship/starship.toml"
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" 2> /dev/null'

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Add in zsh plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light atuinsh/atuin

# Load completions
autoload -Uz compinit && compinit

### End of Zinit's installer chunk

# History
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# fzf-tab init and styling
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons -1 --color=always $realpath'

# Aliases
alias cls="clear"
alias ls="eza"
alias ll="eza --time-style=default --icons --git -l"
alias la="eza --time-style=long-iso --icons --group --git --binary -la"
alias cat="bat"
alias tree="eza --tree --icons"
alias upgrade="brew update && brew upgrade && brew cu --all --yes --cleanup && mas upgrade && brew cleanup --prune=all"
alias v="nvim"
alias history="history 1"
alias pf='fzf --preview='\''bat --color=always --style=header,grid --line-range :500 {}'\'' --bind shift-up: preview-page-up,shift-down:preview-page-down'

 # Bat + Ripgrep + Fzf + Vim
 rfv() (
   RELOAD='reload:rg --column --color=always --smart-case {q} || :'
   OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
             vim {1} +{2}     # No selection. Open the current line in Vim.
           else
             vim +cw -q {+f}  # Build quickfix list for the selected items.
           fi'
   fzf --disabled --ansi --multi \
       --bind "start:$RELOAD" --bind "change:$RELOAD" \
       --bind "enter:become:$OPENER" \
       --bind "ctrl-o:execute:$OPENER" \
       --delimiter : \
       --preview 'bat --style=header,grid --color=always --line-range :500 --highlight-line {2} {1}' \
       --preview-window '~4,+{2}+4/3,<80(up)' \
       --query "$*"
 )

# Shell integrations
eval "$(starship init zsh)"
eval "$(thefuck --alias)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd)"

# pnpm
export PNPM_HOME="/Users/lkw123/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
