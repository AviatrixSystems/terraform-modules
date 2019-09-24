## Aviatrix - Terraform Modules - Aviatrix Access Accounts Setup

### Description

This Terraform module creates Aviatrix access accounts for multiple cloud providers.

### Prerequisites

Aviatrix Controller

### Usage
To create Aviatrix access accounts for GCP, ARM, and AWS
```
module "aviatrix-access-accounts" {
  source                = "./modules/testbed-aviatrix-accounts"
  aws_acc_number	= "<<insert aws acc number>>"
  aws_acc_access_key	= "<<insert access key>>"
  aws_acc_secret_key	= "<<insert secret key>>"
  arm_subscription_id	= "<<insert subscription id>>"
  arm_directory_id	= "<<insert directory id>>"
  arm_application_id	= "<<insert application id>>"
  arm_application_key	= "<<insert application key>"
  gcp_id		= "<<insert gcp id>>"
  gcp_credentials_filepath = "<<insert gcp credentials filepath>>"
}
```

### Variables

- **aws_acc_number**

AWS Account number.

- **aws_acc_access_key**

AWS access key.

- **aws_acc_secret_key**

AWS secret key.

- **arm_subscription_id**

ARM subscription id

- **arm_directory_id**

ARM directory id.

- **arm_application_id**

ARM application id.

- **arm_application_key**

ARM application key.

- **gcp_id**

GCP id.

- **gcp_credentials_filepath**

GCP Credentials filepath in local machine.
