#!/usr/bin/env bash

source ./vendor/bash_colors.sh

# Error - Red
# Warning - Yellow
# Info - Blue
# Debug - Cyan
# Success - Green

# clr_dump

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &>/dev/null && pwd)
MODULES_DIR="${SCRIPT_DIR}/modules"

source ./modules/system.sh
source ./modules/tty.sh
source ./modules/nodeJS.sh
source ./modules/python.sh
source ./modules/ruby.sh
source ./modules/dotnet.sh
source ./modules/go.sh
source ./modules/apps.sh
source ./modules/dracula.sh
source ./modules/vscode.sh
source ./modules/aliases.sh

# setup_system
# setup_tty
# setup_nodejs
# setup_python
# setup_ruby
# setup_dotnet
# setup_go
# setup_apps
setup_dracula
# setup_vscode
setup_aliases
