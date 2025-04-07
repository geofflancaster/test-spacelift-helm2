

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = data.aws_eks_cluster.cluster.name
  fargate_profile_name   = "beluga-apps"
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = data.aws_subnets.cluster_subnets.ids

  selector {
    namespace = var.karpenter_namespace
    labels = {
        "app.kubernetes.io/name": "karpenter"
    }
  }
}