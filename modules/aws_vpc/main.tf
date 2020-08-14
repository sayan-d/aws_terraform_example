###############
# VPC resource
###############
resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = var.name,
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

############################################################################
# Internet Gateway - Route traffic to this IGW for outgoing internet traffic
############################################################################
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "${var.project}-gwInternet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

#################################
# Route table for private subnets
#################################
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "${var.project}-PrivateRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

##############################################################################
# For Private subnets - Set Route for outgoing internet traffic to NAT Gateway
##############################################################################
resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

#################################
# Route table for public subnets
#################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "${var.project}-PublicRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

######################################################################
# For Public subnets - Set Route for outgoing internet traffic to IGW
######################################################################
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

##################################################
# Create private subnets in multi Availability zone
##################################################
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name        = "${var.project}-PrivateSubnet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

##################################################
# Create public subnets in multi Availability zone
##################################################
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "${var.project}-PublicSubnet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

##################################################################
# Associate the previously created route tables to Private subnets
##################################################################
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

##################################################################
# Associate the previously created route tables to Public subnets
##################################################################
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################################################################
# Generate Static Elastic IP to attach to below NAT resource for Private subnets
################################################################################
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  vpc = true
}

##########################################
# Create NAT resources for Private subnets
##########################################
resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.default]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name        = "${var.project}-gwNAT",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}
