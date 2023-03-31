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

echo "Checking if choose is available..."
if [ -x "$(command -v choose)" ]; then
  echo "Found choose"
else
  brew install choose-rust
fi

echo "Checking if delta is available..."
if [ -x "$(command -v delta)" ]; then
  echo "Found delta"
else
  brew install git-delta
fi

# The easy cases where binary == package name
base_tools=( fd sd dust diskus broot zoxide bat exa lsd delta duf jq tldr procs micro )
extra_tools=( yq cheat curlie dog thefuck zenith lazygit)
docker_tools=( ctop lazydocker )

for i in "${base_tools[@]}"
do
  echo "Checking if $i is available..."
  if [ -x "$(command -v $i)" ]; then
    echo "Found $i"
  else
    brew install $i
  fi
done

for i in "${extra_tools[@]}"
do
  echo "Checking if $i is available..."
  if [ -x "$(command -v $i)" ]; then
    echo "Found $i"
  else
    brew install $i
  fi
done

if [ -x "$(command -v docker)" ]; then
  echo "Found docker, installing docker-related tools"
	for i in "${docker_tools[@]}"
	do
    echo "Checking if $i is available..."
    if [ -x "$(command -v $i)" ]; then
      echo "Found $i"
    else
      brew install $i
    fi
	done
fi
