# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "helm/ols-dev-compute-helm-atlantis"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create a GKE cluster with 2 node pools
data "google_secret_manager_secret_version" "github_token" {
  secret = "github-token"
}

data "google_secret_manager_secret_version" "github_webhook_secret" {
  secret = "github-webhook-secret"
}

module "helm_atlantis" {
  source           = "../../modules/compute/helm"
  region           = "asia-southeast2"
  unit             = "ols"
  env              = "dev"
  code             = "compute"
  feature          = "helm"
  release_name     = "atlantis"
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  namespace        = "ci"
  create_namespace = true
  values           = []
  helm_sets = [
    {
      name  = "orgAllowlist"
      value = "github.com/greyhats13"
    },
    {
      name  = "github.user"
      value = "greyhats13"
    },
    {
      name  = "github.token"
      value = data.google_secret_manager_secret_version.github_token.secret_data
    },
    {
      name  = "github.secret"
      value = data.google_secret_manager_secret_version.github_webhook_secret.secret_data
    },
  #  {
  #     name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
  #     value = "nginx"
  #   },
  #   {
  #     name  = "ingress.annotations.networking\\.gke\\.io/managed-certificates"
  #     value = "your-managed-certificate-name"
  #   },
  #   {
  #     name  = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
  #     value = "atlantis.ols.blast.co.id"
  #   },
  #   {
  #     name  = "ingress.enabled"
  #     value = true
  #   },
  #   {
  #     name  = "ingress.hosts[0]"
  #     value = "atlantis.ols.blast.co.id"
  #   },
  #   {
  #     name  = "repoConfig"
  #     value = "path-to-your-repo-config-file"
  #   }
  ]
}
