variable "aws_role_arn" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "ingresses" {
    type = map(object({
        service_name = string
        service_port = number
        cert_ssm_path = string
        ingress_class = string
    }))

    validation {
        condition = length([
            for o in var.ingresses : true
            if contains(["public", "private"], o.ingress_class)
        ]) == length(var.ingresses)
        error_message = "Ingresses must have ingress_class of either public or private"
    }
}