variable "skip_s3" {
  description = "Skip S3 bucket creation if set to true"
  default     = "false"
}

variable "skip_dynamodb" {
  description = "Skip DynamoDB table creation if set to true"
  default     = "false"
}

variable "skip_cloudfront" {
  description = "Skip CloudFront distribution creation if set to true"
  default     = "false"
}

variable "skip_iam_role" {
  description = "Skip IAM Role creation if set to true"
  default     = "false"
}

variable "skip_iam_policy" {
  description = "Skip IAM Policy creation if set to true"
  default     = "false"
}

variable "skip_lambda" {
  description = "Skip Lambda function creation if set to true"
  default     = "false"
}