#!/bin/bash

#################
# Define Colors #
#################

# Change colors here if wanted
#   Color Reference Guide: https://misc.flogisoft.com/bash/tip_colors_and_formatting
reset_terminal="\e[0m"

color1_text="\e[33m"            # Yellow text
color1_background="\e[43m"      # Yellow background

color2_text="\e[95m"            # Light magenta text
color2_background="\e[105m"     # Light magenta background

color3_text="\e[96m"            # Light cyan text
color3_background="\e[106m"     # Light cyan background


####################
# Define variables #
####################

round_open=""
round_close=""

user="♙  \u "
host="🖳  \h "
directory="🗁  \w "

###########
# Combine #
###########

user_w_color="${color1_text}${round_open}${reset_terminal}${color1_background}${user}${reset_terminal}${color1_text}${round_close}${reset_terminal}"
host_w_color="${color2_text}${round_open}${reset_terminal}${color2_background}${host}${reset_terminal}${color2_text}${round_close}${reset_terminal}"
directory_w_color="${color3_text}${round_open}${reset_terminal}${color3_background}${directory}${reset_terminal}${color3_text}${round_close}${reset_terminal}"

PS1="${user_w_color} ${host_w_color} ${directory_w_color} $ "