# Terraform State Storage
terraform {
  backend "gcs" {
    bucket      = "ols-dev-gcloud-storage-tfstate"
    prefix      = "gcd/ols-dev-network-gcd"
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
