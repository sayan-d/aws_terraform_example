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


output "elb_id" {
  description = "The name of the ELB"
  value       = concat(aws_elb.internal_elb.*.id, [""])[0]
}

output "elb_arn" {
  description = "The ARN of the ELB"
  value       = concat(aws_elb.internal_elb.*.arn, [""])[0]
}

output "elb_name" {
  description = "The name of the ELB"
  value       = concat(aws_elb.internal_elb.*.name, [""])[0]
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = concat(aws_elb.internal_elb.*.dns_name, [""])[0]
}
