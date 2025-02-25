#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <json_file_path> <environment>"
    exit 1
fi

# Assign arguments to variables
JSON_FILE="$1"
ENVIRONMENT="$2"

# Check if JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "JSON file not found: $JSON_FILE"
    exit 1
fi

# Extract IAM role ARNs and regions using Python
DEFAULT_IAM_ROLE_ARN=$(python -c "import json; print(json.load(open('$JSON_FILE'))['$ENVIRONMENT']['default_iam_role_arn'])")
DEFAULT_IAM_ROLE_REGION=$(python -c "import json; print(json.load(open('$JSON_FILE'))['$ENVIRONMENT']['default_iam_role_region'])")
DNS_IAM_ROLE_ARN=$(python -c "import json; print(json.load(open('$JSON_FILE'))['$ENVIRONMENT']['dns_iam_role_arn'])")
DNS_IAM_ROLE_REGION=$(python -c "import json; print(json.load(open('$JSON_FILE'))['$ENVIRONMENT']['dns_iam_role_region'])")

# Ensure no empty variables
if [[ -z "$DEFAULT_IAM_ROLE_ARN" || -z "$DEFAULT_IAM_ROLE_REGION" || -z "$DNS_IAM_ROLE_ARN" || -z "$DNS_IAM_ROLE_REGION" ]]; then
    echo "Error: One or more IAM role values are empty. Please check your JSON file."
    exit 1
fi

# Correctly setting them as environment variables for GitHub Actions
{
    echo "DEFAULT_IAM_ROLE_ARN=$DEFAULT_IAM_ROLE_ARN"
    echo "DEFAULT_IAM_ROLE_REGION=$DEFAULT_IAM_ROLE_REGION"
    echo "DNS_IAM_ROLE_ARN=$DNS_IAM_ROLE_ARN"
    echo "DNS_IAM_ROLE_REGION=$DNS_IAM_ROLE_REGION"
} >> "$GITHUB_ENV"

# Debugging output
echo "Extracted IAM Roles:"
echo "DEFAULT_IAM_ROLE_ARN=$DEFAULT_IAM_ROLE_ARN"
echo "DNS_IAM_ROLE_ARN=$DNS_IAM_ROLE_ARN"
