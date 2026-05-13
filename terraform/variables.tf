variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "3tier-app"
  validation {
    condition     = length(var.project_name) <= 32 && can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must be lowercase alphanumeric and hyphens, max 32 characters."
  }
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "ap-south-1"
}

variable "company_name" {
  description = "Company name for tagging standards"
  type        = string
  default     = "YourCompany"
}

variable "cost_center" {
  description = "Cost center for billing and resource tracking"
  type        = string
  validation {
    condition     = length(var.cost_center) > 0
    error_message = "Cost center is required."
  }
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring and alarms"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
  validation {
    condition     = var.log_retention_days > 0 && var.log_retention_days <= 3653
    error_message = "Log retention must be between 1 and 3653 days."
  }
}
