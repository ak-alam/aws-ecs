variable "vpc_id" {
  description = "VPC ID for service discovery namespace"
  type = string
}

variable "private_domain_namespace" {
  description = "DNS name for service discovery (example.com)"
  type = string
  default = ""
}