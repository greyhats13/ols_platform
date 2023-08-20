# create cloud dns outputs from gcd module

output "network_dns_id" {
  value = module.gcloud_dns.dns_id
}

output "network_dns_managed_zone_id" {
  value = module.gcloud_dns.dns_managed_zone_id
}

output "network_dns_name_servers" {
  value = module.gcloud_dns.dns_name_servers
}

output "network_dns_zone_visibility" {
  value = module.gcloud_dns.dns_zone_visibility
}