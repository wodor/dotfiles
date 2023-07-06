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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions


# A.
setopt promptsubst

# B.
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git 

PS1="READY >" # provide a simple prompt till the theme loads

# C.
zinit wait'!' lucid for \
    OMZL::prompt_info_functions.zsh 


zinit ice depth=1; zinit light romkatv/powerlevel10k
# D.
# zinit wait lucid for \
#   atinit"zicompinit; zicdreplay"  \
#         zdharma-continuum/fast-syntax-highlighting \
#       OMZP::colored-man-pages 

zi ice binary from'gh-r' sbin'**/lsd -> lsd' \
  atclone'cp lsd-*/lsd.1 $ZI[MAN_DIR]/man1; ln -s lsd-*/*/_lsd _lsd'
zi light Peltoche/lsd

zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/history-search-multi-word
zinit light blimmer/zsh-aws-vault
zinit light sroze/docker-compose-zsh-plugin
zinit light gerges-zz/oh-my-zsh-jira-plus
zinit light MichaelAquilina/zsh-you-should-use
zinit light tom-doerr/zsh_codex
zinit light z-shell/zsh-lsd