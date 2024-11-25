#!/usr/bin/env zsh

RUBY_VERSION=3.3.6

function setup_ruby() {
    source ./common.sh

    attempt_brew_install rbenv

    HAS_RBENV_ZSHRC_CONFIG=$(is_config_in_zshrc rbenv)

    if [[ $HAS_RBENV_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc rbenv configuration..."

        cat <<'EOF' >>~/.zshrc

### BEGIN_CONF rbenv

eval "$(rbenv init - --no-rehash zsh)"

### END_CONF rbenv
EOF
    else
        echo ".zshrc rbenv configuration present. Continuing..."
    fi

    RUBY_IS_INSTALLED=$(rbenv versions | grep $RUBY_VERSION >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $RUBY_IS_INSTALLED -ne 0 ]]; then
        echo "Installing ruby $RUBY_VERSION..."
        rbenv install $RUBY_VERSION
    else
        echo "Ruby $RUBY_VERSION is installed. Continuing..."
    fi

    RUBY_IS_GLOBAL=$(rbenv global | grep $RUBY_VERSION >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $RUBY_IS_GLOBAL -ne 0 ]]; then
        echo "Setting ruby $RUBY_VERSION to global version..."
        rbenv global $RUBY_VERSION
    else
        echo "Ruby $RUBY_VERSION is global version. Continuing..."
    fi
}
