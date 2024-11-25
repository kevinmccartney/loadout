#!/usr/bin/env zsh

# deps:
#   - none

function setup_apps() {
    source ./common.sh

    CASKS=(
        'visual-studio-code'
        'google-chrome'
        'spotify'
        'chatgpt'
        'docker'
        'raycast'
        'postman'
        'dbeaver-community'
        'font-fira-code-nerd-font'
        'cursor'
        'rectangle'
    )

    # for CASK in "${CASKS[@]}"; do
    #     attempt_brew_install $CASK 1
    # done

    CHROME_EXTENSIONS=(
        'clngdbkpkpeebahjckkjfobafhncgmne' # stylus
        'gfapcejdoghpoidkfodoiiffaaibpaem' # dracula theme
    )

    GOOGLE_EXTENSIONS_PATH='/Users/Kevin.McCartney/Library/Application Support/Google/Chrome/External Extensions'
    EXENSION_FILE_CONTENTS='{ "external_update_url": "https://clients2.google.com/service/update2/crx" }'

    echo "Installing Chrome extensions..."
    for EXTENSION in "${CHROME_EXTENSIONS[@]}"; do
        echo $EXENSION_FILE_CONTENTS >>"$GOOGLE_EXTENSIONS_PATH/$EXTENSION.json"
    done
}
