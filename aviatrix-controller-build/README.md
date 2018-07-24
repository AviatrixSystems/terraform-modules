## Aviatrix - Terraform Modules - BYOL Controller

### Description
This Terraform module creates an Aviatrix Controller and related components for a BYOL environment.  The components created include:

* One Aviatrix Controller EC2 Instance (named AviatrixController)
* One Aviatrix Security Group (named AviatrixSecurityGroup)

### Pre-requisites:

* Hashicorp Terraform installed
* An existing VPC
* An existing public subnet in that VPC
* An internet gateway attached to the VPC
* An AWS Key Pair
* Accept the terms and subscribe to the Aviatrix Controller in the AWS Marketplace.  Click [here](https://aws.amazon.com/marketplace/pp?sku=zemc6exdso42eps9ki88l9za)
* Aviatrix [IAM roles](../aviatrix-controller-iam-roles/)

### Usage:

To create an Aviatrix BYOL Controller:

```
module "aviatrixcontroller" {
  source = "github.com/AviatrixSystems/terraform-modules.git/controller"
  region  = "<<insert aws region here, ie.: us-east-1>>"
  vpc = "<<insert VPC here> ie. vpc-xxxxxx>"
  subnet = "<<insert public subnet id ie.: subnet-9x3237xx>>"
  keypair = "<<insert keypair name ie.: keypairname>>"
  ec2role = "<<insert role for aviatrix-role-ec2>> OR if you are using the iam_role simply use this: ${module.aviatrix-controller-iam-roles.aviatrix-role-ec2}"
}
```

### Variables

- **region**

  The AWS region where the provider should connect

- **vpc**

  The VPC ID where the Controller will be installed
  
- **subnet**

  The subnet ID where the Controller instance will reside.  Note this must be a public subnet (i.e., be attached to an IGW)

- **keypair**

  The name of the AWS Key Pair (required when building an AWS EC2 instance)
  
- **ec2role**

  The ARN of the aviatrix-ec2-role IAM role

### Outputs
- **aws-account**

  The AWS account ID where this controller was installed.

- **aviatrix-role-ec2**

  The AWS IAM role ARN created for EC2 instances (gateways)

- **aviatrix-role-app**

  The AWS IAM role ARN created for granting the controller access to the account.

- **controller-private-ip**

  The private IP address of the AWS EC2 instance created for the controller.

- **controller-public-ip**

  The public IP address of the AWS EC2 instance created for the controller.
