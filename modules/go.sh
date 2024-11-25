GO_VERSION="go1.23.3"

function setup_go() {
    source ./common.sh

    # for whatever reason, gvm depends on go for the install process
    # we're installing one here as a bootstrap
    # https://github.com/moovweb/gvm/issues/459#issuecomment-2140900949
    attempt_brew_install go

    GVM_IS_INSTALLED=$(which gvm >/dev/null 2>&1 && echo 0 || echo 1)

    if [[ $GVM_IS_INSTALLED -ne 0 ]]; then
        echo "Installing gvm..."
        curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
    else
        echo "gvm is installed. Continuing..."
    fi

    GO_IS_INSTALLED=$(gvm list | grep $GO_VERSION >/dev/null 2>&1 && echo 0 || echo 1)

    if [[ $GO_IS_INSTALLED -ne 0 ]]; then
        echo "Installing $GO_VERSION..."
        gvm install $GO_VERSION
        gvm use $GO_VERSION --default
    else
        echo "$GO_VERSION is installed. Continuing..."
    fi

    # uninstall the homebrew go bootstrap
    brew uninstall go

}
