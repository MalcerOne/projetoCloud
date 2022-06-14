# ========== Group nodes ==============
resource "aws_iam_role" "group-nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# ========== EKS Worker Node policy ==============
resource "aws_iam_role_policy_attachment" "group-nodes-worker-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.group-nodes.name
}

# ========== EKS CNI policy ==============
resource "aws_iam_role_policy_attachment" "group-nodes-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.group-nodes.name
}

# ========== EC2 Container Registry Read Only ==============
resource "aws_iam_role_policy_attachment" "group-nodes-read-only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.group-nodes.name
}

# ========== Nodes ==============
resource "aws_eks_node_group" "cluster-eks-rafael-nodes" {
  cluster_name    = aws_eks_cluster.cluster-eks-rafael.name
  node_group_name = "cluster-eks-rafael-nodes"
  node_role_arn   = aws_iam_role.group-nodes.arn

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.public.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.small"]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.group-nodes-worker-policy,
    aws_iam_role_policy_attachment.group-nodes-cni-policy,
    aws_iam_role_policy_attachment.group-nodes-read-only,
  ]
}
