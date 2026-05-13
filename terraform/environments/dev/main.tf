provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source       = "../modules/vpc"
  project_name = "abhi-infra"
  environment  = "dev"
  tags         = {
    Project     = "3tier-app"
    Environment = "dev"
    ManagedBy   = "terraform"
    CostCenter  = "engineering-platform"
  }
}

module "iam" {
  source       = "../modules/iam"
  project_name = "abhi-infra"
  environment  = "dev"
  tags         = {
    Project     = "3tier-app"
    Environment = "dev"
    ManagedBy   = "terraform"
    CostCenter  = "engineering-platform"
  }
  cluster_name = "abhi-infra-cluster"
}

module "eks" {
  source             = "../modules/eks"
  project_name       = "abhi-infra"
  environment        = "dev"
  tags               = {
    Project     = "3tier-app"
    Environment = "dev"
    ManagedBy   = "terraform"
    CostCenter  = "engineering-platform"
  }
  cluster_name       = "abhi-infra-cluster"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
}

module "rds" {
  source             = "../modules/rds"
  project_name       = "abhi-infra"
  environment        = "dev"
  tags               = {
    Project     = "3tier-app"
    Environment = "dev"
    ManagedBy   = "terraform"
    CostCenter  = "engineering-platform"
  }
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_password       = "SecurePass123!"
  db_instance_identifier = "abhi-infra-db"
  db_subnet_group_name   = "abhi-infra-db-subnet"
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
