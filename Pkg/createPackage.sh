#!/bin/bash
BUNDLE_NAME="br.com.victorwads.UptimeLogger"
INSTALLER_NAME="Install UptimeLogger"
UNINSTALLER_NAME="Uninstall"

CACHE_FOLDER="cache"
APP_FOLDER="$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app"
DMG_FOLDER="$CACHE_FOLDER/dmg"
GRELEASE="../../GoogleService-Info.plist"
S=9
I=1

function header() {
    echo -e "\n\033[32m ($I/$S) - $1\033[0m"
    I=$((I+1))
}

# Apagando logs de teste
rm -f ../Service/logs/*
clear

# Apagando logs de teste
if [ ! -f "$GRELEASE" ]; then
    echo -e "\033[31m$GRELEASE not found\033[0m"
    exit 1
fi

header "Copiando Google Release Configs"
cp "$GRELEASE" "../Resources/"

# Apaga caches anteriores
header "Buildando app release"
xcodebuild  -project ../UptimeLogger.xcodeproj\
            -scheme UptimeLogger -configuration Release\
            -destination 'generic/platform=macOS'\
            -derivedDataPath "$CACHE_FOLDER" -quiet

header "Identificando Versão do Projeto"
VERSION=$(xcodebuild -project ../UptimeLogger.xcodeproj -showBuildSettings | awk '/MARKETING_VERSION/ { print $3 }' | sed 's/[[:space:]]//g')

header "Assinando app"
codesign --deep --force --verbose --options runtime \
    --timestamp=none --all-architectures\
    --entitlements "$APP_FOLDER/Contents/Resources/UptimeLogger.entitlements" \
    --sign - "$APP_FOLDER"

header "Criando Instalador"
mkdir "$DMG_FOLDER"
pkgbuild --root "$APP_FOLDER"  --install-location "/Applications/UptimeLogger.app" --scripts ./Install\
    --identifier "$BUNDLE_NAME" --version "$VERSION"\
    "$DMG_FOLDER/$INSTALLER_NAME.pkg"

header "Criando Desinstalador"
pkgbuild --nopayload  --scripts ./Uninstall\
    --identifier "$BUNDLE_NAME.uninstall" --version "$VERSION"\
    "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"

# header "Assinando pacotes"
# productsign --sign - "$CACHE_FOLDER/$INSTALLER_NAME.pkg" "$DMG_FOLDER/$INSTALLER_NAME.pkg"
# productsign --sign - "$CACHE_FOLDER/$UNINSTALLER_NAME.pkg" "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"

header "Criando dmg de instalação"
hdiutil create -volname "UptimeLogger"\
    -srcfolder "$DMG_FOLDER"\
    -ov -format UDZO\
    "UptimeLogger-$VERSION.dmg"

# cp "$DMG_FOLDER/$INSTALLER_NAME.pkg" "./$INSTALLER_NAME.pkg"
# cp -R "$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app" ./

header "Apagando caches"
rm -rf "$CACHE_FOLDER"

if [ "$1" != "loop" ]; then
    header "Criando Tag do Git"
    read -p "Gostaria de criar a tag $VERSION no git? [s/N]" confirm
    if [[ $confirm =~ ^[Ss]$ ]]; then
        git tag $VERSION
        git --no-pager tag
    else
        echo -e "\033[31mA tag não foi criada.\033[0m"
    fi
    I=$((I+1))
fi
