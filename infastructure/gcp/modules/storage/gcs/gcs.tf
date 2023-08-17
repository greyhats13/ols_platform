resource "google_storage_bucket" "bucket" {
  name          = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.bucket_name}"
  location      = "${var.region}"
  force_destroy = var.force_destroy

  public_access_prevention = var.public_access_prevention
}