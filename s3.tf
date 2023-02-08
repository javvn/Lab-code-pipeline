resource "aws_s3_bucket" "pipeline" {
  bucket        = lower(local.common_tags.Project)
  force_destroy = true
}

resource "aws_s3_bucket_acl" "pipeline_acl" {
  bucket = aws_s3_bucket.pipeline.id
  acl    = "private"
}