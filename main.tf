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

resource "aws_security_group" "ecs_tasks" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ecs-tasks-sg"
  description = "allow inbound access from the ALB only"

  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "lb" {
  vpc_id      = aws_vpc.vpc.id
  name        = "alb-sg"
  description = "controls access to the Application Load Balancer (ALB)"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "testalb" {
  name               = "alb"
  subnets            = aws_subnet.pub_subnet.*.id 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "test_https_forward" {
  load_balancer_arn = aws_lb.testalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_alb_tg.arn
  }
}

resource "aws_lb_target_group" "test_alb_tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id 
  target_type = "ip"
}


