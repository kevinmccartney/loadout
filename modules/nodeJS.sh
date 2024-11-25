#!/usr/bin/env zsh

# deps:
#   - apps

NODE_VERSION="22.11.0"

function setup_nodejs() {
    source ./common.sh

    attempt_brew_install nvm

    # have to source nvm to use it in this script
    # https://unix.stackexchange.com/a/184512
    . $(brew --prefix nvm)/nvm.sh

    # find a local instance of a node version
    nvm version $NODE_VERSION >/dev/null 2>&1

    NODE_IS_INSTALLED=$?
    if [ $NODE_IS_INSTALLED -eq 0 ]; then
        echo "Node $NODE_VERSION is installed. Continuing..."
    else
        echo "Installing Node $NODE_VERSION..."
        nvm install v$NODE_VERSION
    fi

    HAS_NVM_ZSHRC_CONFIG=$(is_config_in_zshrc nvm)
    if [[ $HAS_NVM_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc NVM configuration..."

        cat <<EOF >>~/.zshrc

### BEGIN_CONF nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

### END_CONF nvm
EOF
    else
        echo ".zshrc NVM configuration present. Continuing..."
    fi

    NVM_ALIAS_DEFAULT="$(nvm alias)"
    HAS_CORRECT_NODE_DEFAULT="$(echo $NVM_ALIAS_DEFAULT | ggrep -Pzo "default -> ${NODE_VERSION//./\\.}")"
    if [[ -z $HAS_CORRECT_NODE_DEFAULT ]]; then
        echo "Nvm default version is $NODE_VERSION. Continuing..."
    else
        nvm alias default $NODE_VERSION
    fi
}
