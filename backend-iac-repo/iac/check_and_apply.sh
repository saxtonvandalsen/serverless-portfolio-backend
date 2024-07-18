#!/bin/bash

set -e

# Check if S3 bucket exists
BUCKET_NAME="cloudresumechallenge-sv"
if aws s3 ls "s3://${BUCKET_NAME}" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "S3 bucket ${BUCKET_NAME} does not exist, creating..."
  terraform apply -auto-approve
else
  echo "S3 bucket ${BUCKET_NAME} already exists, skipping creation..."
fi

# Check if DynamoDB table exists
TABLE_NAME="cloudresumechallenge-db"
if aws dynamodb describe-table --table-name "${TABLE_NAME}" 2>&1 | grep -q 'ResourceNotFoundException'; then
  echo "DynamoDB table ${TABLE_NAME} does not exist, creating..."
  terraform apply -auto-approve
else
  echo "DynamoDB table ${TABLE_NAME} already exists, skipping creation..."
fi
