output "outputs" {
  value = {
    # https_listener = length(var.alb_certificate_arn) > 0 ? aws_lb_listener.https_listener.0 : null
    # http_listener  = aws_lb_listener.http_listener
    alb            = aws_lb.main
    target_group = aws_lb_target_group.target_group_main
  }
}