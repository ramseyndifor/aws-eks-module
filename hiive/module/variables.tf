variable "region" {
  description = "default aws region"
  type = string
}

variable "project_name" {
  description = "project name"
  type = string
}

# variable "subnet_ids" {
#   description = "list of subnet ids"
#   type = list(string)
# }

# variable "vpc_id" {
#   description = "vpc id"
#   type = string
# }

variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
  default = ""
}

# variable "eks_role_arn" {
#   description = "eks cluster role arn"
#   type = string
# }

# variable "node_role_arn" {
#   description = "eks worker node role arn"
#   type = string
# }

variable "container_image" {
  description = "container image for eks cluster"
  type = string
  default = "nginx:latest"
}