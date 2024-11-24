<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Team Unicorn macOS Setup](#team-unicorn-macos-setup)
  - [Order](#order)
  - [Install Homebrew](#install-homebrew)
  - [Install tools](#install-tools)
  - [TODO](#todo)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Team Unicorn macOS Setup
TODO: write intro

## How to Use

### Install Homebrew
To install [Homebrew](https://brew.sh)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Run the script

```sh
./setup.sh
source ~/.zshrc
```

## TODO
- [x] pyenv
- [ ] rvm
- [ ] dotnet
- [ ] Go
- [ ] Cursor (?)
- [ ] VS Code setup
- [ ] Verbose mode
- [ ] Git aliases/add-ons
    - https://medium.com/otto-group-data-works/developer-hacks-modern-command-line-tools-and-advanced-git-commands-e3724dab00a1
    - https://github.com/stevemao/awesome-git-addons#readme
- [ ] More Dracula themes
- [ ] Set up copilot
- [ ] Install AppMap via VS Code
- [ ] Window management
- [ ] zsh plugins
  - https://github.com/unixorn/awesome-zsh-plugins#readme
- [ ] test all oh my posh segments
- [ ] AWS cli
  - https://apple.stackexchange.com/a/394976
  - https://awscli.amazonaws.com/AWSCLIV2.pkg
- Should I add this?
  - `eval "$(/opt/homebrew/bin/brew shellenv)"`

## Manual Steps
- iTerm
  - Set colors to Dracula
  - Set font to FiraCode
- VS Code
  - `"editor.fontFamily": "'FiraCode Nerd Font', Monaco, 'Courier New', monospace"`
- Chrome
  - https://draculatheme.com/chrome
- raycast
  - Has Setup wizard
- chatgpt
  - disable keyboard shortcut as it conflicts with raycast

## Resources
- https://github.com/alebcay/awesome-shell
- https://github.com/agarrharr/awesome-cli-apps
- https://www.nerdfonts.com/cheat-sheet
- https://medium.com/otto-group-data-works/developer-hacks-modern-command-line-tools-and-advanced-git-commands-e3724dab00a1