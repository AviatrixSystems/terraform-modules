variable "region" {}

variable "master-account-id" {
  default = "false"
}
data "aws_caller_identity" "current" {}

#Define the region
provider "aws" {
  region     = "${var.region}"
}

# Roles

resource "aws_iam_role" "aviatrix-role-ec2" {
  name = "aviatrix-role-ec2"
  description = "Aviatrix EC2 - Created by Terraform+Aviatrix"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal":
      {
        "Service": [ "ec2.amazonaws.com" ]
      },
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "aviatrix-role-app" {
  name = "aviatrix-role-app"
  description = "Aviatrix APP - Created by Terraform+Aviatrix"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal":
      {
          "AWS": ${replace("[\"arn:aws:iam::${data.aws_caller_identity.current.account_id}:root\",\"arn:aws:iam::${var.master-account-id}:root\"]","/,\"arn:aws:iam::false:root\"/","")}
      },
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aviatrix-assume-role-policy" {
  name        = "aviatrix-assume-role-policy"
  path        = "/"
  description = "Policy for creating aviatrix-assume-role-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Action":
      [
        "iam:UpdateAssumeRolePolicy",
        "sts:AssumeRole"
      ],
      "Resource": "arn:aws:iam::*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aviatrix-app-policy" {
  name        = "aviatrix-app-policy"
  path        = "/"
  description = "Policy for creating aviatrix-app-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ec2:Describe*",
              "elasticloadbalancing:Describe*",
              "route53:List*",
              "route53:Get*",
              "sqs:Get*",
              "sqs:List*",
              "sns:List*",
              "s3:List*",
              "s3:Get*",
              "iam:List*",
              "iam:Get*"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "ec2:RunInstances"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "ec2:RunInstances",
          "Resource": "arn:aws:ec2:*:*:image/ami-*"
      },
      {
          "Effect": "Allow",
          "Action": "ec2:RunInstances",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "ec2:DeleteSecurityGroup",
              "ec2:RevokeSecurityGroupEgress",
              "ec2:RevokeSecurityGroupIngress",
              "ec2:AuthorizeSecurityGroup*",
              "ec2:CreateSecurityGroup",
              "ec2:AssociateRouteTable",
              "ec2:CreateRoute",
              "ec2:CreateRouteTable",
              "ec2:DeleteRoute",
              "ec2:DeleteRouteTable",
              "ec2:DisassociateRouteTable",
              "ec2:ReplaceRoute",
              "ec2:ReplaceRouteTableAssociation"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "ec2:AllocateAddress",
              "ec2:AssociateAddress",
              "ec2:DisassociateAddress",
              "ec2:ReleaseAddress",
              "ec2:AssignPrivateIpAddresses",
              "ec2:AttachNetworkInterface",
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DetachNetworkInterface",
              "ec2:ModifyNetworkInterfaceAttribute",
              "ec2:ResetNetworkInterfaceAttribute",
              "ec2:UnassignPrivateIpAddresses",
              "ec2:ModifyInstanceAttribute",
              "ec2:MonitorInstances",
              "ec2:RebootInstances",
              "ec2:ReportInstanceStatus",
              "ec2:ResetInstanceAttribute",
              "ec2:StartInstances",
              "ec2:StopInstances",
              "ec2:TerminateInstances",
              "ec2:UnmonitorInstances",
              "ec2:AttachInternetGateway",
              "ec2:CreateInternetGateway",
              "ec2:DeleteInternetGateway",
              "ec2:DetachInternetGateway",
              "ec2:CreateKeyPair",
              "ec2:DeleteKeyPair",
              "ec2:CreateSubnet",
              "ec2:DeleteSubnet",
              "ec2:ModifySubnetAttribute",
              "ec2:CreateTags",
              "ec2:DeleteTags",
              "ec2:CreateVpc",
              "ec2:DeleteVpc",
              "ec2:ModifyVpcAttribute"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
              "elasticloadbalancing:AttachLoadBalancerToSubnets",
              "elasticloadbalancing:ConfigureHealthCheck",
              "elasticloadbalancing:CreateLoadBalancer*",
              "elasticloadbalancing:DeleteLoadBalancer*",
              "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
              "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "route53:ChangeResourceRecordSets",
              "route53:CreateHostedZone",
              "route53:DeleteHostedZone"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:CreateBucket",
              "s3:DeleteBucket",
              "s3:PutObject"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "cloudwatch:DeleteAlarms",
              "cloudwatch:PutMetricAlarm"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "sns:CreateTopic",
              "sns:DeleteTopic",
              "sns:Subscribe",
              "sns:Unsubscribe"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "sqs:AddPermission",
              "sqs:ChangeMessageVisibility",
              "sqs:CreateQueue",
              "sqs:DeleteMessage",
              "sqs:DeleteQueue",
              "sqs:PurgeQueue",
              "sqs:ReceiveMessage",
              "sqs:RemovePermission",
              "sqs:SendMessage",
              "sqs:SetQueueAttributes",
              "sqs:TagQueue"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "iam:UpdateAssumeRolePolicy",
              "sts:AssumeRole"
          ],
          "Resource": "arn:aws:iam::*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "iam:UpdateAssumeRolePolicy",
              "iam:PassRole",
              "iam:AddRoleToInstanceProfile",
              "iam:CreateInstanceProfile",
              "iam:DeleteInstanceProfile",
              "iam:RemoveRoleFromInstanceProfile"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-ec2-attach" {
    role       = "${aws_iam_role.aviatrix-role-ec2.name}"
    policy_arn = "${aws_iam_policy.aviatrix-assume-role-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-app-attach" {
    role       = "${aws_iam_role.aviatrix-role-app.name}"
    policy_arn = "${aws_iam_policy.aviatrix-app-policy.arn}"
}

output "aws-account" {
    value = "${data.aws_caller_identity.current.account_id}"
}

output "aviatrix-role-ec2" {
    value = "${aws_iam_role.aviatrix-role-ec2.id}"
}

output "aviatrix-role-app" {
    value = "${aws_iam_role.aviatrix-role-app.id}"
}
