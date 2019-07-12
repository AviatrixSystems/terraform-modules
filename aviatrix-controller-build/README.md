## Aviatrix - Terraform Modules - Build Aviatrix Controller

### Description
This Terraform module creates an Aviatrix Controller and related components in an existing AWS environment. The
components created include:

* One Aviatrix Controller EC2 Instance (named AviatrixController)
* One AWS Security Group (named AviatrixSecurityGroup)

### Pre-requisites:

* An existing VPC
* An existing public subnet in that VPC
* An internet gateway attached to the VPC
* An AWS Key Pair
* Accept the terms and subscribe to the Aviatrix Controller in the AWS Marketplace.
Click [here](https://aws.amazon.com/marketplace/pp?sku=zemc6exdso42eps9ki88l9za)
* Aviatrix [IAM roles](../aviatrix-controller-iam-roles/)

### Usage:

To create an Aviatrix Controller:

```
module "aviatrixcontroller" {
  source  = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-build?ref=terraform_0.12"
  vpc     = "<<insert VPC here> ie. vpc-xxxxxx>"
  subnet  = "<<insert public subnet id ie.: subnet-9x3237xx>>"
  keypair = "<<insert keypair name ie.: keypairname>>"
  ec2role = "<<insert role for aviatrix-role-ec2>> OR if you are using the iam_role simply use this: ${module.aviatrix-iam-roles.aviatrix-role-ec2-name}"
}
```

### Variables

- **vpc**

  The VPC ID where the Controller will be installed.
  
- **subnet**

  The subnet ID where the Controller instance will reside.  Note this must be a public subnet (i.e., be attached to an IGW).

- **keypair**

  The name of the AWS Key Pair (required when building an AWS EC2 instance).
  
- **ec2role**

  The name of the aviatrix-ec2-role IAM role.

- **root_volume_size**
  
  The size of the hard disk for the controller instance, default value is 20, as suggested by Aviatrix.

- **root_volume_type**
  
  The type of the hard disk for the controller instance, Default value is "standard".

- **incoming_ssl_cidr**
  
  The CIDR to be allowed for HTTPS(port 443) access to the controller. Type is "list", and default value is ["0.0.0.0/0"].

- **instance_type**

  The instance size for the Aviatrix controller instance. Default value is "t2.large".

- **name_prefix**

  A prefix to be added the Aviatrix controller instance name. Default value is "".

- **type**

  The license type for the Aviatrix controller. Default value is "metered". Valid values are "metered", "BYOL".

- **termination_protection**

  Whether termination protection is enabled for the controller. Default value is true. Valid values are true/false.

### Outputs
- **aws-account**

  The AWS account ID where this controller was installed.

- **aviatrix-role-ec2**

  The AWS IAM role ARN created for EC2 instances (gateways).

- **aviatrix-role-app**

  The AWS IAM role ARN created for granting the controller access to the account.

- **private_ip**

  The private IP address of the AWS EC2 instance created for the controller.

- **public_ip**

  The public IP address of the AWS EC2 instance created for the controller.
