# Skip Ubuntu's global compinit in /etc/zsh/zshrc — oh-my-zsh handles it
skip_global_compinit=1

# Keep zcompdump out of $HOME — single file per zsh version in XDG cache
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"
export ZSH_COMPDUMP
