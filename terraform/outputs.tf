output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = false
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.rds_endpoint
  sensitive   = false
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds.database_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "deployment_metadata" {
  description = "Deployment metadata and information"
  value = {
    environment  = var.environment
    region       = var.aws_region
    project_name = var.project_name
    timestamp    = local.deployment_timestamp
  }
}
