# create gcp provider
provider "google" {
  credentials = file("../../secrets/onlineshop-378118-e796d2c86870.json")
  project     = "onlineshop-378118"
  region      = "asia-southeast2"
}

# data source for gke cluster
data "terraform_remote_state" "gke_cluster" {
  backend = "gcs"

  config = {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "gke/ols-dev-compute-gke"
    credentials = "../../secrets/onlineshop-378118-e796d2c86870.json"
  }
}



# create kubernetes provider
data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.gke_cluster.outputs.gke_cluster_endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_ca_certificate)
}

# create helm provider
provider "helm" {
  kubernetes {
    host                   = "https://${data.terraform_remote_state.gke_cluster.outputs.gke_cluster_endpoint}"
    cluster_ca_certificate = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_ca_certificate)
    client_key             = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_client_key)
    client_certificate     = base64decode(data.terraform_remote_state.gke_cluster.outputs.gke_cluster_client_certificate)
  }
}

