# Terraform State Storage
terraform {
  backend "gcs" {
    bucket  = "ols-dev-storage-gcs-iac"
    prefix  = "gke/ols-dev-compute-gke"
    credentials = "../../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create gke from modules gke
module "gke" {
  source                            = "../../modules/compute/gke"
  region                            = "asia-southeast2"
  unit                              = "ols"
  env                               = "dev"
  code                              = "compute"
  feature                           = "gke"
  gke_pods_secondary_range_name     = "pods-range"
  gke_services_secondary_range_name = "services-range"
  gke_remove_default_node_pool      = false
  gke_initial_node_count            = 2
  gke_issue_client_certificate      = true
  default_machine_type              = "e2-medium"
  default_disk_size_gb              = 20
  default_disk_type                 = "pd-standard"
  service_account                   = "ol-shop@onlineshop-378118.iam.gserviceaccount.com"
  gke_oauth_scopes                  = ["https://www.googleapis.com/auth/cloud-platform"]
  preemptible_nodepool_name         = "preemptible"
  preemptible_machine_type          = "e2-medium"
  preemptible_disk_size_gb          = 20
  preemptible_disk_type             = "pd-standard"
  preemptible_tags                  = ["preemptible"]
  preemptible_oauth_scopes          = ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
  preemptible_min_node_count        = 1
  preemptible_max_node_count        = 20
}
