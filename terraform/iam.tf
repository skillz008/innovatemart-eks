# terraform/iam.tf - SIMPLIFIED WITHOUT KUBERNETES RESOURCES
# Developer read-only user
resource "aws_iam_user" "developer" {
  name = "${var.project_name}-developer"
  tags = local.tags
}

resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

# Developer policy for EKS read-only access
resource "aws_iam_policy" "developer_eks_readonly" {
  name        = "${var.project_name}-developer-eks-readonly"
  description = "Read-only access to EKS cluster resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "developer_eks_readonly" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks_readonly.arn
}

# Note: Kubernetes RBAC will be configured separately after cluster creation
