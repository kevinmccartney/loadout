#!/usr/bin/env zsh

# deps:
#   - none

function setup_system() {
    source ./common.sh

    HAS_BREW_ZSHRC_CONFIG=$(is_config_in_zshrc brew)

    if [[ $HAS_BREW_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc brew configuration..."

        cat <<'EOF' >>~/.zshrc

### BEGIN_CONF brew

eval "$(/opt/homebrew/bin/brew shellenv)"

### END_CONF brew
EOF
    else
        echo ".zshrc brew configuration present. Continuing..."
    fi

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
        'bison'
        'duti'
        'peco'
        'git-extras'
        'pygments'
        'vim'
        'shfmt'
    )

    for FORMULA in "${FORMULAS[@]}"; do
        attempt_brew_install $FORMULA
    done

    LOOP_IS_TAPPED=$(brew tap | grep 'miserlou/loop' >/dev/null 2>&1 && echo 0 || echo 1)

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

        cat <<EOF >>~/.zshrc

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
        cat <<'EOF' >>~/.zshrc

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

        cat <<'EOF' >>~/.zshrc

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

    # always show dotfiles in finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # restart finder
    killall Finder

    # set theme to dark mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

    CHROME_IS_DEFAULT_BROWSER=$(duti -d http | grep Chrome >/dev/null 2>&1 && duti -d https | grep Chrome >/dev/null 2>&1 && echo 0 || echo 1)

    if [[ $CHROME_IS_DEFAULT_BROWSER -ne 0 ]]; then
        echo "Setting Chrome as default browser..."
        duti -s com.google.chrome http
        duti -s com.google.chrome https
    else
        echo "Chrome is already default browser. Continuing..."
    fi

    HAS_CORRECT_INITIAL_KEY_REPEAT=$(defaults read -g InitialKeyRepeat)

    if [[ $HAS_CORRECT_INITIAL_KEY_REPEAT -ne 25 ]]; then
        echo "Setting InitialKeyRepeat to 25..."
        defaults write -g InitialKeyRepeat -int 25
        killall -HUP cfprefsd
    else
        echo "InitialKeyRepeat is set to 25. Continuing..."
    fi

    HAS_CORRECT_KEY_REPEAT=$(defaults read -g KeyRepeat)

    if [[ $HAS_CORRECT_KEY_REPEAT -ne 2 ]]; then
        echo "Setting KeyRepeat to 2..."
        defaults write -g KeyRepeat -int 2
        killall -HUP cfprefsd
    else
        echo "KeyRepeat is set to 2. Continuing..."
    fi

    HAS_AUTOENV_ZSHRC_CONFIG=$(is_config_in_zshrc autoenv)
    if [[ $HAS_AUTOENV_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc autoenv configuration..."

        cat <<'EOF' >>~/.zshrc

### BEGIN_CONF autoenv

source $(brew --prefix autoenv)/activate.sh

### END_CONF autoenv
EOF
    else
        echo ".zshrc autoenv configuration present. Continuing..."
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
    # export cat=bat
    # export ls=eza
    # alias zsrc=source ~/.zshrc

    GIT_GLOBAL_CONFIG=$(git config list --global)

    GIT_PUSH_AUTO_SETUP_REMOTE_SET=$(echo $GIT_GLOBAL_CONFIG | grep 'push.autosetupremote=true' >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $GIT_PUSH_AUTO_SETUP_REMOTE_SET -eq 0 ]]; then
        echo "git global push.autosetupremote is setup correctly. Continuing..."
    else
        echo "Setting git global push.autosetupremote..."
        git config set --global push.autosetupremote true
    fi

    GIT_CONFIG_PULL_REBASE_SET=$(echo $GIT_GLOBAL_CONFIG | grep 'pull.rebase=true' >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $GIT_CONFIG_PULL_REBASE_SET -eq 0 ]]; then
        echo "git global pull.rebase is setup correctly. Continuing..."
    else
        echo "Setting git global pull.rebase..."
        git config set --global pull.rebase true
    fi

    GIT_CONFIG_MERGE_CONFLICT_STYLE_SET=$(echo $GIT_GLOBAL_CONFIG | grep 'merge.conflictstyle=zdiff3' >/dev/null 2>&1 && echo 0 || echo 1)
    if [[ $GIT_CONFIG_MERGE_CONFLICT_STYLE_SET -eq 0 ]]; then
        echo "git global merge.conflictstyle is setup correctly. Continuing..."
    else
        echo "Setting git global merge.conflictstyle..."
        git config set --global merge.conflictstyle zdiff3
    fi
}
