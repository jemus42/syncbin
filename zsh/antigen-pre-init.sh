# Init antigen, *before* sourcing antigen bundle stuff

function source_if_possible() {
    if [[ -r $1 ]]; then source $1; fi
}

case $( uname -s ) in
Linux)  
    case $( hostname ) in
        kitchensink) source $HOME/.antigen.zsh;;
        pfannkuchen) source $HOME/.antigen.zsh;;
        *) source $(brew --prefix)/share/antigen/antigen.zsh;;
    esac;;
Darwin) 
    source $(brew --prefix)/share/antigen/antigen.zsh;;
FreeBSD) 
    source /usr/local/share/zsh-antigen/antigen.zsh;;
*) 
    source $HOME/.antigen.zsh;;
esac


# Only execute if antigen commend is present, i.e. skip on FreeBSD
$(command -v antigen) init $SYNCBIN/zsh/antigen.sh