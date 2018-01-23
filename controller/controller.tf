resource "aws_eip" "controller_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.aviatrixcontroller.id}"
  allocation_id = "${aws_eip.controller_eip.id}"
}

resource "aws_network_interface" "eni-controller" {
  subnet_id = "${var.subnet}"

  security_groups = [
    "${aws_security_group.AviatrixSecurityGroup.id}",
  ]

  tags {
    Name      = "Aviatrix Controller interface"
    Createdby = "Terraform+Aviatrix"
  }
}

resource "aws_iam_instance_profile" "aviatrix-role-ec2_profile" {
  name = "aviatrix-role-ec2_profile"
  role = "${var.ec2role}"
}

resource "aws_instance" "aviatrixcontroller" {
  ami                  = "${lookup(var.images, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.aviatrix-role-ec2_profile.id}"

  network_interface {
    network_interface_id = "${aws_network_interface.eni-controller.id}"
    device_index         = 0
  }

  root_block_device {
    volume_size = "${var.root_volume_size}"
    volume_type = "${var.root_volume_type}"
  }

  tags {
    Name      = "AviatrixController"
    Createdby = "Terraform+Aviatrix"
  }
}
