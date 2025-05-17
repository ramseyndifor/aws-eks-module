module "vpc" {
  source    = "./modules/vpc"
  region    = var.region
  vpc_cidr  = var.vpc_cidr
}

module "iam" {
  source        = "./modules/iam"
  project_name  = var.project_name
  region        = var.region
}

module "eks" {
  source         = "./modules/eks"
  project_name   = var.project_name
  region         = var.region
  subnet_ids     = module.vpc.private_subnet_ids
  vpc_id         = module.vpc.vpc_id
  eks_role_arn   = module.iam.eks_role_arn
  node_role_arn  = module.iam.node_role_arn
}

module "app" {
  source        = "./modules/app"
  cluster_name  = module.eks.cluster_name
  project_name  = var.project_name
  contianer_image = var.contianer_image
}

module "hiive-app" {
  source = "./module"
  project_name = "hiive"
  region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  container_image = "nginx:latest"

}