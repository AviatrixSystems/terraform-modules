#Terraform configuration file to set up Windows instance

# Set up the AWS VPC to launch windows instance
resource "aws_vpc" "vpc" {
  count       = var.deploy_windows ? 1 : 0
  cidr_block  = var.vpc_cidr
  tags  = {
    Name      = "${var.resource_name_label}_windows-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count       = var.deploy_windows ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  cidr_block  = var.subnet_cidr
  tags  = {
    Name      = "${var.resource_name_label}_windows-public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  count       = var.deploy_windows ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  tags  = {
    Name		  = "${var.resource_name_label}_windows-igw"
  }
}

resource "aws_route_table" "rtb" {
  count       = var.deploy_windows ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw[0].id
  }
  tags  = {
    Name      = "${var.resource_name_label}_windows-public_rtb"
  }
}

resource "aws_route_table_association" "rtb_associate" {
  count       = var.deploy_windows ? 1 : 0
  subnet_id       = aws_subnet.subnet[0].id
  route_table_id  = aws_route_table.rtb[0].id
}

resource "random_id" "key_id" {
  count       = var.deploy_windows ? 1 : 0
	byte_length = 4
}

# Key pair is used for  Windows instance
resource "aws_key_pair" "key_pair" {
  count       = var.deploy_windows ? 1 : 0
  key_name        = "windows_ssh_key-${random_id.key_id[0].dec}"
  public_key      = var.public_key
}

resource "aws_security_group" "sg" {
  count       = var.deploy_windows ? 1 : 0
  name        = "allow_rdp"
  description = "Allow RDP to windows instance"
  vpc_id      = aws_vpc.vpc[0].id
  ingress {
 #RDP
  from_port   = 3389
  to_port     = 3389
  protocol    = "tcp"
  cidr_blocks = var.sg_source_ip
  }
  tags  = {
    Name      = "${var.resource_name_label}_windows-security_group"
  }

  egress {
  # Allow all
  from_port 	= 0
  to_port 		= 0
  protocol 		= "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch windows instance
resource "aws_instance" "instance" {
 count       = var.deploy_windows ? 1 : 0
 ami                     = var.ami
 instance_type           = "t3.medium"
 disable_api_termination = var.termination_protection
 subnet_id               = aws_subnet.subnet[0].id
 key_name								 = aws_key_pair.key_pair[0].key_name
 vpc_security_group_ids  = [aws_security_group.sg[0].id]
 tags  = {
   Name      = "${var.resource_name_label}_windows-instance"
 }
}

resource "aws_eip" "eip" {
 count       = var.deploy_windows ? 1 : 0
 instance  = aws_instance.instance[0].id
 vpc       = true
 tags  = {
   Name      = "${var.resource_name_label}_windows-eip"
 }
}
