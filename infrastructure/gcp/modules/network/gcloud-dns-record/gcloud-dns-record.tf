resource "google_dns_record_set" "frontend" {
  name = "${var.subdomain}.${var.dns_zone_name}"
  type = var.record_type
  ttl  = var.ttl

  managed_zone = var.dns_zone_name

  rrdatas = var.rrdatas
}