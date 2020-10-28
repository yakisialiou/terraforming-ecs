data "template_file" "service-task-definition" {
  template = file(var.task_definition_template)
  vars = {
    aws_ecr_repository = var.container_repo
    tag                = var.container_tag
    app_port           = var.container_port
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = var.service_family
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_execution_iam_role
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.service-task-definition.rendered
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.ecs_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service-alb-tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  service_registries {
    registry_arn     = aws_service_discovery_service.service-sd.arn
  }

}

resource "aws_service_discovery_public_dns_namespace" "service-dns-sd" {
  name        = var.service_discovery_dns
}

resource "aws_service_discovery_service" "service-sd" {
  name = var.service_discovery_name
  dns_config {
    namespace_id = aws_service_discovery_public_dns_namespace.service-dns-sd.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

}
