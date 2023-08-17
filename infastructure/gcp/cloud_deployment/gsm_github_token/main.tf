# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "gcm/ols-dev-security-gcm-github-token"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

variable "github_token" {}

module "helm" {
  source        = "../../modules/security/gcm"
  region        = "asia-southeast2"
  unit          = "ols"
  env           = "dev"
  code          = "security"
  feature       = "gcm"
  gcm_secret_id = "github-token"
  gcm_labels = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gcm"
    "name"    = "github-token"
  }
  gcm_annotations = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gcm"
    "name"    = "github-token"
  }
  gcm_secret_data = var.github_token
}
