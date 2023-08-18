# VPC output
output "vpc_id" {
  value       = google_compute_network.vpc.id
  description = "The ID of the VPC being created."
}

output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The URI of the VPC being created."
}

output "vpc_gateway_ipv4" {
  value       = google_compute_network.vpc.gateway_ipv4
  description = "The IPv4 address of the VPC's gateway."
}

# Subnetwork output
output "subnet_network" {
  value       = google_compute_subnetwork.subnet.network
  description = "The network to which this subnetwork belongs."
}

output "subnet_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "The URI of the subnetwork."
}

output "subnet_ip_cidr_range" {
  value       = google_compute_subnetwork.subnet.ip_cidr_range
  description = "The IP CIDR range of the subnetwork."
}

output "router_id" {
  value       = google_compute_router.router.id
  description = "The ID of the router being created."
}

output "router_self_link" {
  value       = google_compute_router.router.self_link
  description = "The URI of the router being created."
}

output "nat_id" {
  value       = google_compute_router_nat.nat.id
  description = "The ID of the NAT being created."
}

output "route_id" {
  value       = google_compute_route.route_igw.id
  description = "The ID of the route being created."
}

output "route_next_hop_gateway" {
  value       = google_compute_route.route_igw.next_hop_gateway
  description = "The next hop to the destination network."
}

output "route_self_link" {
  value       = google_compute_route.route_igw.self_link
  description = "The URI of the route being created."
}