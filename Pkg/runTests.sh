#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh

header "Testando app Debug"

xcodebuild test-without-building \
    -project "$PROJECT"\
    -scheme "$SCHEME"\
    -configuration Debug
ret=$?