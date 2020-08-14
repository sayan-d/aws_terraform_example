###############################
# Create Security Group for EC2
###############################
resource "aws_security_group" "ec2_instance" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-sg",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

###############################
# Attach Security Group to EC2
###############################
resource "aws_network_interface_sg_attachment" "ec2_instance" {
  security_group_id    = aws_security_group.ec2_instance.id
  network_interface_id = aws_instance.ec2_instance.primary_network_interface_id
}

###############################
# Launch EC2 instance
###############################
resource "aws_instance" "ec2_instance" {
  ami                         = var.ec2_ami
  ebs_optimized               = var.ec2_ebs_optimized
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_name
  monitoring                  = false
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data_base64            = var.ec2_user_data

  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${var.name}",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}
