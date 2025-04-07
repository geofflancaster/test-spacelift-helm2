
data "aws_subnets" "cluster_subnets" {
    filter {
        name = "vpc-id"
        values = [data.aws_eks_cluster.cluster.vpc_config.0.vpc_id]
    }
    filter {
        name = "tag:Name"
        values = ["*private*"] 
    }
}


data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}