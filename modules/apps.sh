#!/usr/bin/env zsh

function setup_apps() {
    local module_name="apps"

    source "${MODULES_DIR}/common.sh"

    log_info "Setting up $module_name..." $module_name

    local casks=(
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
        'microsoft-teams'
        'wireshark'
    )

    for cask in "${casks[@]}"; do
        attempt_brew_install $cask $module_name 1
    done

    # had to make this csv since bash v3 (which is shipped with sequoia) doesn't have tuples
    # or associative arrays :(
    CHROME_EXTENSIONS=(
        '"Stylus",clngdbkpkpeebahjckkjfobafhncgmne'
        '"Dracula Chrome Theme",gfapcejdoghpoidkfodoiiffaaibpaem'
        '"Web Developer",bfbameneiokkgbdmiekhjnmfkcnldhhm'
        '"ColorZilla",bhlhnicpbhignbdhedgjhgdocnmhomnp'
        '"Wappalyzer - Technology profiler",gppongmhjkpfnbhagpmjfkannfbllamg'
        '"Clear Cache",cppjkneekbjaeellbfkmgnhonkkjfpdn'
        '"JSONVue",chklaanhfefbnpoihckbnefhakgolnmc' # TODO: install Dracula theme
        '"ModHeader - Modify HTTP headers",idgpnmonknjnojddfkpgkljpfnnfcklj'
        '"Fake Filler",bnjjngeaknajbdcgpfkgnonkmififhfo'
        '"AdBlock",gighmmpiobklfepjocnamgkkbiglidom'
        '"LT Debug",kofahhnmgobkidipanhejacffiigppcd'
        '"Requestly - Intercept, Modify & Mock HTTP Requests",mdnleldcmiljblolnjhpnblkcekpdkpa'
        '"WAVE Evaluation Tool",jbbplnpkjmmeebjpijfedlgcdilocofh'
        '"Lighthouse",blipmdconlkpinefehnmjammfjpmpbjk'
        '"Vimium",dbepggeogbaibhgnhhndojpepiihcmeb'
        '"Redux DevTools",lmhkpmbekcpmknklioeibfkpmmfibljd'
        '"React Developer Tools",fmkadmapgofadopljbjfkapdkoienihi'
        '"Angular DevTools",ienfalfjdbdpebioblfackkekamfmbnh'
        '"Vue.js devtools",nhdogjmejiglipccpnnnanhbledajbpd'
        '"daily.dev , The homepage developers deserve",jlmpjdjjbgclbocgajdjefcidcncaied'
        '"axe DevTools - Web Accessibility Testing",lhdoppojpmngadmnindnejefpokejbdd'
        '"Dark Reader",eimadpbcbfnmbkopoojfekhnkhdbieeh'
        '"Session Buddy",edacconmaakjimmfgnblocblbcdcpbko'
        '"Picture-in-Picture Extension (by Google)",hkgfoiooedgoejojocmhlaklaeopbecg'
        '"GoFullPage - Full Page Screen Capture",fdpohaocaechififmbbbbbknoalclacl'
        '"Ghostery Tracker & Ad Blocker - Privacy AdBlock",mlomiejdfkolichcflejclcbmpeaniij'
    )

    GOOGLE_EXTENSIONS_PATH='/Users/Kevin.McCartney/Library/Application Support/Google/Chrome/External Extensions'
    EXENSION_FILE_CONTENTS='{ "external_update_url": "https://clients2.google.com/service/update2/crx" }'

    for EXTENSION in "${CHROME_EXTENSIONS[@]}"; do
        extension_name=$(
            echo $"Name,Id
${EXTENSION}" | mlr --csv --headerless-csv-output cut -f Name | sed 's/^"\(.*\)"$/\1/'
        )
        extension_id=$(
            echo $"Name,Id
${EXTENSION}" | mlr --csv --headerless-csv-output cut -f Id | sed 's/^"\(.*\)"$/\1/'
        )

        if [[ -f "${GOOGLE_EXTENSIONS_PATH}/${extension_id}.json" ]]; then
            log_info "Chrome extension $(clr_cyan "$extension_name") already installed. $(clr_bright 'Continuing')..." $module_name
        else
            log_info "Installing Chrome extension $(clr_cyan "$extension_name")..." $module_name
            echo $EXENSION_FILE_CONTENTS >"$GOOGLE_EXTENSIONS_PATH/$EXTENSION.json"
        fi
    done

    log_info "$(clr_green "$module_name setup complete")" $module_name
}
