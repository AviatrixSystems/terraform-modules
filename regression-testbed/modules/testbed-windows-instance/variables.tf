# Variable declarations for TF Regression Testbed Windows instance setup

variable "vpc" {
	type					= string
	description		= "VPC ID."
}

variable "subnet" {
	type					= string
	description		= "Pubic subnet ID."
}

variable "sg_source_ip" {
  type          = string
  description   = "Source IP that Windows instance security group will allow."
}

variable "windows_ami" {
  type          = string
  description   = "Amazon Machine Id for the windows instance to be created."
}

variable "keypair" {
	type					= string
	description		= "Name of the key pair used to connect to instance."
}

variable "termination_protection" {
	type					= bool
	description		= "Whether to enable termination protection for Windows instance."
}

variable "resource_name_label" {
	type					= string
	description		= "The label for the resource name."
}
