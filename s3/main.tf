resource "aws_s3_bucket" "app_s3" {
  bucket = var.bucket_name

  tags = {
    Name        = "app-bucket"
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.app_s3.id
  acl    = var.acl
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.app_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}