windows## Regression Testbed Terraform

### Description

This Terraform configuration creates an AWS VPC testbed environment with ubuntu instances, builds and initializes an Aviatrix controller, sets up Aviatrix access accounts, and launches a Windows instance ready for RDP. SSH and ICMP are opened to 0.0.0.0/0 for the AWS VPCs. SSH and HTTPS opened to a specified IP for the Aviatrix Controller. RDP is opened to a specified IP for the Windows instance.

### Prerequisites

- Have Aviatrix IAM roles
- Existing AWS Key Pair
- AMI with private key already within ubuntu instances

### Set up Environment and Install terraform
- To download and install Terraform, follow the Step 1 of the [Terraform tutorial on the Aviatrix documentation page](https://docs.aviatrix.com/HowTos/tf_aviatrix_howto.html).

### Usage

1. Create testbed.tf and testbed_outputs.tf

```
## testbed.tf
module "regression-testbed" {
  source = "<<main module path>> ie: ./regression-testbed"
  termination_protection      = <<true/false>>
  resource_name_label         = ""<<input label for all resources>>"

  # Provider
  aws_primary_acct_access_key = "<<your aws primary access key>>"
  aws_primary_acct_secret_key = "<<your aws primary secret key>>"

  # AWS VPC setup
  vpc_public_key              = "<<your public key to access ubuntu instances>>"
  pub_hostnum                 = <<input instance private ip hostnum>>
  pri_hostnum                 = <<input instance private ip hostnum>>

  # US West 1
  vpc_count_west1             = <<input number of vpcs>>
  vpc_cidr_west1              = [<<insert cidrs>>]
  pub_subnet1_cidr_west1      = [<<insert cidrs>>]
  pub_subnet2_cidr_west1      = [<<insert cidrs>>]
  pri_subnet_cidr_west1       = [<<insert cidrs>>]
  pri_subnet_cidr_west1       = [<<insert cidrs>>]
  ubuntu_ami_west1            = "<<insert ami>>"

  # US West 2
  vpc_count_west2             = <<input number of vpcs>>
  vpc_cidr_west2              = [<<insert cidrs>>]
  pub_subnet1_cidr_west2      = [<<insert cidrs>>]
  pub_subnet2_cidr_west2      = [<<insert cidrs>>]
  pri_subnet_cidr_west2       = [<<insert cidrs>>]
  ubuntu_ami_west2            = "<<insert ami>>"

  # US East 1
  vpc_count_east1             = <<input number of vpcs>>
  vpc_cidr_east1              = [<<insert cidrs>>]
  pub_subnet1_cidr_east1      = [<<insert cidrs>>]
  pub_subnet2_cidr_east1      = [<<insert cidrs>>]
  pri_subnet_cidr_east1       = [<<insert cidrs>>]
  ubuntu_ami_east1            = "<<insert ami>>"

  # US East 2
  vpc_count_east2             = <<input number of vpcs>>
  vpc_cidr_east2              = [<<insert cidrs>>]
  pub_subnet1_cidr_east2      = [<<insert cidrs>>]
  pub_subnet2_cidr_east2      = [<<insert cidrs>>]
  pri_subnet_cidr_east2       = [<<insert cidrs>>]
  ubuntu_ami_east2            = "<<insert ami>>"

  # AWS VPC for controller
  controller_region           = "<<insert region to launch controller>>"
  controller_vpc_cidr         = "<<insert vpc cidr for controller>>"
  controller_subnet_cidr      = "<<insert subnet cidr for controller>>"
  controller_public_key       = "<<insert your public key to access controller>>""
  controller_sg_source_ip     = "<<insert controller source ip>>"

  # Aviatrix controller
  admin_email                 = "<<insert your email>>"
  admin_password              = "<<insert password to access controller>>"
  access_account              = "<<insert name for access account>>"
  customer_id                 = "<<insert your license id>>"

  # Windows instance
  windows_region              = "<<insert region to launch windows instance>>"
  windows_vpc_cidr            = "<<insert vpc cidr for windows instance>>"
  windows_subnet_cidr         = "<<insert subnet cidr for windows instance>>"
  windows_public_key          = "<<insert public key to access windows instance>>
  windows_ami                 = "<<insert windows ami>>"
  windows_sg_source_ip        = "<<insert windows instance source ip>>"
}
```

```
## testbed_outputs.tf

# AWS VPCs
output "us-west-1" {
  value = [module.regression-testbed.west1_vpc_info, module.regression-testbed.west1_subnet_info, module.regression-testbed.west1_ubuntu_info]
}
output "us-west-2" {
  value = [module.regression-testbed.west2_vpc_info, module.regression-testbed.west2_subnet_info, module.regression-testbed.west2_ubuntu_info]
}
output "us-east-1" {
  value = [module.regression-testbed.east1_vpc_info, module.regression-testbed.east1_subnet_info, module.regression-testbed.east1_ubuntu_info]
}
output "us-east-2" {
  value = [module.regression-testbed.east2_vpc_info, module.regression-testbed.east2_subnet_info, module.regression-testbed.east2_ubuntu_info]
}

# Aviatrix controller
output "controller_public_ip" {
 value = module.regression-testbed.controller_public_ip
}
output "controller_key" {
 value = module.regression-testbed.controller_key
}
output "controller_username_password" {
 value = module.regression-testbed.controller_username_password
}

# Windows instance
output "windows_public_ip" {
 value = module.regression-testbed.windows_public_ip
}
output "windows_key" {
  value = module.regression-testbed.windows_key
}
```

2. ```terraform init``` to initialize the workspace with .tf files

3. Initial ```terraform apply```

4. Add aviatrix provider and module for aviatrix-access-accounts after successful 1st apply.
  - optionally, just have it commented out before the initial terraform apply, then uncomment it after.

```
module "regression-testbed" {
  ...
}

provider "aviatrix" {
  controller_public_ip  = module.regression-testbed.controller_public_ip
  username              = element(module.regression-testbed.controller_username_password, 0)
  admin_password        = element(module.regression-testbed.controller_username_password, 1)
}

module "aviatrix-access-accounts" {
  # this module is within the regression-terraform modules folder
  source                = "./regression-terraform/modules/testbed-aviatrix-accounts"
  aws_acc_number        = "<<input aws acc number>>"
  aws_acc_access_key    = "<<input aws access key>>"
  aws_acc_secret_key    = "<<input aws secret key>>"
  arm_subscription_id   = "<<input arm subscription id>>"
  arm_directory_id      = "<<input arm directory id>>"
  arm_application_id    = "<<input application id>>"
  arm_application_key   = "<<input application key>>"
  gcp_credentials_filepath = "<<input gcp cred filepath>>"
}
```

5. ```terraform init```

6. Second ```terraform apply``` after successful 1st apply.

7. To output into file, ```terraform output > <<FILENAME>>```.
  - By default, all output from a terraform root module will be displayed on the CLI.

### Output format

```
<<region>> = [
  [
    #vpc info
    [
      <<vpc name>>
    ],
    [
      <<vpc id>>
    ],
  ],
  [
    #subnet info
    [
      <<subnet name>>
    ],
    [
      <<subnet cidr>>
    ],
  ],
  [
    #ubuntu instance info
    [
      <<ubuntu instance name>>
    ],
    [
      <<instance id>>
    ],
    [
      <<public ip>>
    ],
    [
      <<private ip>>
    ],
  ],
]
```

### Variables
- **aws_primary_acct_access_key**

AWS primary account's access key.

- **aws_primary_acct_secret_key**

AWS primary account's secret key.

- **termination_protection**

Whether to enable termination protection for ec2 instances.

- **resource_name_label**

The label for the resource name.

- **vpc_public_key**

Public key used for creating key pair for all instances.

- **pub_hostnum**

Number to be used for public ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer.

- **pri_hostnum**

Number to be used for private ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer.

- **vpc_count_west1**
- **vpc_count_west2**
- **vpc_count_east1**
- **vpc_count_east2**

The number of vpcs to create in the given AWS region.

- **vpc_cidr_west1**
- **vpc_cidr_west2**
- **vpc_cidr_east1**
- **vpc_cidr_east2**

The cidr of a vpc for a given region. List of strings.

- **pub_subnet1_cidr_west1**
- **pub_subnet1_cidr_west2**
- **pub_subnet1_cidr_east1**
- **pub_subnet1_cidr_east2**

The cidr for public subnet 1 of a given region. List of strings.

- **pub_subnet2_cidr_west1**
- **pub_subnet2_cidr_west2**
- **pub_subnet2_cidr_east1**
- **pub_subnet2_cidr_east2**

The cidr for public subnet 2 of a given region. List of strings.

- **pri_subnet_cidr_west1**
- **pri_subnet_cidr_west2**
- **pri_subnet_cidr_east1**
- **pri_subnet_cidr_east2**

The cidr for a private subnet of a given region. List of strings.

- **ubuntu_ami_west1**
- **ubuntu_ami_west2**
- **ubuntu_ami_east1**
- **ubuntu_ami_east2**

AMI of the ubuntu instances.

- **controller_vpc_cidr**

AWS VPC cidr being created for Aviatrix controller.

- **controller_subnet_cidr**

Public subnet cidr of the vpc being created for the Aviatrix controller.

- **controller_public_key**

Public key to create a new key pair for the controller.

- **controller_sg_source_ip**

Source IP that AWS security group will allow for controller.

- **admin_email**

Admin email to be used for the Aviatrix controller.

- **admin_password**

Admin password to be used for logging into te Aviatrix controller.

- **access_account**

Account name for this AWS access account to be used for the Aviatrix controller.

- **customer_id**

Customer license ID for the Aviatrix controller, if using BYOL controller.

- **windows_vpc_cidr**

AWS VPC cidr being created for windows instance.

- **windows_subnet_cidr**

Public subnet cidr of the vpc being created for windows instance.

- **windows_public_key**

Public key to create a new key pair for the windows instance.

- **windows_sg_source_ip**

Source IP that Windows instance security group will allow.

- **windows_ami**

AMI for the Windows instance to be created.

### Outputs
- **us-west-1_vpc_id**
- **us-west-2_vpc_id**
- **us-east-1_vpc_id**
- **us-east-2_vpc_id**

Outputs the ID for all vpc's in the given regions.

- **us-west-1_vpc_name**
- **us-west-2_vpc_name**
- **us-east-1_vpc_name**
- **us-east-2_vpc_name**

Outputs the name for all vpc's in the given regions.

- **us-west-1_subnet_name**
- **us-west-2_subnet_name**
- **us-east-1_subnet_name**
- **us-east-2_subnet_name**

Outputs the name for all subnets in the given regions.

- **us-west-1_subnet_cidr**
- **us-west-2_subnet_cidr**
- **us-east-1_subnet_cidr**
- **us-east-2_subnet_cidr**

Outputs the cidr for all subnets in the given regions.

- **us-west-1_ubuntu_public_ip**
- **us-west-2_ubuntu_public_ip**
- **us-east-1_ubuntu_public_ip**
- **us-east-2_ubuntu_public_ip**

Outputs the public IP of the public ubuntu instances in the given regions.

- **us-west-1_ubuntu_private_ip**
- **us-west-2_ubuntu_private_ip**
- **us-east-1_ubuntu_private_ip**
- **us-east-2_ubuntu_private_ip**

Outputs the private IP of the ubuntu instances in the given regions.

- **us-west-1_ubuntu_id**
- **us-west-2_ubuntu_id**
- **us-east-1_ubuntu_id**
- **us-east-2_ubuntu_id**

Outputs the instance ID of the ubuntus in the given regions.

- **controller_public_ip**

Outputs the Aviatrix controller's public IP.

- **controller_key**

Outputs the Aviatrix controller's key pair name.

- **controller_username_password**

Outputs the login information for the Aviatrix controller.

- **windows_public_ip**

Outputs the public IP of the Windows instance.

- **windows_key**

Outputs the Windows instance key pair name.

### Notes

#### SSH into private ubuntu instance
- Need to ssh into public instances first, then from public instance, ssh into private ubuntu instances.
- Terraform doesn't add the private key used for ssh into the public instances.
  - Prepare an ubuntu instance that already contains the private key. Create a snapshot (ami) of the VM to be used when Terraform creates the testbed.
  - copy AMI to the other Regions and use AMI for the ubuntu_ami variable

#### Setting up Aviatrix access accounts
For GCP access account, you will need to provide an absolute filepath to the gcp credentials file stored on your local machine.

#### Accessing Aviatrix controller
- Login to controller using:
  - username: "admin"
  - password: admin_password

#### Destroying Environment
1. Change ```termination_protection``` to be false.
  - Terraform won't automatically remove termination protection.

2. ```terraform destroy -target module.aviatrix-access-accounts```, to destroy the aviatrix access accounts first.
  - Not destroying the access accounts first will end up with a dependency error. Currently Terraform doesn't support module to module dependency.

3. Comment out
```
provider "aviatrix" {
  ...
}
module "aviatrix-access-accounts" {
  ...
}
```

4. ```terraform destroy```, to destroy the rest of the resources.
