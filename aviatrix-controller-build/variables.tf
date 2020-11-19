variable num_controllers {
  type        = number
  description = "Number of controllers to build"
  default     = 1
}

variable vpc {
  type        = string
  description = "VPC in which you want launch Aviatrix controller"
}

variable subnet {
  type        = string
  description = "Subnet in which you want launch Aviatrix controller"
}

variable keypair {
  type        = string
  description = "Key pair which should be used by Aviatrix controller"
}

variable ec2role {
  type        = string
  description = "EC2 role for controller"
}

variable tags {
  type        = map(string)
  description = "Map of common tags which should be used for module resources"
  default     = {}
}

variable termination_protection {
  type        = bool
  description = "Enable/disable switch for termination protection"
  default     = true
}

#
# Defaults
#

# This is the default root volume size as suggested by Aviatrix
variable root_volume_size {
  type        = number
  description = "Root volume disk size for controller"
  default     = 32
}

variable root_volume_type {
  type        = string
  description = "Root volume type for controller"
  default     = "gp2"
}

variable incoming_ssl_cidr {
  type        = list(string)
  description = "Incoming cidr for security group used by controller"
  default     = ["0.0.0.0/0"]
}

variable instance_type {
  type        = string
  description = "Controller instance size"
  default     = "t3.large"
}

variable name_prefix {
  type        = string
  description = "Additional name prefix for your environment resources"
  default     = ""
}

variable type {
  default     = "MeteredPlatinum"
  type        = string
  description = "Type of billing, can be 'MeteredPlatinum', 'BYOL' or 'Custom'"
}

variable controller_name {
  default     = ""
  type        = string
  description = "Name of controller that will be launched. If not set, default name will be used."
}

data aws_region current {}

locals {
  name_prefix     = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  images_byol     = jsondecode(data.http.avx_iam_id.body).BYOL
  images_platinum = jsondecode(data.http.avx_iam_id.body).MeteredPlatinum
  images_custom   = jsondecode(data.http.avx_iam_id.body).Custom
  images_copilot  = jsondecode(data.http.avx_iam_id.body).MeteredPlatinumCopilot
  ami_id          = var.type == "MeteredPlatinumCopilot"? local.images_copilot[data.aws_region.current.name] : ( var.type == "Custom" ? local.images_custom[data.aws_region.current.name] : (var.type == "BYOL" || var.type == "byol" ? local.images_byol[data.aws_region.current.name] : local.images_platinum[data.aws_region.current.name]))
  common_tags = merge(
    var.tags, {
      module    = "aviatrix-controller-build"
      Createdby = "Terraform+Aviatrix"
  })
}


data http avx_iam_id {
  url = "https://s3-us-west-2.amazonaws.com/aviatrix-download/AMI_ID/ami_id.json"
  request_headers = {
    "Accept" = "application/json"
  }
}
