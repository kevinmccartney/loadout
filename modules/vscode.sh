EXTENSIONS=(
    'foxundermoon.shell-format'
    'dracula-theme.theme-dracula'
    'esbenp.prettier-vscode'
    'appland.appmap'
    'github.copilot'
    'rogalmic.bash-debug'
    'ms-azuretools.vscode-docker'
    'ms-vscode-remote.remote-containers'
    'davidanson.vscode-markdownlint'
    'ms-python.python'
    'ms-python.debugpy'
    'dbaeumer.vscode-eslint'
    'eamodio.gitlens'
    'pkief.material-icon-theme'
    'ms-python.isort'
    'formulahendry.auto-rename-tag'
    'vscode-icons-team.vscode-icons'
    'redhat.vscode-yaml'
    'christian-kohler.path-intellisense'
    'golang.go'
    'streetsidesoftware.code-spell-checker'
    'mechatroner.rainbow-csv'
    'oderwat.indent-rainbow' # TODO: config for only python files in settings.json
    'bradlc.vscode-tailwindcss'
    'redhat.vscode-xml'
    'ms-dotnettools.csdevkit'
    'gruntfuggly.todo-tree'
    'wayou.vscode-todo-highlight'
    'ms-kubernetes-tools.vscode-kubernetes-tools'
    'hashicorp.terraform'
    'ms-python.black-formatter'
    'johnpapa.vscode-peacock'
    'ms-python.pylint'
    'tonybaloney.vscode-pets'
    'ms-python.flake8'
    'tyriar.sort-lines'
    'kisstkondoros.vscode-codemetrics'
    'mads-hartmann.bash-ide-vscode'
    'nhoizey.gremlins'
    'shopify.ruby-extensions-pack'
    'kamikillerto.vscode-colorize'
    'yzhang.markdown-all-in-one'
    'alefragnani.bookmarks'
    'redhat.fabric8-analytics'
    'aaron-bond.better-comments'
    'accessibility-snippets.accessibility-snippets'
    'bazelbuild.vscode-bazel'
    'deerawan.vscode-faker'
    'eliostruyf.vscode-typescript-exportallmodules'
    'github.vscode-github-actions'
    'hashicorp.hcl'
    'hashicorp.terraform'
    'ms-python.mypy-type-checker'
    'ms-python.vscode-pylance'
    'ms-vscode.makefile-tools'
    'richie5um2.vscode-sort-json'
    'stylelint.vscode-stylelint'
    'tamasfe.even-better-toml'
    'ue.alphabetical-sorter'
)

setup_vscode() {
    local module_name="vscode"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    INSTALLED_EXTENSIONS=$(code --list-extensions)

    for EXTENSION in "${EXTENSIONS[@]}"; do
        EXTENSION_RESULT=$(echo $INSTALLED_EXTENSIONS | ggrep -Pzo $EXTENSION | tr -d '\0')

        if [[ -z $EXTENSION_RESULT ]]; then
            log_info "Installing $(clr_cyan $EXTENSION) VS Code plugin..." $module_name
            code --install-extension $EXTENSION
        else
            log_info "$(clr_cyan $EXTENSION) VS Code plugin is already installed. $(clr_bright 'Continuing...')" $module_name
        fi
    done

    log_info "Copying $(clr_cyan 'VS Code settings')..." $module_name
    cp -f conf/vs-code-settings.jsonc $HOME/Library/Application\ Support/Code/User/settings.json

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
