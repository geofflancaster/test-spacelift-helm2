resource "kubectl_manifest" "loki_storageclass" {
  yaml_body = <<EOF
    allowVolumeExpansion: true
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
        name: loki-gp3
    mountOptions:
        - discard
    parameters:
        csi.storage.k8s.io/fstype: ext4
        encrypted: "true"
        type: gp3
    provisioner: ebs.csi.aws.com
    reclaimPolicy: Delete
    volumeBindingMode: WaitForFirstConsumer
    EOF
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.10.1"
  namespace = "loki"
  create_namespace = true

  values = [
    <<-EOT
    loki.persistence.enabled: true
    loki.persistence.storageClassName: ${kubectl_manifest.loki_storageclass.yaml_body_parsed.metadata.name}
    loki.persistence.size: 10Gi
    loki.service.type: ClusterIP
    deploymentMode: SimpleScalable
    minio.enabled: false
    gateway.enabled: true
    grafana.enabled: true
    loki.schemaConfig: |
      configs:
          - from: "2024-04-01"
            store: tsdb
            object_store: s3
            schema: v13
            index:
                prefix: loki_index_
                period: 24h
      storage_config:
        use_thanos_objstore: true
        object_store:
          s3:
            bucket_name: ${var.loki_bucket_name}
            endpoint: s3.amazonaws.com
            region: ${var.loki_bucket_region}
            dualstack_enabled: false
            storage_class: STANDARD
            max_retries: 5
            http:
              insecure_skip_verify: false
            sse:
              type: SSE-S3
    loki.pattern_ingester.enabled: true
    loki.limits_config: |
      allow_structured_metadata: true
      volume_enabled: true
      retention_period: 672h
    loki.querier.max_concurrent: 4
    promtail.enabled: false
    fluent-bit.enabled: true
    fluent-bit.image.tag: 3.1.2-arm64
    EOT
  ]
}