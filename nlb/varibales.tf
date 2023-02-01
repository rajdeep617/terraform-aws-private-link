variable "nlb_listener_port" {
  description = "Network load balancer listener port"
  type        = number
  default     = 80
}
variable "instance_ids" {
  description = "List of instance ids to attach with target group"
  type        = list(string)
}
variable "name_tag" {
  description = "The value of name tag to used on all resources"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID to create resources"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}
variable "internal_nlb" {
  description = "Should create internal NLB"
  type        = bool
  default     = true
}
variable "idle_timeout" {
  description = "NLB request timeout"
  type        = number
  default     = 60
}
variable "enable_deletion_protection" {
  description = "Should enable NLB delete protection"
  type        = bool
  default     = false
}
variable "enable_cross_zone_load_balancing" {
  description = "Should Enable cross zone load balancing"
  type        = bool
  default     = true
}