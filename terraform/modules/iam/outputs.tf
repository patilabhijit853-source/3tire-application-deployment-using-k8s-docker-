################################################################################
# IAM Module - Outputs
################################################################################

output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_role_name" {
  description = "EKS cluster IAM role name"
  value       = aws_iam_role.eks_cluster_role.name
}

output "eks_node_role_arn" {
  description = "EKS node IAM role ARN"
  value       = aws_iam_role.eks_node_role.arn
}

output "eks_node_role_name" {
  description = "EKS node IAM role name"
  value       = aws_iam_role.eks_node_role.name
}

output "eks_node_instance_profile" {
  description = "EKS node instance profile name"
  value       = aws_iam_instance_profile.eks_node_profile.name
}
