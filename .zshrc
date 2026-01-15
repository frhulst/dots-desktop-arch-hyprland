# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bureau"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

COMPLETION_WAITING_DOTS="true"

# Add plugins here
plugins=(git genpass ssh kitty)

source $ZSH/oh-my-zsh.sh

# User configuration
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# set sudo editor
export SUDO_EDITOR="nvim"


# SETTING FABRIC 
# Loop through all files in the ~/.config/fabric/patterns directory
# for pattern_file in $HOME/.config/fabric/patterns/*; do
#     # Get the base name of the file (i.e., remove the directory path)
#     pattern_name=$(basename "$pattern_file")
#
#     # Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
#     alias_command="alias $pattern_name='fabric --pattern $pattern_name'"
#
#     # Evaluate the alias command to add it to the current shell
#     eval "$alias_command"
# done

yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    fi

    transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
        transcript_flag="--transcript-with-timestamps"
        shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
}

# Custom exports
export OLLAMA_HOME="$HOME/.ollama"

# Set aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias "sudoedit"='function _sudoedit(){sudo -e "$1";};_sudoedit'
alias gowebcam="sudo gopro webcam -a -r 1080 -f linear"
alias fabric='fabric-ai'
alias py='python'
alias gocker='~/.venv-PythonApps/bin/gocker'
alias dots='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias subextractor='sh ~/.scripts/mkv_sub_extractor.sh'

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/maskop/.dart-cli-completion/zsh-config.zsh ]] && . /home/maskop/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

fastfetch
