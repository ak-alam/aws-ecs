variable "identifier" {
  type = string
    description = "The projector identifier"
}

variable "vpc_cidr" {
 type = string
 description = "value of the vpc cidr block"
 default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type = bool
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  description = " boolean flag to enable/disable DNS hostnames in the VPC"
  default = true
}

variable "public_subnets" {
  type = list(string)
  description = "public subnet cidrs for the vpc"
  default = []
}

variable "private_subnets" {
  type = list(string)
  description = "public subnet cidrs for the vpc"
  default = []
}

variable "data_subnets" {
    type = list(string)
  description = "public subnet cidrs for the vpc"
  default = []

}

variable "tags" {
  type = map
  default = {}
  description = "Tags to applied to the resources"
}