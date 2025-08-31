#!/bin/bash

#################
# Define Colors #
#################

# Change colors here if wanted
#   Color Reference Guide: https://misc.flogisoft.com/bash/tip_colors_and_formatting

reset="\[\e[0m\]"


venv_text="\[\e[38;5;36m\]"                 # dunkleres #94E1B4 text
venv_text="\[\e[38;5;36m\]"                 # dunkleres #94E1B4 text
venv_background="\[\e[48;5;36m\]"           # dunkleres #94E1B4 background
venv_background="\[\e[48;5;36m\]"           # dunkleres #94E1B4 background


user_text="\[\e[38;5;72m\]"                  # #69C5A0 text
user_text="\[\e[38;5;72m\]"                  # #69C5A0 text
user_background="\[\e[48;5;72m\]"            # #69C5A0 background
user_background="\[\e[48;5;72m\]"            # #69C5A0 background


host_text="\[\e[38;5;37m\]"                  # #45A994 text
host_text="\[\e[38;5;37m\]"                  # #45A994 text
host_background="\[\e[48;5;37m\]"            # #45A994 background
host_background="\[\e[48;5;37m\]"            # #45A994 background


directory_text="\[\e[38;5;30m\]"             # #288D8A text
directory_text="\[\e[38;5;30m\]"             # #288D8A text
directory_background="\[\e[48;5;30m\]"       # #288D8A background
directory_background="\[\e[48;5;30m\]"       # #288D8A background


git_text="\[\e[38;5;23m\]"                   # #126171 text
git_text="\[\e[38;5;23m\]"                   # #126171 text
git_background="\[\e[48;5;23m\]"             # #126171 background
git_background="\[\e[48;5;23m\]"             # #126171 background


####################
# Define variables #
####################

round_open=""
round_close=""

user="♙  \u"           # icon: ♙
host="🖳  \h"           # icon: 🖳
directory="🗁  \W"     # icon: 🗁


#############
# Functions #
#############

accumulate_ps1() {
    local color_text="$1"
    local color_background="$2"
    local property="$3"

    local open="${color_text}${round_open}${reset}"
    local close="${color_text}${round_close}${reset}"

    accumulated_ps1="${accumulated_ps1}${open}${color_background}${property}${reset}${close} "
}

git_prompt_info() {
    # If not in a repo, return 
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # Get branch
    local branch dirty ahead behind
    branch="⎇  $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    git_info="${branch}"
    accumulate_ps1 "$git_text" "$git_background" "$git_info"

    # Are there local changes? 
    local changes
    changes=$(git status --porcelain 2>/dev/null | wc -l)

    # Get changes from remote repository

    # Ahead / behind of remote branch
    ahead=0
    behind=0
    if git rev-parse "@{upstream}" &>/dev/null; then
        read behind ahead < <(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    fi

    # Add local changes to ahead
    (( ahead += changes ))

    # Build strings
    if [[ $ahead  -gt 0 || $behind -gt 0 ]]; then
        [[ $ahead  -gt 0 ]] && ahead="↑$ahead" || ahead=""
        [[ $behind -gt 0 ]] && behind="↓$behind" || behind=""

        accumulated_ps1="${accumulated_ps1}[${ahead}${behind}] "
    fi
}

build_prompt() {

    accumulated_ps1=""

    # Check if Venv is active
    local venv_name="${VIRTUAL_ENV##*[\\/]}"
    if [[ -n "$venv_name" ]]; then

        # Include Python Venv
        accumulate_ps1 "$venv_text" "$venv_background" "⛭ $venv_name"
    
    fi

    # Include User
    accumulate_ps1 "$user_text" "$user_background" "$user"

    # Include Host
    accumulate_ps1 "$host_text" "$host_background" "$host"

    # Include Directory
    accumulate_ps1 "$directory_text" "$directory_background" "$directory"

    # Include Git    
    git_prompt_info

    # root vs user -> $ oder #
    PS1=$'\n'"${accumulated_ps1}$ "
}


########
# Main #
########

# Set command prompt
PROMPT_COMMAND=build_prompt
