## Aviatrix - Terraform Modules - IAM Roles

### Description
This Terraform module creates the Aviatrix IAM roles required to connect your Aviatrix Controller to an existing AWS account.  This should be run in the account where you are installing the Controller and any additional accounts that will be connected to the Controller.

For additional details on these roles see the [documentation](https://docs.aviatrix.com/HowTos/HowTo_IAM_role.html).

### Usage

To create roles necessary for Aviatrix access on your AWS account:
```
module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git/iam_roles"
  master-account-id = "<<insert aws account ID here>>"
  other-account-id = "<<insert aws account ID here>>"
}
```

### Variables
  
- **master-account-id**

  The AWS account ID where the Aviatrix Controller is (or will be) installed

- **other-account-id**

  The AWS account ID of the account being linked.  If this is the first installation, provide the same ID here as the `master-account-id`

### Outputs

- **aws-account**

  The current AWS account ID
  
- **aviatrix-role-ec2-name**

  The ARN of the newly created IAM role aviatrix-role-ec2
  
- **aviatrix-role-app-name**

  The ARN of the newly created IAM role aviatrix-role-app
