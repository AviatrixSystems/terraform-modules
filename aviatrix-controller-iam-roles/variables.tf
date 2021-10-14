data aws_caller_identity current {}

data aws_region current {}

variable tags {
  type        = map(string)
  description = "Map of common tags which should be used for module resources"
  default     = {}
}

variable name_prefix {
  type        = string
  description = "Additional name prefix for your environment resources"
  default     = ""
}

variable ec2_role_name {
  type        = string
  description = "EC2 role name"
  default     = ""
}

variable app_role_name {
  type        = string
  description = "APP role name"
  default     = ""
}

locals {
  name_prefix      = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  ec2_role_name    = var.ec2_role_name != "" ? var.ec2_role_name : "${local.name_prefix}aviatrix-role-ec2"
  app_role_name    = var.app_role_name != "" ? var.app_role_name : "${local.name_prefix}aviatrix-role-app"
  is_aws_cn_1      = element(split("-", data.aws_region.current.name), 0) == "cn" ? "aws-cn" : "aws"
  is_aws_cn_2      = element(split("-", data.aws_region.current.name), 0) == "cn" ? ".cn" : ""
  other-account-id = data.aws_caller_identity.current.account_id
  policy_primary   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:${local.is_aws_cn_1}:iam::${local.other-account-id}:root"
            ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
}
EOF
  policy_cross     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:${local.is_aws_cn_1}:iam::${var.external-controller-account-id}:root",
              "arn:${local.is_aws_cn_1}:iam::${local.other-account-id}:root"
            ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
}
EOF

  common_tags = merge(
    var.tags, {
      module    = "aviatrix-controller-iam-roles"
      Createdby = "Terraform+Aviatrix"
  })
}


variable external-controller-account-id {
  type    = string
  default = ""
}
