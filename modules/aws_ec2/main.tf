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

data "template_file" "instance_userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars = {
    docker_image = var.docker_image
  }
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
  user_data            = data.template_file.instance_userdata.template

  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${var.name}",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

##########################################
# Launch ELB Internal for Private Instance
##########################################

resource "aws_elb" "internal_elb" {
  name               = "foobar-terraform-elb"
  availability_zones = var.azs

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.ec2_instance.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${var.name}-elb",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}
