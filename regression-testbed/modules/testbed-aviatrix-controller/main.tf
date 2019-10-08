# Terraform configuration file to set up Aviatrix Controller

# Set up the AWS VPC to launch controller in
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "aws_vpc" "vpc" {
  count       = var.deploy_controller ? 1 : 0
  cidr_block  = var.vpc_cidr
  tags  = {
    Name      = "${var.resource_name_label}_controller_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count       = var.deploy_controller ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  cidr_block  = var.subnet_cidr
  tags  = {
    Name      = "${var.resource_name_label}_controller-public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  count       = var.deploy_controller ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  tags  = {
    Name		  = "${var.resource_name_label}_controller-igw"
  }
}

resource "aws_route_table" "public_rtb" {
  count       = var.deploy_controller ? 1 : 0
  vpc_id      = aws_vpc.vpc[0].id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw[0].id
  }
  tags  = {
    Name      = "${var.resource_name_label}_controller-public_rtb"
  }
}

resource "aws_route_table_association" "public_rtb_associate" {
  count       = var.deploy_controller ? 1 : 0
  subnet_id       = aws_subnet.public_subnet[0].id
  route_table_id  = aws_route_table.public_rtb[0].id
}

resource "random_id" "key_id" {
  count       = var.deploy_controller ? 1 : 0
	byte_length = 4
}

# Key pair is used for Aviatrix Controller
resource "aws_key_pair" "key_pair" {
  count       = var.deploy_controller ? 1 : 0
  key_name        = "controller_ssh_key-${random_id.key_id[0].dec}"
  public_key      = var.public_key
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Build Aviatrix controller
# Code from aviatrix-controller-build module by Tim
# Edited to include deploy_controller variable and add ssh into SG
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "aws_eip" "controller_eip" {
  count = var.deploy_controller ? 1 : 0
  vpc   = true
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.deploy_controller ? 1 : 0
  instance_id   = aws_instance.aviatrixcontroller[0].id
  allocation_id = aws_eip.controller_eip[0].id
}

resource "aws_network_interface" "eni-controller" {
  count           = var.deploy_controller ? 1 : 0
  subnet_id       = aws_subnet.public_subnet[0].id
  security_groups = [aws_security_group.AviatrixSecurityGroup[0].id]
  tags            = {
    Name      = "${format("%s%s : %d", "${var.resource_name_label}-", "Aviatrix Controller interface", count.index)}"
    Createdby = "Terraform+Aviatrix"
  }
}

resource "aws_instance" "aviatrixcontroller" {
  count                   = var.deploy_controller ? 1 : 0
  ami                     = local.ami_id
  instance_type           = "t2.large"
  key_name                = aws_key_pair.key_pair[0].key_name
  iam_instance_profile    = "aviatrix-role-ec2"
  disable_api_termination = var.termination_protection

  network_interface {
    network_interface_id = aws_network_interface.eni-controller[0].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = {
    Name      = "${format("%s%s-%d", "${var.resource_name_label}-", "AviatrixController", count.index)}"
    Createdby = "Terraform+Aviatrix"
  }
}

# Security Groups
resource "aws_security_group" "AviatrixSecurityGroup" {
  count = var.deploy_controller ? 1 : 0
  name        = "${var.resource_name_label}-AviatrixSecurityGroup"
  description = "Aviatrix - Controller Security Group"
  vpc_id      = aws_vpc.vpc[0].id

  tags = {
    Name      = "${var.resource_name_label}-AviatrixSecurityGroup"
    Createdby = "Terraform+Aviatrix"
  }
}

resource "aws_security_group_rule" "ssh_ingress_rule" {
  count = var.deploy_controller ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.sg_source_ip
  security_group_id = aws_security_group.AviatrixSecurityGroup[0].id
}

resource "aws_security_group_rule" "https_ingress_rule" {
  count = var.deploy_controller ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.sg_source_ip
  security_group_id = aws_security_group.AviatrixSecurityGroup[0].id
}

resource "aws_security_group_rule" "egress_rule" {
  count = var.deploy_controller ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.AviatrixSecurityGroup[0].id
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Initialize Aviatrix controller
# Code from aviatrix-controller-init module by Tim
# Edited to include deploy_controller variable
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "aws_caller_identity" "current" {
}

resource "aws_iam_role" "iam_for_lambda" {
  count = var.deploy_controller ? 1 : 0
  name = "${replace("iam_for_lambda_${aws_eip.controller_eip[0].public_ip}",".","-")}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  count      = var.deploy_controller ? 1 : 0
  role       = aws_iam_role.iam_for_lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_region" "current" {}

resource "aws_lambda_function" "lambda" {
  count         = var.deploy_controller ? 1 : 0
  s3_bucket     = "aviatrix-lambda-${data.aws_region.current.name}"
  s3_key        = "run_controller_init_setup.zip"
  function_name = "${replace("AvxLambda_${aws_eip.controller_eip[0].public_ip}",".","-")}"
  role          = aws_iam_role.iam_for_lambda[0].arn
  handler       = "run_controller_init_setup.lambda_handler"
  runtime       = "python3.7"
  description   = "MANAGED BY TERRAFORM"
  timeout       = 900
}

data "aws_lambda_invocation" "example" {
  count         = var.deploy_controller ? 1 : 0
  function_name = aws_lambda_function.lambda[0].function_name

  input = <<JSON
{ "ResourceProperties":
{
  "PrefixStringParam"                : "avx",
  "LambdaInvokerTypeParam"           : "terraform",
  "AWS_Account_ID"                   : "${data.aws_caller_identity.current.account_id}",
  "KeywordForCloudWatchLogParam"     : "avx-log",
  "DelimiterForCloudWatchLogParam"   : "---",
  "ControllerPublicIpParam"          : "${aws_eip.controller_eip[0].public_ip}",
  "AviatrixApiVersionParam"          : "v1",
  "AviatrixApiRouteParam"            : "api/",
  "ControllerPrivateIpParam"         : "${aws_instance.aviatrixcontroller[0].private_ip}",
  "ControllerAdminPasswordParam"     : "${var.admin_password}",
  "ControllerAdminEmailParam"        : "${var.admin_email}",
  "ControllerVersionParam"           : "latest",
  "ControllerAccessAccountNameParam" : "${var.access_account}",
  "AviatrixCustomerLicenseIdParam"   : "${var.customer_id}"
}
}
JSON
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
