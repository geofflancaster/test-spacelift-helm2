resource "aws_iam_role" "fargate" {
    name_prefix = "${var.cluster_name}-fargate"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
            Service = "eks-fargate-pods.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
        ]
    })
}

data "aws_iam_policy_document" "fargate" {
    statement {
        actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_role_policy" "fargate" {
    name = "fargate"
    role = aws_iam_role.fargate.name
    policy = data.aws_iam_policy_document.fargate.json
}

resource "aws_iam_role" "karpenter_node_role" {
    name = "${var.cluster_name}-KarpenterNodeRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
            Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
    for_each = toset(["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly", "AmazonSSMManagedInstanceCore"])
    role       = aws_iam_role.karpenter_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_role" "karpenter_controller_role" {
    name = "${var.cluster_name}-KarpenterControllerRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
                Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://")}",
            },
            Action = "sts:AssumeRoleWithWebIdentity",
            Condition = {
                StringEquals = {
                    "${trimprefix(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://")}:aud": "sts.amazonaws.com",
                    "${trimprefix(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://")}:sub": "system:serviceaccount:karpenter:karpenter"
                }
            }
        }
        ]
    })
}


data "aws_iam_policy_document" "karpenter_controller_policy" {
    statement {
      actions = [
        "ssm:GetParameter",
                "ec2:DescribeImages",
                "ec2:RunInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:DescribeSpotPriceHistory",
                "pricing:GetProducts"
      ]
      effect = "Allow"
      resources = ["*"]
      sid = "karpenter"
    }
    statement {
        actions = ["ec2:TerminateInstances"]
        effect = "Allow"
        resources = ["*"]
        condition {
            test = "StringLike"
            variable = "aws:ResourceTag/karpenter.sh/nodepool"
            values = ["*"]
        }
        sid = "karpenterterminate"
    }
    statement {
        actions = ["iam:PassRole"]
        effect = "Allow"
        resources = [aws_iam_role.karpenter_node_role.arn]
        sid = "karpenterpassrole"
    }
    statement {
        effect = "Allow"
        actions = ["eks:DescribeCluster"]
        resources = ["arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"]
        sid = "EKSClusterEndpointLookup"
    }
    statement {
        sid = "AllowScopedInstanceProfileCreationActions"
        effect = "Allow"
        resources = ["*"]
        actions = [
            "iam:CreateInstanceProfile"
        ]
        condition {
            test = "StringEquals"
            variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_name}"
            values = ["owned"]
        }
        condition {
            test = "StringEquals"
            variable = "aws:RequestTag/topology.kubernetes.io/region"
            values = ["${data.aws_region.current.name}"]
        }
        condition {
            test = "StringLike"
            variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
            values = ["*"]
        }
    }
    statement {
        sid = "AllowScopedInstanceProfileTagActions"
        effect = "Allow"
        resources = ["*"]
        actions = ["iam:TagInstanceProfile"]
        condition {
            test="StringEquals"
            variable="aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
            values=["owned"]
        }
        condition {
            test = "StringEquals"
            variable = "aws:ResourceTag/topology.kubernetes.io/region"
            values = ["${data.aws_region.current.name}"]
        }
        condition {
            test = "StringEquals"
            variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_name}"
            values = ["owned"]
        }
        condition {
            test = "StringEquals"
            variable = "aws:RequestTag/topology.kubernetes.io/region"
            values = ["${data.aws_region.current.name}"]
        }
        condition {
            test = "StringLike"
            variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
            values = ["*"]
        }
        condition {
            test = "StringLike"
            variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
            values = ["*"]
        }
    }
    statement {
        sid = "AllowScopedInstanceProfileActions"
        effect = "Allow"
        resources = ["*"]
        actions = [
            "iam:AddRoleToInstanceProfile",
            "iam:RemoveRoleFromInstanceProfile",
            "iam:DeleteInstanceProfile"
        ]
        condition {
            test = "StringEquals"
            variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
            values = ["owned"]
        }
        condition {
            test = "StringEquals"
            variable = "aws:ResourceTag/topology.kubernetes.io/region"
            values = ["${data.aws_region.current.name}"]
        }
        condition {
            test = "StringLike"
            variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
            values = ["*"]
        }
    }
    statement {
        sid = "AllowInstanceProfileReadActions"
        effect = "Allow"
        resources = ["*"]
        actions = ["iam:GetInstanceProfile"]
    }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
    name = "${var.cluster_name}-KarpenterControllerPolicy"
    policy = data.aws_iam_policy_document.karpenter_controller_policy.json
}

resource "aws_iam_policy_attachment" "karpenter_controller_policy_attachment" {
    name = "${var.cluster_name}-KarpenterControllerPolicyAttachment"
    policy_arn = aws_iam_policy.karpenter_controller_policy.arn
    roles = [aws_iam_role.karpenter_controller_role.name]
}