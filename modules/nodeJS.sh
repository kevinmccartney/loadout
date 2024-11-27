#!/usr/bin/env zsh

NODE_VERSION="22.11.0"

function setup_nodejs() {
    local module_name="nodejs"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    attempt_brew_install nvm $module_name

    # have to source nvm to use it in this script
    # https://unix.stackexchange.com/a/184512
    . $(brew --prefix nvm)/nvm.sh

    # find a local instance of a node version
    run_silent "nvm version $NODE_VERSION"

    if [[ $? -ne 0 ]]; then
        log_info "Installing Node $NODE_VERSION..." $module_name
        nvm install v$NODE_VERSION
    else
        log_info "$(clr_cyan "Node $NODE_VERSION") is installed. $(clr_bright 'Continuing...')" $module_name
    fi

    local nodejs_zshrc_content=$(
        cat <<EOF
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
EOF
    )
    ensure_config_section nvm ~/.zshrc "$nodejs_zshrc_content" $module_name

    NVM_ALIAS_DEFAULT="$(nvm alias)"
    HAS_CORRECT_NODE_DEFAULT="$(echo $NVM_ALIAS_DEFAULT | ggrep -Pzo "default -> ${NODE_VERSION//./\\.}")"
    if [[ -z $HAS_CORRECT_NODE_DEFAULT ]]; then
        log_info "$(clr_cyan 'nvm') default version is $(clr_cyan "$NODE_VERSION"). Continuing..." $module_name
    else
        log_info "Setting nvm $(clr_cyan 'default') version to $(clr_cyan "$NODE_VERSION")..." $module_name
        nvm alias default $NODE_VERSION
    fi

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
