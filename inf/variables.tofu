variable "cluster_name" {
    type = string
    description = "Name of the EKS cluster"
}

variable "aws_role_arn" {
    type = string
    description = "ARN of the AWS role to assume"
}