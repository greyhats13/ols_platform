#Naming Standard
variable "region" {
  type        = string
  description = "GCP region"
}

variable "unit" {
  type        = string
  description = "business unit code"
}

variable "env" {
  type        = string
  description = "stage environment where the infrastructure will be deployed"
}

variable "code" {
  type        = string
  description = "service domain code to use"
}

variable "feature" {
  type        = string
  description = "the name of AWS services feature"
}

# gke arguments
variable "issue_client_certificate" {
  type        = bool
  description = "issue client certificate"
}

variable "service_account" {
  type        = string
  description = "service account"
}

# gke node pool arguments
variable "pods_secondary_range_name" {
  type        = string
  description = "the pods secondary range name"
}

variable "services_secondary_range_name" {
  type        = string
  description = "the services secondary range name"
}

variable "node_config" {
  type        = map(object({
    is_spot        = bool
    node_count     = number
    machine_type   = list(string)
    disk_size_gb   = number
    disk_type      = list(string)
    oauth_scopes   = list(string)
    tags           = list(string)
    min_node_count = number
    max_node_count = number
  }))
  description = "node config"
}
