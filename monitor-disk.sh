#!/bin/bash

set -euo pipefail

# Define ANSI escape code for red text to highlight alerts
RED='\033[0;31m'

# Define ANSI escape code for green text to highlight healthy statuses
GREEN='\033[0;32m'

# Define ANSI escape code to reset terminal formatting back to normal
NC='\033[0m'

# Define our standard logging function to keep outputs consistent and timestamped
log() {
    # Generate the current date and time and store it in a local variable
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Print the formatted timestamp alongside the message, enabling escape sequences (-e)
    echo -e "[$timestamp] $1"
# Close the log function
}

# Assign the first argument to THRESHOLD, defaulting to 80 if not provided
THRESHOLD="${1:-80}"

# Assign the second argument to MOUNT_POINT, defaulting to the root directory (/) if not provided
MOUNT_POINT="${2:-/}"

# Log the initiation of the disk check, showing the target mount point and the threshold limit
log "Checking disk space on '${MOUNT_POINT}' (Threshold: ${THRESHOLD}%)"

# Fetch disk usage, extract the second row's 5th column with awk, and delete the '%' sign so we can do math
USAGE=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    
    # Log a red alert message because the disk is too full
    log "${RED}ALERT: Disk usage (${USAGE}%) exceeds the ${THRESHOLD}% threshold!${NC}"
    
    # Exit the script with an error code (1) so monitoring systems know it failed
    exit 1

# Specify what to do if the usage is less than or equal to the threshold
else
    
    # Log a green success message indicating the disk space is healthy
    log "${GREEN}OK: Disk usage is at ${USAGE}%, which is within safe limits.${NC}"
    
    # Exit the script with a success code (0)
    exit 0
    
# Close the if statement
fi


























