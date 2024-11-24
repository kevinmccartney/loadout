#!/usr/bin/env zsh

# deps:
#   - none

function setup_system() {
    source ./common.sh

    # always show dotfiles in finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # restart finder
    killall Finder

    # set theme to dark mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

    FORMULAS=(
        'git'
        'grep' # need this for GNU grep (ggrep)
        'jq'
        'curl'
        'speedtest-cli'
        'eza'
        'fzf'
        'bash' # providing a bash 5 version since the macOS bundles a v3 bash
        'thefuck'
        'ripgrep'
        'dust'
        'bat'
        'bat-extras'
        'fd'
        'tldr'
        'httpie'
        'imagemagick'
        'fastfetch'
        'yank'
        'yq'
        'pandoc'
        'dasel'
        'kubernetes-cli'
        'minikube'
        'k9s'
        'autoenv'
        'parallel'
        'ack'
        'pre-commit'
        'terraform'
        'gnupg'
    )

    for FORMULA in "${FORMULAS[@]}"; do
        attempt_brew_install $FORMULA
    done

    LOOP_IS_TAPPED=$(brew tap | grep 'miserlou/loop' > /dev/null 2>&1 && echo 0 || echo 1)

    if [[ $LOOP_IS_TAPPED -ne 0 ]]; then
        echo "Tapping 'miserlou/loop'..."
        brew tap miserlou/loop https://github.com/Miserlou/Loop.git
    else
        echo "'miserlou/loop' is tapped. Continuing..."
    fi 

    LOOP_IS_INSTALLED=$(is_brew_installed loop)
    if [ $LOOP_IS_INSTALLED -eq 0 ]; then
            echo "loop is installed. Continuing..."
    else
        echo "Installing loop..."
        brew install loop --formula --HEAD
    fi

    HAS_FZF_ZSHRC_CONFIG=$(is_config_in_zshrc fzf)

    if [[ $HAS_FZF_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc fzf configuration..."

        cat <<EOF >> ~/.zshrc

### BEGIN_CONF fzf

source <(fzf --zsh) # Set up fzf key bindings and fuzzy completion

### END_CONF fzf
EOF
    else
        echo ".zshrc fzf configuration present. Continuing..."
    fi

    HAS_THEFUCK_ZSHRC_CONFIG=$(is_config_in_zshrc thefuck)

    if [[ $HAS_THEFUCK_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc thefuck configuration..."

        # add instant mode support (need python 3) https://github.com/nvbn/thefuck?tab=readme-ov-file#experimental-instant-mode
        cat <<'EOF' >> ~/.zshrc

### BEGIN_CONF thefuck

eval $(thefuck --alias)

### END_CONF thefuck
EOF
    else
        echo ".zshrc thefuck configuration present. Continuing..."
    fi

    HAS_BAT_ZSHRC_CONFIG=$(is_config_in_zshrc bat)

    if [[ $HAS_BAT_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc bat configuration..."

        cat <<'EOF' >> ~/.zshrc

### BEGIN_CONF bat

# use bat as the man page colorizer
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# setting help flags to use bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

### END_CONF bat
EOF
    else
        echo ".zshrc bat configuration present. Continuing..."
    fi

    # aliases
    #  export ppath=$(echo "$PATH" | tr ':' '\n' )
    # fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"
    # fd . -X bat
    # export add-gitginore=npx add-gitignore
    # export chokidar=npx chokidar-cli
    # export carbon=npx carbon-now-cli
    # export caniuse=npx caniuse-cmd
    # export serve=npx serve
    # export doctoc=npx doctoc
}
