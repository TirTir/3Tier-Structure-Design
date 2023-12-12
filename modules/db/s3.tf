####################################
#   S3 Bucket
####################################
resource "aws_s3_bucket" "my-bucket" {
  bucket = "kyj-bucket"

  tags = {
    Name = "My bucket"
    Environment = "Dev"
  }
}

####################################
#   S3 Configuration
####################################
resource "aws_s3_bucket_versioning" "my-bucket-versioning" {
  bucket = var.my-bucket-id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "my-bucket-config" {
  bucket = var.my-bucket-id

  rule {
    apply_server_side_encryption_by_default {
    sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = var.my-bucket-id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}