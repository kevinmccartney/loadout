#!/usr/bin/env zsh

DRACULA_THEMES=(
    'iterm'
    'git'
    'pygments'
    'zsh-syntax-highlighting'
    'vim'
)

function link_dracula_theme() {
    local theme_name=$1
    local source_path=$2
    local dest_path=$3
    local module=$4

    if [[ -L $dest_path ]]; then
        log_info "Dracula $(clr_cyan "$theme_name") theme already linked. $(clr_bright 'Continuing...')" $module_name
    else
        log_info "Linking dracula $(clr_cyan "$theme_name") theme..." $module_name
        ensure_dir $(dirname $dest_path)
        ln -s $source_path $dest_path
    fi
}

function setup_dracula() {
    local module_name="dracula"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    ensure_dir ~/.dracula-themes

    for theme in "${DRACULA_THEMES[@]}"; do
        if [ ! -d ~/.dracula-themes/$theme ]; then
            log_info "Downloading Dracula $(clr_cyan "$theme") theme..." $module_name
            git clone https://github.com/dracula/$theme.git ~/.dracula-themes/$theme
        else
            log_info "Dracula $(clr_cyan $theme) theme already exists. $(clr_bright 'Continuing...')" $module_name
        fi
    done

    if [ ! -d ~/.dracula-themes/eza ]; then
        log_info "Downloading Dracula $(clr_cyan 'eza') theme..." $module_name
        git clone https://github.com/eza-community/eza-themes.git ~/.dracula-themes/eza
    else
        log_info "Dracula $(clr_cyan 'eza') theme already exists. $(clr_bright 'Continuing...')" $module_name
    fi

    link_dracula_theme eza ~/.dracula-themes/eza ~/.config/eza/theme.yml $module_name

    SITE_PACKAGES_PATH=$(python -m site | ggrep "$PYENV_ROOT/versions/.*/lib/python.*/site-packages" | tr -d "'" | tr -d ',' | xargs)

    link_dracula_theme pygments ~/.dracula-themes/pygments/dracula.py $SITE_PACKAGES_PATH/pygments/styles/dracula.py $module_name

    local dracula_vimrc_content=$(
        cat <<EOF
if v:version < 802
    packadd! dracula
endif

colorscheme dracula
syntax enable
set number
EOF
    )
    ensure_config_section dracula-vim ~/.vimrc "$dracula_vimrc_content" $module_name '"'
    ensure_config_section dracula-zsh-syntax-highlighting \
        ~/.zshrc \
        'source ~/.dracula-themes/zsh-syntax-highlighting/zsh-syntax-highlighting.sh' \
        $module_name
    ensure_config_section dracula-eza \
        ~/.zshrc \
        'export EZA_CONFIG_DIR=~/.config/eza' \
        $module_name

    local dracula_gitconfig_content=$(cat ~/.dracula-themes/git/config/gitconfig)

    ensure_config_section dracula-git \
        ~/.gitconfig \
        "$dracula_gitconfig_content" \
        $module_name
    ensure_config_section dracula-fzf \
        ~/.zshrc \
        "export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'" \
        $module_name

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
