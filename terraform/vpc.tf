resource "aws_vpc" "chat_app_vpc" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "chat-app-vpc"
  }
}

resource "aws_subnet" "chat_app_subnet" {
  vpc_id                  = aws_vpc.chat_app_vpc.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"

  tags = {
    Name = "chat-app-subnet"
  }
}

resource "aws_subnet" "chat_app_subnet2" {
  vpc_id            = aws_vpc.chat_app_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "chat-app-subnet-2"
  }
}

resource "aws_internet_gateway" "chat_app_gw" {
  vpc_id = aws_vpc.chat_app_vpc.id

  tags = {
    Name = "chat-app-gw"
  }
}

resource "aws_route_table" "chat_app_route_table" {
  vpc_id = aws_vpc.chat_app_vpc.id

  tags = {
    Name = "chat-app-route-table"
  }
}

resource "aws_route" "chat_app_internet_access" {
  route_table_id         = aws_route_table.chat_app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.chat_app_gw.id
}

resource "aws_route_table_association" "chat_app_association" {
  subnet_id      = aws_subnet.chat_app_subnet.id
  route_table_id = aws_route_table.chat_app_route_table.id
}

resource "aws_route_table" "chat_app_private_subnet_route_table" {
  depends_on = [aws_nat_gateway.chat_app_nat_gateway]
  vpc_id     = aws_vpc.chat_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.chat_app_nat_gateway.id
  }

  tags = {
    Name = "chat-app-private-subnet-route-table"
  }
}

resource "aws_route_table_association" "chat_app_private_subnet_route_table_association" {
  depends_on     = [aws_route_table.chat_app_private_subnet_route_table]
  subnet_id      = aws_subnet.chat_app_subnet2.id
  route_table_id = aws_route_table.chat_app_private_subnet_route_table.id
}