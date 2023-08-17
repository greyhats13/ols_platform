# Terraform State Storage
terraform {
  backend "gcs" {
    bucket  = "ols-dev-storage-gcs-iac"
    prefix  = "gcs/ols-dev-storage-gcs-iac"
    credentials = "../secrets/onlineshop-378118-e796d2c86870.json"
  }
}

# create gcs from modules storage
module "gcs" {
  source                   = "../../modules/storage/gcs"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "storage"
  feature                  = "gcs"
  bucket_name              = "iac"
  force_destroy            = true
  public_access_prevention = "enforced"
}
