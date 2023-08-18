# data source for gke cluster
data "terraform_remote_state" "gke_cluster" {
  backend = "gcs"

  config = {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gke/ols-dev-compute-gke"
  }
}

# create gcp provider
provider "google" {
  project     = "onlineshop-378118"
  region      = "asia-southeast2"
}

# create provider for helm and get credential from gke cluster

# create helm provider
provider "helm" {
  kubernetes {
    # add host endpoint with port
    host                   = data.terraform_remote_state.gke_cluster.outputs.gke_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_ca_certificate)
    client_key             = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_client_key)
    client_certificate     = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_client_certificate)
  }
}

