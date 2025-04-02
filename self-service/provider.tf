terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
}

provider "aws" {
  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? [1] : []
    content {
      role_arn     = var.aws_role_arn
      session_name = "runner"
    }
  }
}

provider "kubernetes" {
   host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}