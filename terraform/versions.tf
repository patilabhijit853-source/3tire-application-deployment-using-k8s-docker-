terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }

  # Backend configuration for remote state management
  # Uncomment and configure with your S3 bucket details
  # backend "s3" {
  #   bucket         = "company-terraform-state"
  #   key            = "3tier-app/terraform.tfstate"
  #   region         = "ap-south-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}
