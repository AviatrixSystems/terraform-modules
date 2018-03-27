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
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "instance_type" {
  default = "t2.large"
}

variable "name_prefix" {
  default = ""
}

variable "images" {
  type = "map"
  default = {
    us-east-1 = "ami-db9bb9a1"
    us-east-2 = "ami-b40228d1"
    us-west-1 = "ami-2a7e7c4a"
    us-west-2 = "ami-fd48f885"
    ca-central-1 = "ami-de4bceba"
    eu-central-1 = "ami-a025b9cf"
    eu-west-1 = "ami-830d93fa"
    eu-west-2 = "ami-bc253ed8"
    eu-west-3 = "ami-f8e35585"
    ap-southeast-1 = "ami-0484f878"
    ap-southeast-2 = "ami-34728e56"
    ap-northeast-2 = "ami-d902a2b7"
    ap-northeast-1 = "ami-2a43244c"
    ap-south-1 = "ami-e7560088"
    sa-east-1 = "ami-404c012c"
    us-gov-west-1 = "ami-30890051"
  }
}

locals {
  name_prefix = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}"
}

