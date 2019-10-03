# Main terraform configuration file for setting up Terraform regression testbed

provider "aws" {
	alias					= "west1"
  version       = "~> 2.7"
  region        = "us-west-1"
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aws" {
	alias					=	"west2"
  version       = "~> 2.7"
  region        = "us-west-2"
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aws" {
	alias					= "east1"
  version       = "~> 2.7"
  region        = "us-east-1"
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aws" {
	alias					= "east2"
  version       = "~> 2.7"
  region        = "us-east-2"
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aws" {
	alias					= "controller"
	version				= "~> 2.7"
	region				= var.controller_region
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aws" {
	alias					= "windows"
	version				= "~> 2.7"
	region				= var.windows_region
  access_key    = var.aws_primary_acct_access_key
  secret_key    = var.aws_primary_acct_secret_key
}

provider "aviatrix" {
  username      = "admin"
  password      = module.aviatrix-controller.private_ip
  controller_ip = module.aviatrix-controller.public_ip
}

module "aws-vpc-west1" {
  source                = "./modules/testbed-vpcs"
  providers = {
    aws = aws.west1
  }
  vpc_count             = var.vpc_count_west1
  resource_name_label   = var.resource_name_label
	pub_hostnum						= var.pub_hostnum
  pri_hostnum           = var.pri_hostnum
  vpc_cidr              = var.vpc_cidr_west1
  pub_subnet1_cidr      = var.pub_subnet1_cidr_west1
  pub_subnet2_cidr      = var.pub_subnet2_cidr_west1
  pri_subnet_cidr       = var.pri_subnet_cidr_west1
  ubuntu_ami            = var.ubuntu_ami_west1
  public_key            = var.vpc_public_key
	termination_protection = var.termination_protection
}

module "aws-vpc-west2" {
  source                = "./modules/testbed-vpcs"
  providers = {
    aws = aws.west2
  }
  vpc_count             = var.vpc_count_west2
  resource_name_label   = var.resource_name_label
	pub_hostnum						= var.pub_hostnum
  pri_hostnum           = var.pri_hostnum
  vpc_cidr              = var.vpc_cidr_west2
  pub_subnet1_cidr      = var.pub_subnet1_cidr_west2
  pub_subnet2_cidr      = var.pub_subnet2_cidr_west2
  pri_subnet_cidr       = var.pri_subnet_cidr_west2
  ubuntu_ami            = var.ubuntu_ami_west2
  public_key            = var.vpc_public_key
	termination_protection = var.termination_protection
}

module "aws-vpc-east1" {
  source                = "./modules/testbed-vpcs"
  providers = {
    aws = aws.east1
  }
  vpc_count             = var.vpc_count_east1
  resource_name_label   = var.resource_name_label
	pub_hostnum						= var.pub_hostnum
  pri_hostnum           = var.pri_hostnum
  vpc_cidr              = var.vpc_cidr_east1
  pub_subnet1_cidr      = var.pub_subnet1_cidr_east1
  pub_subnet2_cidr      = var.pub_subnet2_cidr_east1
  pri_subnet_cidr       = var.pri_subnet_cidr_east1
  ubuntu_ami            = var.ubuntu_ami_east1
  public_key            = var.vpc_public_key
	termination_protection = var.termination_protection
}

module "aws-vpc-east2" {
  source                = "./modules/testbed-vpcs"
  providers = {
    aws = aws.east2
  }
  vpc_count             = var.vpc_count_east2
  resource_name_label   = var.resource_name_label
	pub_hostnum						= var.pub_hostnum
  pri_hostnum           = var.pri_hostnum
  vpc_cidr              = var.vpc_cidr_east2
  pub_subnet1_cidr      = var.pub_subnet1_cidr_east2
  pub_subnet2_cidr      = var.pub_subnet2_cidr_east2
  pri_subnet_cidr       = var.pri_subnet_cidr_east2
  ubuntu_ami            = var.ubuntu_ami_east2
  public_key            = var.vpc_public_key
	termination_protection = var.termination_protection
}

module "aviatrix-controller" {
  source          = "./modules/testbed-aviatrix-controller"
  providers = {
    aws = aws.controller
  }
  vpc_cidr        = var.controller_vpc_cidr
  subnet_cidr     = var.controller_subnet_cidr
  sg_source_ip    = var.controller_sg_source_ip
  public_key      = var.controller_public_key
  admin_email     = var.admin_email
  admin_password  = var.admin_password
  access_account  = var.access_account
  customer_id     = var.customer_id
	termination_protection = var.termination_protection
	resource_name_label		 = var.resource_name_label
}

module "windows-instance" {
  source        = "./modules/testbed-windows-instance"
  providers = {
    aws = aws.windows
  }
  vpc_cidr       	= var.windows_vpc_cidr
  subnet_cidr     = var.windows_subnet_cidr
  public_key      = var.windows_public_key
  sg_source_ip  	= var.windows_sg_source_ip
  ami   					= var.windows_ami
  termination_protection = var.termination_protection
	resource_name_label		 = var.resource_name_label
}
