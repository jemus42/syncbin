### default repo
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
    # Bundles from the default repo (robbyrussell's oh-my-zsh)
    extract
    rsync
    git-flow
    z

    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions

    # Prompt
    # nojhan/liquidprompt
EOBUNDLES

### apply, I guess?
antigen apply
