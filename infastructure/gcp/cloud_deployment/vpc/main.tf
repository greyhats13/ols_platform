# Terraform State Storage
terraform {
  backend "gcs" {
    bucket  = "ols-dev-storage-gcs-iac"
    prefix  = "vpc/ols-dev-network-vpc"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create vpc from modules network
module "vpc" {
  source                   = "../../modules/network/vpc"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "network"
  feature                  = "vpc"
  subnet_name              = "subnet-jkt"
  subnetwork_ip_cidr_range = "10.0.0.0/16"
  pods_range_name          = "pods-range"
  pods_ip_cidr_range       = "172.16.0.0/16"
  services_range_name      = "services-range"
  services_ip_cidr_range   = "172.17.0.0/16"
}
