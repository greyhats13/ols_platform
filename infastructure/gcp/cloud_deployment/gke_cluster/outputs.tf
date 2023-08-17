# create output based on the module output

output "gke_cluster_id" {
  value = module.gke.cluster_id
}

output "gke_cluster_self_link" {
  value = module.gke.cluster_self_link
}

output "gke_cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "gke_cluster_client_certificate" {
  value = module.gke.cluster_client_certificate
}

output "gke_cluster_client_key" {
  value = module.gke.cluster_client_key
}

output "gke_cluster_ca_certificate" {
  value = module.gke.cluster_ca_certificate
}

output "gke_cluster_master_version" {
  value = module.gke.cluster_master_version
}