# create vpc module outputs

#vpc
output "network_vpc_id" {
  value = module.vpc.vpc_id
}

output "network_vpc_self_link" {
  value = module.vpc.vpc_self_link
}

output "network_vpc_gateway_ipv4" {
  value = module.vpc.vpc_gateway_ipv4
}

#subnet
output "network_subnet_self_link" {
  value = module.vpc.subnet_self_link
}

output "network_subnet_ip_cidr_range" {
  value = module.vpc.subnet_ip_cidr_range
}