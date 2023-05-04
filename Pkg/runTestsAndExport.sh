#!/bin/bash
# shellcheck source=projectConfig.sh
source Pkg/projectConfig.sh

S=5
header "Gerando projeto"
xcodegen
ret=$?

# shellcheck source=runBuild.sh
source Pkg/runBuild.sh
# shellcheck source=runTests.sh
source Pkg/runTests.sh

header "Exportant Tests"
rm -rf xcov_report
xcov \
    -p "$PROJECT"\
    -s UptimeLogger --html_report
ret=$?

open xcov_report/index.html
ret=$?

header "Abrindo Resultado"

sleep 5
rm -rf xcov_report