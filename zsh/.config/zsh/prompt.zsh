# Load colors and enable git
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# setup a hook that runs before every prompt. 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt PROMPT_SUBST

# add a function to check for untracked files in the directory.
# from https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' formats '%F{4}%F{3} on %F{5}[%F{4}%b%F{5}]%f '
# zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})"
zstyle ':vcs_info:git:*' formats " %{$fg[red]%}%m%u%c%%{$fg[yellow]%} on %{$fg[blue]%}(%{$fg[magenta]%}%b%{$fg[blue]%})"

# prompt classic
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# prompt 2.0
PS1='%B%{$fg[green]%}➜ %B%{$fg[blue]%}[%{$fg[yellow]%}%n %{$fg[magenta]%}%~%{$fg[blue]%}]%{$reset_color%}'
PROMPT+="\$vcs_info_msg_0_ "
