

timestamp=$( date +%T )



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


#Chrome
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


#Git
diff_file_path="$HOME/Desktop/${timestamp}.diff"

alias gd="git diff --output=${diff_file_path} && code -r ${diff_file_path}"



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



# Flutter
export PATH="$PATH:$HOME/flutter/bin"