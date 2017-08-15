source ~/dotfiles/antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# $b atom
antigen bundle brew
antigen bundle brew-cask
# Guess what to install when running an unknown command.
antigen bundle command-not-found
antigen bundle composer
antigen bundle docker
antigen bundle extract
# antigen bundle common-aliases
# antigen bundle git
# antigen bundle gitfast
# antigen bundle git-extras
antigen bundle heroku
antigen bundle httpie
antigen bundle last-working-dir
antigen bundle lol
antigen bundle vagrant
antigen bundle osx

# antigen bundle sudo
antigen bundle symfony2
# antigen bundle web-search
antigen bundle arialdomartini/oh-my-git

# Tracks your most used directories, based on 'frecency'.
antigen bundle robbyrussell/oh-my-zsh plugins/z

# nicoulaj's moar completion files for zsh
antigen bundle zsh-users/zsh-completions src

# Syntax highlighting on the readline
antigen bundle zsh-users/zsh-syntax-highlighting

# colors for all files!
antigen bundle trapd00r/zsh-syntax-highlighting-filetypes

# history search
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

# dont set a theme, because pure does it all
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure

# suggestion as you type
antigen bundle zsh-users/zsh-autosuggestions

antigen theme agnoster

#antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen theme ~/dotfiles/zsh wodor

# Tell antigen that you're done.
antigen apply

# Enable autosuggestions automatically
# zle-line-init() {
#     zle autosuggest-start
# }

zle -N zle-line-init

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Aliases and functions
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan,bold'

# Commands and builtins
ZSH_HIGHLIGHT_STYLES[command]="fg=green"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=green,underline"
ZSH_HIGHLIGHT_STYLES[commandseparator]="none"

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold'

# Options and arguments
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=red'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=red'

ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=green"

# Patterns
ZSH_HIGHLIGHT_PATTERNS+=('mv *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
