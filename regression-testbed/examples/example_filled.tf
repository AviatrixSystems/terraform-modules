
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS Basic Creation module
# - VPCS in each region with Ubuntu instances
# - Aviatrix Controller (optional)
# - Windows instance for RDP (optional)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module "testbed-basic" {
  source = "./regression-testbed/modules/testbed-basic"
	termination_protection			= local.termination_protection
  resource_name_label         = local.resource_name_label

  # AWS Primary Account
  aws_primary_acct_access_key = ""
  aws_primary_acct_secret_key = ""

  # AWS VPC setup
	# example for 2 vpcs
  vpc_public_key              = local.public_key
  pub_hostnum                 = local.pub_hostnum
  pri_hostnum                 = local.pri_hostnum

  # US West 1
	# each variable for the cidr are lists
	# because vpc_count is set to 2,
	# make sure there are 2 elements in each list
  vpc_count_west1             = 2
  vpc_cidr_west1              = ["10.1.0.0/16", "10.2.0.0/16"]
  pub_subnet1_cidr_west1      = ["10.1.1.0/24", "10.2.1.0/24"]
  pub_subnet2_cidr_west1      = ["10.1.10.0/24", "10.2.10.0/24"]
  pri_subnet_cidr_west1       = ["10.1.2.0/24", "10.2.2.0/24"]
  pub_subnet1_az_west1        = ["us-west-1b", "us-west-1c"]
  pub_subnet2_az_west1        = ["us-west-1b", "us-west-1c"]
  pri_subnet_az_west1         = ["us-west-1b", "us-west-1c"]
  ubuntu_ami_west1            = "ami-0acfa9d37b413b160"

  # US West 2
  vpc_count_west2             = 2
  vpc_cidr_west2              = ["10.3.0.0/16", "10.4.0.0/16"]
  pub_subnet1_cidr_west2      = ["10.3.1.0/24", "10.4.1.0/24"]
  pub_subnet2_cidr_west2      = ["10.3.10.0/24", "10.4.10.0/24"]
  pri_subnet_cidr_west2       = ["10.3.2.0/24", "10.4.2.0/24"]
  pub_subnet1_az_west2        = ["us-west-2a", "us-west-2b"]
  pub_subnet2_az_west2        = ["us-west-2a", "us-west-2b"]
  pri_subnet_az_west2         = ["us-west-2a", "us-west-2b"]
  ubuntu_ami_west2            = "ami-0eaedb5f9e4e556f4"

  # US East 1
  vpc_count_east1             = 2
  vpc_cidr_east1              = ["10.5.0.0/16", "10.6.0.0/16"]
  pub_subnet1_cidr_east1      = ["10.5.1.0/24", "10.6.1.0/24"]
  pub_subnet2_cidr_east1      = ["10.5.10.0/24", "10.6.10.0/24"]
  pri_subnet_cidr_east1       = ["10.5.2.0/24", "10.6.2.0/24"]
  pub_subnet1_az_east1        = ["us-east-1a", "us-east-1b"]
  pub_subnet2_az_east1        = ["us-east-1a", "us-east-1b"]
  pri_subnet_az_east1         = ["us-east-1a", "us-east-1b"]
  ubuntu_ami_east1            = "ami-0f40d38d3ce4a1354"

  # US East 2
  vpc_count_east2             = 2
  vpc_cidr_east2              = ["10.7.0.0/16", "10.8.0.0/16"]
  pub_subnet1_cidr_east2      = ["10.7.1.0/24", "10.8.1.0/24"]
  pub_subnet2_cidr_east2      = ["10.7.10.0/24", "10.8.10.0/24"]
  pri_subnet_cidr_east2       = ["10.7.2.0/24", "10.8.2.0/24"]
  pub_subnet1_az_east2        = ["us-east-2a", "us-east-2b"]
  pub_subnet2_az_east2        = ["us-east-2a", "us-east-2b"]
  pri_subnet_az_east2         = ["us-east-2a", "us-east-2b"]
  ubuntu_ami_east2            = "ami-09f0299359c12ab7c"

	# AWS VPC for controller
  deploy_controller           = true
  controller_region           = "us-west-1"
	controller_vpc_cidr         = "10.22.0.0/16"
	controller_subnet_cidr			= "10.22.23.0/24"
	controller_public_key       = local.public_key
	controller_sg_source_ip     = "0.0.0.0/0"

	# Aviatrix controller
	admin_email                 = ""
	admin_password              = ""
	access_account              = ""
	customer_id                 = ""

	# Windows instance
  deploy_windows              = true
  windows_region              = "us-east-1"
  windows_vpc_cidr            = "20.5.0.0/16"
  windows_subnet_cidr         = "20.5.1.0/24"
  windows_public_key          = local.public_key
  windows_ami                 = "ami-0069635df219ce9e5"
	windows_sg_source_ip        = "0.0.0.0/0"
}

## AWS Cross account and Azure Vnet modules are optional.
## If you want to include into testbed, uncomment the modules and providers.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS Cross Account Module (Optional)
# - VPC with Ubuntu instance in alternate AWS account
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#provider "aws" {
#	alias									 = "cross_aws_acc"
#  version       				 = "~> 2.7"
#  region        				 = "us-east-2"
#	access_key    				 = ""
#	secret_key    				 = ""
#}
#module "aws-cross-acct" {
#  source                 = "./regression-testbed/modules/testbed-vpcs"
#  providers = {
#    aws = aws.cross_aws_acc
#  }
#  vpc_count              = 1
#  resource_name_label    = local.resource_name_label
#	pub_hostnum						 = local.pub_hostnum
#  pri_hostnum            = local.pri_hostnum
#  vpc_cidr         			 = ["10.9.0.0/16", "10.10.0.0/16"]
#  pub_subnet1_cidr       = ["10.9.0.0/24", "10.10.3.0/24"]
#  pub_subnet2_cidr       = ["10.9.1.0/24", "10.10.4.0/24"]
#  pri_subnet_cidr        = ["10.9.2.0/24", "10.10.5.0/24"]
#  pub_subnet1_az      	 = ["us-east-2a", "us-east-2b"]
#  pub_subnet2_az      	 = ["us-east-2a", "us-east-2b"]
#  pri_subnet_az       	 = ["us-east-2a", "us-east-2b"]
#  ubuntu_ami             = "ami-09f0299359c12ab7c"
#  public_key             = local.public_key
#	termination_protection = local.termination_protection
#}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Azure Vnet Module (Optional)
# - VNETs with Ubuntu instances in specified region
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#provider "azurerm" {
#	version = "1.34"
#	subscription_id 			= ""
#	tenant_id 						= ""
#	client_id 						= ""
#	client_secret   			= ""
#}
#module "arm-vnet" {
#	source 								= "./regression-testbed/modules/testbed-vnet-arm"
#	region 			 					= "East US"
#	vnet_count 						= 1
#	resource_name_label 	= local.resource_name_label
#  pub_hostnum						= local.pub_hostnum
#  pri_hostnum           = local.pri_hostnum
#  vnet_cidr             = ["10.20.0.0/16", "10.30.0.0/16"]
#	pub_subnet_cidr       = ["10.20.1.0/24", "10.30.3.0/24"]
#	pri_subnet_cidr       = ["10.20.2.0/24", "10.30.4.0/24"]
#	public_key 						= local.public_key
#}

## Leave following provider/module commented before initial terraform apply.
## After successful terraform apply, uncomment.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aviatrix Modules
# **Create these modules last!**
# - Creating additional Aviatrix Access accounts
# - Simulate Onprem connection with Aviatrix S2C
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#provider "aviatrix" {
#	controller_ip	= module.testbed-basic.controller_public_ip
#	username			= element(module.testbed-basic.controller_username_password, 0)
#	password			= element(module.testbed-basic.controller_username_password, 1)
#}
#module "aviatrix-access-accounts" {
#  source                = "./regression-testbed/modules/testbed-aviatrix-accounts"
#  cross_aws_acc_number        = ""
#  cross_aws_acc_access_key    = ""
#  cross_aws_acc_secret_key    = ""
#  arm_subscription_id   = ""
#  arm_directory_id      = ""
#  arm_application_id    = ""
#  arm_application_key   = ""
#  gcp_id                   =
#  gcp_credentials_filepath = ""
#}
#provider "aws" {
#	alias					= "onprem"
#  version       = "~> 2.7"
#  region        = "us-west-2"
#  access_key 		= ""
#  secret_key 		= ""
#}
#module "testbed-onprem" {
#	source = "./regression-testbed/modules/testbed-onprem"
#	providers = {
#		aws = aws.onprem
#	}
#  account_name           = module.testbed-basic.primary_access_account
#
#  onprem_vpc_cidr        = "10.70.0.0/16"
#  pub_subnet_cidr        = "10.70.5.0/24"
#  pri_subnet_cidr        = "10.70.36.0/24"
#  pub_subnet_az          = "us-west-2b"
#  pri_subnet_az          = "us-west-2b"
#  pub_hostnum            = local.pub_hostnum
#  pri_hostnum            = local.pri_hostnum
#
#  termination_protection = local.termination_protection
#  public_key             = local.public_key
#  ubuntu_ami             = "ami-0eaedb5f9e4e556f4"
#}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# LOCALS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
locals {
	resource_name_label	 	 = "regression"
	pub_hostnum						 = 20
	pri_hostnum						 = 40
	public_key 						 = file("~/.ssh/id_rsa.pub")
	termination_protection = false
}
