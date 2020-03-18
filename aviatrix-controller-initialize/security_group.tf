resource "aws_security_group" "AviatrixSecurityGroup2" {
  name        = "${local.name_prefix}AviatrixSecurityGroup2"
  description = "Aviatrix - Controller Security Group 2"
  vpc_id      = var.vpc

  tags = {
    Name      = "${local.name_prefix}AviatrixSecurityGroup2"
    Createdby = "Terraform+Aviatrix2"
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.incoming_ssl_cidr
  security_group_id = aws_security_group.AviatrixSecurityGroup2.id
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.AviatrixSecurityGroup2.id
}