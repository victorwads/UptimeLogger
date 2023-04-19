#!/bin/sh
BUNDLE_NAME="br.com.victorwads.UptimeLogger"
INSTALLER_NAME="Install UptimeLogger"
UNINSTALLER_NAME="Uninstall"
VERSION="2.0"

CACHE_FOLDER="cache"
APP_FOLDER="$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app"
DMG_FOLDER="$CACHE_FOLDER/dmg"

# Apagando testes anteriores
rm -R Tests.xcresult

# Apaga caches anteriores
echo "\033[32mBuildando app release\033[0m"
xcodebuild test -project ../UptimeLogger.xcodeproj\
                -scheme UptimeLogger\
                -destination 'platform=macOS'\
                -derivedDataPath "$CACHE_FOLDER"

xcov    -p ../UptimeLogger.xcodeproj\
        -s UptimeLogger --html_report\
        --derived_data_path "$CACHE_FOLDER"

echo "\033[32mApagando caches\033[0m"
rm -rf "$CACHE_FOLDER"
