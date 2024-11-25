#!/usr/bin/env zsh

# deps:
#   - none
#   - apps

# Pass in a formula/cask name to get it's install status
#   $1 PROGRAM (string): The name of the program to check
#   Return: 0 or 1 to be treated as a bool
function is_brew_installed() {
    PROGRAM=$1
    brew list $PROGRAM >/dev/null 2>&1

    NVM_IS_INSTALLED=$?

    if [[ $NVM_IS_INSTALLED -eq 0 ]]; then
        echo 0
    else
        echo 1
    fi
}

# Attempt to install a program using homebrew
#   $1 PROGRAM(string): The name of the program to install
#   $2 IS_FORMULA (integer)?: OPTIONIAL - Treated as bool to indicate if the program is a formula (if false, the program will be treated as a cask)
#   Return: void
function attempt_brew_install() {
    PROGRAM=$1
    IS_FORMULA=${2:-0}
    IS_INSTALLED=$(is_brew_installed $PROGRAM)

    if [ $IS_INSTALLED -eq 0 ]; then
        echo "$PROGRAM is installed. Continuing..."
    else
        echo "Installing $PROGRAM..."
        if [ $IS_FORMULA -eq 0 ]; then
            brew install $PROGRAM
        else
            brew install --cask $PROGRAM
        fi
    fi
}

# Check if a config group blcok is in your .zshrc
#   $1 CONFIG_GROUP_NAME(string): The name of the config block to look for
#   Return: Return: 0 or 1 to be treated as a bool
function is_config_in_zshrc() {
    CONFIG_GROUP_NAME=$1
    NVM_ZSHRC_CONFIG_ENTRIES=$(
        ggrep -Pzo "(?s)### BEGIN_CONF $CONFIG_GROUP_NAME.*### END_CONF $CONFIG_GROUP_NAME" ~/.zshrc |
            tr -d '\0' # make sure to trim null bytes to avoid bash warnings
    )

    if [[ -z $NVM_ZSHRC_CONFIG_ENTRIES ]]; then
        echo 1
    else
        echo 0
    fi
}

function ensure_dir() {
    DIR_NAME=$1

    if [[ ! -d $DIRNAME ]]; then
        mkdir -p $DIR_NAME
    fi
}

function is_pattern_in_file() {
    PATTERN=$1
    FILE_PATH=$2
    RESULTS=$(
        ggrep -Pzo "$1" $2 |
            tr -d '\0' # make sure to trim null bytes to avoid bash warnings
    )

    if [[ -z $RESULTS ]]; then
        echo 1
    else
        echo 0
    fi
}

# function to_bool() {
#     COMMAND=$1

#     if [[ -z $COMMAND ]]; then
#         echo 3
#     else
#         eval $COMMAND
#     fi
# }
