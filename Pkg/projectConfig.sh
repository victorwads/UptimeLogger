#!/bin/bash
export INSTALLER_NAME="Install UptimeLogger App"
export UNINSTALLER_NAME="Uninstall"
export SCRIPT_DIR="Pkg"
export ACCOUNT_PROFILE="cixcodeandnotorytool"

export TEAM_ID=$(awk -F': ' '/DEVELOPMENT_TEAM/{print $2}' project.yml)
export SCHEME="UptimeLogger"
export PROJECT="$SCHEME.xcodeproj"
export BUNDLE_NAME="br.com.victorwads.UptimeLogger"
export KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db

export CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
export PP_PATH=$RUNNER_TEMP/UptimeLogger2027.mobileprovision

if [ -z "${ret+x}" ]; then
  ret=0
fi
function header() {
    if [ "$ret" -ne 0 ]; then
        echo -e "\n\033[31mfalha\033[0m"
        exit 1
    fi
    echo -e "\n\033[32m ($I/$S) - $1\033[0m"
    I=$((I + 1))
}
