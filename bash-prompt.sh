#!/bin/bash

#################
# Define Colors #
#################

# Change colors here if wanted
#   Color Reference Guide: https://misc.flogisoft.com/bash/tip_colors_and_formatting

reset="\[\e[0m"

color1_text="\[\e[33m"            # Yellow text
color1_background="\[\e[43m"      # Yellow background

color2_text="\[\e[95m"            # Light magenta text
color2_background="\[\e[105m"     # Light magenta background

color3_text="\[\e[96m"            # Light cyan text
color3_background="\[\e[106m"     # Light cyan background


####################
# Define variables #
####################

round_open=""
round_close=""

user="\u"           # icon: ♙
host="\h"           # icon: 🖳
directory="\W"      # icon: 🗁


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
    # sind wir überhaupt in einem Repo?
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch dirty ahead behind
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Änderungen lokal?
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        dirty="*"
    else
        dirty=""
    fi

    # Ahead/Behind vom Remote
    if git rev-parse "@{upstream}" &>/dev/null; then
        read ahead behind < <(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
        [[ $ahead -gt 0 ]] && ahead="↑$ahead" || ahead=""
        [[ $behind -gt 0 ]] && behind="↓$behind" || behind=""
    fi

    echo "${branch}${dirty}${ahead}${behind}"
}

build_prompt() {

    accumulated_ps1="\n"

    # Check if Venv is active
    local venv_name="${VIRTUAL_ENV##*[\\/]}"
    if [[ -n "$venv_name" ]]; then

        # Include Python Venv
        accumulate_ps1 "$color1_text" "$color1_background" "$venv_name"
    
    fi

    # Include User
    accumulate_ps1 "$color1_text" "$color1_background" "$user"

    # Include Host
    accumulate_ps1 "$color2_text" "$color2_background" "$host"

    # Include Directory
    accumulate_ps1 "$color3_text" "$color3_background" "$directory"

    # Check if currently in git repo
    local git_info
    git_info=$(git_prompt_info)
    if [[ -n "$git_info" ]]; then
        accumulate_ps1 "$color2_text" "$color2_background" "$git_info"
    fi

    # root vs user -> $ oder #
    PS1="${accumulated_ps1}\$ "
}


###########
# Combine #
###########


# Set hook so build_prompt runs before each prompt
PROMPT_COMMAND=build_prompt
