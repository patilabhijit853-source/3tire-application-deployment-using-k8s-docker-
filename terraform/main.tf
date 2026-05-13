################################################################################
# AWS Provider Configuration
################################################################################
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  alias  = "no_default_tags"
  region = var.aws_region
}

################################################################################
# Data Sources
################################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "./modules/vpc"

  environment              = var.environment
  project_name             = var.project_name
  vpc_cidr                 = "10.0.0.0/16"
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs     = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones       = data.aws_availability_zones.available.names
  enable_nat_gateway       = true
  enable_vpn_gateway       = false
  enable_flow_logs         = var.environment == "prod"
  flow_logs_retention_days = var.log_retention_days

  tags = local.common_tags
}

################################################################################
# IAM Module
################################################################################
module "iam" {
  source = "./modules/iam"

  providers = {
    aws = aws.no_default_tags
  }

  environment  = var.environment
  project_name = var.project_name
  cluster_name = "${local.name_prefix}-cluster"

  tags = local.common_tags
}

################################################################################
# EKS Module
################################################################################
module "eks" {
  source = "./modules/eks"

  environment               = var.environment
  project_name              = var.project_name
  cluster_name              = "${local.name_prefix}-cluster"
  cluster_version           = "1.27"
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  eks_cluster_role_arn      = module.iam.eks_cluster_role_arn
  eks_node_role_arn         = module.iam.eks_node_role_arn
  node_group_desired_size   = local.env_config.eks_node_group_desired_size
  node_group_max_size       = local.env_config.eks_node_group_max_size
  node_group_min_size       = local.env_config.eks_node_group_min_size
  node_instance_types       = local.env_config.eks_instance_types
  enable_cluster_autoscaler = true
  log_retention_days        = var.log_retention_days
  enable_monitoring         = var.enable_monitoring

  depends_on = [module.iam]
  tags       = local.common_tags
}

################################################################################
# RDS Module
################################################################################
module "rds" {
  source = "./modules/rds"

  environment                = var.environment
  project_name               = var.project_name
  db_instance_identifier     = "${local.name_prefix}-db"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  db_subnet_group_name       = "${local.name_prefix}-db-subnet-group"
  db_name                    = "appdb"
  db_username                = "admin"
  db_password_secret_name    = "${local.name_prefix}-db-password"
  allocated_storage          = local.env_config.rds_allocated_storage
  engine_version             = local.env_config.rds_engine_version
  instance_class             = var.environment == "dev" ? "db.t3.micro" : "db.t3.small"
  multi_az                   = local.env_config.enable_multi_az
  backup_retention_period    = local.env_config.backup_retention_days
  skip_final_snapshot        = var.environment == "dev"
  log_retention_days         = var.log_retention_days
  enable_enhanced_monitoring = var.environment != "dev"

  depends_on = [module.vpc]
  tags       = local.common_tags
}

################################################################################
# Outputs Section
################################################################################
# See outputs.tf for detailed output definitions
