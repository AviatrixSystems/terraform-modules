## Regression Testbed Terraform

### Description

This folder contains instructions and modules to create a Regression Testbed using Terraform. It makes use of the testbed-basic module and other individual testbed terraform modules.

### Prerequisites

- Have Aviatrix IAM roles

### Set up Environment and Install terraform
- To download and install Terraform, follow the Step 1 of the [Terraform tutorial on the Aviatrix documentation page](https://docs.aviatrix.com/HowTos/tf_aviatrix_howto.html).

### Usage
Look into the "examples" folder for example .tf files

There are 3 Phases:
1. Regression Baseline create
 - AWS VPC's in each US region.
 - Aviatrix Controller (optional)
 - Windows instance (optionl)
 - Read the testbed-basic README.md for more information
 - **initial terraform apply**

2. Add Cross AWS/Azure RM vpcs.
 - **optional, uncomment  cross aws/arm modules and outputs to use**

3. Aviatrix tests
 - Add Aviatrix access accounts to Aviatrix controller
 - Aviatrix onprem simulation
 - **uncomment Aviatrix modules and outputs**
 - **terraform init**
 - **2nd terraform apply**


### Notes

#### SSH into private ubuntu instance
- Need to ssh into public instances first, then from public instance, ssh into private ubuntu instances.

- Terraform doesn't add the private key used for ssh into the public instances.
  - Prepare an ubuntu instance that already contains the private key. Create a snapshot (ami) of the VM to be used when Terraform creates the testbed.
  - copy AMI to the other Regions and use AMI for the ubuntu_ami variable

- Utilize ssh-agent forwarding. No need to store private key on ubuntu instances.
 1. Enable ssh-agent
 ```
 $ eval "$(ssh-agent -s)"
 ```
 2. Add the SSH key to the ssh-agent. Example uses id_rsa, feel free to specify filepath to whichever ssh key you want.
 ```
 $ ssh-add ~/.ssh/id_rsa
 ```
 3. SSH into public ubuntu instance. Don't forget to set -A flag to enable agent forwarding. Set -i flag is using an ssh key different from default.
 ```
 ssh -A ubuntu@<<pub_ubuntu_eip>>
 ```
 4. SSH into private ubuntu instance.
 ```
 ssh ubuntu@<<pri_ubuntu_private_ip>>
 ```

#### Setting up Aviatrix access accounts
For GCP access account, you will need to provide an absolute filepath to the gcp credentials file stored on your local machine.

#### Accessing Aviatrix controller
- Login to controller using:
  - username: "admin"
  - password: admin_password

#### Destroying Environment
1. Change `termination_protection` to be false.
  - Terraform won't automatically remove termination protection.

2. Destroy Aviatrix modules and resources first.
  - Not destroying the access accounts first will end up with a dependency error. Currently Terraform doesn't support module to module dependency.
  - `terraform destroy -target <<module name>>`, to destroy targeted Aviatrix modules.

3. Comment out after successfully destroying Aviatrix modules and resources
```
provider "aviatrix" {
  ...
}
module "testbed-aviatrix-accounts" {
  ...
}
module "testbed-onprem"
```

4. `terraform destroy`, to destroy the rest of the resources.
