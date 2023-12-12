variable "my-bucket-id" {
  description = "S3 Bucket ID"
  type = string
}

variable "vpc-id" {
  description = "VPC ID"
  type        = string
}
variable "rds-sg-id" {
  description = "RDS Security Group ID"
  type        = string
}
variable "pri-sub1-id" {
  description = "Private Subnet1 ID"
  type        = string
}
variable "pri-sub2-id" {
  description = "Private Subnet2 ID"
  type        = string
}