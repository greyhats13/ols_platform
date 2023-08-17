# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "helm/ols-dev-compute-helm-atlantis"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

module "helm" {
  source       = "../../modules/compute/helm"
  region       = "asia-southeast2"
  unit         = "ols"
  env          = "dev"
  code         = "compute"
  feature      = "helm"
  release_name = "nginx"
  repository   = "https://kubernetes.github.io/ingress-nginx"
  chart        = "ingress-nginx"
  values       = []
  helm_sets = [
    {
      name  = "controller.replicaCount"
      value = 1
    },
    {
      name  = "controller.autoscaling.enabled"
      value = true
    },
    {
      name  = "controller.autoscaling.minReplicas"
      value = 1
    },
    {
      name  = "controller.autoscaling.maxReplicas"
      value = 2
    },
    {
      name  = "controller.image.tag"
      value = "v1.8.1"
    },
    #set ingress class
    
  ]
  namespace        = "ingress"
  create_namespace = true
}
