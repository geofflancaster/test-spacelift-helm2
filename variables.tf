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