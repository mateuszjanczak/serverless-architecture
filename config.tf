terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.3.0"
    }
  }

  required_version = ">= 1.2.1"

  backend "s3" {
    bucket = "040489059668-bucket"
    key    = "deploy-s3-bucket"
    region = "eu-west-1"
  }
}