resource "aws_s3_bucket" "loki" {
  bucket_prefix = "loki-"
}

resource "aws_s3_bucket_acl" "loki" {
  bucket = aws_s3_bucket.loki.id

  acl = "private"
}