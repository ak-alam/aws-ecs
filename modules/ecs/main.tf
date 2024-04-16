locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${var.cluster_name}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.identifier}-${var.cluster_name}-${terraform.workspace}"
  setting {
    value = var.container_insights
    name  = "containerInsights"
  }

  lifecycle {
    ignore_changes = [
      setting,
    ]
  }

  tags = local.tags
}