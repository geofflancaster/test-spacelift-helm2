terraform {
  required_providers {
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