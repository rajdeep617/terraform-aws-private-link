vpc_configs = {
  provider_vpc = {
    azs                     = ["us-east-1a", "us-east-1b", "us-east-1c"]
    create_internet_gateway = false
    create_nat_gateway      = false
    create_private_subnets  = true
    create_public_subnets   = false
    enable_dns_hostnames    = true
    enable_dns_support      = true
    name_tag                = "provider"
    cidr                    = "10.0.0.0/16"
  }
  consumer_vpc = {
    azs                     = ["us-east-1a", "us-east-1b", "us-east-1c"]
    create_internet_gateway = true
    create_nat_gateway      = false
    create_private_subnets  = true
    create_public_subnets   = true
    enable_dns_hostnames    = true
    enable_dns_support      = true
    name_tag                = "consumer"
    cidr                    = "10.1.0.0/16"
  }
}

provider_ec2_config = {
  associate_public_ip_address = false
  instance_count              = 2
  name_tag                    = "provider"
  ingress_rules = {
    http = {
      from_port  = 80
      to_port    = 80
      protocol   = "TCP"
      cidr_block = ["0.0.0.0/0"]
    }
  }
}

provider_nlb = {
  name_tag     = "provider"
  internal_nlb = true
}

consumer_ec2_config = {
  bastion = {
    associate_public_ip_address = true
    instance_count              = 1
    name_tag                    = "consumer-bastion"
    ingress_rules = {
      ssh = {
        from_port  = 22
        to_port    = 22
        protocol   = "TCP"
        cidr_block = ["0.0.0.0/0"]
      }
    }
  }
  consumer = {
    associate_public_ip_address = false
    instance_count              = 1
    name_tag                    = "consumer-ec2"
    ingress_rules = {
      ssh = {
        from_port  = 22
        to_port    = 22
        protocol   = "TCP"
        cidr_block = ["0.0.0.0/0"]
      }
    }
  }
}