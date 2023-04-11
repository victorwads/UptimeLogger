#!/bin/bash
echo "All Logs"
ls -1p ./logs

echo ""
echo "Watching latest:"
readlink -f logs/latest    
echo ""

while true; do
    cat logs/latest
    sleep 1
done
