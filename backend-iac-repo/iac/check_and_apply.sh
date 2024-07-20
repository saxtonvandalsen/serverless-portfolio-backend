#!/bin/bash

set -e

# Ensuring terraform configuration in correct directory
cd backend-iac-repo/iac

# Check if S3 bucket exists
BUCKET_NAME="cloudresumechallenge-sv"
if aws s3 ls "s3://${BUCKET_NAME}" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "S3 bucket ${BUCKET_NAME} does not exist, creating..."
else
  echo "S3 bucket ${BUCKET_NAME} already exists, skipping creation..."
  export SKIP_S3=true
fi

# Check if DynamoDB table exists
TABLE_NAME="cloudresumechallenge-db"
if aws dynamodb describe-table --table-name "${TABLE_NAME}" 2>&1 | grep -q 'ResourceNotFoundException'; then
  echo "DynamoDB table ${TABLE_NAME} does not exist, creating..."
else
  echo "DynamoDB table ${TABLE_NAME} already exists, skipping creation..."
  export SKIP_DYNAMODB=true
fi

# Check if IAM role exists
ROLE_NAME="iam_for_lambda_SV3"
if aws iam get-role --role-name "${ROLE_NAME}" 2>&1 | grep -q 'NoSuchEntity'; then
  echo "IAM Role ${ROLE_NAME} does not exist, creating..."
else
  echo "IAM Role ${ROLE_NAME} already exists, skipping creation..."
  export SKIP_IAM_ROLE=true
fi

# Check if IAM policy exists
POLICY_NAME="aws_iam_policy_for_terraform_cloud_resume_policySV3"
POLICY_ARN="arn:aws:iam::123456789012:policy/${POLICY_NAME}"
if aws iam get-policy --policy-arn "${POLICY_ARN}" 2>&1 | grep -q 'NoSuchEntity'; then
  echo "IAM Policy ${POLICY_NAME} does not exist, creating..."
else
  echo "IAM Policy ${POLICY_NAME} already exists, skipping creation..."
  export SKIP_IAM_POLICY=true
fi

# Check if Lambda function exists
LAMBDA_NAME="myfunc"
if aws lambda get-function --function-name "${LAMBDA_NAME}" 2>&1 | grep -q 'ResourceNotFoundException'; then
  echo "Lambda function ${LAMBDA_NAME} does not exist, creating..."
else
  echo "Lambda function ${LAMBDA_NAME} already exists, skipping creation..."
  export SKIP_LAMBDA=true
fi

# Check if CloudFront distribution exists
CLOUDFRONT_ID="E2LYTO40JJHVJ"
if aws cloudfront get-distribution --id "${CLOUDFRONT_ID}" 2>&1 | grep -q 'NoSuchDistribution'; then
  echo "CloudFront distribution ${CLOUDFRONT_ID} does not exist, creating..."
else
  echo "CloudFront distribution ${CLOUDFRONT_ID} already exists, skipping creation..."
  export SKIP_CLOUDFRONT=true
fi

# Check if CloudFront origin access identity exists
OAI_ID="YOUR_OAI_ID"  # replace with your actual OAI ID
if aws cloudfront get-cloud-front-origin-access-identity --id "${OAI_ID}" 2>&1 | grep -q 'NoSuchOriginAccessIdentity'; then
  echo "CloudFront origin access identity ${OAI_ID} does not exist, creating..."
else
  echo "CloudFront origin access identity ${OAI_ID} already exists, skipping creation..."
  export SKIP_OAI=true
fi

# Run terraform apply with conditional logic
echo "Applying Terraform configurations..."
terraform apply -auto-approve -var="skip_s3=${SKIP_S3}" -var="skip_dynamodb=${SKIP_DYNAMODB}" -var="skip_iam_role=${SKIP_IAM_ROLE}" -var="skip_iam_policy=${SKIP_IAM_POLICY}" -var="skip_lambda=${SKIP_LAMBDA}" -var="skip_cloudfront=${SKIP_CLOUDFRONT}" -var="skip_oai=${SKIP_OAI}"
