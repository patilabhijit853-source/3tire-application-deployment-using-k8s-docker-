# Local values for computed configuration and company standards
locals {
  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags applied to all resources (company standard)
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Company     = var.company_name
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }

  deployment_timestamp = timestamp()

  # Environment-specific configuration
  environment_config = {
    dev = {
      eks_node_group_desired_size = 1
      eks_node_group_max_size     = 2
      eks_node_group_min_size     = 1
      eks_instance_types          = ["t3.medium"]
      rds_allocated_storage       = 20
      rds_engine_version          = "14.7"
      enable_backup               = false
      backup_retention_days       = 0
      enable_multi_az             = false
    }
    staging = {
      eks_node_group_desired_size = 2
      eks_node_group_max_size     = 4
      eks_node_group_min_size     = 2
      eks_instance_types          = ["t3.large"]
      rds_allocated_storage       = 50
      rds_engine_version          = "14.7"
      enable_backup               = true
      backup_retention_days       = 7
      enable_multi_az             = true
    }
    prod = {
      eks_node_group_desired_size = 3
      eks_node_group_max_size     = 10
      eks_node_group_min_size     = 3
      eks_instance_types          = ["t3.xlarge"]
      rds_allocated_storage       = 100
      rds_engine_version          = "14.7"
      enable_backup               = true
      backup_retention_days       = 30
      enable_multi_az             = true
    }
  }

  env_config = local.environment_config[var.environment]
}
