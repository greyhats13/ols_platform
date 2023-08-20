# create cloud dns outputs from gcd module

output "network_gcd_id" {
  value = module.gcloud_dns.gcd_id
}

output "network_gcd_managed_zone_id" {
  value = module.gcloud_dns.gcd_managed_zone_id
}

output "network_gcd_name_servers" {
  value = module.gcloud_dns.gcd_name_servers
}

output "network_gcd_zone_visibility" {
  value = module.gcloud_dns.gcd_zone_visibility
}