# Shell Functions
# Custom functions and complex command definitions


# Reload syncbin configuration
reload() {
  echo "Updating syncbin at $SYNCBIN..."
  git -C "$SYNCBIN" pull --recurse-submodules origin main
  echo ""
  echo "Running health check..."
  "$SYNCBIN/bin/syncbin-doctor"
  echo ""
  echo "Reloading Bash..."
  exec bash
}


# PDF manipulation
pdfcombine() {
  echo "Output: $1"
  shift
  echo "Input: $*"
  gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "$@"
}

# Video compression and conversion
compavc() {
  local output
  output=$(echo "$1" | sed -e 's/\.(mp4|mkv)//')-comp.mp4
  ffmpeg -i "$1" -vcodec libx264 -crf 23 "$output"
}

gif2mp4() {
  local TEMPGIF
  TEMPGIF=$(mktemp)
  ffmpeg -stream_loop 10 -i "${1}" "${TEMPGIF}.gif" -y
  ffmpeg -i "${TEMPGIF}.gif" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${1%.gif}.mp4"
  rm -f "${TEMPGIF}.gif"
}

ffsilent() {
  ffmpeg -i "$1" -c copy -an "${1}-nosound.${1##*.}"
}

# Image processing
alpha2white() {
  convert "$1" -background white -alpha remove -alpha off "$1"
}

imgcrop() {
  magick mogrify -bordercolor white -fuzz 2% -trim -format png "$1"
}

# Git utilities
git-find-large-files() {
  git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

git-disk-usage() {
  git for-each-ref --format='%(refname)' |
  while read -r branch; do
      size=$(git rev-list --disk-usage=human --objects HEAD.."$branch")
      echo "$size $branch"
  done |
  sort -h
}

gitit() {
  git commit -am "Formatting / typo / trivial change ($(date +%Y%m%d%H%M%S))" && git push
}

git-timetravel() {
  if [ -z "${1}" ]; then
      echo "Must provide a valid timestamp in roughly ISO 8601"
      echo "Example: git-timetravel \"2022-10-01 12:00\" main"
      return 1
  fi

  local BRANCH
  if [ -z "${2}" ]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Guessing branch: ${BRANCH}"
  else
    BRANCH=${2}
  fi

  git checkout "$(git rev-list -n 1 --first-parent --before="${1}" "${BRANCH}")"
}

# Download utilities
aria() {
  aria2c --seed-time=0 --max-concurrent-downloads=5 "$@"
}

# Development environment
prefer-conda() {
  export PATH="$HOME/Library/r-miniconda/bin:$PATH"
}

# LaTeX cleanup
cleantex() {
  rm -rf ./*.out ./*.dvi ./*.log ./*.aux ./*.bbl ./*.blg ./*.ind ./*.idx ./*.ilg ./*.lof ./*.lot ./*.toc ./*.nav ./*.snm ./*.vrb ./*.fls ./*.fdb_latexmk ./*.synctex.gz ./*-concordance.tex
}

# R package management
upr-base() {
  R -e "update.packages(ask = FALSE)"
}

upr() {
  R -e "remotes::update_packages()"
}

# Makefile validation
checkmake() {
  rg "^[^\S\t\n\r]" < Makefile
}

# RStudio launcher
rstudio() {
  local FILE
  if [[ -z "$1" ]]; then
    FILE="$(find . -maxdepth 1 -iname '*.Rproj')"
  else
    FILE="$1"
  fi

  echo "Opening $FILE with RStudio..."
  open -a RStudio.app "$FILE"
}

# Help function with bat pager
if command -v bat >/dev/null 2>&1; then
  help() {
    "$@" --help 2>&1 | bat --plain --language=help
  }
fi

# Tmux session management functions
tmn() {
  if [ -z "${1}" ]; then
    tmux new-session -A -s "${host_short}"
  else
    tmux new-session -A -s "${1}"
  fi
}

tma() {
    local session_name
    if [ -z "${1}" ]; then
        session_name="${host_short}"
    else
        session_name="${1}"
    fi

    if tmux list-sessions | grep -q "^${session_name}:"; then
        # Session exists, attach to it
        tmux attach -t "${session_name}"
    else
        # Session does not exist, create it and then attach
        tmux new-session -s "${session_name}"
    fi
}