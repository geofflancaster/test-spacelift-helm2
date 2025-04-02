resource "kubernetes_manifest" "nodepool" {
    depends_on = [helm_release.karpenter]
    manifest = {
        apiVersion = "karpenter.sh/v1"
        kind       = "NodePool"
        metadata = {
            name = "default"
        }
        spec = {
            template = {
                spec = {
                    nodeClassRef = {
                        group = "karpenter.k8s.aws"
                        kind  = "EC2NodeClass"
                        name  = "default"
                    }
                    requirements = [
                        {
                            key= "karpenter.k8s.aws/instance-category"
                            operator= "In"
                            values= ["c", "m", "r", "t"]
                        }, {
                            key = "kubernetes.io/arch"
                            operator = "In"
                            values = ["arm64"]
                        }, {
                            key = "karpenter.sh/capacity-type"
                            operator = "In"
                            values = ["on-demand", "spot"]
                        }
                    ]
                }
            }
        }
    }
}

resource "kubernetes_manifest" "nodeclass" {
    depends_on = [helm_release.karpenter]
    manifest = {
        apiVersion = "karpenter.k8s.aws/v1"
        kind       = "EC2NodeClass"
        metadata = {
            name = "default"
        }
        spec = {
            kubelet = {
                systemReserved = {
                    cpu              = "100m"
                    memory           = "100Mi"
                    ephemeral-storage = "1Gi"
                }
                kubeReserved = {
                    cpu              = "200m"
                    memory           = "100Mi"
                    ephemeral-storage = "3Gi"
                }
                evictionHard = {
                    "memory.available"  = "5%"
                    "nodefs.available"  = "10%"
                    "nodefs.inodesFree" = "10%"
                }
                evictionSoft = {
                    "memory.available"  = "500Mi"
                    "nodefs.available"  = "15%"
                    "nodefs.inodesFree" = "15%"
                }
                evictionSoftGracePeriod = {
                    "memory.available"  = "1m"
                    "nodefs.available"  = "1m30s"
                    "nodefs.inodesFree" = "2m"
                }
                evictionMaxPodGracePeriod = "60"
                imageGCHighThresholdPercent = "85"
                imageGCLowThresholdPercent  = "80"
                cpuCFSQuota = true
            }
            amiFamily = "AL2"
            subnetSelectorTerms = [
                {
                    tags = {
                        "karpenter.sh/discovery" = "${var.cluster_name}"
                    }
                }
            ]
            securityGroupSelectorTerms = [
                {
                    id = "${var.node_security_group_id}"
                }
            ]
            role = "${data.aws_iam_role.karpenter_node_role.arn}"
            amiSelectorTerms = [
                {
                    id = "${data.aws_ssm_parameter.karpenter_ami_id.value}"
                }
            ]
            metadataOptions = {
                httpEndpoint            = "enabled"
                httpProtocolIPv6        = "disabled"
                httpPutResponseHopLimit = 1
                httpTokens              = "required"
            }
            blockDeviceMappings = [
                {
                    deviceName = "/dev/xvda"
                    ebs = {
                        volumeSize          = "40Gi"
                        volumeType          = "gp3"
                        iops                = "10000"
                        encrypted           = "true"
                        deleteOnTermination = "true"
                        throughput          = "125"
                    }
                }
            ]
        }
    }
}
