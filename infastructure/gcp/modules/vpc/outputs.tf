# VPC output

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "vpc_gateway_ipv4" {
  value = google_compute_network.vpc.gateway_ipv4
}


# Subnetwork output
output "subnet_network" {
  value = google_compute_subnetwork.subnet.network
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "subnet_ip_cidr_range" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}