#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export STM32_PRG_PATH=/home/maskop/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin