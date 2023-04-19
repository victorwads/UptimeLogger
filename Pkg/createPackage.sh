#!/bin/sh
BUNDLE_NAME="br.com.victorwads.UptimeLogger"
INSTALLER_NAME="Install UptimeLogger"
UNINSTALLER_NAME="Uninstall"
VERSION="2.0.1"

CACHE_FOLDER="cache"
APP_FOLDER="$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app"
DMG_FOLDER="$CACHE_FOLDER/dmg"

# Apagando logs de teste
rm -f ../Service/logs/*

# Apaga caches anteriores
echo "\033[32mBuildando app release\033[0m"
xcodebuild  -project ../UptimeLogger.xcodeproj\
            -scheme UptimeLogger -configuration Release\
            -destination 'generic/platform=macOS'\
            -derivedDataPath "$CACHE_FOLDER" > /dev/null

mkdir "$DMG_FOLDER"

echo "\033[32mCriando Instalador\033[0m"
pkgbuild --root "$APP_FOLDER"  --install-location "/Applications/UptimeLogger.app" --scripts ./Install\
    --identifier "$BUNDLE_NAME" --version "$VERSION"\
    "$DMG_FOLDER/$INSTALLER_NAME.pkg"

echo "\033[32mCriando Desinstalador\033[0m"
pkgbuild --nopayload  --scripts ./Uninstall\
    --identifier "$BUNDLE_NAME.uninstall" --version "$VERSION"\
    "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"

echo "\033[32mCriando dmg de instalação\033[0m"
hdiutil create -volname "UptimeLogger"\
    -srcfolder "$DMG_FOLDER"\
    -ov -format UDZO\
    "UptimeLogger-$VERSION.dmg"

# cp "$DMG_FOLDER/$INSTALLER_NAME.pkg" "./$INSTALLER_NAME.pkg"
# cp -R "$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app" ./

echo "\033[32mApagando caches\033[0m"
rm -rf "$CACHE_FOLDER"
