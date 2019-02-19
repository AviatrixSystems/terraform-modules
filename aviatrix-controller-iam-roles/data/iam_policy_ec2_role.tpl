{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Get*",
                "ec2:Describe*",
                "ec2:Search*",
                "elasticloadbalancing:Describe*",
                "route53:List*",
                "route53:Get*",
                "sqs:Get*",
                "sqs:List*",
                "sns:List*",
                "s3:List*",
                "s3:Get*",
                "iam:List*",
                "iam:Get*",
                "directconnect:Describe*",
                "guardduty:Get*",
                "guardduty:List*",
                "ram:Get*",
                "ram:List*"
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
                "ec2:ModifyVpcAttribute",
                "ec2:CreateCustomerGateway",
                "ec2:DeleteCustomerGateway",
                "ec2:CreateVpnConnection",
                "ec2:DeleteVpnConnection",
                "ec2:CreateVpcPeeringConnection",
                "ec2:AcceptVpcPeeringConnection",
                "ec2:DeleteVpcPeeringConnection",
                "ec2:ModifyInstanceCreditSpecification",
                "ec2:CreateNetworkAclEntry",
                "ec2:ReplaceNetworkAclEntry",
                "ec2:DeleteNetworkAclEntry",
                "ec2:EnableVgwRoutePropagation",
                "ec2:DisableVgwRoutePropagation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AssociateTransitGatewayRouteTable",
                "ec2:AcceptTransitGatewayVpcAttachment",
                "ec2:CreateTransitGateway",
                "ec2:CreateTransitGatewayRoute",
                "ec2:CreateTransitGatewayRouteTable",
                "ec2:CreateTransitGatewayVpcAttachment",
                "ec2:DeleteTransitGateway",
                "ec2:DeleteTransitGatewayRoute",
                "ec2:DeleteTransitGatewayRouteTable",
                "ec2:DeleteTransitGatewayVpcAttachment",
                "ec2:DisableTransitGatewayRouteTablePropagation",
                "ec2:DisassociateTransitGatewayRouteTable",
                "ec2:EnableTransitGatewayRouteTablePropagation",
                "ec2:EnableRoutePropagation",
                "ec2:ExportTransitGatewayRoutes",
                "ec2:ModifyTransitGatewayVpcAttachment",
                "ec2:RejectTransitGatewayVpcAttachment",
                "ec2:ReplaceTransitGatewayRoute"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:StopInstances",
                "ec2:StartInstances",
                "ec2:CopySnapshot",
                "ec2:CreateSnapshot",
                "ec2:CreateVolume",
                "ec2:DeleteVolume",
                "ec2:DeleteSnapshot",
                "ec2:AttachVolume",
                "ec2:DetachVolume"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ram:CreateResourceShare",
                "ram:DeleteResourceShare",
                "ram:UpdateResourceShare",
                "ram:AssociateResourceShare",
                "ram:DisassociateResourceShare",
                "ram:TagResource",
                "ram:UntagResource",
                "ram:AcceptResourceShareInvitation",
                "ram:EnableSharingWithAwsOrganization"
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
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
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
                "s3:PutObject",
                "s3:DeleteObject"
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
                "iam:PassRole",
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "guardduty:CreateDetector",
                "guardduty:DeleteDetector",
                "guardduty:UpdateDetector"
            ],
            "Resource": "*"
        }
    ]
}