#!/bin/bash

set -e

# Set the working directory to where your Terraform files are located
cd backend-iac-repo/iac

# Check if S3 bucket exists
BUCKET_NAME="cloudresumechallenge-sv"
S3_EXISTS=true
if aws s3 ls "s3://${BUCKET_NAME}" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "S3 bucket ${BUCKET_NAME} does not exist, creating..."
  S3_EXISTS=false
fi

# Check if DynamoDB table exists
TABLE_NAME="cloudresumechallenge-db"
DYNAMODB_EXISTS=true
if aws dynamodb describe-table --table-name "${TABLE_NAME}" 2>&1 | grep -q 'ResourceNotFoundException'; then
  echo "DynamoDB table ${TABLE_NAME} does not exist, creating..."
  DYNAMODB_EXISTS=false
fi

# Run Terraform Apply
# if [ "$S3_EXISTS" = false ] || [ "$DYNAMODB_EXISTS" = false ]; then
#  terraform apply -auto-approve
#else
#  echo "S3 bucket and DynamoDB table already exist, applying other changes..."
#  terraform apply -auto-approve
#fi