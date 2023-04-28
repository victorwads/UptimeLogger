#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh

# to store pass
xcrun notarytool store-credentials "$ACCOUNT_PROFILE" \
    --team-id "$TEAM_ID"
#    --apple-id "email@email.com" \
#    --password "fma-password-at-idapple-com"