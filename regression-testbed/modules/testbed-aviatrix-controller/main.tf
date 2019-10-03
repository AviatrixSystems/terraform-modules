# Terraform configuration file to set up Aviatrix Controller

# Set up the AWS VPC to launch controller in
resource "aws_vpc" "vpc" {
  cidr_block  = var.vpc_cidr
  tags  = {
    Name      = "${var.resource_name_label}_controller_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = var.subnet_cidr
  tags  = {
    Name      = "${var.resource_name_label}_controller-public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id      = aws_vpc.vpc.id
  tags  = {
    Name		  = "${var.resource_name_label}_controller-igw"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id      = aws_vpc.vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
  tags  = {
    Name      = "${var.resource_name_label}_controller-public_rtb"
  }
}

resource "aws_route_table_association" "public_rtb_associate" {
  subnet_id       = aws_subnet.public_subnet.id
  route_table_id  = aws_route_table.public_rtb.id
}

# Key pair is used for Aviatrix Controller
resource "aws_key_pair" "key_pair" {
  key_name        = "controller_ssh_key"
  public_key      = var.public_key
}

resource "aws_security_group" "sg" {
  name        = "allow_ssh_and_https"
  description = "Allow SSH connection and HTTP to Aviatrix controller."
  vpc_id      = aws_vpc.vpc.id
  ingress {
  # SSH
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0", var.sg_source_ip]
  }
  ingress {
  # HTTPS
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [var.sg_source_ip]
  }
  tags  = {
    Name      = "${var.resource_name_label}_controller-security_group"
  }
}

data "aws_caller_identity" "current" {
}

# Build Aviatrix controller
module "aviatrix-controller-build" {
  source      = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-build?ref=terraform_0.12"
  vpc         = aws_vpc.vpc.id
  subnet      = aws_subnet.public_subnet.id
  keypair     = aws_key_pair.key_pair.key_name
  ec2role     = "aviatrix-role-ec2"
	type				= "BYOL"
	name_prefix = var.resource_name_label
	termination_protection	= var.termination_protection
}

# Initialize Aviatrix controller
module "aviatrix-controller-init" {
  source              = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-initialize?ref=terraform_0.12"
  admin_email         = var.admin_email
  admin_password      = var.admin_password
  private_ip          = module.aviatrix-controller-build.private_ip
  public_ip           = module.aviatrix-controller-build.public_ip
  access_account_name = var.access_account
  aws_account_id      = data.aws_caller_identity.current.account_id
	customer_license_id = var.customer_id
}
