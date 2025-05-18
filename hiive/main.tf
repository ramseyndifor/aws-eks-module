module "hiive-app" {
  source = "./module"
  project_name = var.project_name
  region = var.region
  vpc_cidr = "10.0.0.0/16" #var.vpc_cidr
  container_image = var.container_image
  user_arn = var.user_arn
}