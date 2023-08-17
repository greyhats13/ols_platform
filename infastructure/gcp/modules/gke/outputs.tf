#output cluster_name

output "cluster_name" {
  value = google_container_cluster.cluster.name
}