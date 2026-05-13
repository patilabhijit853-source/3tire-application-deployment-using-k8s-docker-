resource "aws_eks_cluster" "main" {
  name     = "3tier-app-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = aws_subnet.private.*.id
  }

  depends_on = [aws_vpc.main]
}

resource "aws_iam_role" "eks_node" {
  name = "3tier-app-eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "eks_node_attachment" {
  name       = "3tier-app-eks-node-policy-attachment"
  roles      = [aws_iam_role.eks_node.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
