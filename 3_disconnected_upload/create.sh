#!/bin/bash

# Configuration
HARBOR_HOST="harbor.apps.harvester.local"
USERNAME="admin"
PASSWORD="Harbor12345"

# Get project name from command line argument or prompt for it
PROJECT_NAME="$1"

if [ -z "${PROJECT_NAME}" ]; then
  read -p "Enter project name to create: " PROJECT_NAME
fi

if [ -z "${PROJECT_NAME}" ]; then
  echo "Error: Project name cannot be empty."
  exit 1
fi

# Optional: Default to private (set to "true" for public)
IS_PUBLIC="true"

# Encode credentials
AUTH_HEADER="Authorization: Basic $(echo -n "${USERNAME}:${PASSWORD}" | base64)"

# Construct JSON payload
PAYLOAD=$(jq -n \
  --arg name "${PROJECT_NAME}" \
  --arg public "${IS_PUBLIC}" \
  '{
    project_name: $name,
    public: ($public == "true"),
    storage_limit: -1
  }')

echo "Creating project '${PROJECT_NAME}' on ${HARBOR_HOST}..."

# Send request to Harbor API v2.0
HTTP_STATUS=$(curl -s -k -o /dev/null -w "%{http_code}" -X POST \
  "https://${HARBOR_HOST}/api/v2.0/projects" \
  -H "${AUTH_HEADER}" \
  -H "Content-Type: application/json" \
  -d "${PAYLOAD}")

case "${HTTP_STATUS}" in
  201)
    echo "Success: Project '${PROJECT_NAME}' created."
    ;;
  409)
    echo "Notice: Project '${PROJECT_NAME}' already exists."
    ;;
  400)
    echo "Error (400): Invalid project name syntax or payload."
    ;;
  *)
    echo "Failed to create project. HTTP Status Code: ${HTTP_STATUS}"
    ;;
esac
