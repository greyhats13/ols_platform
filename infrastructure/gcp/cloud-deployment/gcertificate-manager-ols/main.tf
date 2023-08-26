# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gcd/ols-dev-security-gcm-ols-ssl"
  }
}

# create cloud dns module

module "gcm_ols" {
  source = "../../modules/security/gcm"

  region           = "asia-southeast2"
  unit             = "ols"
  env              = "dev"
  code             = "security"
  feature          = "gcm"
  gcm_name         = "ols-ssl"
  gcm_domains      = ["ols.blast.co.id"]
}
