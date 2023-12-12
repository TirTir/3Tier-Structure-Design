################### Terraform Configuration ###################
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}

################### Module VPC ###################
module "vpc" {
  source  = "../modules/vpc"
  vpc-id = module.vpc.vpc_id

  pub-sub1-id = module.vpc.public_subnet1_id
  pub-sub2-id = module.vpc.public_subnet2_id
  pri-sub1-id = module.vpc.private_subnet1_id
  pri-sub2-id = module.vpc.private_subnet2_id

  pub-rt-id = module.vpc.public_route_table_id
  pri-rt-id = module.vpc.private_route_table_id
  igw-id = module.vpc.internet_gateway_id
  ngw-id = module.vpc.nat_gateway_id
  eip-id = module.vpc.elastic_ip_id
}

# ################### Module RDS ###################
# module "db" {
#   source  = "../modules/db"
#   vpc-id = module.vpc.vpc_id
#   rds-sg-id = module.sg.rds_security_group_id
#   pri-sub1-id = module.vpc.private_subnet1_id
#   pri-sub2-id = module.vpc.private_subnet2_id

#   my-bucket-id = module.db.my_bucket_id
# }

################### Module Security Group ###################
module "sg" {
  source = "../modules/sg"

  vpc-id = module.vpc.vpc_id
  vpc-sg-id = module.sg.vpc_security_group_id
}

################### Module EC2 ###################
module "ec2_instance" {
  source  = "../modules/ec2"
  vpc-id = module.vpc.vpc_id

  vpc-sg-id = module.sg.vpc_security_group_id
  web-sg-id = module.sg.web_security_group_id
  was-sg-id = module.sg.was_security_group_id

  pub-sub1-id = module.vpc.public_subnet1_id
  pub-sub2-id = module.vpc.public_subnet2_id
  pri-sub1-id = module.vpc.private_subnet1_id
  pri-sub2-id = module.vpc.private_subnet2_id

}
