module "redis" {
  source                            = "./modules/service/"
  vpc_id  = aws_vpc.vpc.id
  ecs_execution_iam_role = aws_iam_role.ecs_task_execution_role.arn
  ecs_cluster = aws_ecs_cluster.testservice.arn
  ecs_subnets = aws_subnet.pub_subnet.*.id
  service_port_in = "6379"
  service_port_out ="6379"
  service_discovery_dns = "example.test" 
  service_discovery_name = "redis"
  task_definition_template = "./redis-task-defenition.json.tpl"
  container_repo = "redis"
  container_tag = "latest"
  container_port = "6379"
  container_name = "redis" 
  service_name = "redis"
  service_family = "redis"
}
module "redis-write" {
  source                            = "./modules/service/"
  vpc_id  = aws_vpc.vpc.id
  ecs_execution_iam_role = aws_iam_role.ecs_task_execution_role.arn
  ecs_cluster = aws_ecs_cluster.testservice.arn
  ecs_subnets = aws_subnet.pub_subnet.*.id
  service_port_in = "8080"
  service_port_out ="8080"
  service_discovery_dns = "example.test"
  service_discovery_name = "redis-write"
  task_definition_template = "./write-redis-task-definition.json.tpl"
  container_repo = "768997443862.dkr.ecr.us-east-1.amazonaws.com/go-test-app"
  container_tag = "latest"
  container_port = "8080"
  container_name = "redis-write"
  service_name = "redis-write"
  service_family = "redis-write"
}
