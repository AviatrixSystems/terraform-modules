resource "aws_security_group" "AviatrixLambdaSecurityGroup" {
  name        = "${local.name_prefix}AviatrixLambdaSecurityGroup"
  description = "Aviatrix - Lambda Security Group"
  vpc_id      = var.vpc

  tags = {
    Name      = "${local.name_prefix}AviatrixLambdaSecurityGroup"
    Createdby = "Terraform+Aviatrix"
  }
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.AviatrixLambdaSecurityGroup.id
}