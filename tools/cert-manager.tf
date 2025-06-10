resource "helm_release" "cert_manager" {
  depends_on = [kubernetes_manifest.cert_manager_crd]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.17.2"

  create_namespace = true

  atomic = true
  wait   = true

  replace = true
}

resource "kubernetes_manifest" "cert_manager_crd" {
  for_each = fileset(path.module, "crds/cert-manager/*.yaml")
  manifest = yamldecode(file("${path.module}/${each.value}"))
}

resource "kubernetes_manifest" "pd_operator_webhook_cert" {
  depends_on = [ kubernetes_manifest.cert_manager_issuer_selfsigned ]
  manifest = yamldecode(<<EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: pingdirectory-operator-webhook-cert
      namespace: default
    spec:
      dnsNames:
        - pingdirectory-operator-webhook-service.default.svc
        - pingdirectory-operator-webhook-service.default.svc.cluster.local
      secretName: pingdirectory-operator-webhook-cert
      issuerRef:
        name: selfsigned-issuer
        kind: Issuer
    EOF
  )
}

resource "kubernetes_manifest" "cert_manager_issuer_selfsigned" {
  manifest = yamldecode(<<EOF
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: selfsigned-issuer
      namespace: default
    spec:
      selfSigned: {}
    EOF
  )
}
