variable "region" {
  description = "default aws region"
  type = string
}

variable "project_name" {
  description = "project name"
  type = string
  default = ""
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