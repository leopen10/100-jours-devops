output "ip_publique" {
  value = aws_instance.devops_server.public_ip
}

output "instance_id" {
  value = aws_instance.devops_server.id
}
