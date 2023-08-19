# Configure the backend for Terraform state storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}

# Deploy the VPC using the VPC module
module "vpc" {
  source  = "../../modules/network/vpc"
  region  = "asia-southeast2"
  unit    = "ols"
  env     = "prd"
  code    = "vpc"
  feature = ["network", "subnet", "router", "address", "nat"]
  ip_cidr_range = {
    dev = "10.0.0.0/16"
    stg = "10.1.0.0/16"
    prd = "10.2.0.0/16"
  }
  secondary_ip_range = {
    dev = [
      {
        range_name    = "pods-range"
        ip_cidr_range = "172.16.0.0/16"
      },
      {
        range_name    = "services-range"
        ip_cidr_range = "172.17.0.0/16"
      }
    ]
    stg = [
      {
        range_name    = "pods-range"
        ip_cidr_range = "172.18.0.0/16"
      },
      {
        range_name    = "services-range"
        ip_cidr_range = "172.19.0.0/16"
      }
    ]
    prd = [
      {
        range_name    = "pods-range"
        ip_cidr_range = "172.20.0.0/16"
      },
      {
        range_name    = "services-range"
        ip_cidr_range = "172.21.0.0/16"
      }
    ]
  }
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
