output "nlb_arn_suffix" {
  value = aws_lb.internal.arn_suffix
}
output "nlb_dns" {
  value = aws_lb.internal.dns_name
}
output "nlb_arn" {
  value = aws_lb.internal.arn
}