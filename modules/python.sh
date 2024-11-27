#!/usr/bin/env zsh

PYTHON_VERSION=3.13.0

function setup_python() {
    local module_name="python"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    attempt_brew_install pyenv $module_name

    local pyenv_zshrc_content=$(
        cat <<EOF
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
    )
    ensure_config_section pyenv ~/.zshrc "$pyenv_zshrc_content" $module_name

    # make sure the global pyenv version is correct
    pyenv global | run_silent "grep $PYTHON_VERSION"

    if [ $? -ne 0 ]; then
        log_info "Installing $(clr_cyan 'global pyenv python version') to $(clr_cyan $PYTHON_VERSION)..." $module_name
        pyenv install $PYTHON_VERSION
        pyenv global $PYTHON_VERSION

    else
        log_info "$(clr_cyan 'global pyenv python version') set to $(clr_cyan $PYTHON_VERSION). $(clr_bright 'Continuing...')" $module_name
    fi

    PIP_PACKAGES=(
        'dankcli'
        'saws'
        'mdv'
    )

    for PACKAGE in "${PIP_PACKAGES[@]}"; do
        run_silent "pip show $PACKAGE"

        if [[ $? -ne 0 ]]; then
            log_info "Installing pip package $(clr_cyan $PACKAGE)..." $module_name
            pip install $PACKAGE
        else
            log_info "Pip package $(clr_cyan $PACKAGE) is installed. $(clr_bright 'Continuing...')" $module_name
        fi
    done

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
