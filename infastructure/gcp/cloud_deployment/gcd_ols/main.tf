# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-storage-gcs-iac"
    prefix      = "gcd/ols-dev-network-gcd"
    credentials = "../../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create cloud dns module

module "gcd_blast" {
  source = "../../modules/network/gcd"

  region           = "asia-southeast2"
  unit             = "ols"
  env              = "dev"
  code             = "network"
  feature          = "gcd"
  zone_name        = "ols-blast"
  dns_name         = "ols.blast.co.id."
  zone_description = "GCD for ols.blast.co.id"
}
