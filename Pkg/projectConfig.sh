#!/bin/bash
export INSTALLER_NAME="Install UptimeLogger App"
export UNINSTALLER_NAME="Uninstall"

export BUNDLE_NAME="br.com.victorwads.UptimeLogger"
export SCHEME="UptimeLogger"
export PROJECT="$SCHEME.xcodeproj"
export SCRIPT_DIR="Pkg"

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
