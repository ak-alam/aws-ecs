
variable "identifier" {
  description = "Identifier for all the resource"
  default     = ""
  type        = string
}

variable "lb_name" {
  description = "Name of the load balancer"
  type = string
  default = ""
}

variable "security_groups" {
  description = "Security group"
  type        = list(string)
}

variable "lb_is_internal" {
  description = "Boolean that represent if the load balancer will be internal or no"
  default     = false
  type        = bool
}

variable "lb_deletion_protection" {
  type = bool
  description = "Activate deletion protection for alb"
  default = false
}

variable "vpc_id" {
  description = "The VPC where all the resources belong"
  default     = ""
  type        = string
}


variable "subnet_ids" {
  description = "List of all the subnets"
  default     = []
  type        = list(string)
}

# variable "alb_certificate_arn" {
#   description = "ARN for the load balancer certificate"
#   default     = []
#   type        = list(string)
# }


variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

#target group
variable "tg_name" {
 description = "Target group main"
 type = string
 default = ""
}

variable "tg_port" {
 description = "Target group default port"
 type = number
 default = 80
}

variable "tg_protocol" {
 description = "Target group default protocol"
 type = string
 default = "HTTP"
}

variable "target_type" {
 description = "Target group default type"
 type = string
 default = "ip"
}

