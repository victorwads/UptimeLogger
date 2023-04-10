#!/bin/bash
echo "All Logs"
ls -1p ./logs

echo ""
echo "Watching latest:"
readlink -f log_latest.txt
echo ""

while true; do
    cat log_latest.txt
    sleep 1
done