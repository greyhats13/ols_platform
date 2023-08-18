// Configuration for Terraform state storage in Google Cloud Storage
terraform {
  backend "gcs" {
    bucket  = "ols-dev-gcloud-storage-tfstate"
    prefix  = "gcs/ols-dev-gcloud-storage-tfstate"
  }
}

// Deploy a Google Cloud Storage bucket using the gcloud-storage module
module "gcloud-storage-tfstate" {
  source                   = "../../modules/storage/gcloud-storage"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "gcloud-storage"
  feature                  = "tfstate"
  force_destroy            = true
  public_access_prevention = "enforced"
}
