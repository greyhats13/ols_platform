# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  auto_create_subnetworks = false
}

# Create a subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.subnet_name}"
  ip_cidr_range = var.subnetwork_ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.self_link
  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.pods_ip_cidr_range
  }

  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.services_ip_cidr_range
  }
  depends_on    = [google_compute_network.vpc]
}