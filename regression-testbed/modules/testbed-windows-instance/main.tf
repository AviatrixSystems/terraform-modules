#Terraform configuration file to set up Windows instance

# Set up the AWS VPC to launch windows instance
resource "aws_vpc" "vpc" {
  cidr_block  = var.vpc_cidr
  tags  = {
    Name      = "${var.resource_name_label}_windows-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = var.subnet_cidr
  tags  = {
    Name      = "${var.resource_name_label}_windows-public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id      = aws_vpc.vpc.id
  tags  = {
    Name		  = "${var.resource_name_label}_windows-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id      = aws_vpc.vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
  tags  = {
    Name      = "${var.resource_name_label}_windows-public_rtb"
  }
}

resource "aws_route_table_association" "rtb_associate" {
  subnet_id       = aws_subnet.subnet.id
  route_table_id  = aws_route_table.rtb.id
}

# Key pair is used for  Windows instance
resource "aws_key_pair" "key_pair" {
  key_name        = "windows_ssh_key"
  public_key      = var.public_key
}

resource "aws_security_group" "sg" {
  name        = "allow_rdp"
  description = "Allow RDP to windows instance"
  vpc_id      = aws_vpc.vpc.id
  ingress {
 #RDP
  from_port   = 3389
  to_port     = 3389
  protocol    = "tcp"
  cidr_blocks = [var.sg_source_ip]
  }
  tags  = {
    Name      = "${var.resource_name_label}_windows-security_group"
  }
}

# Launch windows instance
resource "aws_instance" "instance" {
 ami                     = var.ami
 instance_type           = "t2.medium"
 disable_api_termination = var.termination_protection
 subnet_id               = aws_subnet.subnet.id
 key_name								 = aws_key_pair.key_pair.key_name
 vpc_security_group_ids  = [aws_security_group.sg.id]
 tags  = {
   Name      = "${var.resource_name_label}_windows-instance"
 }
}

resource "aws_eip" "eip" {
 instance  = aws_instance.instance.id
 vpc       = true
 tags  = {
   Name      = "${var.resource_name_label}_windows-eip"
 }
}
