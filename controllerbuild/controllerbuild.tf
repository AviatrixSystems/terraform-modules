module "aviatrixcontroller" {
    source      = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-build"
    vpc         = "vpc-727c5215"
    subnet      = "subnet-214f5646"
    keypair     = "mypairuswest1"
    ec2role     = "aviatrix-role-ec2"
    type        = "byol"
#    name_prefix = ""
}

output "controller_private_ip" {
    value="${module.aviatrixcontroller.private_ip}"
}

output "controller_public_ip" {
    value="${module.aviatrixcontroller.public_ip}"
}
