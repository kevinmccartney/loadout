#!/usr/bin/env zsh

function setup_apps() {
    source ./common.sh

    CASKS=(
        'visual-studio-code'
        'google-chrome'
        'spotify'
        'chatgpt'
        'docker'
        'raycast'
        'postman'
        'dbeaver-community'
        'font-fira-code-nerd-font'
        'cursor'
        'rectangle'
    )

    # for CASK in "${CASKS[@]}"; do
    #     attempt_brew_install $CASK 1
    # done

    CHROME_EXTENSIONS=(
        'clngdbkpkpeebahjckkjfobafhncgmne' # Stylus
        'gfapcejdoghpoidkfodoiiffaaibpaem' # Dracula Chrome Theme
        'bfbameneiokkgbdmiekhjnmfkcnldhhm' # Web Developer
        'bhlhnicpbhignbdhedgjhgdocnmhomnp' # ColorZilla
        'gppongmhjkpfnbhagpmjfkannfbllamg' # Wappalyzer - Technology profiler
        'cppjkneekbjaeellbfkmgnhonkkjfpdn' # Clear Cache
        'chklaanhfefbnpoihckbnefhakgolnmc' # JSONVue TODO: install Dracula theme
        'idgpnmonknjnojddfkpgkljpfnnfcklj' # ModHeader - Modify HTTP headers
        'bnjjngeaknajbdcgpfkgnonkmififhfo' # Fake Filler
        'gighmmpiobklfepjocnamgkkbiglidom' # AdBlock
        'kofahhnmgobkidipanhejacffiigppcd' # LT Debug
        'mdnleldcmiljblolnjhpnblkcekpdkpa' # Requestly - Intercept, Modify & Mock HTTP Requests
        'jbbplnpkjmmeebjpijfedlgcdilocofh' # WAVE Evaluation Tool
        'blipmdconlkpinefehnmjammfjpmpbjk' # Lighthouse
        'dbepggeogbaibhgnhhndojpepiihcmeb' # Vimium
        'lmhkpmbekcpmknklioeibfkpmmfibljd' # Redux DevTools
        'fmkadmapgofadopljbjfkapdkoienihi' # React Developer Tools
        'ienfalfjdbdpebioblfackkekamfmbnh' # Angular DevTools
        'nhdogjmejiglipccpnnnanhbledajbpd' # Vue.js devtools
        'jlmpjdjjbgclbocgajdjefcidcncaied' # daily.dev | The homepage developers deserve
        'lhdoppojpmngadmnindnejefpokejbdd' # axe DevTools - Web Accessibility Testing
        'eimadpbcbfnmbkopoojfekhnkhdbieeh' # Dark Reader
        'edacconmaakjimmfgnblocblbcdcpbko' # Session Buddy
        'hkgfoiooedgoejojocmhlaklaeopbecg' # Picture-in-Picture Extension (by Google)
        'fdpohaocaechififmbbbbbknoalclacl' # GoFullPage - Full Page Screen Capture
        'mlomiejdfkolichcflejclcbmpeaniij' # Ghostery Tracker & Ad Blocker - Privacy AdBlock
    )

    GOOGLE_EXTENSIONS_PATH='/Users/Kevin.McCartney/Library/Application Support/Google/Chrome/External Extensions'
    EXENSION_FILE_CONTENTS='{ "external_update_url": "https://clients2.google.com/service/update2/crx" }'

    echo "Installing Chrome extensions..."
    for EXTENSION in "${CHROME_EXTENSIONS[@]}"; do
        echo $EXENSION_FILE_CONTENTS >"$GOOGLE_EXTENSIONS_PATH/$EXTENSION.json"
    done
}
