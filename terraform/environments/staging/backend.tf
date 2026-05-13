# Backend Configuration for Staging
# This file configures remote state storage in S3

terraform {
  backend "s3" {
    bucket         = "company-terraform-state-staging"
    key            = "3tier-app/staging/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
