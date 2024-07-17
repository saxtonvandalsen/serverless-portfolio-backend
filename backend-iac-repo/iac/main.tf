resource "aws_lambda_function" "myfunc" {
  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name = "myfunc"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "func.lambda_handler"
  runtime = "python3.8"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_iam_policy" "iam_policy_for_cloudresumechallenge" {

    name = "aws_iam_policy_for_terraform_cloud_resume_policy"
    path = "/"
    description = "AWS IAM Policy for managing cloud resume project role"
    policy = jsonencode(
        {
            "Version" : "2012-10-17",
            "Statement" : [
                {
                    "Action" : [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ],
                    "Resource" : "arn:aws:logs:*:*:*",
                    "Effect" : "Allow"
                },
                {
                    "Effect" : "Allow",
                    "Action" : [
                        "dynamodb:UpdateItem",
                        "dynamodb:GetItem",
                        "dynamodb:PutItem"
                    ],
                    "Resource" : "arn:aws:dynamodb:*:*:table/cloudresumechallenge-db"
                },
            ]
        }
    )

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_cloudresumechallenge.arn
}

data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda/"
    output_path = "${path.module}/packedlambda.zip"
}

resource "aws_lambda_function_url" "url1" {
  function_name = aws_lambda_function.myfunc.function_name
  authorization_type = "NONE"
}

# DynamoDB table
resource "aws_dynamodb_table" "my_table" {
  name = "cloudresumechallenge-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"    # Attribute definition
    type = "S"     # S for String
  }


  lifecycle {
    ignore_changes = all
  }
}

# S3 bucket for front-end
resource "aws_s3_bucket" "cloudresumes3bucket-sv" {
  bucket = "cloudresumechallenge-sv"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.cloudresumes3bucket-sv.bucket
  key    = "index.html"
  source = "/Users/SaxtonVanDalsen/Desktop/Programming/CloudResumeChallenge/src/index.html"
  acl    = "public-read"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "my_distribution" {

  origin {
    domain_name              = aws_s3_bucket.cloudresumechallenge-sv.bucket_regional_domain_name
    origin_id                = "cloudresumechallenge-sv"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "cloudresumechallenge-sv"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

    restrictions {
    geo_restriction {
      restriction_type = "none"  # Change to appropriate restriction type
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "my_oai" {
  comment = "OAI for my-cloud-resume-bucket"
}