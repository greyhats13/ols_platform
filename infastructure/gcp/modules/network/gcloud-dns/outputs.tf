#create cloud dns outputs

output "gcd_id" {
  value = google_dns_managed_zone.gcd.id
}

output "gcd_managed_zone_id" {
  value = google_dns_managed_zone.gcd.managed_zone_id
}

output "gcd_name_servers" {
  value = google_dns_managed_zone.gcd.name_servers
}

output "gcd_zone_visibility" {
  value = google_dns_managed_zone.gcd.visibility
}