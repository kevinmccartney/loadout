#!/usr/bin/env zsh

#
# Logging
#

LOG_INFO_TAG="[$(clr_blue 'INFO')]"

function get_module_tag() {
    local module=$1

    echo "$(clr_magenta $module):"
}

function log_info() {
    local message=$1
    local module_name=$2

    echo "$LOG_INFO_TAG $(get_module_tag $module_name) $message"
}

#
# brew helpers
#
function is_brew_installed() {
    local program=$1

    run_silent "brew list $program"

    return $?
}

function attempt_brew_install() {
    local program=$1
    local module=$2
    local is_formula=${3:-0}

    is_brew_installed $program

    if [ $? -eq 0 ]; then
        log_info "$(clr_cyan $program) is installed. $(clr_bright 'Continuing...')" $module
    else
        log_info "Installing $(clr_cyan program)..." $module
        if [ $is_formula -eq 0 ]; then
            brew install $program
        else
            brew install --cask $program
        fi
    fi

    return 0
}

#
# File helpers
#
function ensure_file() {
    local file=$1

    if [ ! -f $file ]; then
        touch $file
    fi

    return 0
}

function ensure_dir() {
    DIR_NAME=$1

    if [[ ! -d $DIRNAME ]]; then
        mkdir -p $DIR_NAME
    fi

    return 0
}

function regex_exists_in_file() {
    local text=$1
    local file=$2

    local config_section=$(
        ggrep -Pzo "$text" $file |
            tr -d '\0' # make sure to trim null bytes to avoid bash warnings
    )

    if [[ ! -z $config_section ]]; then
        return 0
    else
        return 1
    fi
}

function ensure_config_section() {
    local config_section_name=$1
    local config_file=$2
    local config_section_content=$3
    local module_name=$4
    local comment_character=${5:-'#'}
    local comment_block=$(printf "%3s" | tr ' ' "$comment_character")

    local reg="(?s)${comment_block} BEGIN_CONF ${config_section_name}.*${comment_block} END_CONF ${config_section_name}"

    if ! regex_exists_in_file "$reg" "$config_file"; then
        log_info "Writing $(clr_cyan $config_section_name) configuration in $(clr_cyan $config_file)..." $module_name
        echo "" >>$config_file
        echo "${comment_block} BEGIN_CONF $config_section_name" >>$config_file
        echo "" >>$config_file
        echo "$config_section_content" >>$config_file
        echo "" >>$config_file
        echo "${comment_block} END_CONF $config_section_name" >>$config_file
    else
        log_info "$(clr_cyan $config_section_name) configuration in $(clr_cyan $config_file) present. $(clr_bright 'Continuing...')" $module_name
    fi

    return 0
}

#
# Command helpers
#
function run_silent() {
    local command=$1

    eval $command >/dev/null 2>&1

    return $?
}
