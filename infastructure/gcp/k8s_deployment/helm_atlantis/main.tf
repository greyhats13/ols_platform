# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "helm/ols-dev-compute-helm-atlantis"
  }
}

# create a GKE cluster with 2 node pools
data "google_secret_manager_secret_version" "github_token" {
  secret = "github-token"
}

data "google_secret_manager_secret_version" "github_webhook_secret" {
  secret = "github-webhook-secret"
}


# create atlantis cert using google certificate manager
module "k8s_managedcert_atlantis" {
  source = "../../modules/compute/k8s"
  manifest = file("managed-cert.yaml")
}


# deploy atlantis helm chart
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
  values           = ["${file("values.yaml")}"]
  helm_sets = [
    {
      name  = "orgAllowlist"
      value = "github.com/greyhats13/*"
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
    {
      name = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "gce"
    },
    {
      name = "ingress.annotations.networking\\.gke\\.io/managed-certificates"
      value = "atlantis-cert"
    },
    {
      name = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
      value = "atlantis.ols.blast.co.id"
    },
    {
      name  = "ingress.enabled"
      value = true
    },
    {
      name  = "ingress.host"
      value = "atlantis.ols.blast.co.id"
    }
  ]
}
