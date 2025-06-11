output "karpenter_controller_role" {
  value = aws_iam_role.karpenter_controller_role.arn
}

output "loki_bucket" {
  value = aws_s3_bucket.loki.id
}
output "loki_bucket_region" {
  value = aws_s3_bucket.loki.region
}
output "loki_ruler_bucket" {
  value = aws_s3_bucket.loki_ruler.id
}
output "loki_ruler_bucket_region" {
  value = aws_s3_bucket.loki_ruler.region
}
output "loki_admin_bucket" {
  value = aws_s3_bucket.loki_admin.id
}
output "loki_admin_bucket_region" {
  value = aws_s3_bucket.loki_admin.region
}