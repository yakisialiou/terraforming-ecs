resource "aws_security_group" "ecs_tasks" {
  vpc_id      = var.vpc_id
  name        = "${var.service_name}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"

  ingress {
    protocol        = "tcp"
    from_port   = var.service_port_in
    to_port     = var.service_port_out
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.service-alb-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "service-alb-sg" {
  vpc_id      = var.vpc_id
  name        = "${var.service_name}-alb-sg"
  description = "controls access to the Application Load Balancer (ALB)"

  ingress {
    protocol    = "tcp"
    from_port   = var.service_port_in
    to_port     = var.service_port_out
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "service-lb" {
  name               = "${var.service_name}-alb"
  subnets            = var.ecs_subnets 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.service-alb-sg.id]
}

resource "aws_lb_listener" "service-alb-listener" {
  load_balancer_arn = aws_lb.service-lb.arn
  port              = var.service_port_in
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service-alb-tg.arn
  }
}

resource "aws_lb_target_group" "service-alb-tg" {
  name        = "${var.service_name}-alb-tg"
  port        = var.service_port_out
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}
