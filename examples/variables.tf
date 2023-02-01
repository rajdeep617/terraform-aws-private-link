variable "vpc_configs" {
  type = map(object({
    azs                     = list(string)
    create_internet_gateway = bool
    create_nat_gateway      = bool
    create_private_subnets  = bool
    create_public_subnets   = bool
    enable_dns_hostnames    = bool
    enable_dns_support      = bool
    name_tag                = string
    cidr                    = string
  }))
  description = "VPC configuration"
}

variable "provider_ec2_config" {
  type = object({
    associate_public_ip_address = bool
    instance_count              = number
    name_tag                    = string
    ingress_rules = map(object({
      from_port  = number
      to_port    = number
      protocol   = string
      cidr_block = list(string)
    }))
  })
  description = "EC2 configuration in provider vpc"
}

variable "provider_nlb" {
  type = object({
    name_tag     = string
    internal_nlb = bool
  })
}

variable "consumer_ec2_config" {
  type = map(object({
    associate_public_ip_address = bool
    instance_count              = number
    name_tag                    = string
    ingress_rules = map(object({
      from_port  = number
      to_port    = number
      protocol   = string
      cidr_block = list(string)
    }))
  }))
}