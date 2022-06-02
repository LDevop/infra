# network.tf

resource "aws_vpc" "cluster-vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = "VPC for ${var.name}"
  }
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.cluster-vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.cluster-vpc.id
  tags = {
    Name = "Private subnet for ${var.name}"
  }
}


# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.cluster-vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.cluster-vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet for ${var.name}"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "cluster-igw" {
  vpc_id = aws_vpc.cluster-vpc.id
  tags = {
    Name = "Internet gateway for ${var.name}"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.cluster-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cluster-igw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "cluster-eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.cluster-igw]
  tags = {
    Name = "elastic IP for ${var.name}"
  }
}

resource "aws_nat_gateway" "cluster-natgw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.cluster-eip.*.id, count.index)
  tags = {
    Name = "NAT gateway for ${var.name}"
  }
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.cluster-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.cluster-natgw.*.id, count.index)
  }
  tags = {
    Name = "Private routetable for ${var.name}"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
