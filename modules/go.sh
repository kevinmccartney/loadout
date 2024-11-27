GO_VERSION="go1.23.3"

function setup_go() {
    local module_name="go"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    # for whatever reason, gvm depends on go for the install process
    # we're installing one here as a bootstrap
    # https://github.com/moovweb/gvm/issues/459#issuecomment-2140900949
    run_silent "attempt_brew_install go"

    run_silent "which gvm"

    if [[ $? -ne 0 ]]; then
        log_info "Installing $(clr_cyan 'gvm')..." $module_name
        curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
    else
        log_info "$(clr_cyan 'gvm') is installed. $(clr_bright 'Continuing...')" $module_name
    fi

    run_silent "gvm list | grep $GO_VERSION"

    if [[ $? -ne 0 ]]; then
        log_info "Installing $(clr_cyan $GO_VERSION)..." $module_name
        gvm install $GO_VERSION
        gvm use $GO_VERSION --default
    else
        log_info "$(clr_cyan $GO_VERSION) is installed. $(clr_bright 'Continuing...')" $module_name
    fi

    # uninstall the homebrew go bootstrap
    run_silent "brew uninstall go"

}
