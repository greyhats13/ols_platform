# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gsm/ols-dev-security-gsm-github-token"
  }
}

variable "github_token" {}

module "gsm_github_token" {
  source        = "../../modules/security/gsm"
  region        = "asia-southeast2"
  unit          = "ols"
  env           = "dev"
  code          = "security"
  feature       = "gsm"
  gsm_secret_id = "github-token"
  gsm_labels = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gsm"
    "name"    = "github-token"
  }
  gsm_annotations = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gsm"
    "name"    = "github-token"
  }
  gsm_secret_data = var.github_token
}
