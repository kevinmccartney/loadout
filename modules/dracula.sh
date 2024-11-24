#!/usr/bin/env zsh

# deps:
#   - apps
#   - nodeJS

APPS=('iterm')

function setup_dracula() {
  if [ -d ~/.dracula-themes ]; then
    echo "'~/.dracula-themes' exists. Continuing..."
    cd ~/.dracula-themes

    for element in "${APPS[@]}"; do
      if [ ! -d ~/.dracula-themes/$element ]; then
        echo "Installing $element theme..."
        git clone https://github.com/dracula/$element.git
      else
        echo "$element theme already installed. Continuing..."
      fi
    
    done

    if [ ! -d ~/.dracula-themes/visual-studio-code ]; then
      echo "Installing VS Code theme..."
      git clone https://github.com/dracula/visual-studio-code.git
      cd ~/.dracula-themes/visual-studio-code
      DRACULA_VS_CODE_VERSION=$(cat package.json | jq -r .version)
      npm install
      npm run build
      npx vsce package
      code --install-extension theme-dracula-$DRACULA_VS_CODE_VERSION.vsix
      cd ~/.dracula-themes
    else
      echo "VS Code theme already installed. Continuing..."
    fi

  else
    echo "Creating '~/.dracula-themes'..."
    mkdir ~/.dracula-themes
  fi

  echo "Dracula themes install complete"
}