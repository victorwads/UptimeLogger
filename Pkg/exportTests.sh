#!/bin/sh

rm -rf xcov_report

source "runBuildTests.sh"

xcov    -p "$PROJECT"\
        -s UptimeLogger --html_report\

open xcov_report/index.html