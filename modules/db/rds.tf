####################################
#   DB Subnet Group
####################################
resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "main"
  subnet_ids = [var.pri-sub1-id, var.pri-sub2-id]

  tags = {
    Name = "My DB subnet group"
  }
}

####################################
#   RDS Cluster
####################################
resource "aws_rds_cluster" "rds-cluster" {
  cluster_identifier      = "rds-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.9"
  availability_zones      = ["us-east-2a", "us-east-2b"]
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [var.rds-sg-id]
  master_username         = "tf"
  master_password         = "soldesk1."
  skip_final_snapshot = true
}

####################################
#   RDS Instance
####################################
resource "aws_rds_cluster_instance" "rds-instance" {
  count              = 2
  identifier         = "rds-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.rds-cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.rds-cluster.engine
  engine_version     = aws_rds_cluster.rds-cluster.engine_version
}