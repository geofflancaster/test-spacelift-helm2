

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = data.aws_eks_cluster.cluster.name
  fargate_profile_name   = "beluga-apps"
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = data.aws_subnets.cluster_subnets.ids

  selector {
    namespace = "karpenter"
  }
#   selector {
#     namespace = "kube-system"
#     labels = {
#         "k8s-app" = "kube-dns"
#     }
#   }
}
