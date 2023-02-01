output "instance_ids" {
  value = aws_instance.main[*].id
}
output "ec2_private_ips" {
  value = aws_instance.main.*.private_ip
}
output "ec2_public_ips" {
  value = aws_instance.main.*.public_ip
}