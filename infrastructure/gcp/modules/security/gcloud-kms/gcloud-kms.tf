# create service account
resource "google_service_account" "service_account" {
  account_id   = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  display_name = "${var.unit}-${var.env}-${var.code}-${var.feature[0]} service account"
}

resource "google_kms_key_ring" "keyring" {
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}"
  location = var.location
}

resource "google_kms_crypto_key" "cryptokey" {
  name                       = "${var.unit}-${var.env}-${var.code}-${var.feature[2]}"
  key_ring                   = google_kms_key_ring.keyring.id
  rotation_period            = var.rotation_period
  destroy_scheduled_duration = var.destroy_scheduled_duration
  purpose                    = var.purpose
  version_template {
    algorithm = var.version_template.algorithm
    protection_level = var.version_template.protection_level
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "cryptokey_iam_binding" {
  crypto_key_id = google_kms_crypto_key.cryptokey.id
  role          = var.cryptokey_role
  members       = ["serviceAccount:${google_service_account.service_account.email}"]
}

