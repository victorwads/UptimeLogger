#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh
S=5;

header "import certificate and provisioning profile from secrets"
echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o "$CERTIFICATE_PATH"
echo -n "$BUILD_PROVISION_PROFILE_BASE64" | base64 --decode -o "$PP_PATH"

header "create temporary keychain"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"

header "import certificate to keychain"
security import "$CERTIFICATE_PATH" -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
security list-keychain -d user -s "$KEYCHAIN_PATH"

header "apply provisioning profile"
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "$PP_PATH" ~/Library/MobileDevice/Provisioning\ Profiles

header "to store pass for notarytool"
xcrun notarytool store-credentials "$ACCOUNT_PROFILE" \
    --team-id "$TEAM_ID" \
    --apple-id "$APPLE_ID" \
    --password "$APPLE_APPPASS" \
    --keychain "$KEYCHAIN_PATH"
