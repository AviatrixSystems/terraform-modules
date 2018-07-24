## Aviatrix - Terraform Modules

### Description
These Terraform modules allow you to build Aviatrix Controllers and prepare accounts for connecting to an existing Aviatrix Controller.

### Available Modules

| Module  | Description | Prerequisites |
| ------- | ----------- | ------------- |
| [aviatrix-controller-iam-roles](./aviatrix-controller-iam-roles) | Builds the IAM roles required for Aviatrix to connect with this AWS account | None |
| [aviatrix-controller-build](./aviatrix-controller-build) | Builds the controller in an AWS VPC | <ul><li>Existing VPC,</li><li>Public subnet,</li><li>An AWS Key Pair,</li><li>IAM roles created</li></ul> |
| [aviatrix-controller-initialize](./aviatrix-controller-inititialize) | Initializes the Controller (Upgrade, set admin e-mail, set admin password). | <ul><li>Aviatrix Controller</li></ul> |

### Basic Usage

```
module "<<name>>" {
  source = "github.com/AviatrixSystems/terraform-modules.git/<<module-name>>"
  var1 = "<<value1>>"
}
```

### Building a Controller and Initializing

Because the Aviatrix provider requires the Controller to be up and running before it can operate, the initialization must be separated from building the Controller.  Once Terraform supports a concept of [`depends_on`](https://github.com/hashicorp/terraform/issues/2430) for a provider, these steps can be combined into one.  Until then, you will need to run each step separately:

#### 1. Create the IAM roles and Build the Controller

**build/main.tf**

``` terraform

provider "aws" {
   <<< your credentials and region >>>
}
data "aws_caller_identity" "current" {}

module "iam_roles" {
  source = "github.com/AviatrixSystems/terraform-modules.git/iam_roles"
  master-account-id = "${data.aws_caller_identity.current.account_id}"
  other-account-id = "${data.aws_caller_identity.current.account_id}"
}

module "aviatrix-controller-build" {
    source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-build"
    vpc = "<<< your VPC ID >>>"
    subnet = "<<< your public Subnet ID >>>"
    keypair = "<<< your EC2 key pair name >>>"
    ec2role = "${module.aviatrix-iam-roles.aviatrix-role-ec2-name}"
}

output "controller_private_ip" {
    value="${module.aviatrix-controller-build.private_ip}"
}

output "controller_public_ip" {
    value="${module.aviatrix-controller-build.public_ip}"
}

```

*Execute*

``` shell
> cd build
> terraform init
> terraform apply
> terraform output | sed -ne 's/\(.*\) = \(.*\)/\1="\2"/p' > ../aviatrix_controller.tfvars
> cd ..
```

#### 2. Initialize the Controller

**init/main.tf**

``` terraform
provider "aws" {
   <<< your credentials and region >>>
}
data "aws_caller_identity" "current" {}

variable "controller_private_ip" {
}
variable "controller_public_ip" {
}

/* aviatrix provider */
provider "aviatrix" {
    username = "admin"
    password = "${var.controller_private_ip}"
    #password = "P@ssw0rd!"
    controller_ip = "${var.controller_public_ip}"
}

module "aviatrix-controller-initialize" {
    source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-initialize"

    admin_password = "<<< new admin password >>>"
    admin_email = "<<< administrator email address >>>"
    private_ip = "${var.controller_private_ip}"
    public_ip = "${var.controller_public_ip}"
}

```

*Execute*

``` shell
> cd init
> terraform init
> terraform apply -var-file=../aviatrix_controller.tfvars
```
