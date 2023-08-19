# Terraform State Storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gke/ols-dev-compute-gke"
  }
}

data "terraform_remote_state" "vpc_ols_network" {
  backend = "gcs"

  config = {
    bucket = "${var.unit}-${var.env}-gcloud-storage-tfstate"
    prefix = "vpc/${var.unit}-${var.env}-vpc-network"
  }
}

# create gke from modules gke
module "gke" {
  source                        = "../../modules/compute/gkubernetes-engine"
  region                        = "asia-southeast2"
  unit                          = "ols"
  env                           = "dev"
  code                          = "compute"
  feature                       = "gke"
  issue_client_certificate      = true
  vpc_self_link                 = data.terraform_remote_state.vpc_ols_network.vpc_self_link
  subnet_self_link              = data.terraform_remote_state.vpc_ols_network.subnet_self_link
  pods_secondary_range_name     = data.terraform_remote_state.vpc_ols_network.pods_secondary_range_name
  services_secondary_range_name = data.terraform_remote_state.vpc_ols_network.services_secondary_range_name
  service_account               = "ol-shop@onlineshop-378118.iam.gserviceaccount.com"
  node_config = {
    ondemand = {
      is_spot      = false
      node_count   = 1
      machine_type = ["e2-medium", "e2-standard-2", "e2-standard-4"]
      disk_size_gb = 20
      disk_type    = ["pd-standard", "pd-ssd"]
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
      tags         = ["ondemand"]
    },
    spot = {
      is_spot        = true
      node_count     = 0
      machine_type   = ["e2-medium", "e2-standard-2", "e2-standard-4"]
      disk_size_gb   = 20
      disk_type      = ["pd-standard", "pd-ssd"]
      oauth_scopes   = ["https://www.googleapis.com/auth/cloud-platform"]
      tags           = ["spot"]
      min_node_count = 0
      max_node_count = 20
    }
  }
}
