data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

variable "tags" {
  type        = map(string)
  description = "Map of common tags which should be used for module resources"
  default     = {}
}

variable "name_prefix" {
  type        = string
  description = "Additional name prefix for your environment resources"
  default     = ""
}

variable "ec2_role_name" {
  type        = string
  description = "EC2 role name"
  default     = ""
}

variable "app_role_name" {
  type        = string
  description = "APP role name"
  default     = ""
}

locals {
  name_prefix          = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  ec2_role_name        = var.ec2_role_name != "" ? var.ec2_role_name : "${local.name_prefix}aviatrix-role-ec2"
  app_role_name        = var.app_role_name != "" ? var.app_role_name : "${local.name_prefix}aviatrix-role-app"
  arn_partition        = element(split("-", data.aws_region.current.name), 0) == "cn" ? "aws-cn" : (element(split("-", data.aws_region.current.name), 1) == "gov" ? "aws-us-gov" : "aws")
  is_aws_cn            = element(split("-", data.aws_region.current.name), 0) == "cn" ? ".cn" : ""
  other-account-id     = data.aws_caller_identity.current.account_id
  resource_account_ids = length(var.secondary-account-ids) == 0 ? [local.other-account-id] : concat(var.secondary-account-ids, [local.other-account-id])
  resource_strings = [
    for id in local.resource_account_ids :
    "arn:${local.arn_partition}:iam::${id}:role/${local.app_role_name}"
  ]

  identifiers = (var.external-controller-account-id == "" ?
    [
      "arn:${local.arn_partition}:iam::${local.other-account-id}:root",
    ]
    :
    [
      "arn:${local.arn_partition}:iam::${var.external-controller-account-id}:root",
      "arn:${local.arn_partition}:iam::${local.other-account-id}:root"
    ]
  )

  common_tags = merge(
    var.tags, {
      module    = "aviatrix-controller-iam-roles"
      Createdby = "Terraform+Aviatrix"
  })
}


variable "external-controller-account-id" {
  type    = string
  default = ""
}

variable "secondary-account-ids" {
  type    = list(string)
  default = []
}
