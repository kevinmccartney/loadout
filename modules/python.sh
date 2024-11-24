#!/usr/bin/env zsh

PYTHON_VERSION=3.13.0

function setup_python() {
    source ./common.sh

    attempt_brew_install pyenv

    HAS_PYENV_ZSHRC_CONFIG=$(is_config_in_zshrc pyenv)

    if [[ $HAS_PYENV_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc pyenv configuration..."

        cat <<'EOF' >> ~/.zshrc

### BEGIN_CONF pyenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

### END_CONF pyenv
EOF
    else
        echo ".zshrc pyenv configuration present. Continuing..."
    fi

    GLOBAL_VERSION_SET=$(pyenv global | grep $PYTHON_VERSION > /dev/null 2>&1 && echo 0 || echo 1)

    if [ $GLOBAL_VERSION_SET -eq 0 ];then
        echo "Global pyenv version set to '$PYTHON_VERSION'. Continuing..."
    else
        echo "Installing global pyenv version..."
        pyenv install $PYTHON_VERSION
        pyenv global $PYTHON_VERSION
    fi

    PIP_PACKAGES=(
        'dankcli'
        'saws'
        'mdv'
    )

    for PACKAGE in "${PIP_PACKAGES[@]}"; do
        PACKAGE_IS_INSTALLED=$(pip show $PACKAGE > /dev/null 2>&1 && echo 0 || echo 1)

        if [[ $PACKAGE_IS_INSTALLED -eq 0 ]]; then
            echo "$PACKAGE is installed. Continuing..."
        else
            echo "Installing $PACKAGE..."
            pip install $PACKAGE
        fi
    done
}
