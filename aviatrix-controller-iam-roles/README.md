## Aviatrix - Terraform Modules - IAM Roles

### Description
This Terraform module creates the Aviatrix IAM roles required to connect your Aviatrix Controller to an existing AWS
account.  This should be run in the account where you are installing the Controller and any additional accounts that
will be connected to the Controller.

When running this for the initial installation of the Controller, the `external-controller-account-id` should NOT be
set.  For additional accounts, the `external-controller-account-id` should be the AWS account ID where the controller
is installed.

For additional details on these roles see the [documentation](https://docs.aviatrix.com/HowTos/HowTo_IAM_role.html).

### Usage

To create roles necessary for Aviatrix access on your AWS account:
```
module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-iam-roles"
}

# cross account 
module "iam_roles" {
  source                         = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-iam-roles?ref=terraform_0.12"
  external-controller-account-id = "<<insert controller aws account ID here>>"
}
```

### Variables
  
- **external-controller-account-id** <Optional>

  The AWS account ID where the Aviatrix Controller was launched. This is only required if you are creating roles for 
  secondary account different from the account where controller was launched. DO NOT use this parameter if creating role 
  in account where controller was launched.

### Outputs

- **aws-account**

  The current AWS account ID
  
- **aviatrix-role-ec2-name**

  The ARN of the newly created IAM role aviatrix-role-ec2
  
- **aviatrix-role-app-name**

  The ARN of the newly created IAM role aviatrix-role-app
