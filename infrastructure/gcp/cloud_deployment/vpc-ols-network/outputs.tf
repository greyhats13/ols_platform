# Outputs for the VPC Deployment

# VPC Outputs
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The unique identifier of the VPC."
}

output "vpc_self_link" {
  value       = module.vpc.vpc_self_link
  description = "The URI of the VPC in GCP."
}

output "vpc_gateway_ipv4" {
  value       = module.vpc.vpc_gateway_ipv4
  description = "The IPv4 address of the VPC's default internet gateway."
}

# Subnetwork Outputs
output "subnet_self_link" {
  value       = module.vpc.subnet_self_link
  description = "The URI of the subnetwork in GCP."
}

output "subnet_ip_cidr_range" {
  value       = module.vpc.subnet_ip_cidr_range
  description = "The primary IP CIDR range of the subnetwork."
}

# Router Outputs
output "router_id" {
  value       = module.vpc.router_id
  description = "The unique identifier of the router."
}

output "router_self_link" {
  value       = module.vpc.router_self_link
  description = "The URI of the router in GCP."
}

# NAT Outputs
output "nat_id" {
  value       = module.vpc.nat_id
  description = "The unique identifier of the NAT."
}
