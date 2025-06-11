resource "aws_s3_bucket" "loki" {
  bucket_prefix = "loki-"
  force_destroy = true
}

resource "aws_s3_bucket" "loki_ruler" {
  bucket_prefix = "loki-ruler-"
  force_destroy = true
}

resource "aws_s3_bucket" "loki_admin" {
  bucket_prefix = "loki-admin-"
  force_destroy = true
}
