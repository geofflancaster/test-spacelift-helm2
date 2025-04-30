variable "cluster_name" {
    type = string
    description = "Name of the EKS cluster"
}

variable "aws_role_arn" {
  type = string
}

variable "loki_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for Loki"
}

variable "loki_bucket_region" {
  type        = string
  description = "Region of the S3 bucket for Loki"
}