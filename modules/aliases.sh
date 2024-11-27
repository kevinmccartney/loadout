#!/usr/bin/env zsh

setup_aliases() {
    local module_name="aliases"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    local aliases_config_content=$(
        cat <<'EOF'
alias ppath="echo "$PATH" | tr ':' '\n'"
alias pfzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias fdp="fd . -X bat"
alias add-gitginore="npx add-gitignore"
alias chokidar="npx chokidar-cli"
alias carbon="npx carbon-now-cli"
alias caniuse="npx caniuse-cmd"
alias serve="npx serve"
alias doctoc="npx doctoc"
alias zsrc="source ~/.zshrc"
alias zedit="vim ~/.zshrc"
alias oco="npx opencommit"
EOF
    )

    ensure_config_section $module_name ~/.zshrc "$aliases_config_content" $module_name

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
