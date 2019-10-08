# Variable declarations for TF Regression Testbed Windows instance setup

variable "deploy_windows" {
	type 					= bool
	description   = "Whether to launch windows instance."
}

variable "vpc_cidr" {
	type					= string
	description		= "VPC cidr."
}

variable "subnet_cidr" {
	type					= string
	description		= "Pubic subnet cidr."
}

variable "sg_source_ip" {
  type          = list(string)
  description   = "Source IPs that Windows instance security group will allow."
}

variable "ami" {
  type          = string
  description   = "Amazon Machine Id for the windows instance to be created."
}

variable "public_key" {
	type					= string
	description		= "Public ssh key."
}

variable "termination_protection" {
	type					= bool
	description		= "Whether to enable termination protection for Windows instance."
}

variable "resource_name_label" {
	type					= string
	description		= "The label for the resource name."
}
