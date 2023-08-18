terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}

module "vpc" {
  source                             = "../../modules/network/vpc"
  region                             = "asia-southeast2"
  unit                               = "ols"
  env                                = "dev"
  code                               = "vpc"
  feature                            = ["network", "subnet", "router", "address", "nat", "route"]
  pods_range_name                    = "pods-range"
  services_range_name                = "services-range"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
