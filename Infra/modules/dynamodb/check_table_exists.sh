#!/bin/bash
TABLE_NAME=$1
REGION=$2

if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" > /dev/null 2>&1; then
    echo "{\"exists\":true}"
else
    echo "{\"exists\":false}"
fi