#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh
clear

CACHE_FOLDER="$SCRIPT_DIR/cache"
DMG_FOLDER="$CACHE_FOLDER/dmg"
APP_FOLDER="$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app"
GRELEASE="../GoogleService-Info.plist"
if [ ! -f "$GRELEASE" ]; then echo -e "\033[31m$GRELEASE not found\033[0m"; exit 1; fi

S=12;I=1;

header "Identificando Certificados e Versão do Projeto"
VERSION=$(awk -F'\"' '/CFBundleShortVersionString/{print $2}' project.yml)
TEAM_ID=$(awk -F': ' '/DEVELOPMENT_TEAM/{print $2}' project.yml)
#APP_CERT=$(security find-certificate -c "Developer ID Application" -Z | awk -F'"' '/alis/ {print $4}')
INSTALLER_CERT=$(security find-certificate -c "Developer ID Installer" -Z | awk -F'"' '/alis/ {print $4}')
echo "VERSION: $VERSION"
echo "TEAM_ID: $TEAM_ID"

header "Copiando Google Release Configs"
cp "$GRELEASE" "Resources/"
mkdir "$CACHE_FOLDER"
mkdir "$DMG_FOLDER"

header "Apangando dados anteriores e logs de teste"
rm -rf Service/logs/
rm -f ./**/*.dmg

header "Buildando service"
shc -f Service/uptime_logger.sh -o Service/UptimeLoggerService
ret=$?
rm Service/uptime_logger.sh.*

header "Gerando projeto"
xcodegen

header "Buildando app release"
xcodebuild -project $PROJECT -scheme UptimeLogger -configuration Release \
    -destination 'generic/platform=macOS'\
    -derivedDataPath "$CACHE_FOLDER" -quiet
ret=$?

# header "Assinando app"
# codesign --deep --force --verbose --options runtime \
#     --all-architectures --entitlements "Resources/Release.entitlements" \
#     --sign "$APP_CERT" "$APP_FOLDER"
# ret=$?

header "Criando Instalador"
pkgbuild --root "$APP_FOLDER" --install-location "/Applications/UptimeLogger.app" --scripts "$SCRIPT_DIR/Install"\
    --identifier "$BUNDLE_NAME" --version "$VERSION" \
    "$CACHE_FOLDER/$INSTALLER_NAME.pkg"
ret=$?

header "Criando Desinstalador"
pkgbuild --nopayload --scripts "$SCRIPT_DIR/Uninstall"\
    --identifier "$BUNDLE_NAME.uninstall" --version "$VERSION" \
    "$CACHE_FOLDER/$UNINSTALLER_NAME.pkg"
ret=$?

header "Assinando pacotes"
productsign --sign "$INSTALLER_CERT" "$CACHE_FOLDER/$INSTALLER_NAME.pkg" "$DMG_FOLDER/$INSTALLER_NAME.pkg"
ret=$?
productsign --sign "$INSTALLER_CERT" "$CACHE_FOLDER/$UNINSTALLER_NAME.pkg" "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"
ret=$?

header "Criando dmg de instalação"
hdiutil create -volname "UptimeLogger" \
    -srcfolder "$DMG_FOLDER" \
    -ov -format UDZO\
    "UptimeLogger-$VERSION.dmg"

# cp "$DMG_FOLDER/$INSTALLER_NAME.pkg" "./$INSTALLER_NAME.pkg"
# cp -R "$CACHE_FOLDER/Build/Products/Release/UptimeLogger.app" ./

header "Apagando caches"
rm -rf "$CACHE_FOLDER"

header "Criando Tag do Git"
tag_exist=$(git --no-pager tag --list "$VERSION")
if [[ -n $tag_exist ]]; then
    echo "Tag já existe criada"
else
    read -p "Gostaria de criar a tag $VERSION no git? [s/N]" confirm
    if [[ $confirm =~ ^[Ss]$ ]]; then
        git tag "$VERSION"
        echo "Tag Criada"
    else
        echo -e "\033[31mA tag não foi criada.\033[0m"
    fi
    I=$((I + 1))
fi
