variable "num_controllers" {
  default = 1
}

variable "region" {}

variable "vpc" {}

variable "subnet" {}

variable "keypair" {}

variable "ec2role" {}

#
# Defaults
#

# This is the default root volume size as suggested by Aviatrix
variable "root_volume_size" {
  default = 16
}

variable "root_volume_type" {
  default = "standard"
}

variable "incoming_ssl_cidr" {
  default = ["0.0.0.0/0"]
}

variable "instance_type" {
  default = "t2.large"
}

variable "name_prefix" {
  default = ""
}

variable "images" {
  default = {
    us-east-1      = "ami-690c467e"
    us-east-2      = "ami-811248e4"
    us-west-1      = "ami-43206823"
    us-west-2      = "ami-03558e63"
    ca-central-1   = "ami-2dc57749"
    eu-central-1   = "ami-70c43a1f"
    eu-west-1      = "ami-33d69440"
    eu-west-2      = "ami-a1272dc5"
    ap-south-1     = "ami-970672f8"
    ap-northeast-1 = "ami-7308d212"
    ap-northeast-2 = "ami-93d400fd"
    ap-southeast-1 = "ami-f4258297"
    ap-southeast-2 = "ami-921624f1"
    sa-east-1      = "ami-bcf66bd0"
  }
}

locals {
  name_prefix = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}"
}

