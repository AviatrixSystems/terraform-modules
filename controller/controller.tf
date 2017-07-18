variable "region" {}
variable "subnet" {}
variable "keypair" {}
variable "role" {}
variable "images" {
  type = "map"
  default = {
    us-east-1 = "ami-690c467e"
    us-east-2 = "ami-811248e4"
    us-west-1 = "ami-43206823"
    us-west-2 = "ami-03558e63"
    ca-central-1 = "ami-2dc57749"
    eu-central-1 = "ami-70c43a1f"
    eu-west-1 = "ami-33d69440"
    eu-west-2 = "ami-a1272dc5"
    ap-south-1 = "ami-970672f8"
    ap-northeast-1 = "ami-7308d212"
    ap-northeast-2 = "ami-93d400fd"
    ap-southeast-1 = "ami-f4258297"
    ap-southeast-2 = "ami-921624f1"
    sa-east-1 = "ami-bcf66bd0"
  }
}

#Define the region
provider "aws" {
  region     = "${var.region}"
}

resource "aws_security_group" "AviatrixSecurityGroup" {
  name        = "AviatrixSecurityGroup"
  description = "Aviatrix - Controller Security Group"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "AviatrixSecurityGroup"
  }
}

resource "aws_network_interface" "eni-controller" {
  subnet_id = "${var.subnet}"
  security_groups = [
    "${aws_security_group.AviatrixSecurityGroup.id}"
  ]
  tags {
    Name = "Aviatrix Controller interface"
  }
}

resource "aws_instance" "aviatrixcontroller" {
  ami           = "${lookup(var.images, var.region)}"
  instance_type = "t2.large"
  key_name = "${var.keypair}"
  role = "${var.role}"
  network_interface {
     network_interface_id = "${aws_network_interface.eni-controller.id}"
     device_index = 0
  }
  root_block_device {
        volume_size = 16
  }
  tags {
    Name = "AviatrixController"
  }
}

output "private-ip" {
    value = "${aws_instance.aviatrixcontroller.private_ip}"
}

output "public-ip" {
    value = "${aws_instance.aviatrixcontroller.public_ip}"
}
