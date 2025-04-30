resource "aws_s3_bucket" "loki" {
  bucket_prefix = "loki-"
  force_destroy = true

}
