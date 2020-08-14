# aws_terraform_example
An example Terraform code to setup VPC and EC2 with a running docker container in AWS

## Create VPC
```
terraform init
terraform plan -target=module.vpc_demo_1
terraform apply -target=module.vpc_demo_1
```

## Launch EC2 in Private subnet
```
terraform plan -target=module.ec2_demo_1_pvt
terraform apply -target=module.ec2_demo_1_pvt
```

## Launch EC2 in Public subnet 
### (A docker container with sample hello-world is launched here based on userdata)
```
terraform plan -target=module.ec2_demo_1_pub
terraform apply -target=module.ec2_demo_1_pub
```
