# Zsh has been adopted as the default shell for macOS Catalina.

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#common folders
alias home="cd ~"
alias doc="cd ~/Documents"
alias dow="cd ~/Downloads"
alias dt="cd ~/Desktop"

# Define `setproxy` command to enable proxy configuration
setproxy() {
  export http_proxy="http://localhost:7890"
  export https_proxy="http://localhost:7890"
}

# Define `unsetproxy` command to disable proxy configuration
unsetproxy() {
  unset http_proxy
  unset https_proxy
}

timestamp=$( date +%T )

# XCode
findxcworkspace() {
    # shopt -s nullglob dotglob
    # printf "path:$1
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            if [[ $pathname =~ ".xcodeproj"$ ]]; then
                continue
            elif [[ $pathname =~ ".xcworkspace"$ ]]; then
                echo $pathname
                break 2
            else 
                findxcworkspace "$pathname"
            fi
        fi
    done
}

findxcodeproj() {
    # shopt -s nullglob dotglob
    # printf "path:$1
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            if [[ $pathname =~ ".xcodeproj"$ ]]; then
                echo $pathname
                break 2
            elif [[ $pathname =~ ".xcworkspace"$ ]]; then
                continue
            else 
                findxcworkspace "$pathname"
            fi
        fi
    done
}
xcws() {
    local xcworkspace=$(findxcworkspace .)
    echo 'xcode open '$xcworkspace''
    open $xcworkspace
}
xcp() {
    local xcodeproj=$(findxcodeproj .)
    echo 'xcode open '$xcodeproj''
    open $xcodeproj
}

# Git
diff_file_path="$HOME/Desktop/${timestamp}.diff"
alias gd="git diff --color > ${diff_file_path} && code -r ${diff_file_path}"

# Flutter
export PATH="$PATH:$HOME/flutter/bin"

# system
alias sleep="open -a ScreenSaverEngine.app"
