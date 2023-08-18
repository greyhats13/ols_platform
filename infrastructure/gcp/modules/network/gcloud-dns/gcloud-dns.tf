resource "google_dns_managed_zone" "gcd" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.zone_name}"
  dns_name    = var.dns_name
  description = var.zone_description
}