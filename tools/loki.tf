resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "2.9.0"

  set {
    name  = "loki.persistence.enabled"
    value = true
  }

  set {
    name  = "loki.persistence.storageClassName"
    value = "gp3"
  }

  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }

  set {
    name  = "loki.service.type"
    value = "ClusterIP"
  }

  set {
    name = "deploymentMode"
    value = "SimpleScalable"
  }

  set {
    name = "minio.enabled"
    value = false
  }

  set {
    name = "gateway.enabled"
    value = false
  }

  set {
    name = "loki.schemaConfig"
    value = <<EOF
configs:
    - from: "2024-04-01"
    store: tsdb
    object_store: s3
    schema: v13
    index:
        prefix: loki_index_
        period: 24h
storage_config:
    aws:
    region: "${var.loki_bucket_region}"
    bucketnames: "${var.loki_bucket_name}"
    s3forcepathstyle: false
EOF
  }
  set {
    name = "loki.pattern_ingester.enabled"
    value = true
  }
  set {
    name = "loki.limits_config"
    value = <<EOF
allow_structured_metadata: true
volume_enabled: true
retention_period: 672h
EOF
  }
  set {
    name = "loki.querier.max_concurrent"
    value = 4
  }
}