## Aviatrix - Terraform Modules - IAM Roles

### Description
This Terraform module creates AWS IAM credentials (IAM roles, policies, etc...), which are used to grant AWS API
permissions for Aviatrix controller in order to allow the controller to access resources in AWS account(s). This
Terraform module should be run in the AWS account where you are installing the Controller and any additional AWS 
accounts that will be connected to the Controller.

If this module is applied for setting up IAM credentials on the AWS account where your controller is (going to be)
located, the Terraform variable, "external-controller-account-id" should NOT be set.

If this module is applied for AWS account(s), which will be managed by the controller, please configure the Terraform
variable, "external-controller-account-id" and set the value to be the AWS account ID of the controller.

Please refer to the documentation below for more detail:
[documentation](https://docs.aviatrix.com/HowTos/HowTo_IAM_role.html).

### Usage

To create roles necessary for Aviatrix access on your AWS account:
```
module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-iam-roles?ref=terraform_0.12"
}

# cross account 
module "iam_roles" {
  source                         = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-iam-roles?ref=terraform_0.12"
  external-controller-account-id = "<<< insert AWS account ID of the controller here >>>"
}
```

### Variables
  
- **external-controller-account-id** <Optional>

  The AWS account ID where the Aviatrix Controller was/will be launched. This is only required if you are creating roles
  for the secondary account different from the account where controller was/will be launched. DO NOT use this parameter
  if this Terraform module is applied on the AWS account of your controller.

- **name_prefix**

  A prefix to be added to the Aviatrix controller instance name. Default value is "".

- **tags** 

  Additional map of tags passed to mark resources create by module. Default value is {}.

### Outputs

- **aws-account**

  The current AWS account ID.
  
- **aviatrix-role-ec2-name**

  The ARN of the newly created IAM role aviatrix-role-ec2.
  
- **aviatrix-role-app-name**

  The ARN of the newly created IAM role aviatrix-role-app.
