#!/usr/bin/env zsh

dotnet_versions=(
    'dotnet-sdk8'
    'dotnet-sdk9'
)

function setup_dotnet() {
    local module_name="dotnet"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    brew tap | run_silent "grep 'isen-ng/dotnet-sdk-versions'"

    if [[ $? -ne 0 ]]; then
        log_info "Tapping $(clr_cyan 'isen-ng/dotnet-sdk-versions')..." $module_name
        brew tap isen-ng/dotnet-sdk-versions
    else
        log_info "$(clr_cyan 'isen-ng/dotnet-sdk-versions') is tapped. $(clr_bright 'Continuing...')" $module_name
    fi

    for version in "${dotnet_versions[@]}"; do
        attempt_brew_install $version $module_name 1
    done

    if [[ ! -L /usr/local/bin/dotnet ]]; then
        log_info "Creating dotnet symlink..." $module_name
        sudo ln -sf /usr/local/share/dotnet/dotnet /usr/local/bin/dotnet
    fi

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
