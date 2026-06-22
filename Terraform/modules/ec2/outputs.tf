output "instance_id" {
  value = aws_instance.app_server.id
}

output "private_ip" {
  value = aws_instance.app_server.private_ip
}

output "iam_role_name" {
  value = aws_iam_role.ssm_role.name
}
