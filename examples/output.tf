output "nlb_dns" {
  value = module.provider-nlb.nlb_dns
}

output "provider_ec2_ips" {
  value = join(", ", module.provider-ec2.ec2_private_ips)
}

output "consumer_ec2_ip" {
  value = join("", module.consumer-ec2["consumer"].ec2_private_ips)
}

output "consumer_bastion_ip" {
  value = join("", module.consumer-ec2["bastion"].ec2_public_ips)
}

output "dns_entry" {
  value = module.endpoint.dns_entry
}