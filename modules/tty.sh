#!/usr/bin/env zsh

# deps:
#   - apps

function setup_tty() {
    source ./common.sh

    FORMULAS=(
        'antigen'
        'jandedobbeleer/oh-my-posh/oh-my-posh'
    )
    CASKS=(
        'iterm2'
    )

    for FORMULA in "${FORMULAS[@]}"; do
        attempt_brew_install $FORMULA
    done

    for CASK in "${CASKS[@]}"; do
        attempt_brew_install $CASK 1
    done

    if [ ! -f ~/.zshrc ]; then
        echo "Creating '~/.zshrc'..."
        touch ~/.zshrc
    else
        echo "'~/.zshrc' exists. Continuing..."
    fi

    if [ ! -f ~/.antigenrc ]; then
        echo "Creating '~/.antigenrc'..."
        touch ~/.antigenrc
    else
        echo "'~/.antigenrc' exists. Continuing..."
    fi

    # /opt/homebrew/Cellar/antigen/2.2.3/share/antigen/antigen.zsh
    ANTIGEN_PATH=$(brew list antigen | grep antigen.zsh)

    HAS_ANTIGEN_ZSHRC_CONFIG=$(is_config_in_zshrc antigen)

    if [[ $HAS_ANTIGEN_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc antigen configuration..."

        cat <<EOF >>~/.zshrc

### BEGIN_CONF antigen

# Load Antigen
source $ANTIGEN_PATH
# Load Antigen configurations
antigen init ~/.antigenrc

### END_CONF antigen
EOF
    else
        echo ".zshrc antigen configuration present. Continuing..."
    fi

    echo "Writing antigen configuration..."

    cat <<EOF >~/.antigenrc
# Load oh-my-zsh library.
antigen use oh-my-zsh

# Load bundles from the default repo (oh-my-zsh).
antigen bundle aliases
antigen bundle alias-finder
antigen bundle autoenv
antigen bundle aws
antigen bundle brew
antigen bundle docker
antigen bundle docker-composebre
antigen bundle git
antigen bundle git-extras
antigen bundle golang
antigen bundle httpie
antigen bundle jsontools
antigen bundle minikube
antigen bundle npm
antigen bundle pip
antigen bundle terraform

# Load bundles from external repos.
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting


# Tell Antigen that you're done.
antigen apply
EOF

    if [[ ! -f ~/.kevops.omp.jsonc ]]; then
        echo "Writing Oh My Posh configuration..."
        cp ../conf/kevops.omp.jsonc ~/.kevops.omp.jsonc
    else
        echo "Oh My Posh configuration exists. Continuing..."
    fi

    HAS_OH_MY_POSH_ZSHRC_CONFIG=$(is_config_in_zshrc oh-my-posh)
    if [[ $HAS_OH_MY_POSH_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc Oh My Posh configuration..."

        cat <<'EOF' >>~/.zshrc

### BEGIN_CONF oh-my-posh

eval "$(oh-my-posh init zsh --config ~/.kevops.omp.jsonc)"

### END_CONF oh-my-posh
EOF
    else
        echo ".zshrc Oh MY Posh configuration present. Continuing..."
    fi

    HAS_ALIAS_FINDER_ZSHRC_CONFIG=$(is_config_in_zshrc alias-finder)
    if [[ $HAS_ALIAS_FINDER_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc alias-finder configuration..."

        cat <<'EOF' >>~/.zshrc

### BEGIN_CONF alias-finder

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

### END_CONF alias-finder
EOF
    else
        echo ".zshrc alias-finder configuration present. Continuing..."
    fi
}
