# Create a Google Compute VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  auto_create_subnetworks = false  # Ensure that no default subnets are created
  delete_default_routes_on_create = true  # Delete default routes created by GCP
}

# Create a Google Compute Subnetwork within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-${var.region}"
  # set ip_cidr_range based on the environment, if dev set to 10.0.0.0/16, if stg set to 10.1.0.0/16, if prod set to 10.2.0.0/16
  ip_cidr_range = var.env == "dev" ? "10.0.0.0/16" : (
                var.env == "stg" ? "10.1.0.0/16" : "10.2.0.0/16")
  network       = google_compute_network.vpc.self_link  # Link to the VPC created above

  # Define secondary IP range for GKE pods
  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.env == "dev" ? "172.16.0.0/16" : (
                  var.env == "stg" ? "172.18.0.0/16" : "172.20.0.0/16")
  }

  # Define secondary IP range for GKE services
  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.env == "dev" ? "172.17.0.0/16" : (
                  var.env == "stg" ? "172.19.0.0/16" : "172.21.0.0/16")
  }
}

# Create a Google Compute Router
resource "google_compute_router" "router" {
  name    = "${var.unit}-${var.env}-${var.code}-${var.feature[2]}"
  region  = var.region
  network = google_compute_network.vpc.self_link
}

# Create a Google Compute External IP Address if NAT IP allocation is set to MANUAL_ONLY
resource "google_compute_address" "address" {
  count  = var.nat_ip_allocate_option == "MANUAL_ONLY" ? 3 : 0
  name   = "${var.unit}-${var.env}-${var.code}-${var.feature[3]}"
  region = google_compute_subnetwork.subnet.region
}

# Create a Google Compute NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${var.unit}-${var.env}-${var.code}-${var.feature[4]}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = var.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_address.address.*.self_link : [] # set to empty list if NAT IP allocation is set to AUTO_ONLY or DISABLED
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  # If source_subnetwork_ip_ranges_to_nat is set to "LIST_OF_SUBNETWORKS", define the list of subnetworks to NAT
  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.subnetworks : []
    content {
      name          = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }
}

# Create a custom route to default internet gateway
resource "google_compute_route" "route_igw" {
  name                  = "${var.unit}-${var.env}-${var.code}-${var.feature[5]}-igw"
  network               = google_compute_network.vpc.name
  dest_range            = "0.0.0.0/0"
  next_hop_gateway      = "global/gateways/default-internet-gateway"
  priority              = 1000
}



