locals {
  name_prefix = ""
}

# Roles

resource "aws_iam_role" "aviatrix-role-ec2" {
  name = "${local.name_prefix}aviatrix-role-ec2"
  description = "Aviatrix EC2 - Created by Terraform+Aviatrix"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
           "Service": [
              "ec2.amazonaws.com"
           ]
         },
         "Action": [
           "sts:AssumeRole"
         ]
       }
    ]
}
EOF
}

resource "aws_iam_role" "aviatrix-role-app" {
  name = "${local.name_prefix}aviatrix-role-app"
  description = "Aviatrix APP - Created by Terraform+Aviatrix"
  path = "/"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
         {
              "Effect": "Allow",
              "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.master-account-id}:root",
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
}

data "template_file" "iam_policy_assume_role" {
  template = "${file("./data/iam_policy_assume_role.tpl")}"
}

resource "aws_iam_policy" "aviatrix-assume-role-policy" {
  name        = "${local.name_prefix}aviatrix-assume-role-policy"
  path        = "/"
  description = "Policy for creating aviatrix-assume-role-policy"
  policy = "${data.template_file.iam_policy_assume_role.rendered}"
}

data "template_file" "iam_policy_ec2_role" {
  template = "${file("./data/iam_policy_ec2_role.tpl")}"
}

resource "aws_iam_policy" "aviatrix-app-policy" {
  name        = "${local.name_prefix}aviatrix-app-policy"
  path        = "/"
  description = "Policy for creating aviatrix-app-policy"
  policy = "${data.template_file.iam_policy_ec2_role.rendered}"
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-ec2-attach" {
    role       = "${aws_iam_role.aviatrix-role-ec2.name}"
    policy_arn = "${aws_iam_policy.aviatrix-assume-role-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-app-attach" {
    role       = "${aws_iam_role.aviatrix-role-app.name}"
    policy_arn = "${aws_iam_policy.aviatrix-app-policy.arn}"
}

resource "aws_iam_instance_profile" "aviatrix-role-ec2_profile" {
    name = "${aws_iam_role.aviatrix-role-ec2.name}"
    role = "${aws_iam_role.aviatrix-role-ec2.name}"
}
