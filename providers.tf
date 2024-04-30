terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}



resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MiVPC"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.mi_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "SubnetPublica"
  }
}

resource "aws_internet_gateway" "mi_igw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "MiIGW"
  }
}

resource "aws_route_table" "mi_rt" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_igw.id
  }

  tags = {
    Name = "MiTablaDeRuteo"
  }
}

resource "aws_route_table_association" "asoc_rt" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.mi_rt.id
}
