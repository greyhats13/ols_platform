# Sample code to decrypt
provider "google" {
  project     = "onlineshop-378118"
  region      = "asia-southeast2"
}

data "terraform_remote_state" "kms_ols_cryptokey" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-kms/ols-dev-gcloud-kms-ols"
  }
}

variable "chipertext" {
  type = string
  default = "CiQAu5Ik/nzSksAAow5AogU48Cc1F0a7mrflWJrG5as84WlZmtgSMQD4TGYHvMKd7qAN7w+HsHT76TGunNZitz90vECGGvS8DfNrtMF9q93MQsx7bvdZoG0="
  description = "its the chipertext of 'nasiuduk'"
}

data "google_kms_secret" "decrypt" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.ciphertext
}

output "plaintext" {
  value = data.google_kms_secret.decrypt.plaintext
  sensitive = true
}