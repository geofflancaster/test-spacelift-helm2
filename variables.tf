variable "cluster_name" {
    type = string
    description = "Name of the EKS cluster"
}

variable "customer_dns" {
    type = string
}

variable "env" {
  type = string
}

variable "nginx_pod_count" {
  type = number
  default = 1
}

variable "nginx_log_level" {
    type = string
    default = "info"
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

variable "devops_user" {
  type = string
}

variable "devops_key" {
  type = string
}
variable "server_profile_url" {
  type = string
}
variable "ssh_known_hosts" {
  type = string
}

variable "aws_role_arn" {
  type = string
}

variable "codecommit_key" {
  type = string
  description = "base64 encoded codecommit key"
}