resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks.arn

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attach
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "default"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  remote_access {
    ec2_ssh_key               = aws_key_pair.eks_key_pair.key_name
    source_security_group_ids = [aws_security_group.eks_nodes.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy_attach
  ]
}

resource "tls_private_key" "eks_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "eks_key_pair" {
  key_name   = "${var.project_name}-key-pair"
  public_key = tls_private_key.eks_key.public_key_openssh
}

# Save the private key locally for SSH access
resource "local_file" "private_key" {
  content  = tls_private_key.eks_key.private_key_pem
  filename = "${path.module}/eks-key.pem"
  file_permission = "0600"
}