####################################
#   RDS Security Group
####################################
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "RDS Security Group"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}
