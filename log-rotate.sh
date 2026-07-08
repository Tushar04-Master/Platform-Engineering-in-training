# Shebang to specify this script runs in the bash shell
#!/bin/bash

set -euo pipefail

log() {
  local timestamp=$(date+"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1"
}

if [ "$#" -ne 2 ]; then
log "Error : Invalid number of arguments"
log "Usage: ./log-rotate.sh <log_directory> <archive_directory>"
exit 1
fi

LOG_DIR="$1"
ARCHIVE_DIR="$2"
mkdir -p "$ARCHIVE_DIR"

log "Starting log rotation. Source: $LOG_DIR | Destination: $ARCHIVE_DIR"

BEFORE_COUNT=$(find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" | wc -l)
log "Total .log files before rotation: $BEFORE_COUNT"
find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" -mtime +7 -print0 | while IFS= read -r -d '' file; do
    
    # Log the specific file currently being processed
    log "Archiving old log file: $file"
    
    # Compress the file using gzip (this automatically deletes the uncompressed original)
    gzip "$file"
    
    # Move the newly created .gz file into our target archive directory
    mv "${file}.gz" "$ARCHIVE_DIR/"
    
# Close the while loop
done

AFTER_COUNT=$(find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" | wc -l)

# Log the final file count
log "Total .log files remaining: $AFTER_COUNT"

# Log a success message to indicate the script finished without errors
log "Log rotation completed successfully!"

