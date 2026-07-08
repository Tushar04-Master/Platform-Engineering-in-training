# Shebang to tell the OS to execute this file using the bash shell
#!/bin/bash

# Exit on error (-e), exit on unset variables (-u), catch pipe errors (-o pipefail)
set -euo pipefail

# Define the ANSI escape code for green text
GREEN='\033[0;32m'

# Define the ANSI escape code for red text
RED='\033[0;31m'

# Define the ANSI escape code to reset terminal formatting back to normal
NC='\033[0m'

# Define a function named 'log' to standardize our output with timestamps
log() {
    # Create a local variable holding the current date and time format
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Print the timestamp and the first argument passed to the function, enabling backslash escapes (-e)
    echo -e "[$timestamp] $1"
# Close the log function block
}

# Assign the first script argument to URL, or use the default string if it is empty/unset
URL="${1:-http://localhost:8000}"

# Set the maximum number of times we want to check the endpoint
MAX_RETRIES=3

# Initialize our loop counter to start at the first attempt
ATTEMPT=1

# Call our log function to announce that the script is starting
log "Starting health check for URL: $URL"

# Begin a while loop that continues as long as ATTEMPT is less than or equal to MAX_RETRIES
while [ "$ATTEMPT" -le "$MAX_RETRIES" ]; do
    
    # Call our log function to print the current attempt number
    log "Attempt $ATTEMPT of $MAX_RETRIES..."
    
    # Use curl to fetch the HTTP status code, suppressing errors (|| true) so the script doesn't abort
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL" || true)
    
    # Check if the HTTP status code exactly matches the string "200"
    if [ "$HTTP_STATUS" = "200" ]; then
        
        # Log a success message formatted with the GREEN color code
        log "${GREEN}SUCCESS: Service at $URL is healthy!${NC}"
        
        # Exit the script immediately with a success code (0)
        exit 0
        
    # Close the if statement
    fi
    
    # Log a warning message formatted with the RED color code showing the failed status
    log "${RED}WARNING: Service returned status $HTTP_STATUS${NC}"
    
    # Check if we have retries remaining before sleeping to avoid an unnecessary wait at the end
    if [ "$ATTEMPT" -lt "$MAX_RETRIES" ]; then
        
        # Log a message indicating we are pausing before the next attempt
        log "Waiting 1 second before retrying..."
        
        # Pause script execution for exactly 1 second
        sleep 1
        
    # Close the inner if statement
    fi
    
    # Increment the attempt counter by using arithmetic expansion
    ATTEMPT=$((ATTEMPT + 1))
    
# Close the while loop
done

# If the loop exhausts all retries without exiting, log a final failure message
log "${RED}FAILURE: Service at $URL is unhealthy after $MAX_RETRIES attempts.${NC}"

# Exit the script with an error code (1) to indicate failure to the OS
exit 1
