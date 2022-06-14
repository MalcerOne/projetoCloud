# ========== IAM role policy ==============
resource "aws_iam_role" "cluster-eks-rafael" {
  name = "cluster-eks-rafael"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# ========== EKS Cluster policy ==============
resource "aws_iam_role_policy_attachment" "cluster-eks-rafael-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-eks-rafael.name
}

# ========== EKS Cluster ==============
resource "aws_eks_cluster" "cluster-eks-rafael" {
  name     = "cluster-eks-rafael"
  role_arn = aws_iam_role.cluster-eks-rafael.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.private.id,
      aws_subnet.public.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-eks-rafael-policy]
}
