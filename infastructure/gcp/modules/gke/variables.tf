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
  type        = list(string)
  description = "the name of AWS services feature"
}

# gke arguments
variable "gke_remove_default_node_pool" {
  type        = bool
  description = "remove default node pool"
}

variable "gke_initial_node_count" {
  type        = number
  description = "initial node count"
}

variable "gke_issue_client_certificate" {
  type        = bool
  description = "issue client certificate"
}

variable "gke_oauth_scopes" {
  type        = list(string)
  description = "oauth scopes"
}

# gke ondemand node pool arguments

variable "ondemand_node_count" {
  type        = number
  description = "node count"
}

variable "ondemand_machine_type" {
  type        = string
  description = "the machine type to use"
}

variable "ondemand_oauth_scopes" {
  type        = list(string)
  description = "oauth scopes"
}

variable "ondemand_tags" {
  type        = list(string)
  description = "the tag to use"
}

# gke preemptible node pool arguments
variable "preemptible_machine_type" {
  type        = string
  description = "the machine type to use"
}

variable "preemptible_oauth_scopes" {
  type        = list(string)
  description = "oauth scopes"
}

variable "preemptible_tags" {
  type        = list(string)
  description = "the tags to use"
}

variable "preemptible_min_node_count" {
  type        = number
  description = "min node count"
}

variable "preemptible_max_node_count" {
  type        = number
  description = "max node count"
}

# network arguments
variable "network_self_link" {
  type        = string
  description = "the network self link to use"
}

variable "subnet_self_link" {
  type        = string
  description = "the subnet self link to use"
}

variable "gke_pods_secondary_range_name" {
  type        = string
  description = "the pods secondary range name"
}

variable "gke_services_secondary_range_name" {
  type        = string
  description = "the services secondary range name"
}