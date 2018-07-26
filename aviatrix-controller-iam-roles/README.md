## Aviatrix - Terraform Modules - IAM Roles

### Description
This Terraform module creates the Aviatrix IAM roles required to connect your Aviatrix Controller to an existing AWS account.  This should be run in the account where you are installing the Controller and any additional accounts that will be connected to the Controller.

When running this for the initial installation of the Controller, the `master-account-id` should be set to the current AWS account ID.  For additional accounts, the `master-account-id` should be the AWS account ID where the controller is installed.'

For additional details on these roles see the [documentation](https://docs.aviatrix.com/HowTos/HowTo_IAM_role.html).

### Usage

To create roles necessary for Aviatrix access on your AWS account:
```
module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-iam-roles"
  master-account-id = "<<insert aws account ID here>>"
}
```

### Variables
  
- **master-account-id**

  The AWS account ID where the Aviatrix Controller is (or will be) installed

### Outputs

- **aws-account**

  The current AWS account ID
  
- **aviatrix-role-ec2-name**

  The ARN of the newly created IAM role aviatrix-role-ec2
  
- **aviatrix-role-app-name**

  The ARN of the newly created IAM role aviatrix-role-app
