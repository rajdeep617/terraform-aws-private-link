terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "POC"
    }
  }
}

module "key-pair" {
  source       = "../key-pair"
  ec2_key_name = "private-link-poc"
}

module "vpc" {
  for_each = var.vpc_configs

  source                  = "git::https://github.com/rajdeep617/terraform-aws-vpc-module.git"
  azs                     = each.value.azs
  create_internet_gateway = each.value.create_internet_gateway
  create_nat_gateway      = each.value.create_nat_gateway
  create_private_subnets  = each.value.create_private_subnets
  create_public_subnets   = each.value.create_public_subnets
  name_tag                = each.value.name_tag
  vpc_cidr                = each.value.cidr
}

module "provider-ec2" {
  source                      = "../ec2"
  associate_public_ip_address = var.provider_ec2_config.associate_public_ip_address
  ingress_rules               = var.provider_ec2_config.ingress_rules
  instance_count              = var.provider_ec2_config.instance_count
  name_tag                    = var.provider_ec2_config.name_tag
  ec2_key_name                = module.key-pair.key_name
  ec2_private_key             = module.key-pair.ec2_private_key
  subnet_id                   = module.vpc["provider_vpc"].private_subnets_ids
  vpc_id                      = module.vpc["provider_vpc"].vpc_id
}

module "provider-nlb" {
  source       = "../nlb"
  instance_ids = module.provider-ec2.instance_ids
  name_tag     = var.provider_nlb.name_tag
  internal_nlb = var.provider_nlb.internal_nlb
  subnet_ids   = module.vpc["provider_vpc"].private_subnets_ids
  vpc_id       = module.vpc["provider_vpc"].vpc_id
}

module "consumer-ec2" {
  for_each = var.consumer_ec2_config

  source                      = "../ec2"
  associate_public_ip_address = each.value.associate_public_ip_address
  ingress_rules               = each.value.ingress_rules
  instance_count              = each.value.instance_count
  name_tag                    = each.value.name_tag
  ec2_key_name                = module.key-pair.key_name
  ec2_private_key             = module.key-pair.ec2_private_key
  subnet_id                   = each.key == "bastion" ? module.vpc["consumer_vpc"].public_subnets_ids : module.vpc["consumer_vpc"].private_subnets_ids
  vpc_id                      = module.vpc["consumer_vpc"].vpc_id
}

module "endpoint" {
  source = "../private-link"
  network_load_balancer_arns = [module.provider-nlb.nlb_arn]
  vpc_id                     = module.vpc["consumer_vpc"].vpc_id
  cidr_block = module.vpc["consumer_vpc"].vpc_cidr
  name_tag   = "endpoint"
  subnet_ids = module.vpc["consumer_vpc"].private_subnets_ids
}
