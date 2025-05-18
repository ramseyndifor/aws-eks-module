variable "region" {
  description = "default aws region"
  type = string
  default = ""
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

variable "user_arn" {
  description = "arn of admin user for access to the eks cluster"
  type = string
  default = ""
}

variable "container_image" {
  description = "container image for eks cluster"
  type = string
  default = ""
}

variable "eks_node_policies" {
  description = "aws managed policies to be attached to eks node role"
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

variable "eks_cluster_policies" {
  description = "aws managed policies to be attached to eks node role"
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}