resource "aws_eip" "controller_eip" {
  count = "${var.num_controllers}"
  vpc   = true
}

resource "aws_eip_association" "eip_assoc" {
  count         = "${var.num_controllers}"
  instance_id   = "${element(aws_instance.aviatrixcontroller.*.id, count.index)}"
  allocation_id = "${element(aws_eip.controller_eip.*.id, count.index)}"
}

resource "aws_network_interface" "eni-controller" {
  count     = "${var.num_controllers}"
  subnet_id = "${var.subnet}"

  security_groups = ["${aws_security_group.AviatrixSecurityGroup.id}"]

  tags {
    Name      = "${format("%s%s : %d", local.name_prefix, "Aviatrix Controller interface", count.index)}"
    Createdby = "Terraform+Aviatrix"
  }
}

resource "aws_iam_instance_profile" "aviatrix-role-ec2_profile" {
  name = "${local.name_prefix}aviatrix-role-ec2_profile"
  role = "${var.ec2role}"
}

resource "aws_instance" "aviatrixcontroller" {
  count                = "${var.num_controllers}"
  ami                  = "${lookup(var.images, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.aviatrix-role-ec2_profile.id}"

  network_interface {
    network_interface_id = "${element(aws_network_interface.eni-controller.*.id, count.index)}"
    device_index         = 0
  }

  root_block_device {
    volume_size = "${var.root_volume_size}"
    volume_type = "${var.root_volume_type}"
  }

  tags {
    Name      = "${format("%s%s : %d", local.name_prefix, "AviatrixController", count.index)}"
    Createdby = "Terraform+Aviatrix"
  }
}
