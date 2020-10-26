data "template_file" "redis" {
  template = file("./redis-task-defenition.json.tpl")
  vars = {
    aws_ecr_repository = "redis"
    tag                = "latest"
    app_port           = 6379
  }
}


resource "aws_ecs_cluster" "testservice" {
  name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "service" {
  family                   = "testapp"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.redis.rendered
}

resource "aws_ecs_service" "testapp" {
  name            = "staging"
  cluster         = aws_ecs_cluster.testservice.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.pub_subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test_alb_tg.arn
    container_name   = "redis"
    container_port   = 6379
  }

  depends_on = [aws_lb_listener.test_https_forward]

}
