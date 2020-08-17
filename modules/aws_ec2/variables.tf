variable "name" {
  default     = "Default"
  type        = string
  description = "Name of the instance"
}

variable "project" {
  type        = string
  description = "Name of project this instance will be used in"
}

variable "environment" {
  type        = string
  description = "Name of environment this instance will be used in"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the EC2"
}

variable "allowed_cidr_blocks" {
  type        = list
  description = "Allowed subnets in Security Group"
}

variable "ec2_ami" {
  type        = string
  description = "Amazon Machine Image (AMI) ID"
}

variable "ec2_ebs_optimized" {
  default     = false
  type        = bool
  description = "If true, the instance will be EBS-optimized"
}

variable "ec2_instance_type" {
  default     = "t3.nano"
  type        = string
  description = "Instance type for the ec2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ec2 instance sec group"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the ec2 instance"
}

variable "key_name" {
  type        = string
  description = "SSH key to use with the ec2 instance"
}

variable "ec2_user_data" {
  default     = ""
  type        = string
  description = "EC2 User Data"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the EC2 resources"
}

variable "docker_image" {
  type = string
  default = ""
}

variable "azs" {
  type = list
  default = []
}
