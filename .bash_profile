timestamp=$( date +%T )

# find document
finddir() {
    shopt -s nullglob dotglob
    # printf "path:$1 format:$2\n"
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            if [[ -n "$2" ]]; then
                if [[ $pathname =~ "$2"$ ]]; then
                    echo $pathname
                    break 2
                else 
                    finddir "$pathname" $2
                fi
            else
                finddir "$pathname"
            fi
        fi
    done
}


# source .base_profile
alias ebp="cd ~/ && vim .bash_profile"

# source .base_profile
alias sbp="cd ~/ && source .bash_profile"

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#common folders
alias home="cd ~"
alias doc="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"


# Chrome
url() { 
  if [ $# -eq 0 ]
    then
      echo "No arguments supplied"
    else
      if [[ $1 == http* ]]
        then
          open -a 'Google Chrome' "$1";
        else
          open -a 'Google Chrome' "http://$1";
      fi
  fi
}

gg() { open -a 'Google Chrome' "http://www.google.com/search?q= $1"; }

# XCode
findxcworkspace() {
    shopt -s nullglob dotglob
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
    shopt -s nullglob dotglob
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


# Proxy
setproxy() {
  export http_proxy="http://localhost:7890"
  export https_proxy="http://localhost:7890"
}

unsetproxy() {
  unset http_proxy
  unset https_proxy
}


# Flutter
export PATH="$PATH:$HOME/flutter/bin"
