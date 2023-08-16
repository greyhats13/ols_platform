output "kubeconfig" {
  value = module.gke.kubeconfig
  sensitive = true
}