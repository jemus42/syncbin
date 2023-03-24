#! /bin/bash

if ! [ -x "$(command -v brew)" ]; then
  echo 'Error: brew is not installed.' >&2
  exit 1
fi


test ! -e $(command -v fd) && brew install fd
test ! -e $(command -v sd) && brew install sd
test ! -e $(command -v dust) && brew install dust
test ! -e $(command -v diskus) && brew install diskus
test ! -e $(command -v broot) && brew install broot
test ! -e $(command -v zoxide) && brew install zoxide
test ! -e $(command -v rg) && brew install ripgrep
test ! -e $(command -v bat) && brew install bat
test ! -e $(command -v exa) && brew install exa
test ! -e $(command -v lsd) && brew install lsd
test ! -e $(command -v delta) && brew install delta
test ! -e $(command -v duf) && brew install duf
test ! -e $(command -v choose) && brew install choose
test ! -e $(command -v jq) && brew install jq
test ! -e $(command -v yq) && brew install yq
test ! -e $(command -v tldr) && brew install tldr
test ! -e $(command -v cheat) && brew install cheat
test ! -e $(command -v bottom) && brew install bottom
test ! -e $(command -v procs) && brew install procs
test ! -e $(command -v curlie) && brew install curlie
test ! -e $(command -v dog) && brew install dog
test ! -e $(command -v micro) && brew install micro
test ! -e $(command -v thefuck) && brew install thefuck