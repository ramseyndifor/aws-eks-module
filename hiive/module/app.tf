provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "${var.project_name}-app"
    labels = {
      app = var.project_name
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.project_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.project_name
        }
      }
      spec {
        container {
          name  = "${var.project_name}-container"
          image = var.container_image
          port {
            container_port = 80
          }
        }
      }
    }
  }
  depends_on = [ aws_eks_node_group.eks_node_group ]
}

resource "kubernetes_service" "app" {
  metadata {
    name = "${var.project_name}-service"
  }
  spec {
    selector = {
      app = var.project_name
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }

  depends_on = [ aws_eks_node_group.eks_node_group ]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.node.arn
        username = "system:node:{{EC2PrivateDNSName}}",
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }
  depends_on = [ aws_eks_node_group.eks_node_group ]
}

resource "aws_eks_access_entry" "user_access" {
  cluster_name   = aws_eks_cluster.eks_cluster.name
  principal_arn  = var.user_arn
  type           = "STANDARD"
}

resource "aws_eks_access_policy_association" "api_auth_link" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = var.user_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
