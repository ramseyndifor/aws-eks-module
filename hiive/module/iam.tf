##########################################
# IAM Components     #
##########################################

resource "aws_iam_role" "eks" {
  name = "${var.project_name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

resource "aws_iam_role" "node" {
  name = "${var.project_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json
}

data "aws_iam_policy_document" "eks_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "node_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_policy_attach" {
  for_each = toset(var.eks_cluster_policies)
  policy_arn = each.value
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "node_policy_attach" {
  for_each = toset(var.eks_node_policies)
  policy_arn = each.value
  role       = aws_iam_role.node.name
}
