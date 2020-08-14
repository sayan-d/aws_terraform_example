module "vpc_demo_1" {
  source = "./modules/aws_vpc"

  name                       = "demo-1"
  region                     = "us-east-1"
  cidr_block                 = "10.100.0.0/16"
  private_subnet_cidr_blocks = ["10.100.1.0/24", "10.100.3.0/24"]
  public_subnet_cidr_blocks  = ["10.100.0.0/24", "10.100.2.0/24"]
  availability_zones         = ["us-east-1a", "us-east-1b"]

  project     = "demo-1"
  environment = "dev"
}

locals {
  instance-userdata = <<EOF

#!/bin/bash
yum install -y docker
service docker start && chkconfig docker on
docker run -d --name hello-world -p 80:80 karthequian/helloworld:latest
EOF
}

module "ec2_demo_1_pub" {
  source = "./modules/aws_ec2"

  name                = "pub"
  region              = "us-east-1"
  vpc_id              = module.vpc_demo_1.id
  subnet_id           = module.vpc_demo_1.public_subnet_ids[0]
  allowed_cidr_blocks = ["0.0.0.0/0"]
  ec2_ami             = "ami-0ff8a91507f77f867"
  ec2_instance_type   = "t2.nano"
  key_name            = "sayan_aws-test_us-east-1"
  project             = "demo-1"
  environment         = "dev"
  ec2_user_data       = base64encode(local.instance-userdata)
}

module "ec2_demo_1_pvt" {
  source = "./modules/aws_ec2"

  name                = "pvt"
  region              = "us-east-1"
  vpc_id              = module.vpc_demo_1.id
  subnet_id           = module.vpc_demo_1.private_subnet_ids[0]
  allowed_cidr_blocks = ["0.0.0.0/0"]
  ec2_ami             = "ami-0ff8a91507f77f867"
  ec2_instance_type   = "t2.nano"
  key_name            = "sayan_aws-test_us-east-1"
  project             = "demo-1"
  environment         = "dev"
}
