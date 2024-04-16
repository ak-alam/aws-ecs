

resource "aws_service_discovery_service" "service_discovery_main" {
  name = var.service_discovery_name 

  dns_config {
    namespace_id = var.cloudmap_namespace_id #.private_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
