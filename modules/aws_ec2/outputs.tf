output "ec2_hostname" {
  value       = aws_instance.ec2_instance.public_dns
  description = "Public DNS name for EC2 instance"
}

output "ec2_security_group_id" {
  value       = aws_security_group.ec2_instance.id
  description = "Security group ID tied to the EC2 instance"
}

output "ec2_network_interface_id" {
  value       = aws_instance.ec2_instance.primary_network_interface_id
  description = "Elastic Network Interface (ENI) ID of the EC2 instance's primary network interface"
}
