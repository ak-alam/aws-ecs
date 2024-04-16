variable "identifier" {
  description = "The name for the project"
  type        = string
}

variable "family" {
  description = "A unique name for ECS task definition"
  type = string
  default = ""
}
variable "requires_compatibilities" {
  description = "Enabled compatibilities for task"
  default     = "FARGATE"
  type        = string
}

variable "network_mode" {
  description = "the task definition network mode"
  default     = "awsvpc"
  type        = string
}

variable "container_memory" {
  description = "The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = 1024 #256
  type        = number
}
variable "container_cpu" {
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 512 #300
  type        = number
}

variable "container_definitions" {
  description = "List of container definition assigned to ecs task"
  type = list(object({
    name = string
    image = string
    cpu            = number
    memory         = number
    environment    = map(string)
    secrets        = map(string)
    container_port = number
  }))
}

#service
variable "enable_service_loadbalancing" {
  description = "If you want to enable service Loadbalancing for the ECS service"
  type = bool
  default = false
}
variable "service_target_group_arn" {
  description = "ARN of the target group to attach load balancer setting with the service"
  type = string
  default = ""
}


variable "service_subnet_ids" {
  description = "List of subnet ids"
  type = list(string)
  default = []
}

variable "service_sg_ids" {
  description = "List of ECS service security group IDs"
  type = list(string)
  default = []
}

variable "service_assign_public_ip" {
  description = "Assign ESC service public IP"
  type = bool
  default = false
}

variable "service_cluster_name" {
  description = "Cluster name reference for serivce"
  type = string
  default = ""
}


variable "enable_service_registry" {
  description = "If you want to enable service discovery for the ECS service"
  type = bool
  default = false
}

variable "service_discovery_name_arn" {
  description = "Service discovery name arn"
  default = ""
}
# variable "execution_role_arn" {
#   description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
#   default     = null
#   type        = string
# }
# variable "task_role_arn" {
#   description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
#   default     = null
#   type        = string
# }

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}