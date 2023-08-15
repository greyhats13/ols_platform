# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  auto_create_subnetworks = false
}

# Create a subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-jakarta"
  ip_cidr_range = var.subnetwork_ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.self_link
  depends_on    = [google_compute_network.vpc]
}