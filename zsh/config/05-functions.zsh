# Shell Functions
# Custom functions and complex command definitions

# File dump utility
function dump {
  for filearg in "$@"; do
    rsync -avh --progress "${filearg}" -e ssh horst:"dump.jemu.name"
    FILE=$(basename $filearg)
    if [[ $ME == "Lukas" ]]; then
      echo "https://dump.jemu.name/$FILE" | pbcopy
    else
      echo "https://dump.jemu.name/$FILE"
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $FILE – http://dump.jemu.name/$FILE" >> $HOME/.dumplog
    if (( $+commands[terminal-notifier] )); then
      terminal-notifier -title "Filedump" -message "$FILE" -execute code $HOME/.dumplog;
    fi
  done
}

# Reload syncbin configuration
function reload () {
  echo "Updating syncbin at $SYNCBIN..."
  git -C $SYNCBIN pull --recurse-submodules origin main
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

# System update function
function upall () {
  case $( uname -s ) in
  Linux)
    echo "####################################"
    echo "##   Updating platform packages   ##"
    echo "####################################"
    if (( $+commands[nala] )); then
      sudo nala upgrade -y
      sudo nala autoremove
    else
      sudo apt update
      sudo apt upgrade -y
      sudo apt autoclean -y
      sudo apt autoremove -y
    fi

    if (( $+commands[brew] )); then
      echo ""
      echo ""
      echo "####################################"
      echo "##        Updating homebrew       ##"
      echo "####################################"
      brew upgrade
    fi
    ;;
  Darwin)
    if (( $+commands[brew] )); then
      echo "####################################"
      echo "##        Updating homebrew       ##"
      echo "####################################"
      echo ""
      brew upgrade
    fi

    echo "####################################"
    echo "##      Updating R packages       ##"
    echo "####################################"
    echo ""
    Rscript --quiet -e \
    'remotes::update_packages(type = "binary")'
    ;;
  FreeBSD)
    echo "####################################"
    echo "##   Updating platform packages   ##"
    echo "####################################"
    echo ""
    if [[ $ME = root ]]; then
      pkg update
      pkg upgrade -y
      pkg clean -y
      pkg autoremove -y
    else
      sudo pkg update
      sudo pkg upgrade -y
      sudo pkg clean -y
      sudo pkg autoremove -y
    fi
    ;;
  *)
    echo "Don't know how to update on this platform: $(uname -s)"
    ;;
  esac

  echo ""
  echo "####################################"
  echo "##        Updating syncbin        ##"
  echo "####################################"

  git -C $SYNCBIN pull origin main
  git -C $SYNCBIN submodule update --recursive --rebase --remote
  omz reload

  echo ""
  echo "## Syncbin updated ##"
  echo ""
  echo "##---- Done updating --- $(timestamp) ----##"
}

# ZSH startup benchmarking
zsh_bench () {
  zsh -xvlic 'source ~/.zshrc' 2>&1 | ts -i '%.s' > zsh_startup_${HOST/.*/}_$(date +%F_%T).log
  echo DONE
}

# PDF manipulation
pdfcombine () {
  echo "Output: $1"
  echo "Input: $@[2,-1]"
  gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$1 $@[2,-1]
}

# Video compression and conversion
compavc () {
  ffmpeg -i "$1" -vcodec libx264 -crf 23 $(echo $1 | sed -e 's/\.(mp4|mkv)//')-comp.mp4
}

gif2mp4 () {
  TEMPGIF=$(mktemp)
  ffmpeg -stream_loop 10 -i "${1}" ${TEMPGIF}.gif -y;
  ffmpeg -i ${TEMPGIF}.gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${1%.gif}.mp4"
  rm tmp-loop.gif
}

ffsilent () {
  ffmpeg -i "$1" -c copy -an "$1-nosound.${1#*.}"
}

# Image processing
alpha2white () {
  convert "$1" -background white -alpha remove -alpha off "$1"
}

imgcrop () {
  magick mogrify -bordercolor white -fuzz 2% -trim -format png "$1"
}

# Git utilities
git-find-large-files () {
  git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

git-disk-usage () {
  git for-each-ref --format='%(refname)' |
  while read branch; do
      size=$(git rev-list --disk-usage=human --objects HEAD..$branch)
      echo "$size $branch"
  done |
  sort -h
}

gitit () {
  git commit -am "Formatting / typo / trivial change ($(date +%Y%m%d%H%M%S))" && git push
}

git-timetravel () {
  if [ -z "${1}" ]; then
      echo "Must provide a valid timestamp in roughly ISO 8601"
      echo "Example: git-timetravel \"2022-10-01 12:00\" main"
      exit 1
  fi

  if [ -z "${2}" ]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Guessing branch: ${BRANCH}"
  else
    BRANCH=${2}
  fi

  git checkout "$(git rev-list -n 1 --first-parent --before=\"${1}\" ${BRANCH})"
}

# Download utilities
aria () {
  aria2c --seed-time=0 --max-concurrent-downloads=5 $@
}

# Development environment
prefer-conda () {
  export PATH="$HOME/Library/r-miniconda/bin:$PATH"
  typeset -aU path
}

# LaTeX cleanup
cleantex () {
  rm -rf *.out *.dvi *.log *.aux *.bbl *.blg *.ind *.idx *.ilg *.lof *.lot *.toc *.nav *.snm *.vrb *.fls *.fdb_latexmk *.synctex.gz *-concordance.tex
}

# R package management
function upr-base {
  R -e "update.packages(ask = FALSE)"
}

function upr {
  R -e "remotes::update_packages()"
}

# Makefile validation
checkmake () {
  rg "^[^\S\t\n\r]" < Makefile
}

# RStudio launcher
rstudio () {
  if [[ -z "$1" ]]; then
    FILE="$(find . -maxdepth 1 -iname '*.Rproj')"
  else
    FILE="$1"
  fi

  echo "Opening $FILE with RStudio..."
  open -a RStudio.app "$FILE"
}

# Help function with bat pager
alias bathelp='bat --plain --language=help'
help() {
  "$@" --help 2>&1 | bathelp
}