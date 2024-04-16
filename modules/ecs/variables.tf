variable "identifier" {
  description = "The name for the project"
  type        = string
}
variable "cluster_name" {
  description = "The name of the cluster"
}

variable "container_insights" {
  description = "Enable container insights for the ecs cluster"
  default     = "enabled"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}