#!/usr/bin/env zsh

DOTNET_VERSIONS=(
    'dotnet-sdk8'
    'dotnet-sdk9'
)

function setup_dotnet() {
    source ./common.sh

    DOTNET_SDK_VERSIONS_IS_TAPPED=$(brew tap | grep 'isen-ng/dotnet-sdk-versions' >/dev/null 2>&1 && echo 0 || echo 1)

    if [[ $DOTNET_SDK_VERSIONS_IS_TAPPED -ne 0 ]]; then
        echo "Tapping 'isen-ng/dotnet-sdk-versions'..."
        brew tap isen-ng/dotnet-sdk-versions
    else
        echo "'isen-ng/dotnet-sdk-versions' is tapped. Continuing..."
    fi

    for VERSION in "${DOTNET_VERSIONS[@]}"; do
        attempt_brew_install $VERSION 1
    done
}
