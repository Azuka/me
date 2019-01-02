# Define colors
NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"
ZSH_THEME="robbyrussell"

# Init rbenv
# eval "$(rbenv init -)"
# Ignore commands starting with a space
setopt HIST_IGNORE_SPACE

# Turn off syslog cmd prompts
mesg n

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gpg-agent vagrant git-extras sudo git_remote_branch history composer osx history-substring-search docker wd kubectl)

# User configuration

export PATH="$HOME/go/bin:/Users/azuka_okuleye-okwuedei/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/git/bin:/usr/local/php5/bin:/usr/local/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

# Go setup
export GOPATH=$HOME/go
export GOROOT=$(go env GOROOT)
export PATH=$PATH:$GOPATH/bin
export CDPATH=.:$GOPATH/src/github.com:$GOPATH/src/bitbucket.org

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Confirm function
confirm () {
	# Read question or use default
    question="${1:-Are you sure?} (y/N)"
    # Print question
    printf '\033[1;37;41m %s \033[0m ' $question
    # call with a prompt string or use a default
    read response
    # Match all yes responses
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

#Tunnel function
tunnel() {
	ssh -nNT -L "${1}:localhost:${2}" $3 &
	echo "SSH tunnel opened for ${3}:${2} accessible at localhost:${1}"
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#Key Bindings
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Aliases from Bash
alias cls='printf "\033c"'
alias gadd='git add --all'
alias gcommit='git commit -S -a -m'
alias gfix='gadd; git commit --amend --gpg-sign='
alias gpull='git pull'
alias gpush='git push'
alias gco='git checkout'
alias gstatus='git status'
alias gstash='git stash'
alias gpop='git stash pop'
gcopfunc() {
	gco "$1"
	gpull --rebase
}
gcobfunc() {
    gco -b "$1"
    gpush -u origin "$1"
}
gcsv() {
	echo 'Commit ID,Author,Relative,Date,Message'
	git log --pretty=format:'%H,%an,%ar,%ai,%s' --since='$1'
}
# Multi Dir Exec (WIP)
mexec() {
    find . -mindepth 1 -maxdepth 1 -type d | xargs -I'{}' \
    /bin/zsh -c "echo '{}:\n==================='; (cd {} && $@); echo ''";
    # find . -mindepth 1 -maxdepth 1 -type d -exec /bin/bash -c "(cd {} && $@)" \;
    # /bin/bash -c "echo '{}:\n==================='; (cd {}; ${@};); echo ''"
    # printf "echo '{}:\n==================='; (cd {} && ${@}); echo ''"
}
mexec2()
{
  export THE_COMMAND=$@
  find . -type d -maxdepth 1 -mindepth 1 -print0 | xargs -0 -I{} zsh -c 'cd "{}" && echo "{}" && echo "$('$THE_COMMAND')" && echo -e'
  # find . -type d -maxdepth 1 -mindepth 1 | xargs -I{} zsh -c 'cd "{}" && echo "{}" && echo "$('$THE_COMMAND')" && echo -e'
  # for d in ./*/ ; do /bin/zsh -c "(cd "$d" && "$@")"; done
}
# Git Functions
alias gcop=gcopfunc
alias gcu='git symbolic-ref --short HEAD'
alias gpf='git fetch --all; confirm "This will overwrite local branches" && ghard "origin/`gcu`"'
alias gpb='gpush -u origin `gcu`'
alias gpp='gpull --rebase && gpush'
alias grab='gstash; gpull; gstash pop'
alias gsoft='git reset --soft "HEAD^"'
alias ghead='git reset HEAD'
alias ghard='git reset --hard'
alias gfetch='git fetch --all'
alias gprune='git fetch origin  && git remote prune origin'
alias gcn='confirm "THIS WILL REMOVE ALL LOCAL BRANCHES THAT HAVE BEEN MERGED!" && git fetch -p && git branch -vv | gawk '"'"'{print $1,$4}'"'"' | grep '"'"'gone]'"'"' | gawk '"'"'{print $1}'"'"' | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -D && gprune'
alias gcn2='git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'

# Config edits
alias ezsh='vim ~/.zshrc'
alias szsh='sublime ~/.zshrc'
alias azsh='atom ~/.zshrc'
# Utilities
alias composer="php -d memory_limit=-1 /usr/local/bin/composer"
alias cup="sudo /usr/bin/composer.phar selfupdate"
alias rzsh='source ~/.zshrc' # Reload this config
alias puml="java -jar ~/bin/plantuml.jar"
alias updatedb='sudo /usr/libexec/locate.updatedb'
export GIT_MERGE_AUTOEDIT=no

func kproxy() {
    echo "${OK_COLOR}Stopping all previous kubernetes proxy instances${NO_COLOR}"
    killall kubectl
    echo "${OK_COLOR}Retrieving token for service account tiller-deploy from server"
    local TOKEN=$(\
        kubectl get serviceaccount tiller-deploy -n kube-system -o json | \
        jq -r '.secrets[0].name' | \
        xargs kubectl get secret -n kube-system -o json | \
        jq -r '.data.token' | \
        base64 --decode \
    )
    echo "${OK_COLOR}Starting proxy in background${NO_COLOR}"
    kubectl proxy &
    sleep 1
    echo $TOKEN | pbcopy
    echo "${OK_COLOR}Your token is now in your clipboard. Enjoy!${NO_COLOR}"
    open http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Azure
autoload bashcompinit && bashcompinit
source '/Users/azuka_okuleye/lib/azure-cli/az.completion'

# AWS
source /usr/local/bin/aws_zsh_completer.sh

# Helm
source <(helm completion zsh)

#Stern
source <(stern --completion=zsh)
