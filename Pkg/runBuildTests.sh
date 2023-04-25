#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJECT="$SCRIPT_DIR/../UptimeLogger.xcodeproj"


echo -e "\033[32mBuildando app release\033[0m"

xcodebuild test -quiet -project "$PROJECT"\
                -scheme UptimeLogger\
                -xcconfig "$SCRIPT_DIR/build.xcconfig"\
                -enableCodeCoverage YES\
                -destination "platform=macOS"

# xcov    -p "$PROJECT"\
#         -s UptimeLogger --html_report\
#         -e FirebaseCrashlytics,FirebaseInstallations,\
#         GULAppDelegateSwizzler,GULEnvironment,GULLogger,GULMethodSwizzler,GULMethodSwizzler,\
#         GULNSData,GULNetwork,GULUserDefaults