output "outputs" {
  value = {
    security_group_name = aws_security_group.default.name
    security_group_id = aws_security_group.default.id
  }
}