data aws_caller_identity current {}

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

locals {
  name_prefix      = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  other-account-id = data.aws_caller_identity.current.account_id
  policy_primary   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:aws:iam::${local.other-account-id}:root"
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
              "arn:aws:iam::${var.external-controller-account-id}:root",
              "arn:aws:iam::${local.other-account-id}:root"
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
