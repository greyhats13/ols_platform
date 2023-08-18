# create vpc module outputs

#vpc
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_self_link" {
  value = module.vpc.vpc_self_link
}

output "vpc_gateway_ipv4" {
  value = module.vpc.vpc_gateway_ipv4
}

#subnet
output "subnet_self_link" {
  value = module.vpc.subnet_self_link
}

output "subnet_ip_cidr_range" {
  value = module.vpc.subnet_ip_cidr_range
}

#router

output "router_id" {
  value = module.vpc.router_id
}

output "router_self_link" {
  value = module.vpc.router_self_link
}

#nat
output "nat_id" {
  value = module.vpc.nat_id
}