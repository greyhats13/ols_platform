# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "helm/ols-dev-compute-helm-atlantis"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create a GKE cluster with 2 node pools
data "terraform_remote_state" "github_token" {
  backend = "gcs"

  config = {
    bucket      = "${var.unit}-${var.env}-storage-gcs-iac"
    prefix      = "gsm/${var.unit}-${var.env}-security-gsm-github-token"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}


data "terraform_remote_state" "github_webhook_secret" {
  backend = "gcs"

  config = {
    bucket      = "${var.unit}-${var.env}-storage-gcs-iac"
    prefix      = "gsm/${var.unit}-${var.env}-security-gsm-github-webhook-secret"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

module "helm_atlantis" {
  source        = "../../modules/compute/helm"
  region        = "asia-southeast2"
  unit          = "ols"
  env           = "dev"
  code          = "compute"
  feature       = "helm"
  release_name  = "atlantis"
  repository    = "https://runatlantis.github.io/helm-charts"
  chart         = "runatlantis"
  namespace     = "ci"
  create_namespace = true
  values        = ["${file("path_to_values_file.yaml")}"]
  helm_sets     = [
    {
      name  = "orgAllowlist"
      value = "github.com/greyhats13"
    },
    {
      name  = "github.token"
      value = data.terraform_remote_state.github_token.outputs.github_token
    },
    {
      name  = "github.webhookSecret"
      value = "secret:GCP:projects/onlineshop-378118/secrets/github-webhook-secret/versions/latest"
    }
    # Add other necessary helm set values
  ]
}
