#! /bin/bash

if ! [ -x "$(command -v brew)" ]; then
  echo 'Error: brew is not installed.' >&2
  exit 1
fi

# Binary name and package name differ
(( $+commands[rg] )) && echo "Found ripgrep" || brew install ripgrep
(( $+commands[btm] )) && echo "Found bottom" || brew install bottom
(( $+commands[choose] )) && echo "Found choose" || brew install choose-rust
(( $+commands[delta] )) && echo "Found delta" || brew install git-delta

# The easy cases where binary == package name
base_tools=( fd sd dust diskus broot zoxide bat exa lsd delta duf jq tldr procs micro )
extra_tools=( yq cheat curlie dog thefuck zenith lazygit hwatch btop )
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
