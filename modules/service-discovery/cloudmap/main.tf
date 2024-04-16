#Service discovery
resource "aws_service_discovery_private_dns_namespace" "private_namespace" {
  name        = var.private_domain_namespace
  description = "Private dns namespace for service discovery"
  vpc         = var.vpc_id
}