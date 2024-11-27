#!/usr/bin/env zsh

# deps:
#   - apps

function setup_tty() {
    local module_name="tty"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    FORMULAS=(
        'antigen'
        'jandedobbeleer/oh-my-posh/oh-my-posh'
    )
    CASKS=(
        'iterm2'
    )

    for FORMULA in "${FORMULAS[@]}"; do
        attempt_brew_install $FORMULA $module_name
    done

    for CASK in "${CASKS[@]}"; do
        attempt_brew_install $CASK $module_name 1
    done

    ensure_file ~/.zshrc
    ensure_file ~/.antigenrc

    # /opt/homebrew/Cellar/antigen/2.2.3/share/antigen/antigen.zsh
    ANTIGEN_PATH=$(brew list antigen | grep antigen.zsh)

    local antigen_zshrc_content=$(
        cat <<EOF >>~/.zshrc

### BEGIN_CONF antigen

# Load Antigen
source $ANTIGEN_PATH
# Load Antigen configurations
antigen init ~/.antigenrc

### END_CONF antigen
EOF
    )

    ensure_config_section antigen ~/.zshrc "$antigen_zshrc_content" $module_name

    log_info "Writing $(clr_cyan 'antigen') configuration to $(clr_cyan '~/.antigenrc')..." $module_name

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
        log_info "Writing $(clr_cyan 'Oh My Posh') configuration to $(clr_cyan '~/kevops.omp.jsonc')..." $module_name
        cp conf/kevops.omp.jsonc ~/.kevops.omp.jsonc
    else
        log_info "$(clr_cyan 'Oh My Posh') configuration exists. Continuing..." $module_name
    fi

    ensure_config_section oh-my-posh \
        ~/.zshrc \
        'eval "$(oh-my-posh init zsh --config ~/.kevops.omp.jsonc)"' \
        $module_name

    local alias_finder_zshrc_content=$(
        cat <<EOF
zstyle :omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
EOF
    )

    ensure_config_section alias-finder \
        ~/.zshrc \
        "$alias_finder_zshrc_content" \
        $module_name

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
