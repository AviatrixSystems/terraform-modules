# Terraform configuration file to set up the AWS environment
#
# Each VPC: 2 public subnets, 1 private subnet, 2 public rtb, 1 private rtb
#						1 public ubuntu instance, 1 private ubuntu instance
#						eip assigned to instances
#						temination protection enabled
#						ssh and icmp open to 0.0.0.0/0

data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
	count				= var.vpc_count
	cidr_block	= var.vpc_cidr[count.index]
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_${data.aws_region.current.name}"
	}
}

resource "aws_subnet" "public_subnet1" {
	count				= var.vpc_count
	vpc_id			= aws_vpc.vpc[count.index].id
	cidr_block	= var.pub_subnet1_cidr[count.index]
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_public1_${data.aws_region.current.name}"
	}
}

resource "aws_subnet" "public_subnet2" {
	count				= var.vpc_count
	vpc_id			= aws_vpc.vpc[count.index].id
	cidr_block	=	var.pub_subnet2_cidr[count.index]
	tags	= {
		Name			=	"${var.resource_name_label}_vpc${count.index}_public2_${data.aws_region.current.name}"
	}
}

resource "aws_subnet" "private_subnet" {
	count				= var.vpc_count
	vpc_id			= aws_vpc.vpc[count.index].id
	cidr_block	= var.pri_subnet_cidr[count.index]
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_private_${data.aws_region.current.name}"
	}
}

resource "aws_internet_gateway" "igw" {
	count				= var.vpc_count
	vpc_id			= aws_vpc.vpc[count.index].id
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_igw_${data.aws_region.current.name}"
	}
}

resource "aws_route_table" "public_rtb" {
	count				= var.vpc_count
	vpc_id			= aws_vpc.vpc[count.index].id
	route {
		cidr_block	= "0.0.0.0/0"
		gateway_id	= aws_internet_gateway.igw[count.index].id
	}
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_public-rtb_${data.aws_region.current.name}"
	}
}

resource "aws_route_table" "private_rtb" {
	count				= var.vpc_count
	vpc_id			=	aws_vpc.vpc[count.index].id
	tags	= {
		Name			= "${var.resource_name_label}_vpc${count.index}_private-rtb_${data.aws_region.current.name}"
	}
}

resource "aws_route_table_association" "public_rtb_associate1" {
	count						=	var.vpc_count
	subnet_id				= aws_subnet.public_subnet1[count.index].id
	route_table_id	= aws_route_table.public_rtb[count.index].id
}

resource "aws_route_table_association" "public_rtb_associate2" {
	count						=	var.vpc_count
	subnet_id				= aws_subnet.public_subnet2[count.index].id
	route_table_id	= aws_route_table.public_rtb[count.index].id
}
resource "aws_route_table_association" "private_rtb_associate" {
	count						=	var.vpc_count
	subnet_id				= aws_subnet.private_subnet[count.index].id
	route_table_id  = aws_route_table.private_rtb[count.index].id
}

# Key pair is used for all ubuntu instances
resource "aws_key_pair" "key_pair" {
	key_name				= "testbed_ubuntu_key"
	public_key			= var.public_key
}

resource "aws_instance" "public_instance" {
	# Ubuntu
	count												= var.vpc_count
	ami													= var.ubuntu_ami
	instance_type								= "t3.micro"
	disable_api_termination			= var.termination_protection
	associate_public_ip_address = true
	subnet_id										= aws_subnet.public_subnet1[count.index].id
	private_ip									= cidrhost(aws_subnet.public_subnet1[count.index].cidr_block, var.pub_hostnum)
	vpc_security_group_ids			= [aws_security_group.sg[count.index].id]
	key_name										= aws_key_pair.key_pair.key_name
	tags	= {
		Name				= "${var.resource_name_label}_public-ubuntu${count.index}_${data.aws_region.current.name}"
	}
}

resource "aws_instance" "private_instance" {
	# Ubuntu
  count                       = var.vpc_count
  ami                         = var.ubuntu_ami
  instance_type               = "t3.micro"
	disable_api_termination     = var.termination_protection
  subnet_id                   = aws_subnet.private_subnet[count.index].id
	private_ip									= cidrhost(aws_subnet.private_subnet[count.index].cidr_block, var.pri_hostnum)
	vpc_security_group_ids			= [aws_security_group.sg[count.index].id]
	key_name										= aws_key_pair.key_pair.key_name
  tags  = {
    Name        = "${var.resource_name_label}_private-ubuntu${count.index}_${data.aws_region.current.name}"
  }
}

resource "aws_security_group" "sg" {
	count				= var.vpc_count
	name				= "allow_ssh_and_icmp"
	description	= "Allow SSH connection and ICMP to ubuntu instances."
	vpc_id			= aws_vpc.vpc[count.index].id

	ingress {
	# SSH
	from_port		= 22
	to_port			= 22
	protocol		= "tcp"
	cidr_blocks = ["0.0.0.0/0", aws_subnet.public_subnet1[count.index].cidr_block]
	}

	ingress {
	# ICMP
	from_port		= -1
	to_port			=	-1
	protocol		= "icmp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	tags	= {
		Name			= "${var.resource_name_label}_security-group${count.index}_${data.aws_region.current.name}"
	}

	egress {
	# SSH
	from_port		= 22
	to_port			= 22
	protocol		= "tcp"
	cidr_blocks	= [aws_subnet.private_subnet[count.index].cidr_block]
	}
}

resource "aws_eip" "eip" {
	count			= var.vpc_count
	instance	= aws_instance.public_instance[count.index].id
	vpc				= true
	tags	= {
		Name		= "${var.resource_name_label}_public-instance-eip${count.index}_${data.aws_region.current.name}"
	}
}
