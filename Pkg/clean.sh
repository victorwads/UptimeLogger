#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh

security delete-keychain "$RUNNER_TEMP/app-signing.keychain-db"
rm "$CERTIFICATE_PATH"
rm "$PP_PATH"
