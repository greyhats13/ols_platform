# Terraform State Storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "helm/ols-dev-helm-argo-cd"
  }
}

data "google_project" "current" {}

module "helm" {
  source                 = "../../modules/compute/helm"
  region                 = "asia-southeast2"
  unit                   = "ols"
  env                    = "dev"
  code                   = "helm"
  feature                = "argo-cd"
  release_name           = "argo-cd"
  repository             = "https://argoproj.github.io/argo-helm"
  chart                  = "argo-cd"
  create_service_account = false
  project_id             = data.google_project.current.project_id
  service_account_role   = null
  kubernetes_cluster_role_rules = {
    api_groups = []
    resources  = []
    verbs      = []
  }
  create_managed_certificate = true
  values                     = []
  helm_sets = [
    {
      name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "gce"
    },
    {
      name  = "ingress.annotations.networking\\.gke\\.io/managed-certificates"
      value = "argo-cd-cert"
    },
    {
      name  = "server.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
      value = "argocd.ols.blast.co.id"
    },
    {
      name  = "server.ingress.enabled"
      value = true
    },
    {
      name  = "server.ingress.hosts[0]"
      value = "argocd.ols.blast.co.id"
    },
    {
      name = "server.GKEmanagedCertificate.enabled"
      value = true
    },
    {
      name = "server.GKEmanagedCertificate.domains[0]"
      value = "argocd.ols.blast.co.id"
    }
  ]
  namespace = "cd"
  create_namespace = true
}
