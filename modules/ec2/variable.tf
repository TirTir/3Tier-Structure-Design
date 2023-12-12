variable "vpc-sg-id" {
  description = "VPC Security Group ID"
  type = string
}
variable "web-sg-id" {
  description = "WEB Security Group ID"
  type = string
}

variable "was-sg-id" {
  description = "WAS Security Group ID"
  type = string
}

variable "vpc-id" {
  description = "VPC ID"
  type = string
}

variable "pub-sub1-id" {
  description = "Public Subnet1 ID"
  type = string
}
variable "pub-sub2-id" {
  description = "Public Subnet2 ID"
  type = string
}

variable "pri-sub1-id" {
  description = "private Subnet1 ID"
  type = string
}
variable "pri-sub2-id" {
  description = "private Subnet2 ID"
  type = string
}

