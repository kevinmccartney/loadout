#!/usr/bin/env zsh

# deps:
#   - apps
#   - nodeJS

APPS=(
    'iterm'
    'git'
    'pygments'
    'zsh-syntax-highlighting'
    'vim'
)

PYTHON_VERSION=3.13.0

function setup_dracula() {
    source ./common.sh

    if [ -d ~/.dracula-themes ]; then
        echo "'~/.dracula-themes' exists. Continuing..."
        cd ~/.dracula-themes
    else
        echo "Creating '~/.dracula-themes'..."
        mkdir ~/.dracula-themes
    fi

    for element in "${APPS[@]}"; do
        if [ ! -d ~/.dracula-themes/$element ]; then
            echo "Installing $element theme..."
            git clone https://github.com/dracula/$element.git
        else
            echo "$element theme already installed. Continuing..."
        fi

    done

    # if [ ! -d ~/.dracula-themes/visual-studio-code ]; then
    #     echo "Installing VS Code theme..."
    #     git clone https://github.com/dracula/visual-studio-code.git
    #     cd ~/.dracula-themes/visual-studio-code
    #     DRACULA_VS_CODE_VERSION=$(cat package.json | jq -r .version)
    #     npm install
    #     npm run build
    #     npx vsce package
    #     code --install-extension theme-dracula-$DRACULA_VS_CODE_VERSION.vsix
    #     cd ~/.dracula-themes
    # else
    #     echo "VS Code theme already installed. Continuing..."
    # fi

    HAS_DRACULA_FZF_ZSHRC_CONFIG=$(is_config_in_zshrc dracula-fzf)

    if [[ $HAS_DRACULA_FZF_ZSHRC_CONFIG -eq 1 ]]; then
        echo "Writing .zshrc dracula-fzf configuration..."

        cat <<EOF >>~/.zshrc

### BEGIN_CONF dracula-fzf

export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

### END_CONF dracula-fzf
EOF
    else
        echo ".zshrc dracula-fzf configuration present. Continuing..."
    fi

    GIT_CONFIG_HAS_DRACULA_CONFIG=$(
        ggrep -Pzo "(?s)### BEGIN_CONF dracula-git.*### END_CONF dracula-git" ~/.gitconfig |
            tr -d '\0' # make sure to trim null bytes to avoid bash warnings
    )

    if [[ -z $GIT_CONFIG_HAS_DRACULA_CONFIG ]]; then
        echo "Installing dracula git theme..."

        cat <<EOF >>~/.gitconfig

### BEGIN_CONF dracula-git

$(echo "$DRACULA_GIT_THEME_CONTENTS")

### END_CONF dracula-git
EOF
    else
        echo "Dracula git theme installed. Continuing..."
    fi

    # TODO = this is brittle & will break if the python version
    SITE_PACKAGES_PATH=$(python -m site | ggrep "$PYENV_ROOT/versions/.*/lib/python.*/site-packages" | tr -d "'" | tr -d ',' | xargs)

    if [[ ! -f $SITE_PACKAGES_PATH/pygments/styles/dracula.py ]]; then
        echo "Copying pygments dracula theme..."
        cp ~/.dracula-themes/pygments/dracula.py "$SITE_PACKAGES_PATH/pygments/styles"
    else
        echo "Pygments dracula theme is present. Continuing..."
    fi

    if [ ! -d ~/.dracula-themes/eza ]; then
        echo "Installing eza theme..."
        git clone https://github.com/eza-community/eza-themes.git eza
        mkdir -p ~/.config/eza
        ln -sf "$(pwd)/eza/themes/dracula.yml" ~/.config/eza/theme.yml
    else
        echo "eza theme already present. Continuing..."
    fi

    HAS_DRACULA_EZA_ZSHRC_CONFIG=$(is_config_in_zshrc dracula-eza)
    if [[ -z $HAS_DRACULA_EZA_ZSHRC_CONFIG ]]; then
        echo "Writing .zshrc dracula-eza configuration"

        cat <<EOF >>~/.gitconfig

### BEGIN_CONF dracula-eza

export EZA_CONFIG_DIR=~/.config/eza

### END_CONF dracula-eza
EOF
    else
        echo ".zshrc dracula-eza configuration present. Continuing..."
    fi

    HAS_DRACULA_ZSH_SYNTAX_HIGHLIGHTING_ZSHRC_CONFIG=$(is_config_in_zshrc dracula-zsh-syntax-highlighting)
    if [[ $HAS_DRACULA_ZSH_SYNTAX_HIGHLIGHTING_ZSHRC_CONFIG -ne 0 ]]; then
        echo "Writing .zshrc dracula-zsh-syntax-highlighting configuration"

        cat <<EOF >>~/.zshrc

### BEGIN_CONF dracula-zsh-syntax-highlighting

source ~/.dracula-themes/zsh-syntax-highlighting/zsh-syntax-highlighting.sh

### END_CONF dracula-zsh-syntax-highlighting
EOF
    else
        echo ".zshrc dracula-zsh-syntax-highlighting configuration present. Continuing..."
    fi

    ensure_dir ~/.vim/pack/themes/start
    ln -s ~/.dracula-themes/vim ~/.vim/pack/themes/start/dracula

    VIMRC_HAS_DRACULA_CONFIG=$(is_pattern_in_file '(?s)""" BEGIN_CONF dracula-vim.*""" END_CONF dracula-vim' ~/.vimrc)
    echo $VIMRC_HAS_DRACULA_CONFIG
    if [[ $VIMRC_HAS_DRACULA_CONFIG -ne 0 ]]; then
        echo "Writing .vimrc dracula-vim configuration"

        cat <<EOF >>~/.vimrc

""" BEGIN_CONF dracula-vim

if v:version < 802
    packadd! dracula
endif

colorscheme dracula
syntax enable
set number

""" END_CONF dracula-vim
EOF
    else
        echo ".vimrc dracula-vim configuration present. Continuing..."
    fi

    echo "Dracula themes install complete"

    # TODO: cd back home?
}
