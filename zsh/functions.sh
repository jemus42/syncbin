######################
## Setting stuff up ##
######################

# Since Homebrew has linux support (v2.0), this shouldn't be necessary soonish
function install_linuxbrew() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  $(brew --prefix)/bin/brew shellenv >>~/.profile
  $(brew --prefix)/bin/brew shellenv >>~/.env.local
}

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# Dump files to my filedump, because dump
function dump {
  rsync -avh --progress "$@" -e ssh mercy:/mnt/data/dump.jemu.name
  FILE=$(basename $1)
  if [[ $ME == "Lukas" ]]; then
    echo "https://dump.jemu.name/$FILE" | pbcopy
  else 
      echo "https://dump.jemu.name/$FILE"
  fi
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $FILE – http://dump.jemu.name/$FILE" >> $HOME/.dumplog
  terminal-notifier -title "Filedump" -message "$FILE" -execute code $HOME/.dumplog;
}

function reload() {
  echo "Updating syncbin at $SYNCBIN..."
  git -C $SYNCBIN pull origin master
  echo ""
  echo "Re-installing..."
  $SYNCBIN/install.sh
  echo ""
  echo "Nuking zcompdump at $ZSH_COMPDUMP..."
  rm -f $ZSH_COMPDUMP
  echo "Reloading ZSH via 'src' alias..."
  echo ""
  src
}

##############
## Updating ##
##############

function upall() {

  case $( uname -s ) in
  Linux)  
    echo "################################"
    echo "## Updating platform packages ##"
    echo "################################"
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y

    if (( $+commands[brew] )); then
      echo ""
      echo ""
      echo "#######################"
      echo "## Updating homebrew ##"
      echo "#######################"
      brew upgrade
    fi
    ;;
  Darwin) 

    if (( $+commands[brew] )); then
      echo "#######################"
      echo "## Updating homebrew ##"
      echo "#######################"
      echo ""
      brew upgrade

      echo ""
      echo "#############################"
      echo "## Updating homebrew casks ##"
      echo "#############################"
      echo ""
      brew upgrade --cask
    fi

    if (( $+commands[mas] )); then
      echo ""
      echo "########################"
      echo "## Updating App Store ##"
      echo "########################"
      echo ""
      echo "mas version $(mas version)"
      mas upgrade
      echo ""
    fi

    echo "#########################"
    echo "## Updating R packages ##"
    echo "#########################"
    echo ""
    # if (( $+commands[rupdate] )); then
    #   rupdate
    # else
        # Rscript --quiet --no-init-file -e \
        # 'update.packages(repos = "https://cloud.r-project.org", ask = FALSE, type = "binary")'
        
        Rscript --quiet --no-init-file -e \
        'remotes::update_packages(repos = "https://cloud.r-project.org", type = "binary")'
    #  echo "Can't find rupdate, is rt installed?"
    #  echo "Run remotes::install_github('rdatsci/rt')"
    # fi

    # echo ""
    # echo "#########################"
    # echo "Backing up iterm2 config"
    # # cp $HOME/Library/Preferences/com.googlecode.iterm2.plist $SYNCBIN/com.googlecode.iterm2.plist
    # plutil -convert xml1 -o - $HOME/Library/Preferences/com.googlecode.iterm2.plist > $SYNCBIN/com.googlecode.iterm2-xml.plist 
    # echo "#########################"
    # echo ""

    ;;
  FreeBSD) 
    echo "################################"
    echo "## Updating platform packages ##"
    echo "################################"
    echo ""
    if [[ $ME = root ]]; then
      pkg update
      pkg upgrade -y
      pkg clean
      pkg autoremove -y    
    else 
      sudo pkg update
      sudo pkg upgrade -y
      sudo pkg clean
      sudo pkg autoremove -y
    fi
    ;;
  *) 
    echo "Don't know how to update on this platform: $(uname -s)"
    ;;
  esac

  echo ""
  echo "######################"
  echo "## Updating syncbin ##"
  echo "######################"

  git -C $SYNCBIN pull origin master
    # git -C $SYNCBIN submodule update --recursive --remote
    git -C $SYNCBIN submodule update --rebase --remote


  echo ""
  echo "## Syncbin updated. Use 'reload' to apply changes or relog ##"
  echo ""
  echo "##---- Done updating --- $(timestamp) ----##"
}

# Benachmarking ZSH startup
function zsh_bench() {
    zsh -xvlic 'source ~/.zshrc' 2>&1 | ts -i '%.s' > zsh_startup_${HOST/.*/}_$(date +%F_%T).log
    echo DONE
}

####################################################################################
### Combining PDFs using gs because I needed it once and want to never forget it ###
####################################################################################
# Using gs because it keeps outline items and bookmarks, which pdfunite did not keep.
function pdfcombine () {
  echo "Output: $1"
  echo "Input: $@[2,-1]"
  gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$1 $@[2,-1]
}
