#!/bin/bash
THRESHOLD=80

# Get disk usage percentage for the root directory
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//g')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage critical: $USAGE%"
else
    echo "Disk is normal: $USAGE%"
fi