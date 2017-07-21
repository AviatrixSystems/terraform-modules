## Aviatrix - Terraform Modules

### Description
These Terraform Modules allows you to create the necessary IAM roles and deployment of an Aviatrix Controller. If you execute this terraform modules, it will create the following:

* One Aviatrix Controller EC2 Instance (named AviatrixController).
* One Aviatrix Security Group (named AviatrixSecurityGroup).
* One Aviatrix Role for EC2 (named aviatrix-role-ec2) with corresponding role policy (named aviatrix-assume-role-policy). [Click here for this policy details](https://s3-us-west-2.amazonaws.com/aviatrix-download/iam_assume_role_policy.txt)
* One Aviatrix Role for Apps (named aviatrix-role-app) with corresponding role policy (named aviatrix-app-policy) [Click here for this policy details](https://s3-us-west-2.amazonaws.com/aviatrix-download/IAM_access_policy_for_CloudN.txt)

### Pre-requisites:

* Hashicorp Terraform installed
* An existing VPC.
* A public subnet on that VPC.
* An internet gateway attached to the VPC.
* KeyPair.
* In order to use the Aviatrix Controller first you need to accept the terms and subscribe to it in the AWS Marketplace.  Click [here](https://aws.amazon.com/marketplace/pp?sku=zemc6exdso42eps9ki88l9za)

### Usage:

To create roles necessary for aviatrix access on your AWS account:
```
module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git/iam_roles"
  region  = "<<insert aws region here, ie. us-east-1>>"
}
```

To create an Aviatrix Controller:

```
module "aviatrixcontroller" {
  source = "github.com/AviatrixSystems/terraform-modules.git/controller"
  region  = "<<insert aws region here, ie.: us-east-1>>"
  subnet = "<<insert public subnet id ie.: subnet-9x3237xx>>"
  keypair = "<<insert keypair name ie.: keypairname>>"
  ec2role = "<<insert role for aviatrix-role-ec2>> OR if you are using the iam_role simply use this: ${module.iam_roles.aviatrix-role-ec2}"
}
```

### Outputs
- aws-account
- aviatrix-role-ec2
- aviatrix-role-app
- controller-private-ip
- controller-public-ip
