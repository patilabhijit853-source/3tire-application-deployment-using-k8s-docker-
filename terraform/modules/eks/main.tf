################################################################################
# EKS Module - Main Configuration
################################################################################

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

################################################################################
# CloudWatch Log Group for EKS Cluster Logging
################################################################################
resource "aws_cloudwatch_log_group" "eks_cluster" {
  count             = var.enable_monitoring ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-eks-logs"
    }
  )
}

################################################################################
# EKS Cluster
################################################################################
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = "1.30"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # Enable control plane logging
  enabled_cluster_log_types = var.enable_monitoring ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []

  depends_on = [aws_cloudwatch_log_group.eks_cluster]

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}

################################################################################
# EKS Node Group
################################################################################
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.name_prefix}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids
  version         = "1.30"
  ami_type        = "AL2_x86_64"
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable_percentage = 33
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-node-group"
    }
  )

  depends_on = [aws_eks_cluster.main]
}

################################################################################
# OIDC Provider for IRSA (IAM Roles for Service Accounts)
################################################################################
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-oidc-provider"
    }
  )
}
