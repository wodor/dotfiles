# CodeWhisperer pre block. Keep at the top of this file.
#[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [ -n "$ITERM_PROFILE" ];
then
    #zmodload zsh/zprof

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    for file in ~/.zsh/{completion,config,history,fasd,aliases,zinit,copilot}.zsh; do
      [ -r "$file" ] && source "$file"
    done
    unset file

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

    # check if we're using an iTerm2 profile that's non- or low-interactive
    # htop profiles should mostly be non-interactive
    if echo "$ITERM_PROFILE" | grep -q "^arbor-";
    then
      aws sso login --profile $ITERM_PROFILE
      alias aws="aws --profile $ITERM_PROFILE"
    fi

    # Git configuration for iTerm profiles
    # Create a git alias that includes the full config when ITERM_PROFILE is set
    git config --global alias.iterm '!git -c include.path=~/.full.gitconfig'
    alias git="git iterm"
    source /Users/artwielogorski/.apiKeys
    #zprof
fi

DEFAULT_USER=`whoami`

export GOPATH="/usr/local"
export GOBIN=/usr/local/bin

export HOMESHICK_DIR=/opt/homebrew/opt/homeshick
source "/opt/homebrew/opt/homeshick/homeshick.sh"

iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}


function csfix(){
  php -d memory_limit=-1 ./vendor/bin/php-cs-fixer fix --config .php-cs-fixer.php --path-mode=override -- $(git diff --name-only  --diff-filter=ACMRTUXB)
}
function csfix81(){
  php81 -d memory_limit=-1 ./vendor/bin/php-cs-fixer fix --config .php-cs-fixer.php --path-mode=override -- $(git diff --name-only  --diff-filter=ACMRTUXB)
}

function ssm () {
    aws-vault exec arbor-prod -- aws ssm start-session --target $1
}

function ssm-qa () {
    aws-vault exec arbor-qa -- aws ssm start-session --target $1
}

function get_task_id_prod() {
 local cluster_name="sis-base-$1"
 aws-vault exec arbor-prod -- aws ecs list-tasks --cluster $cluster_name --service-name config-generator --query 'taskArns[0]' --output text | cut -d'/' -f3
}

function get_task_id() {
 local cluster_name="sis-base-$1"
 aws-vault exec arbor-qa -- aws ecs list-tasks --cluster $cluster_name --service-name config-generator --query 'taskArns[0]' --output text | cut -d'/' -f3
}

function process_updates() {
  TASK_ID=$(get_task_id $1)
  echo $TASK_ID
  aws-vault exec arbor-qa -- aws ecs execute-command --cluster "sis-base-$1" --container config-generator --interactive --command "/app/bin/console config:process-deferred-updates" --task $TASK_ID
}

function show_config() {
  aws-vault exec arbor-qa -- aws ecs execute-command --cluster "sis-base-$1" --container config-generator --interactive --command "cat /mnt/efs/qa/$1/$2" --task $(get_task_id $1)
}

# Git function that conditionally includes full config when ITERM_PROFILE is set
function git() {
    if [ -n "$ITERM_PROFILE" ]; then
        command git -c include.path=~/.full.gitconfig "$@"
    else
        command git "$@"
    fi
}

export LOLCOMMITS_DIR=/Users/artwielogorski/.lolcommits
export EDITOR='vim'




export PATH="$PATH:$HOME/.local/bin"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.symfony5/bin:$PATH
export PATH=$PATH:/Applications/PhpStorm.app/Contents/MacOS
export PATH="$PATH:/Users/artwielogorski/.cache/lm-studio/bin"
# for make
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"
export PATH="/Users/artwielogorski/.codeium/windsurf/bin:$PATH"


alias ssh.admin="aws-vault exec arbor-prod -- aws ssm start-session --target i-0c7b56b115cbe867e"
alias ssm='/Users/artwielogorski/code/devops.scripts/bash/ssm-connect/ssm-connect.sh'


[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export PATH="$HOME/.local/bin:$PATH"
