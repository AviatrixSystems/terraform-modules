# Outputs for TF Regression Testbed Windows instance setup

output "public_ip" {
	value				= aws_eip.eip.public_ip
	description	= "Public IP of the Windows instance."
}

output "key" {
	value				= aws_instance.instance.key_name
	description	= "Key pair name of the Windows instance."
}
