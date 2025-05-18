module "hiive-app" {
  source = "./module"
  project_name = "hiive" #var.project_name
  region = var.region
  vpc_cidr = var.vpc_cidr
  container_image = var.container_image
  user_arn = var.user_arn
}