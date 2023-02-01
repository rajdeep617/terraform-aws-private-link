variable "network_load_balancer_arns" {
  type = list(string)
  description = "Network load balancer arn"
}
variable "acceptance_required" {
  type = bool
  default = false
  description = "Require endpoint acceptance approval"
}
variable "supported_ip_address_types" {
  type = list(string)
  default = ["ipv4"]
  description = "endpoint service supported ip address types"
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
variable "name_tag" {
  type        = string
  description = "The value of name tag to used on all resources"
}
variable "cidr_block" {
  type = string
  description = "VPC CIDR block to allow in security group"
}
variable "subnet_ids" {
  type = list(string)
  description = "List of subnet ids"
}