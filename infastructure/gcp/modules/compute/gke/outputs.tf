#output cluster_name

output "cluster_id" {
  value = google_container_cluster.cluster.id
}

output "cluster_self_link" {
  value = google_container_cluster.cluster.self_link
}

output "cluster_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "cluster_client_certificate" {
  value = google_container_cluster.cluster.master_auth.0.client_certificate
}

output "cluster_client_key" {
  value = google_container_cluster.cluster.master_auth.0.client_key
}

output "cluster_ca_certificate" {
  value = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
}

output "cluster_master_version" {
  value = google_container_cluster.cluster.master_version
}