###########################################################
# Using CIDR block of 10.0.0.0/20 for the VPC. Create 6 subnets with 3 private and 3 public.
# Assign equal number of IPs for each subnet
# Total number of IPs is 10.0.0.0 to 10.0.15.255 (4096 ip iddresses)
#Subnet 1 (Public): 10.0.0.0/23 - IP Range: 10.0.0.0 to 10.0.1.255 - Total IPs: 512
#Subnet 2 (Public): 10.0.2.0/23 - IP Range: 10.0.2.0 to 10.0.3.255 - Total IPs: 512
#Subnet 3 (Public): 10.0.4.0/23 - IP Range: 10.0.4.0 to 10.0.5.255 - Total IPs: 512
#Subnet 4 (Private): 10.0.6.0/23 - IP Range: 10.0.6.0 to 10.0.7.255 - Total IPs: 512
#Subnet 5 (Private): 10.0.8.0/23 - IP Range: 10.0.8.0 to 10.0.9.255 - Total IPs: 512
#Subnet 6 (Private): 10.0.10.0/23 - IP Range: 10.0.10.0 to 10.0.11.255 - Total IPs: 512
# For each subnet, the first 4 and last IP address are reserved. Which makes 507 usable IPs for subnet
# Number of unused IPs are 1024. Can be assigned at a later stage.

# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_name}-VPC"
  }
}

# create first pulic subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/23"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.region}a-public-subnet-1"
  }
}

# create second pulic subnet
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/23"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "${var.region}b-public-subnet-2"
  }
}

# create third pulic subnet
resource "aws_subnet" "public_subnet_3" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/23"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}c"
  tags = {
    Name = "${var.region}c-public-subnet-3"
  }
}

# create first private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.6.0/23"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.region}a-private-subnet-1"
  }
}

# create second private subnet
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.8.0/23"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}b"
  tags = {
    Name = "${var.region}b-private-subnet-2"
  }
}

# create third private subnet
resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.10.0/23"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}c"
  tags = {
    Name = "${var.region}c-private-subnet-3"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.app_name}-IGW"
  }
}

# Public Route Table
# Route all traffic through the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "${var.app_name}-public-route-table"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_3_assoc" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway (placed in the first public subnet)
# Create an Elastic IP address
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.app_name}-NAT-EIP"
  }
}

# Create the NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "${var.app_name}-NAT-GW"
  }
}

# Private Route Table (routes through NAT Gateway)
# Direct all traffic from the private subnet to the NAT gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.my_nat_gateway.id
  }
  tags = {
    Name = "${var.app_name}-private-RT"
  }
}


# Associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_3_assoc" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}

# VPC Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb_ep" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids   = [aws_route_table.public_rt.id, aws_route_table.private_rt.id] 
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "${var.app_name}-DynamoDB-Endpoint"
  }
}

# Security Group for SSM VPC Endpoint
resource "aws_security_group" "ssm_vpce_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.app_name}-SSM-VPC-Endpoint-SG"
  }
  # Ingress rule to allow traffic to the SSM endpoint over port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  # Egress rule to allow all outbound traffic on port 443
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VPC Endpoint for Systems Manager
resource "aws_vpc_endpoint" "ssm_ep" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  security_group_ids = [aws_security_group.ssm_vpce_sg.id]
  tags = {
    Name = "${var.app_name}-SSM-Endpoint"
  }
  private_dns_enabled = true
}


resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.app_name}-Lambda-SG"
  }

  # Egress rule to allow outbound traffic on port 443
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}