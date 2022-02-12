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
  echo "Reloading ZSH via omz reload..."
  echo ""
  omz reload
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

    # if (( $+commands[mas] )); then
    #   echo ""
    #   echo "########################"
    #   echo "## Updating App Store ##"
    #   echo "########################"
    #   echo ""
    #   echo "mas version $(mas version)"
    #   mas upgrade
    #   echo ""
    # fi

    echo "#########################"
    echo "## Updating R packages ##"
    echo "#########################"
    echo ""
    Rscript --quiet -e \
    'remotes::update_packages(type = "binary")'

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

  git -C $SYNCBIN pull origin main
    # git -C $SYNCBIN submodule update --recursive --remote
  git -C $SYNCBIN submodule update --recursive --rebase --remote
  omz reload

  echo ""
  echo "## Syncbin updated ##"
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

# Compress video with fixed CRF 23, append suffix, make it an mp4
compavc () {
  ffmpeg -i $1 -vcodec libx264 -crf 23 $(echo $1 | sed -e 's/\.(mp4|mkv)//')-comp.mp4
}

# Silence a video
function ffsilent { ffmpeg -i $1 -c copy -an "$1-nosound.${1#*.}" }

# From https://stackoverflow.com/a/42544963/409362
function git-find-large-files () {
  git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}


function prefer-conda () {
  export PATH="$HOME/Library/r-miniconda/bin:$PATH"
  typeset -aU path
}
