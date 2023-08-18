resource "google_secret_manager_secret" "secret" {
  secret_id = var.gsm_secret_id

  labels = var.gsm_labels

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  annotations = var.gsm_annotations
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret = google_secret_manager_secret.secret.id

  secret_data = var.gsm_secret_data
}