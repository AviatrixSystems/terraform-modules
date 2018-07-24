## Aviatrix - Terraform Modules - IAM Roles

### Description
This Terraform module creates an Aviatrix Controller and related components for a BYOL environment.  The components created include:

* One Aviatrix Role for EC2 (named aviatrix-role-ec2) with corresponding role policy (named aviatrix-assume-role-policy)
* One Aviatrix Role for Apps (named aviatrix-role-app) with corresponding role policy (named aviatrix-app-policy)

For additional details on these roles see the [documentation](https://docs.aviatrix.com/HowTos/HowTo_IAM_role.html).

### Usage

To create roles necessary for aviatrix access on your AWS account:
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
