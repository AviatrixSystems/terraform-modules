data aws_caller_identity current {}

data aws_region current {}

locals {
  is_aws_cn = element(split("-", data.aws_region.current.name), 0) == "cn" ? "aws-cn" : "aws"
}

  variable admin_email {
  type        = string
  description = "Aviatrix admin email address"
}

variable admin_password {
  type        = string
  description = "Aviatrix admin password"
}

variable private_ip {
  type        = string
  description = "Private IP of Aviatrix controller"
}

variable public_ip {
  type        = string
  description = "Public IP of Aviatrix controller"
}

variable access_account_name {
  type        = string
  description = "The controller account friendly name (mapping to the AWS account ID)"
}

variable aws_account_id {
  type        = string
  description = "AWS account ID"
}

variable vpc_id {
  type        = string
  description = "VPC in which you want launch Aviatrix controller"
}

variable name_prefix {
  type        = string
  description = "Additional name prefix for your environment resources"
  default     = ""
}

variable tags {
  type        = map(string)
  description = "Map of common tags which should be used for module resources"
  default     = {}
}

variable subnet_id {
  type        = string
  description = "Subnet in which you want launch Aviatrix controller"
}

variable customer_license_id {
  type        = string
  description = "Customer license ID"
  default     = ""
}

variable controller_version {
  type        = string
  default     = "latest"
  description = "The version in which you want launch Aviatrix controller"
}

variable controller_launch_wait_time {
  description = "Controller launch wait time"
  default     = 210
}

variable wait_time_for_instance {
  description = "Wait time for controller instance to come up"
  default     = 120
}

locals {
  common_tags = merge(
    var.tags, {
      module    = "aviatrix-controller-initialize"
      Createdby = "Terraform+Aviatrix"
  })
}
