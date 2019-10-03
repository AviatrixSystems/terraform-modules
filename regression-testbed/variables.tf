# Variables for Terraform Regression Testbed setup

variable "aws_primary_acct_access_key" {
  type        = string
  description = "AWS primary account's access key."
}

variable "aws_primary_acct_secret_key" {
  type        = string
  description = "AWS primary account's secret key."
}
variable "termination_protection" {
	type				= bool
	description = "Whether to enable termination protection for ec2 instances."
}
variable "resource_name_label" {
	type				= string
	description	= "The label for the resouce name."
}

# AWS VPC
variable "vpc_public_key" {
  type        = string
  description = "Public key used for creating key pair for all instances."
}
variable "pub_hostnum" {
  type        = number
  description = "Number to be used for public ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer."
}
variable "pri_hostnum" {
  type        = number
  description = "Number to be used for private ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer."
}

# US-WEST-1 Region
variable "vpc_count_west1" {
  type        = number
  description = "The number of vpcs to create in the given aws region."
}
variable "vpc_cidr_west1" {
  type        = list(string)
  description = "The cidr for a vpc."
}
variable "pub_subnet1_cidr_west1" {
  type        = list(string)
  description = "The cidr for public subnet 1."
}
variable "pub_subnet2_cidr_west1" {
  type        = list(string)
  description = "The cidr for public subnet 2."
}
variable "pri_subnet_cidr_west1" {
  type        = list(string)
  description = "The cidr for a private subnet."
}
variable "ubuntu_ami_west1" {
  type        = string
  description = "AMI of the ubuntu instances"
}

# US-WEST-2 Region
variable "vpc_count_west2" {
  type        = number
  description = "The number of vpcs to create in the given aws region."
}
variable "vpc_cidr_west2" {
  type        = list(string)
  description = "The cidr for a vpc."
}
variable "pub_subnet1_cidr_west2" {
  type        = list(string)
  description = "The cidr for public subnet 1."
}
variable "pub_subnet2_cidr_west2" {
  type        = list(string)
  description = "The cidr for public subnet 2."
}
variable "pri_subnet_cidr_west2" {
  type        = list(string)
  description = "The cidr for a private subnet."
}
variable "ubuntu_ami_west2" {
  type        = string
  description = "AMI of the ubuntu instances"
}

# US-EAST-1 Region
variable "vpc_count_east1" {
  type        = number
  description = "The number of vpcs to create in the given aws region."
}
variable "vpc_cidr_east1" {
  type        = list(string)
  description = "The cidr for a vpc."
}
variable "pub_subnet1_cidr_east1" {
  type        = list(string)
  description = "The cidr for public subnet 1."
}
variable "pub_subnet2_cidr_east1" {
  type        = list(string)
  description = "The cidr for public subnet 2."
}
variable "pri_subnet_cidr_east1" {
  type        = list(string)
  description = "The cidr for a private subnet."
}
variable "ubuntu_ami_east1" {
  type        = string
  description = "AMI of the ubuntu instances"
}

# US-EAST-2 Region
variable "vpc_count_east2" {
  type        = number
  description = "The number of vpcs to create in the given aws region."
}
variable "vpc_cidr_east2" {
  type        = list(string)
  description = "The cidr for a vpc."
}
variable "pub_subnet1_cidr_east2" {
  type        = list(string)
  description = "The cidr for public subnet 1."
}
variable "pub_subnet2_cidr_east2" {
  type        = list(string)
  description = "The cidr for public subnet 2."
}
variable "pri_subnet_cidr_east2" {
  type        = list(string)
  description = "The cidr for a private subnet."
}
variable "ubuntu_ami_east2" {
  type        = string
  description = "AMI of the ubuntu instances"
}

# Aviatrix Controller
variable "controller_region" {
	type				= string
	description	= "Region to launch Aviatrix controller."
}
variable "controller_vpc_cidr" {
  type          = string
  description   = "AWS VPC cidr being created for the Aviatrix controller."
}
variable "controller_subnet_cidr" {
  type          = string
  description   = "Public subnet cidr of the vpc being created for the Aviatrix controller."
}
variable "controller_public_key" {
  type          = string
  description   = "Public key to create a new key pair for the controller."
}
variable "controller_sg_source_ip" {
  type          = string
  description   = "Source IP that AWS security group will allow for controller."
}
variable "admin_email" {
  type          = string
  description   = "Admin email to be used for the Aviatrix controller."
}
variable "admin_password" {
  type          = string
  description   = "Admin password to be used for logging into the Aviatrix controller."
}
variable "access_account" {
  type          = string
  description   = "Account name for this AWS access account to be used for the Aviatrix controller."
}
variable "customer_id" {
  type          = string
  description   = "Customer license ID for the Aviatrix controller, if using BYOL controller."
}

# Windows instance
variable "windows_region" {
	type				= string
	description	= "Region to launch Windows instance."
}
variable "windows_vpc_cidr" {
  type          = string
  description   = "AWS VPC cidr being created for the Windows instance."
}
variable "windows_subnet_cidr" {
  type          = string
  description   = "Public subnet cidr of the vpc being created for the Windows instance."
}
variable "windows_public_key" {
  type          = string
  description   = "Public key to create a new key pair for the Windows instance."
}
variable "windows_sg_source_ip" {
  type          = string
  description   = "Source IP that Windows instance security group will allow."
}
variable "windows_ami" {
  type          = string
  description   = "Amazon Machine Id for the windows instance to be created."
}
