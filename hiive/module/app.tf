# modules/app/main.tf
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
    name = "${project_name}-app"
    labels = {
      app = "${project_name}"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${project_name}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${project_name}"
        }
      }
      spec {
        container {
          name  = "${project_name}-container"
          image = var.container_image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "${project_name}-service"
  }
  spec {
    selector = {
      app = "${project_name}"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}
