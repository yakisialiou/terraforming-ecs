variable "vpc_id" {
  type        = string
  description = "VPC to use"
}

variable "ecs_execution_iam_role" {
  type        = string
  description = "ECS execution role ARN created previously"
}

variable "ecs_cluster" {
  type        = string
  description = "ECS cluster ARN created previously"
}

variable "ecs_subnets" {
  type        =  list(string) 
  description = "ECS subnets ARNs, created previously"
}

variable "service_port_in" {
  type        = string
  description = "ECS task port in"
}

variable "service_port_out" {
  type        = string
  description = "ECS task port out"
}

variable "service_discovery_dns" {
  type        = string
  description = "Service discovery DNS prefix"
}

variable "service_discovery_name" {
  type        = string
  description = "Service discovery name"
}

variable "task_definition_template" {
  type        = string
  description = "template file for task defiition"
}

variable "container_repo" {
  type        = string
  description = "container repository with container to run"
}

variable "container_tag" {
  type        = string
  description = "container repository tag to run container"
}

variable "container_port" {
  type        = string
  description = "port where container is listening"
}

variable "service_family" {
  type        = string
  description = "ECS service family"
  default = "myservice"
}

variable "service_cpu" {
  type        = string
  description = "CPU limits for container"
  default = 256
}

variable "service_memory" {
  type        = string
  description = "Memory limits for container"
  default = 2048
}

variable "service_name" {
  type        = string
  description = "ECS service name"
  default = "Myservicename"
}

variable "container_name" {
  type        = string
  description = "ECS container name, the same as task definition"
}
