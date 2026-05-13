# Backend Configuration for Development
# This file configures remote state storage in S3

terraform {
  backend "s3" {
    bucket         = "company-terraform-state-dev"
    key            = "3tier-app/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
