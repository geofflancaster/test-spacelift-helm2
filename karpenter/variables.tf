variable "cluster_name" {
    type = string
    description = "Name of the EKS cluster"
}

variable "karpenter_namespace" {
  default = "karpenter"
}

variable "node_architecture" {
  type = string
  default ="arm64"
}

variable "cluster_version" {
  type = string
  default = "1.31"
}

variable "node_security_group_id" {
  default = "sg-09e9a4af4da92e97a"
}

variable "aws_role_arn" {
  type = string
}
