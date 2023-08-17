# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "gcd/ols-dev-security-gcm-ols-ssl"
    credentials = "../../secrets/onlineshop-378118-e796d2c86870.json"
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
  gcm_domains      = ["*.ols.blast.co.id"]
}
