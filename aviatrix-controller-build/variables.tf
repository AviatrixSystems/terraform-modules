variable "num_controllers" {
  default = 1
}

variable "vpc" {}

variable "subnet" {}

variable "keypair" {}

variable "ec2role" {}

variable "termination_protection" {
    default = true
}

#
# Defaults
#

# This is the default root volume size as suggested by Aviatrix
variable "root_volume_size" {
  default = 32
}

variable "root_volume_type" {
  default = "gp2"
}

variable "incoming_ssl_cidr" {
  type = list(string)
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
  name_prefix    = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  images_metered = jsondecode(data.http.avx_iam_id.body).BYOL
  images_byol    = jsondecode(data.http.avx_iam_id.body).Metered
  ami_id         = "${var.type == "metered" ? local.images_metered[data.aws_region.current.name] : local.images_byol[data.aws_region.current.name]}"
}

data "http" "avx_iam_id" {
  url             = "https://s3-us-west-2.amazonaws.com/aviatrix-download/AMI_ID/ami_id.json"
  request_headers = {
    "Accept" = "application/json"
  }
}
