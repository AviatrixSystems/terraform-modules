#Terraform configuration file to set up Windows instance

resource "aws_security_group" "windows_sg" {
  name        = "allow_rdp"
  description = "Allow RDP to windows instance"
  vpc_id      = var.vpc
  ingress {
 #RDP
  from_port   = 3389
  to_port     = 3389
  protocol    = "tcp"
  cidr_blocks = [var.sg_source_ip]
  }
  tags  = {
    Name      = "${var.resource_name_label}_windows-security-group"
  }
}

# Launch windows instance
resource "aws_instance" "windows_instance" {
 ami                     = var.windows_ami
 instance_type           = "t2.medium"
 disable_api_termination = var.termination_protection
 subnet_id               = var.subnet
 key_name								= var.keypair 
 vpc_security_group_ids  = [aws_security_group.windows_sg.id]
 tags  = {
   Name      = "${var.resource_name_label}_windows-instance"
 }
}

resource "aws_eip" "windows_eip" {
 instance  = aws_instance.windows_instance.id
 vpc       = true
 tags  = {
   Name      = "${var.resource_name_label}_windows-eip"
 }
}
