# create kms outputs

output "keyring_id" {
  value = module.gcloud_kms.keyring_id
}

output "cryptokey_id" {
  value = module.gcloud_kms.cryptokey_id
}

output "service_account_id" {
  value = module.gcloud_kms.service_account_id
}

output "service_account_email" {
  value = module.gcloud_kms.service_account_email
}