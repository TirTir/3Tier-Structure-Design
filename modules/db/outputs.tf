output "my_bucket_id" {
  description = "S3 Bucket ID"
  value = aws_s3_bucket.my-bucket.id
}