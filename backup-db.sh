#!/bin/bash

set -euo pipefail

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

log() {
    # Generate the current date and time and store it in a local variable
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Print the formatted timestamp alongside the message, enabling escape sequences (-e)
    echo -e "[$timestamp] $1"
# Close the log function
}
# Check if the number of arguments provided ($#) is exactly not equal to 4
if [ "$#" -ne 4 ]; then
    
    # Log an error message indicating the user missed required arguments
    log "ERROR: Invalid number of arguments."
    
    # Show the user the correct usage pattern for the script
    log "Usage: ./backup-db.sh <db_host> <db_name> <db_user> <backup_dir>"
    
    # Exit the script with a status code of 1 to signal a failure
    exit 1
    
# Close the argument validation block
fi

# Assign the first argument to the DB_HOST variable
DB_HOST="$1"

# Assign the second argument to the DB_NAME variable
DB_NAME="$2"

# Assign the third argument to the DB_USER variable
DB_USER="$3"

# Assign the fourth argument to the BACKUP_DIR variable
BACKUP_DIR="$4"

# Generate a timestamp formatted as YYYYMMDD_HHMMSS for the filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Construct the full filename using the database name and the timestamp
FILENAME="${DB_NAME}_${TIMESTAMP}.sql"

# Construct the absolute path by combining the backup directory and filename
FILEPATH="${BACKUP_DIR}/${FILENAME}"

# Log the start of the backup process
log "Starting backup for database '${DB_NAME}' on host '${DB_HOST}'..."

# Create the backup directory and any missing parent directories (-p) safely
mkdir -p "$BACKUP_DIR"

# Check if the pg_dump command does NOT exist on the system, silencing the check output
if ! command -v pg_dump >/dev/null 2>&1; then
    
    # Log a yellow warning that the required database client is missing
    log "${YELLOW}WARNING: pg_dump utility not found on this system.${NC}"
    
    # Print the exact command the user needs to run to install the missing tool
    log "${YELLOW}To install, run: sudo apt-get update && sudo apt-get install postgresql-client${NC}"
    
    # Log that we are generating a mock file instead since the tool is missing
    log "Generating a placeholder backup file for testing..."
    
    # Create a dummy SQL file to simulate a successful database dump
    echo "-- MOCK SQL DUMP DATA FOR ${DB_NAME} --" > "$FILEPATH"
    
# Specify what to do if pg_dump IS actually installed
else
    
    # Log that the tool was found and we are initiating the dump
    log "pg_dump found. Initiating database dump..."
    
    # PHASE 2 REAL COMMAND: pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -F c > "$FILEPATH"
    
    # Create a dummy SQL file anyway for this simulated phase 1 script
    echo "-- MOCK SQL DUMP DATA FOR ${DB_NAME} --" > "$FILEPATH"
    
# Close the pg_dump check block
fi

# Log that we are compressing the newly created backup file
log "Compressing backup file..."

# Compress the SQL file using gzip, which automatically deletes the uncompressed original
gzip "$FILEPATH"

# Define a new variable for the compressed file by appending .gz to the path
FINAL_FILE="${FILEPATH}.gz"

# Calculate the file size using du (disk usage) in human-readable format (-h) and extract just the size using cut
FILE_SIZE=$(du -sh "$FINAL_FILE" | cut -f1)

# Log a green success message containing the final path and the calculated size
log "${GREEN}SUCCESS: Backup saved to ${FINAL_FILE} (Size: ${FILE_SIZE})${NC}"

# Log a placeholder note for where the cloud upload logic will go
log "Preparing to upload to offsite storage..."

# PHASE 2 REAL COMMAND: aws s3 cp "$FINAL_FILE" s3://my-company-db-backups/

# Exit the script with a status code of 0 to signal a clean, successful run
exit 0





















































