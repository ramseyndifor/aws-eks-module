variable "region" {
  description = "default aws region"
  type = string
  default = ""
}

variable "project_name" {
  description = "project name"
  type = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
  default = ""
}

variable "container_image" {
  description = "container image for eks cluster"
  type = string
  default = "nginx:latest"
}