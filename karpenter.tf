resource "helm_release" "karpenter" {
    name       = "karpenter"
    repository = "oci://public.ecr.aws/karpenter"
    chart      = "karpenter"
    namespace  = var.karpenter_namespace
    version = "1.3.0"
    create_namespace = true
    set = [
        {
            name = "settings.clusterName"
            value = var.cluster_name
        },
        {
            name = "logLevel"
            value ="debug"
        },
        {
            name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
            value = data.aws_iam_role.karpenter_controller_role.arn
        },
        {
            name = "dnsPolicy"
            value = "Default"
        }
    ]

    wait = true
    atomic = true
}
