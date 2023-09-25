resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name      = "App VPC"
    CreatedBy = "Nevus"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name      = "IG_For_AppVPC"
    CreatedBy = "Nevus"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "PublicRT"
    CreatedBy = "Nevus"
  }
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_configs)

  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.subnet_configs[count.index].cidr_block
  availability_zone       = var.subnet_configs[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name      = var.subnet_configs[count.index].name
    CreatedBy = "Nevus"
  }
}

resource "aws_route_table_association" "a" {
  count          = length(var.subnet_configs)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.PublicRT.id
}
