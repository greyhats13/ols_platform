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
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}

# create gke from modules gke
module "gke" {
  source                               = "../../modules/compute/gkubernetes-engine"
  region                               = "asia-southeast2"
  unit                                 = "ols"
  env                                  = "dev"
  code                                 = "compute"
  feature                              = "gke"
  issue_client_certificate             = true
  vpc_self_link                        = data.terraform_remote_state.vpc_ols_network.outputs.vpc_self_link
  subnet_self_link                     = data.terraform_remote_state.vpc_ols_network.outputs.subnet_self_link
  binary_authorization_evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  pods_secondary_range_name            = data.terraform_remote_state.vpc_ols_network.outputs.pods_secondary_range_name
  services_secondary_range_name        = data.terraform_remote_state.vpc_ols_network.outputs.services_secondary_range_name
  service_account                      = "ol-shop@onlineshop-378118.iam.gserviceaccount.com"
  private_cluster_config = {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }
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
