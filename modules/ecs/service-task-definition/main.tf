locals {
  default_tags = {
    # Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

#Task defintion role
resource "aws_iam_role" "task_role" {
  name               = "${var.identifier}-${var.family}-role-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_policy.json

  inline_policy {
    name = "ecs-task-permissions"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecr:*",
            "logs:*",
            "ssm:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

#Cloud watch log group
resource "aws_cloudwatch_log_group" "log" {
  name              = "/${var.identifier}/${var.family}/${terraform.workspace}"
  retention_in_days = 14
}

#ECS Task definition
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.identifier}-${var.family}-${terraform.workspace}"    
  requires_compatibilities = [var.requires_compatibilities]
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  network_mode             = var.network_mode
  task_role_arn            = aws_iam_role.task_role.arn 
  execution_role_arn       = aws_iam_role.task_role.arn
  

 container_definitions    = local.container_definitions

  tags = local.tags
}


# ECS Service
resource "aws_ecs_service" "service" {
  name            = "${var.identifier}-${var.family}-${terraform.workspace}"
  cluster         = var.service_cluster_name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets  = var.service_subnet_ids
    security_groups = var.service_sg_ids
    assign_public_ip = var.service_assign_public_ip
  }
  dynamic "load_balancer" {
    for_each = var.enable_service_loadbalancing ? [1] : []
    content {
    container_name   = local.main_container_name
    container_port   = local.main_container_port
    target_group_arn = var.service_target_group_arn   
    }
  }
  dynamic "service_registries" {
    for_each = var.enable_service_registry ? [1] : []
    content {
      registry_arn   = var.service_discovery_name_arn #aws_service_discovery_service.this.arn
      container_name = local.main_container_name
    }
  }

}

#Service AutoScaling
resource "aws_appautoscaling_target" "ecs_target_tracking" {
  max_capacity = 5
  min_capacity = 1
  resource_id = "service/${var.service_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "memory_utilization" {
  name               = "memory_utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_tracking.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_tracking.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_tracking.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "cpu_utilization" {
  name = "cpu_utilization"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target_tracking.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_tracking.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target_tracking.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}