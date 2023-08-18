# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "helm/ols-dev-compute-helm-externaldns"
  }
}

data "google_project" "current" {}

# create a GKE cluster with 2 node pools
data "terraform_remote_state" "ols_dns" {
  backend = "gcs"

  config = {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gcd/ols-dev-network-gcd"
  }
}

module "externaldns" {
  source       = "../../modules/compute/helm"
  region       = "asia-southeast2"
  unit         = "ols"
  env          = "dev"
  code         = "compute"
  feature      = "helm"
  release_name = "external-dns"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "external-dns"
  values       = []
  helm_sets = [
    # add google provider for externaldns
    {
      name  = "provider"
      value = "google"
    },
    {
      name  = "google.project"
      value = data.google_project.current.project_id
    },
    {
      name  = "google.serviceAccountSecretKey"
      value = "../../secrets/onlineshop-378118-e796d2c86870.json"
    },
    {
      name = "zoneVisibility"
      value = data.terraform_remote_state.ols_dns.outputs.network_gcd_zone_visibility
    }
  ]
  namespace        = "ingress"
  create_namespace = true
}
