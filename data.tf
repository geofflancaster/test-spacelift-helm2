data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_ecr_authorization_token" "ecr_token" {
}

data "aws_iam_role" "karpenter_controller_role" {
  name = "${var.cluster_name}-KarpenterControllerRole"
}

data "aws_iam_role" "karpenter_node_role" {
  name = "${var.cluster_name}-KarpenterNodeRole"
}

data "aws_ssm_parameter" "karpenter_ami_id" {
  name = "/aws/service/eks/optimized-ami/1.31/amazon-linux-2-arm64/recommended/image_id"
}