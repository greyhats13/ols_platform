# Create a Google Compute VPC
# This VPC will serve as the primary network for other resources.
resource "google_compute_network" "vpc" {
  name                    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  auto_create_subnetworks = false  # Disable default subnets creation for more granular control
}

# Create a Google Compute Subnetwork within the VPC
# This subnetwork will be used by GKE and other resources within the VPC.
# CIDR ranges are determined based on the environment.
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-${var.region}"
  ip_cidr_range = var.env == "dev" ? "10.0.0.0/16" : (
                var.env == "stg" ? "10.1.0.0/16" : "10.2.0.0/16")
  network       = google_compute_network.vpc.self_link  # Link to the VPC created above

  # Define secondary IP range for GKE pods based on the environment
  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.env == "dev" ? "172.16.0.0/16" : (
                  var.env == "stg" ? "172.18.0.0/16" : "172.20.0.0/16")
  }

  # Define secondary IP range for GKE services based on the environment
  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.env == "dev" ? "172.17.0.0/16" : (
                  var.env == "stg" ? "172.19.0.0/16" : "172.21.0.0/16")
  }
}

# Create a Google Compute Router
# This router will manage traffic routing and connect the VPC to external networks.
resource "google_compute_router" "router" {
  name    = "${var.unit}-${var.env}-${var.code}-${var.feature[2]}"
  region  = var.region
  network = google_compute_network.vpc.self_link
}

# Create a Google Compute External IP Address if NAT IP allocation is set to MANUAL_ONLY
# This IP will be used by the Cloud NAT for outbound traffic.
resource "google_compute_address" "address" {
  count  = var.nat_ip_allocate_option == "MANUAL_ONLY" ? 3 : 0
  name   = "${var.unit}-${var.env}-${var.code}-${var.feature[3]}"
  region = google_compute_subnetwork.subnet.region
}

# Create a Google Compute NAT
# Cloud NAT allows VM instances without external IPs to access the internet.
# It uses either auto-allocated or manually specified IPs based on the configuration.
resource "google_compute_router_nat" "nat" {
  name                               = "${var.unit}-${var.env}-${var.code}-${var.feature[4]}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = var.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_address.address.*.self_link : [] # set to empty list if NAT IP allocation is set to AUTO_ONLY or DISABLED
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  
  # Define subnetworks that will use this Cloud NAT if "LIST_OF_SUBNETWORKS" is specified
  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.subnetworks : []
    content {
      name          = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }
}
