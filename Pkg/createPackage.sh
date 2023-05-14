#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh
clear
DEBUG=false
S=19;

if [[ "$*" == *"--debug"* ]]; then
    S=5;
    DEBUG=true
fi

header "Identificando Certificados e Versão do Projeto e variaveis"
VERSION=$(awk -F': ' '/MARKETING_VERSION/{print $2}' project.yml)
APP_CERT=$(security find-certificate -c "Developer ID Application" -Z | awk -F'"' '/alis/ {print $4}')
INSTALLER_CERT=$(security find-certificate -c "Developer ID Installer" -Z | awk -F'"' '/alis/ {print $4}')
CACHE_FOLDER="$SCRIPT_DIR/cache"
APP_FOLDER="$CACHE_FOLDER/Build/Products/Release/$SCHEME.app"
DMG_FOLDER="$CACHE_FOLDER/dmg"
DMG_NAME="UptimeLogger-$VERSION.dmg"
echo "VERSION: $VERSION"
echo "TEAM_ID: $TEAM_ID"
echo "APP_CERT: $APP_CERT"
echo "INSTALLER_CERT: $INSTALLER_CERT"
echo "CACHE_FOLDER: $CACHE_FOLDER"
echo "APP_FOLDER: $APP_FOLDER"
echo "DMG_FOLDER: $DMG_FOLDER"
echo "DMG_NAME: $DMG_NAME"

mkdir "$CACHE_FOLDER"
mkdir "$DMG_FOLDER"

if [ ! $DEBUG = true ]; then
    header "Apagando caches e dados anteriores e logs de teste"
    rm -rf "$CACHE_FOLDER"
    rm -rf Service/logs
    rm -f **/*.dmg
fi

header "Gerando projeto"
xcodegen

header "Buildando app release"
xcodebuild -project $PROJECT -scheme UptimeLogger -configuration Release \
    -destination 'generic/platform=macOS'\
    -derivedDataPath "$CACHE_FOLDER" -quiet
ret=$?

ret=$?
if [ ! $DEBUG = true ]; then
    codesign -dvv $APP_FOLDER

    header "Submentendo app para validação da Apple"
    ZIP_PATH="$CACHE_FOLDER/$SCHEME.app.zip"
    /usr/bin/ditto -c -k --keepParent "$APP_FOLDER" "$ZIP_PATH"
    xcrun notarytool submit "$ZIP_PATH" \
        --keychain-profile "$ACCOUNT_PROFILE" \
        --wait
    ret=$?

    header "Marcando validação no app"
    xcrun stapler staple "$APP_FOLDER"
    ret=$?
fi

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

if [ ! $DEBUG = true ]; then
    header "Assinando pacotes de instalação pkg localmente"
    productsign --keychain "$KEYCHAIN_PATH" --timestamp \
        --sign "$INSTALLER_CERT" \
        "$CACHE_FOLDER/$INSTALLER_NAME.pkg" "$DMG_FOLDER/$INSTALLER_NAME.pkg"
    ret=$?

    productsign --keychain "$KEYCHAIN_PATH" --timestamp \
        --sign "$INSTALLER_CERT" \
        "$CACHE_FOLDER/$UNINSTALLER_NAME.pkg" "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"
    ret=$?

    header "Submentendo Instalador para validação da Apple"
    xcrun notarytool submit "$DMG_FOLDER/$INSTALLER_NAME.pkg" \
        --keychain-profile "$ACCOUNT_PROFILE" \
        --wait
    ret=$?

    header "Marcando validação no instalador"
    xcrun stapler staple "$DMG_FOLDER/$INSTALLER_NAME.pkg"
    ret=$?

    header "Submentendo Desinstalador para validação da Apple"
    xcrun notarytool submit "$DMG_FOLDER/$UNINSTALLER_NAME.pkg" \
        --keychain-profile "$ACCOUNT_PROFILE" \
        --wait
    ret=$?

    header "Marcando validação no desinstalador"
    xcrun stapler staple "$DMG_FOLDER/$UNINSTALLER_NAME.pkg"
    ret=$?

    header "Criando imagem dmg"
    hdiutil create -volname "UptimeLogger" \
        -srcfolder "$DMG_FOLDER" \
        -ov -format UDZO\
        "$DMG_NAME"
    ret=$?

    header "Assinando dmg localmente"
    codesign --verbose --options runtime --keychain "$KEYCHAIN_PATH" \
        --sign "$APP_CERT" "$DMG_NAME"
    ret=$?

    header "Submentendo imagem dmg para validação da Apple"
    xcrun notarytool submit "$DMG_NAME" \
        --keychain-profile "$ACCOUNT_PROFILE" \
        --wait
    ret=$?

    header "Marcando validação na imagem dmg"
    xcrun stapler staple "$DMG_NAME"
    ret=$?

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
fi