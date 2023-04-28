#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh

header "Buildando app Debug"

xcodebuild build-for-testing -quiet\
    -project "$PROJECT"\
    -scheme "$SCHEME"\
    -configuration Debug\
    -destination "platform=macOS"\
    -xcconfig "$SCRIPT_DIR/build.xcconfig"
ret=$?