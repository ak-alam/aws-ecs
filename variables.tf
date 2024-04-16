variable "identifier" {
  type = string
    description = "The projector identifier"
}

#VPC settings
variable "cluster_vpc" {}

#Public LB security group settings
variable "public_lb_sg" {}

#Backend service security group
variable "backend_service_sg" {}

#Backend ALB 
# variable "backend_public_alb" {}

# Frontend ALB
variable "frontend_public_alb" {}

#ECS Cluster
variable "ecs_cluster_settings" {}

# #ECS Backend Service and Task Definition
variable "backend_task_definition_settings" {}

# #ECS frontend Service and Task Definition
variable "webapp_service_task" {}

variable "service_discovery_name" {
  description = "service discovery list name"
  default = ["redis"]
}