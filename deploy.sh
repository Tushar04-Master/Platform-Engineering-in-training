#!/bin/bash

set -euo pipefail

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
log(){
       local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
       echo -e "[$timestamp] $1"
}
if [ "$#" -ne 3 ]; then
# Log a red error message indicating the user missed required arguments
    log "${RED}ERROR: Missing required arguments.${NC}"
    
    # Show the user the correct usage pattern for the script
    log "Usage: ./deploy.sh <namespace> <app_name> <image_tag>"
    
    # Exit the script with a status code of 1 to signal a failure to the operating system
    exit 1
fi

# Assign the first argument passed to the script to the NAMESPACE variable
NAMESPACE="$1"

# Assign the second argument passed to the script to the APP_NAME variable
APP_NAME="$2"

# Assign the third argument passed to the script to the IMAGE_TAG variable
IMAGE_TAG="$3"

# Announce the start of the deployment using yellow to show it is in progress
log "${YELLOW}Initiating deployment for ${APP_NAME} to namespace: ${NAMESPACE}${NC}"

# ---------------------------------------------------------
# STEP 1: PULL IMAGE
# ---------------------------------------------------------

# Log that we are simulating the image pull process
log "${YELLOW}[1/5] Pulling image tag ${IMAGE_TAG}...${NC}"

# PHASE 2 REAL COMMAND: docker pull myregistry.com/${APP_NAME}:${IMAGE_TAG}

# Pause for 1 second to simulate network latency of downloading an image
sleep 1

# ---------------------------------------------------------
# STEP 2: VALIDATE CONFIGURATION
# ---------------------------------------------------------

# Log that we are validating the deployment manifests
log "${YELLOW}[2/5] Validating Kubernetes manifests...${NC}"

# PHASE 2 REAL COMMAND: kubectl kustomize ./k8s/${APP_NAME} > dry-run.yaml

# Pause for 1 second to simulate a validation check
sleep 1

# STEP 3: APPLY MANIFESTS
# ---------------------------------------------------------

# Log that we are applying the configuration to the cluster
log "${YELLOW}[3/5] Applying configuration to cluster...${NC}"

# PHASE 2 REAL COMMAND: kubectl apply -f dry-run.yaml -n ${NAMESPACE}

# Pause for 1 second to simulate API server communication
sleep 1

# STEP 4: WAIT FOR ROLLOUT
# ---------------------------------------------------------

# Log that we are waiting for the new pods to spin up
log "${YELLOW}[4/5] Waiting for resources to provision...${NC}"

# PHASE 2 REAL COMMAND: kubectl rollout status deployment/${APP_NAME} -n ${NAMESPACE} --timeout=90s

# Pause for 2 seconds to simulate container startup time
sleep 2

# STEP 5: HEALTH CHECK
# ---------------------------------------------------------

# Log that we are performing a final health check on the deployed application
log "${YELLOW}[5/5] Performing post-deployment health check...${NC}"

# PHASE 2 REAL COMMAND: kubectl get pods -l app=${APP_NAME} -n ${NAMESPACE} | grep Running

# Pause for 1 second to simulate hitting a /healthz endpoint
sleep 1

# Log a final green success message indicating the deployment finished without triggering set -e
log "${GREEN}SUCCESS: ${APP_NAME}:${IMAGE_TAG} has been successfully deployed to ${NAMESPACE}!${NC}"

# Exit the script with a status code of 0 to signal a clean, successful run
exit 0

































































