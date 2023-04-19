#!/bin/sh
BUNDLE_NAME="br.com.victorwads.UptimeLogger"
INSTALLER_NAME="Install UptimeLogger"
UNINSTALLER_NAME="Uninstall"

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

echo "\033[32mIdentificando Versão do Projeto\033[0m"
VERSION=$(xcodebuild -project ../UptimeLogger.xcodeproj -showBuildSettings | awk '/MARKETING_VERSION/ { print $3 }' | sed 's/[[:space:]]//g')

echo "\033[32mCriando Instalador\033[0m"
mkdir "$DMG_FOLDER"
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

if [ "$1" != "loop" ]; then
    echo "\033[32mCriando Tag do Git\033[0m"
    read -p "Gostaria de criar a tag $VERSION no git? [s/N]" confirm
    if [[ $confirm =~ ^[Ss]$ ]]; then
        git tag $VERSION
        git --no-pager tag
    else
        echo "A tag não foi criada."
    fi
fi

echo "\033[32mListando Resultado\033[0m"
ls -lha