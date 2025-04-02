terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.1"
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

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
  registries = [
    {
      url      = "${replace(data.aws_ecr_authorization_token.ecr_token.proxy_endpoint, "https", "oci")}"
      username = data.aws_ecr_authorization_token.ecr_token.user_name
      password = data.aws_ecr_authorization_token.ecr_token.password
    }
  ]
}
