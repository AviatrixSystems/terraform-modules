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
        us-east-1 = "ami-e578ef9a"
        us-east-2 = "ami-d8a39ebd"
        us-west-1 = "ami-fa322b9a"
        us-west-2 = "ami-98b3c1e0"
        ca-central-1 = "ami-8c4bcbe8"
        eu-central-1 = "ami-02f9d6e9"
        eu-west-1 = "ami-cdcefeb4"
        eu-west-2 = "ami-86f518e1"
        eu-west-3 = "ami-3c71c041"
        ap-southeast-1 = "ami-0b744577"
        ap-southeast-2 = "ami-c79746a5"
        ap-northeast-2 = "ami-0238cf7d"
        ap-northeast-1 = "ami-3eb21a50"
        ap-south-1 = "ami-1294b67d"
        sa-east-1 = "ami-ed85d981"
        us-gov-west-1 = "ami-edc1578c"
    }
    ami_id = "${var.type == "metered" ? local.images_metered[data.aws_region.current.name] : local.images_byol[data.aws_region.current.name]}"
}

