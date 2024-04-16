locals {
  default_tags = {
    # Name        = "${var.identifier}-${var.lb_name}${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_lb" "main" {
  name                       = "${var.identifier}-${var.lb_name}-${terraform.workspace}"
  security_groups            = var.security_groups
  internal                   = var.lb_is_internal 
  subnets                    = var.subnet_ids
  enable_deletion_protection = var.lb_deletion_protection

  tags = local.tags
}

resource "aws_lb_target_group" "target_group_main" {
  name        = "${var.identifier}-${var.tg_name}-${terraform.workspace}"
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.id
  protocol          = "HTTP"
  port              = "80"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_main.arn
  }
}
