module "hiive-app" {
  source = "./module"
  project_name = "hiive"
  region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  container_image = "nginx:latest"
}