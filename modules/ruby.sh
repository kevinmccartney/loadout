#!/usr/bin/env zsh

RUBY_VERSION=3.3.6

function setup_ruby() {
    source ./common.sh

    attempt_brew_install rbenv

    rbenv install $RUBY_VERSION

#     HAS_PYENV_ZSHRC_CONFIG=$(is_config_in_zshrc pyenv)

#     if [[ $HAS_PYENV_ZSHRC_CONFIG -eq 1 ]]; then
#         echo "Writing .zshrc pyenv configuration..."

#         cat <<'EOF' >> ~/.zshrc

# ### BEGIN_CONF pyenv

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# ### END_CONF pyenv
# EOF
#     else
#         echo ".zshrc pyenv configuration present. Continuing..."
#     fiwh

#     GLOBAL_VERSION_SET=$(pyenv global | grep $PYTHON_VERSION > /dev/null 2>&1 && echo 0 || echo 1)

#     if [ $GLOBAL_VERSION_SET -eq 0 ];then
#         echo "Global pyenv version set to '$PYTHON_VERSION'. Continuing..."
#     else
#         echo "Installing global pyenv version..."
#         pyenv install $PYTHON_VERSION
#         pyenv global $PYTHON_VERSION
#     fi 
}