# create google secret manager outputs

output "gcm_secret_id" {
  value = google_secret_manager_secret.secret.id
}

output "gcm_secret_version_id" {
  value = google_secret_manager_secret_version.secret_version.id
}

output "gcm_secret_version" {
  value = google_secret_manager_secret_version.secret_version.id
}