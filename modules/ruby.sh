#!/usr/bin/env zsh

RUBY_VERSION=3.3.6

function setup_ruby() {
    local module_name="ruby"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    attempt_brew_install rbenv $module_name

    ensure_config_section $module_name \
        ~/.zshrc \
        'eval "$(rbenv init - --no-rehash zsh)"' \
        $module_name

    RUBY_IS_INSTALLED=$(rbenv versions | grep $RUBY_VERSION >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $RUBY_IS_INSTALLED -ne 0 ]]; then
        log_info "Installing $(clr_cyan "ruby ${RUBY_VERSION}...")" $module_name
        rbenv install $RUBY_VERSION
    else
        log_info "$(clr_cyan "Ruby $RUBY_VERSION") is installed. $(clr_bright 'Continuing...')" $module_name
    fi

    RUBY_IS_GLOBAL=$(rbenv global | grep $RUBY_VERSION >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $RUBY_IS_GLOBAL -ne 0 ]]; then
        log_info "Setting $(clr_cyan "ruby $RUBY_VERSION") to global version..." $module_name
        rbenv global $RUBY_VERSION
    else
        log_info "$(clr_cyan "Ruby $RUBY_VERSION") is global version. $(clr_bright 'Continuing...')" $module_name
    fi
}
