data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

####################################
#   SSH Key
####################################
resource "aws_key_pair" "deployer" {
key_name = "deployer-key"
public_key = file("~/.ssh/testkey.pub")
}

resource "aws_key_pair" "prikey" {
 key_name = "prikey-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}

####################################
#   WEB Launch Configuration 
####################################
resource "aws_launch_configuration" "web-configuration" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.prikey.key_name
  security_groups = [var.web-sg-id]

  lifecycle {
    create_before_destroy = true
  }
}

####################################
#   WAS Launch Configuration 
####################################
resource "aws_launch_configuration" "was-configuration" {
  name          = "was_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  user_data = file("userdata.template")
  security_groups = [var.was-sg-id]

  lifecycle {
    create_before_destroy = true
  }
}

####################################
#   Bastion Instance
####################################
resource "aws_instance" "bastion_instance"{
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = var.pub-sub1-id
  associate_public_ip_address = "true"

  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [var.vpc-sg-id]
  tags = { Name = "bastion_instance" }
}