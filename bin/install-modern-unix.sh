#! /bin/bash

if ! [ -x "$(command -v brew)" ]; then
  echo 'Error: brew is not installed.' >&2
  exit 1
fi

# Binary name and package name differ
echo "Checking if ripgrep is available..."
if [ -x "$(command -v rg)" ]; then
  echo "Found ripgrep"
else
  brew install ripgrep
fi

echo "Checking if bottom is available..."
if [ -x "$(command -v btm)" ]; then
  echo "Found bottom"
else
  brew install bottom
fi

array=( fd sd dust diskus broot zoxide bat exa lsd delta duf choose jq yq tldr cheat procs curlie dog micro thefuck )
for i in "${array[@]}"
do
	echo "Checking if $i is available..."
  if [ -x "$(command -v $i)" ]; then
    echo "Found $i"
  else
    brew install $i
  fi

done

