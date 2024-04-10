terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "pubsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "myvpc pubsub"
  }
}
resource "aws_subnet" "prisub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "myvpc prisub"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc igw"
  }
}
resource "aws_route_table" "pubrout" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
  }

  tags = {
    Name = "myvpc pubrout"
  }
}
resource "aws_route_table_association" "asso" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.pubrout.id
}
resource "aws_eip" "ip" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.pubsub.id

  tags = {
    Name = "natgw"
  }
}
resource "aws_route_table" "prirout" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }



  tags = {
    Name = "myvpc prirout"
  }
}
resource "aws_route_table_association" "asso1" {
  subnet_id      = aws_subnet.prisub.id
  route_table_id = aws_route_table.prirout.id
}
resource "aws_security_group" "myvpc_sec" {
  name        = "myvpc_sec"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc_sec"
  }
}

resource "aws_vpc_security_group_ingress_rule" "myvpc_sec_ipv4" {
  security_group_id = aws_security_group.myvpc_sec.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "myvpc_sec_traffic_ipv4" {
  security_group_id = aws_security_group.myvpc_sec.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

  
