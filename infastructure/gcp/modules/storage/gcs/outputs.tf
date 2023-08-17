# create google cloud storage bucket outputs

output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "bucket_url" {
  value = google_storage_bucket.bucket.url
}

output "bucket_self_link" {
  value = google_storage_bucket.bucket.self_link
}