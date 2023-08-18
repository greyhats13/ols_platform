# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gsm/ols-dev-security-gsm-github-webhook-secret"
  }
}

variable "github_webhook_secret" {}

module "gsm_github_webhook_secret" {
  source        = "../../modules/security/gsm"
  region        = "asia-southeast2"
  unit          = "ols"
  env           = "dev"
  code          = "security"
  feature       = "gsm"
  gsm_secret_id = "github-webhook-secret"
  gsm_labels = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gsm"
    "name"    = "github-webhook-secret"
  }
  gsm_annotations = {
    "unit"    = "ols"
    "env"     = "dev"
    "code"    = "security"
    "feature" = "gsm"
    "name"    = "github-webhook-secret"
  }
  gsm_secret_data = var.github_webhook_secret
}
