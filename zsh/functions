ME=$(whoami)

## Setup helpers ##

function install_linuxbrew() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

	test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
	test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.env.local
}

# Dump files to my filedump, because dump
function dump {
	rsync -avz --progress -h --partial "$@" -e ssh mercy:/srv/dump.jemu.name
	FILE=$(basename $1)
	if [[ $ME == "Lukas" ]]; then
		echo "https://dump.jemu.name/$FILE" | pbcopy
	else 
      echo "https://dump.jemu.name/$FILE"
	fi
	echo "$(date '+%Y-%m-%d %H:%M:%S'): $FILE – http://dump.jemu.name/$FILE" >> $HOME/.dumplog
	terminal-notifier -title "Filedump" -message "$FILE" -execute code $HOME/.dumplog;
}