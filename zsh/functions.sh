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
	rsync -avh --progress "$@" -e ssh mercy:/srv/dump.jemu.name
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

function upall() {

	case $( uname -s ) in
	Linux)  
		echo "################################"
		echo "## Updating platform packages ##"
		echo "################################"
		sudo apt update
		sudo apt upgrade -y
		sudo apt autoremove

		if (( $+commands[brew] )); then
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
			brew upgrade

			echo "#############################"
			echo "## Updating homebrew casks ##"
			echo "#############################"
			brew cask upgrade
		fi

		if (( $+commands[mas] )); then
			echo "#######################"
			echo "## Updating App Store ##"
			echo "#######################"
			echo "mas version $(mas version)"
			mas upgrade
		fi

	    echo "#########################"
		echo "## Updating R packages ##"
		echo "#########################"
		Rscript --quiet --no-init-file -e \
		'update.packages(lib.loc = "/Users/Lukas/Library/R/shared", repos = "https://cloud.r-project.org", ask = FALSE, type = "binary")'
		;;
	FreeBSD) 
		echo "################################"
		echo "## Updating platform packages ##"
		echo "################################"
		pkg update
		pkg upgrade -y
		pkg clean
		pkg autoremove
		;;
	*) 
		echo "Don't know how to update on this platform: $(uname -s)"
		;;
	esac

	echo "#---- Done updating --- $(timestamp) ----#"
}


# Benachmarking ZSH startup
function zsh_bench() {
    zsh -xvlic 'source ~/.zshrc' 2>&1 | ts -i '%.s' > zsh_startup_${HOST/.*/}_$(date +%F_%T).log
    echo DONE
}