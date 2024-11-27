#!/usr/bin/env zsh

function setup_system() {
    local module_name="system"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    ensure_config_section brew ~/.zshrc 'eval "$(/opt/homebrew/bin/brew shellenv)"' $module_name

    local formulas=(
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
        'openssh'
        'miller'
        'base64'
    )

    for formula in "${formulas[@]}"; do
        attempt_brew_install $formula $module_name
    done

    brew tap | run_silent "grep 'miserlou/loop'"

    if [[ $? -ne 0 ]]; then
        log_info "Tapping $(clr_cyan 'miserlou/loop')..." $module_name
        brew tap miserlou/loop https://github.com/Miserlou/Loop.git
    else
        log_info "$(clr_cyan 'miserlou/loop') is tapped. $(clr_bright 'Continuing...')" $module_name
    fi

    is_brew_installed loop

    if [ $? -eq 0 ]; then
        log_info "$(clr_cyan 'loop') is installed. $(clr_bright 'Continuing...')" $module_name
    else
        log_info "Installing $(clr_cyan 'loop')..." $module_name
        brew install loop --formula --HEAD
    fi

    ensure_config_section fzf ~/.zshrc 'source <(fzf --zsh) # Set up fzf key bindings and fuzzy completion' $module_name
    ensure_config_section thefuck ~/.zshrc 'eval $(thefuck --alias)' $module_name

    local bat_zshrc_content=$(
        cat <<'EOF'
# use bat as the man page colorizer
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# setting help flags to use bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
EOF
    )

    ensure_config_section bat ~/.zshrc "$bat_zshrc_content" $module_name
    ensure_config_section autoenv ~/.zshrc 'source $(brew --prefix autoenv)/activate.sh' $module_name

    # always show dotfiles in finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # restart finder
    killall Finder

    # set theme to dark mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

    duti -d http | run_silent 'ggrep Chrome'
    local chrome_is_http_browser=$?
    duti -d https | run_silent 'ggrep Chrome'
    local chrome_is_https_browser=$?
    local chrome_is_default_browser=$(($chrome_is_http_browser && $chrome_is_https_browser))

    if [[ $chrome_is_default_browser -ne 0 ]]; then
        log_info "Setting $(clr_cyan 'Chrome')  as default browser..." $module_name
        duti -s com.google.chrome http
        duti -s com.google.chrome https
    else
        log_info "$(clr_cyan 'Chrome') is already default browser. $(clr_bright 'Continuing...')" $module_name
    fi

    local has_correct_initial_key_repeat=$(defaults read -g InitialKeyRepeat)

    if [[ $has_correct_initial_key_repeat -ne 25 ]]; then
        log_info "Setting $(clr_cyan 'InitialKeyRepeat') to $(clr_cyan '25')..." $module_name
        defaults write -g InitialKeyRepeat -int 25
        killall -HUP cfprefsd
    else
        log_info "$(clr_cyan 'InitialKeyRepeat') is set to $(clr_cyan '25'). $(clr_bright 'Continuing...')" $module_name
    fi

    local has_correct_key_repeat=$(defaults read -g KeyRepeat)

    if [[ $has_correct_key_repeat -ne 2 ]]; then
        log_info "Setting $(clr_cyan 'KeyRepeat') to $(clr_cyan '2')..." $module_name
        defaults write -g KeyRepeat -int 2
        killall -HUP cfprefsd
    else
        log_info "$(clr_cyan 'KeyRepeat') is set to $(clr_cyan '2'). $(clr_bright 'Continuing...')" $module_name
    fi

    local git_global_config=$(git config list --global)
    local git_settings=(
        'pull.rebase=true'
        'push.autosetupremote=true'
        'merge.conflictstyle=zdiff3'
    )

    for setting in "${git_settings[@]}"; do
        local key=$(echo $setting | cut -d '=' -f 1)
        local value=$(echo $setting | cut -d '=' -f 2)

        echo $git_global_config | run_silent "grep $setting"

        if [[ $? -eq 0 ]]; then
            log_info "git global $(clr_cyan $key) is setup correctly. $(clr_bright 'Continuing...')" $module_name
        else
            log_info "Setting git global $(clr_cyan $key)..." $module_name

            git config set --global $key $value
        fi
    done

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
