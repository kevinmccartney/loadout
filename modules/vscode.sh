EXTENSIONS=(
    'foxundermoon.shell-format'
    'dracula-theme.theme-dracula'
    'esbenp.prettier-vscode'
    'appland.appmap'
    'GitHub.copilot'
)

setup_vscode() {
    source ./common.sh

    INSTALLED_EXTENSIONS=$(code --list-extensions)

    for EXTENSION in "${EXTENSIONS[@]}"; do
        EXTENSION_RESULT=$(echo $INSTALLED_EXTENSIONS | ggrep -Pzo $EXTENSION)

        if [[ -z $EXTENSION_RESULT ]]; then
            echo "Installing $EXTENSION VS Code plugin..."
            code --install-extension $EXTENSION
        else
            echo "$EXTENSION VS Code plugin is already installed. Continuing..."
        fi
    done
}
