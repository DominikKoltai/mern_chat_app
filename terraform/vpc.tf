resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "jenkins-vpc"
  }
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"

  tags = {
    Name = "jenkins-subnet"
  }
}

resource "aws_internet_gateway" "jenkins_gw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins-gw"
  }
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins-route-table"
  }
}

resource "aws_route" "jenkins_internet_access" {
  route_table_id         = aws_route_table.jenkins_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jenkins_gw.id
}

resource "aws_route_table_association" "jenkins_association" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.jenkins_route_table.id
}