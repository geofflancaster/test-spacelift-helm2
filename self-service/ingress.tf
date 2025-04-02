data "aws_secretsmanager_secret" "tls_cert" {
    for_each = {
        for key, value in var.ingresses : key => value.cert_ssm_path
    }
    name = each.value
}

data "aws_secretsmanager_secret_version" "tls_cert" {
    for_each = data.aws_secretsmanager_secret.tls_cert
    secret_id = each.value.id
}

# temporary for PoC which doesnt use SecretsManager CSI
resource "kubernetes_manifest" "tls_secret" {
    for_each = toset(keys(var.ingresses))
    manifest = {
    "apiVersion"= "v1",
    "data"= {
        "tls.crt"= jsondecode(data.aws_secretsmanager_secret_version.tls_cert[each.key].secret_string)["tlscrt"],
        "tls.key"= jsondecode(data.aws_secretsmanager_secret_version.tls_cert[each.key].secret_string)["tlskey"]
    },
    "kind"= "Secret",
    "metadata"= {
        "name"= "${each.key}-tls-cert",
        "namespace"= "default",
    },
    "type"= "Opaque"
    }

}

resource "kubernetes_manifest" "ingresses" {
    for_each = var.ingresses
    manifest = {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
        "annotations": {
            "nginx.ingress.kubernetes.io/backend-protocol": "HTTPS",
            "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
        },
        "name": "${each.key}-${each.value.service_name}-ingress",
        "namespace": "default",
    },
    "spec": {
        "ingressClassName": "nginx-${each.value.ingress_class}",
        "rules": [
            {
                "host": "${each.key}",
                "http": {
                    "paths": [
                        {
                            "backend": {
                                "service": {
                                    "name": "${each.value.service_name}",
                                    "port": {
                                        "number": "${each.value.service_port}"
                                    }
                                }
                            },
                            "path": "/",
                            "pathType": "Prefix"
                        }
                    ]
                }
            }
        ],
        "tls": [
            {
                "hosts": [
                    "${each.key}"
                ],
                "secretName": "${each.key}-tls-cert"
            }
        ]
    },
    
}
}