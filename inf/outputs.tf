output "karpenter_controller_role" {
  value = aws_iam_role.karpenter_controller_role.arn
}

output "loki_bucket" {
  value = aws_s3_bucket.loki.id
}
output "loki_bucket_region" {
  value = aws_s3_bucket.loki.region
}