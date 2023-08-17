# create cloud dns outputs from gcd module

output "network_gcd_id" {
  value = module.gcd_blast.gcd_id
}

output "network_gcd_managed_zone_id" {
  value = module.gcd_blast.gcd_managed_zone_id
}

output "network_gcd_name_servers" {
  value = module.gcd_blast.gcd_name_servers
}