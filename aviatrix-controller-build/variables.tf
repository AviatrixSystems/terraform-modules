variable "num_controllers" {
  default = 1
}

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

variable "type" {
  default = "metered"
}

data "aws_region" "current" {}

locals {
    name_prefix = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}"
    images_metered = {
        us-east-1 = "ami-df74f6a0"
        us-east-2 = "ami-a72c11c2"
        us-west-1 = "ami-e3170983"
        us-west-2 = "ami-1f770667"
        ca-central-1 = "ami-8d8707e9"
        eu-central-1 = "ami-d9bf9d32"
        eu-west-1 = "ami-f227138b"
        eu-west-2 = "ami-a06587c7"
        eu-west-3 = "ami-339e2f4e"
        ap-southeast-1 = "ami-8fcbfef3"
        ap-southeast-2 = "ami-e90ed98b"
        ap-northeast-1 = "ami-358f674a"
        ap-northeast-2 = "ami-cc08a1a2"
        ap-south-1 = "ami-ccc4e7a3"
        sa-east-1 = "ami-1a90cd76"
    }
    images_byol = {
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
    ami_id = "${var.type == "metered" ? local.images_metered[data.aws_region.current.name] : local.images_byol[data.aws_region.current.name]}"
}

