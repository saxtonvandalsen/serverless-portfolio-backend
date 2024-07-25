terraform {
    required_providers {
        aws = {
            version = ">=4.9.0"
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
  access_key = "AKIAXYKJSPAG7XWC64JY"
  secret_key = "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"
  region = "us-west-1"
}