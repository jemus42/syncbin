ME=$(whoami)

######################
## Setting stuff up ##
######################

# Since Homebrew has linux support (v2.0), this shouldn't be necessary soonish
function install_linuxbrew() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

	test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
	test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.env.local
}

function install_homebrew() {
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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


##############
## Updating ##
##############

function update_all() {
	echo "################################"
	echo "## Updating platform packages ##"
	echo "################################"

	case $( uname -s ) in
	Linux)  
		sudo apt update
		sudo apt upgrade -y
		sudo apt autoremove
		;;
	Darwin) 
		brew upgrade
		brew cask upgrade
		mas upgrade
		;;
	FreeBSD) 
		pkg update
		pkg upgrade
		;;
	*) 
		echo "Don't know how to update on this platform: $(uname -s)"
		;;
	esac

	if (( $+commands[Rscript] )); then
		echo "#########################################"
		echo "## Updating R packages as current user ##"
		echo "#########################################"
		
		Rscript -e "update.packages(ask = FALSE, type = 'binary')"
	fi

	echo "#---- Done updating --- $(timestamp) ----#"
}