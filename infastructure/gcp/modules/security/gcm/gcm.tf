resource "google_secret_manager_secret" "secret" {
  secret_id = var.gcm_secret_id

  labels = var.gcm_labels

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  annotations = var.gcm_annotations
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret = google_secret_manager_secret.secret.id

  secret_data = var.gcm_secret_data
}