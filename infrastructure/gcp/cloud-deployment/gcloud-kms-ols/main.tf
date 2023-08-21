# Terraform State Storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-kms/ols-dev-gcloud-kms-ols"
  }
}

# create cloud dns module

module "gcloud_dns" {
  source                     = "../../modules/security/gcloud-dns"
  region                     = "asia-southeast2"
  unit                       = "ols"
  env                        = "dev"
  code                       = "gcloud-kms"
  feature                    = ["sa", "keyring", "cryptokey"]
  location                   = "global"
  rotation_period            = "2592000s"
  destroy_scheduled_duration = "24"
  purpose                    = "ENCRYPT_DECRYPT"
  version_template = {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
  cryptokey_role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}
