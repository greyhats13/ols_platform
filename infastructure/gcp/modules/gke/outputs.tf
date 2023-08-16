output "kubeconfig" {
  value     = <<EOT
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: ${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}
        server: https://${google_container_cluster.cluster.endpoint}
      name: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
    contexts:
    - context:
        cluster: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
        user: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
      name: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
    current-context: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
    kind: Config
    preferences: {}
    users:
    - name: ${var.unit}-${var.env}-${var.code}-${var.feature[0]}
      user:
        client-certificate-data: ${google_container_cluster.cluster.master_auth.0.client_certificate}
        client-key-data: ${google_container_cluster.cluster.master_auth.0.client_key}
  EOT
  sensitive = true
}
