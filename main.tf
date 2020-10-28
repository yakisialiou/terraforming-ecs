locals {
  az_count       = length(var.availability_zones)
}

provider "aws" {
    region  = "us-east-1"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.100.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "ECS VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "pub_subnet" {
    count             = local.az_count
    vpc_id            = aws_vpc.vpc.id
    availability_zone = var.availability_zones[count.index]
    cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
}


resource "aws_route_table" "outside" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "route_table_association" {
    count          = local.az_count
    subnet_id      = aws_subnet.pub_subnet[count.index].id
    route_table_id = aws_route_table.outside.id
}

