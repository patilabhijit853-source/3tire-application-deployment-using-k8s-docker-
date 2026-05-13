# Backend Configuration for Production
# This file configures remote state storage in S3

terraform {
  backend "s3" {
    bucket         = "company-terraform-state-prod"
    key            = "3tier-app/prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
