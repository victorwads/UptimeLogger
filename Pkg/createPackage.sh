#!/bin/sh
rm -rf ../cache UptimeLogger.app "./UptimeLogger.pkg"

xcodebuild -project ../UptimeLogger.xcodeproj -scheme UptimeLogger -configuration Release -derivedDataPath ../cache/
cp -R ../cache/Build/Products/Release/UptimeLogger.app ./

pkgbuild --root "UptimeLogger.app" --install-location "/Applications/UptimeLogger.app" --identifier "br.com.victorwads.UptimeLogger" --version "2.0" --scripts "./Scripts" "./UptimeLogger.pkg"
pkgbuild --nopayload --scripts ./UninstallScripts --identifier "br.com.victorwads.UptimeLogger.uninstall" --version "2.0" UptimeLoggerUninstaller.pkg

rm -rf ../cache UptimeLogger.app
