terraform {
    required_providers {
        aws = {
            version = "5.58.0"
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
  profile = "default"
  region = "us-west-1"
}